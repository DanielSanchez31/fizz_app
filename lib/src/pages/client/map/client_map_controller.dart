import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fizz_app/src/api/environment.dart';
import 'package:fizz_app/src/models/client.dart';
import 'package:fizz_app/src/models/driver.dart';
import 'package:fizz_app/src/providers/auth_provider.dart';
import 'package:fizz_app/src/providers/client_provider.dart';
import 'package:fizz_app/src/providers/driver_provider.dart';
import 'package:fizz_app/src/providers/geofire_provider.dart';
import 'package:fizz_app/src/providers/push_notifications_provider.dart';
import 'package:fizz_app/src/utils/my_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:fizz_app/src/utils/snackbar.dart' as utils;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_webservice/places.dart' as places;
import 'package:flutter_google_places/flutter_google_places.dart';

class ClientMapController {

  BuildContext context;
  Function refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapController = Completer();

  CameraPosition initialPosition = CameraPosition(
      target: LatLng(19.7107759,-98.9754828),
      zoom: 14.0
  );

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Position _position;
  StreamSubscription<Position> _positionStream;

  BitmapDescriptor markerDriver;

  GeofireProvider _geofireProvider;
  AuthProvider _authProvider;
  DriverProvider _driverProvider;
  ClientProvider _clientProvider;
  PushNotificationsProvider _pushNotificationsProvider;

  bool isConnect = false;
  ProgressDialog _progressDialog;

  StreamSubscription<DocumentSnapshot> _statusSuscription;
  StreamSubscription<DocumentSnapshot> _clientInfoSuscription;

  Client client;

  String from;
  LatLng fromLatLng;
  String to;
  LatLng toLatLng;

  bool isFromSelected = true;

  places.GoogleMapsPlaces _places = places.GoogleMapsPlaces(apiKey: Environment.api_key_maps);

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _geofireProvider = new GeofireProvider();
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
    _clientProvider = new ClientProvider();
    _pushNotificationsProvider = new PushNotificationsProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Conectando...');
    markerDriver = await createMarkerImageFromAsset('assets/img/taxi_icon.png');
    checkGPS();
    saveToken();
    getClientInfo();
  }

  void getClientInfo () {
    Stream<DocumentSnapshot> clientStream = _clientProvider.getByIDStream(_authProvider.getUser().uid);
    _clientInfoSuscription = clientStream.listen((DocumentSnapshot document) {
      client = Client.fromJson(document.data());
      refresh();
    });
  }

  void openDrawer () {
    key.currentState.openDrawer();
  }

  void dispose() {
    _positionStream?.cancel();
    _statusSuscription?.cancel();
    _clientInfoSuscription?.cancel();
  }

  void signOut () async {
    await _authProvider.signOut();
    Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]');
    _mapController.complete(controller);
  }

  void updateLocation () async {
    try {
      await _determinePosition();
      _position = await Geolocator.getLastKnownPosition();
      centerPosition();
      getNearbyDrivers();

    } catch (error) {
      print('Error en la localización: $error');
    }
  }

  void requestDriver () {
    if (fromLatLng != null && toLatLng != null) {
      Navigator.pushNamed(context, 'client/travel/info', arguments: {
        'from' : from,
        'to' : to,
        'fromLatLng' : fromLatLng,
        'toLatLng' : toLatLng
      });
    } else {
      utils.Snackbar.showSnackbar(context, key, 'Seleccione lugar de inicio y destino para continuar');
    }
  }

  void changeFromTo () {
    isFromSelected = !isFromSelected;

    if (isFromSelected) {
      utils.Snackbar.showSnackbar(context, key, 'Lugar de recogida');
    } else {
      utils.Snackbar.showSnackbar(context, key, 'Lugar de destino');
    }
  }

  Future<Null> showGoogleAutocomplete(bool isFrom) async {
    places.Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: Environment.api_key_maps,
        language: 'es',
        strictbounds: true,
        radius: 20000,
        location: places.Location(19.7119125,-98.9738159)
    );

    if (p != null) {
      places.PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId, language: 'es');
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;
      List<Address> address = await Geocoder.local.findAddressesFromQuery(p.description);

      if (address != null) {
        if (address.length > 0) {
          if (detail != null) {
            String direction = detail.result.name;
            String city = address[0].locality;
            String department = address[0].adminArea;

            if(isFrom) {
              from = '$direction, $city, $department';
              fromLatLng = new LatLng(lat, lng);
            } else {
              to = '$direction, $city, $department';
              toLatLng = new LatLng(lat, lng);
            }



            refresh();
          }
        }
      }
    }
  }

  Future<Null> setLocationDraggableInfo ()  async {
    if (initialPosition != null) {
      double lat = initialPosition.target.latitude;
      double lng = initialPosition.target.longitude;

      List<Placemark> address = await placemarkFromCoordinates(lat,lng);
      print('address: '+ address.toList().toString());

      if (address != null) {
        if (address.length > 0){
          String direction = address[0].thoroughfare;
          String street = address[0].subThoroughfare;
          String city = address[0].locality;
          String department = address[0].administrativeArea;
          String country = address[0].country;

          if (isFromSelected) {
            from = '$direction #$street, $city, $department';
            fromLatLng = new LatLng(lat, lng);
          } else {
            to = '$direction #$street, $city, $department';
            toLatLng = new LatLng(lat, lng);
          }

          refresh();
        }
      }
    }
  }

  void goToPaymentPage () {
    Navigator.pushNamed(context, 'client/payment/list');
  }

  void goToEditPage () {
    Navigator.pushNamed(context, 'client/edit');
  }

  void goToHistoryPage () {
    Navigator.pushNamed(context, 'client/history');
  }

  void saveToken() {
    _pushNotificationsProvider.saveToken(_authProvider.getUser().uid, 'client');
  }

  void getNearbyDrivers () {
    Stream<List<DocumentSnapshot>> stream = _geofireProvider.getNearbyDrivers(
        _position.latitude,
        _position.longitude,
        5
    );
    
    stream.listen((List<DocumentSnapshot> documentList) {
      for ( MarkerId m in markers.keys) {
        bool remove = true;

        for (DocumentSnapshot d in documentList) {
          if (m.value == d.id){
            remove = false;
          }
        }

        if (remove) {
          markers.remove(m);
          refresh();
        }
      }

      for (DocumentSnapshot d in documentList) {
        GeoPoint point = d.data()['position']['geopoint'];
        addMarker(
            d.id,
            point.latitude,
            point.longitude,
            'Conductor Disponible',
            '',
            markerDriver
        );
      }
      refresh();
    });
  }

  void centerPosition() {
    if (_position != null) {
      animateCameraToPosition(_position.latitude, _position.longitude);
    } else {
      utils.Snackbar.showSnackbar(context, key, 'Activa el GPS para obtener tu posición');
    }
  }

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if(isLocationEnabled) {
      updateLocation();
    } else {
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        updateLocation();
      }
    }
  }

  /// DDetermina la posición actual del dispositivo
  /// Cuando los permisos de localización no estén activos o
  /// sean denegados el método `Future` regresará un error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future animateCameraToPosition(double latitude, double longitude) async {
    GoogleMapController controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              bearing: 0,
              target: LatLng(latitude, longitude),
              zoom: 16
          )
      ));
    }
  }

  Future<BitmapDescriptor> createMarkerImageFromAsset(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor bitmapDescriptor = await BitmapDescriptor.fromAssetImage(configuration, path);
    return bitmapDescriptor;
  }

  void addMarker(String markerId, double lat, double lng, String title, String content, BitmapDescriptor iconMarker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
      markerId: id,
      icon: iconMarker,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(
        title: title,
        snippet: content,
      ),
      draggable: false,
      zIndex: 2,
      flat: true,
      anchor: Offset(0.5,0.5),
      rotation: _position.heading,
    );

    markers[id] = marker;

  }

}