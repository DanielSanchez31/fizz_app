import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fizz_app/src/models/driver.dart';
import 'package:fizz_app/src/models/travel_info.dart';
import 'package:fizz_app/src/providers/auth_provider.dart';
import 'package:fizz_app/src/providers/driver_provider.dart';
import 'package:fizz_app/src/providers/geofire_provider.dart';
import 'package:fizz_app/src/providers/push_notifications_provider.dart';
import 'package:fizz_app/src/providers/travel_info_provider.dart';
import 'package:fizz_app/src/utils/my_progress_dialog.dart';
import 'package:fizz_app/src/widgets/bottom_sheet_client_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:fizz_app/src/utils/snackbar.dart' as utils;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../../api/environment.dart';

class ClientTravelMapController {

  BuildContext context;
  Function refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapController = Completer();

  CameraPosition initialPosition = CameraPosition(
      target: LatLng(19.7107759,-98.9754828),
      zoom: 14.0
  );

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  BitmapDescriptor _markerDriver;
  BitmapDescriptor fromMarker;
  BitmapDescriptor toMarker;

  GeofireProvider _geofireProvider;
  AuthProvider _authProvider;
  DriverProvider _driverProvider;
  PushNotificationsProvider _pushNotificationsProvider;
  TravelInfoProvider _travelInfoProvider;

  bool isConnect = false;
  ProgressDialog _progressDialog;

  StreamSubscription<DocumentSnapshot> _statusSuscription;
  StreamSubscription<DocumentSnapshot> _driverInfoSuscription;

  Set<Polyline> polylines = {};
  List<LatLng> points = new List();

  Driver driver;
  TravelInfo travelInfo;
  LatLng _driverLatLng;

  bool isRouteReady = false;

  String currentStatus = '';
  Color colorStatus = Colors.white;
  Color styleStatus = Colors.white;

  bool isPickupTravel = false;
  bool isStartTravel = false;
  bool isFinishTravel = false;

  StreamSubscription<DocumentSnapshot> _streamLocationController;
  StreamSubscription<DocumentSnapshot> _streamTravelController;

  String numeroTarjeta;
  String codigoTarjeta;
  String fechaTarjeta;
  //String titularTarjeta;
  String from;
  LatLng fromLatLng;
  String to;
  LatLng toLatLng;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    Map<String,dynamic> arguments = ModalRoute.of(context).settings.arguments as Map<String,dynamic>;

    numeroTarjeta = arguments['numero_tarjeta'];
    codigoTarjeta = arguments['codigo_tarjeta'];
    fechaTarjeta = arguments['expiracion_tarjeta'];
    //titularTarjeta = arguments['expiracion_tarjeta'];

    from = arguments['from'];
    to = arguments['to'];
    fromLatLng = arguments['fromLatLng'];
    toLatLng = arguments['toLatLng'];

    _geofireProvider = new GeofireProvider();
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
    _travelInfoProvider = new TravelInfoProvider();
    _pushNotificationsProvider = new PushNotificationsProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Conectando...');

    _markerDriver = await createMarkerImageFromAsset('assets/img/taxi_icon.png');
    fromMarker = await createMarkerImageFromAsset('assets/img/marker_person.png');
    toMarker = await createMarkerImageFromAsset('assets/img/end_travel.png');

    checkGPS();
  }

  void openBottomSheet() {
    if(driver == null ) return;

    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => BottomSheetClientInfo(
          imageUrl: driver?.image,
          username: driver?.username,
          email: driver?.email,
          plates: driver?.plate,
          auto: driver?.auto,
          model: driver?.model,
        )
    );
  }

  void getDriverLocation(String idDriver) {
    Stream<DocumentSnapshot> stream = _geofireProvider.getLocationByIdStream(idDriver);
    _streamLocationController = stream.listen((DocumentSnapshot document) {
      GeoPoint geoPoint = document.data()['position']['geopoint'];
      _driverLatLng = new LatLng(geoPoint.latitude, geoPoint.longitude);
      addSimpleMarker(
          'driver',
          _driverLatLng.latitude,
          _driverLatLng.longitude,
          'Tu conductor',
          '',
          _markerDriver
      );

      refresh();

      if(!isRouteReady) {
        isRouteReady = true;
        checkTravelStatus();
      }

    });
  }

  void pickupTravel() {
    if(!isPickupTravel){
      isPickupTravel = true;
      LatLng from = new LatLng(_driverLatLng.latitude, _driverLatLng.longitude);
      LatLng to = new LatLng(travelInfo.toLat, travelInfo.toLng);
      addSimpleMarker('from', to.latitude, to.longitude, 'Tu cliente', '', fromMarker);
      setPolylines(from, to);
    }
  }

  void checkTravelStatus() async {
    Stream<DocumentSnapshot> stream = _travelInfoProvider.getByIdStream(_authProvider.getUser().uid);
    _streamTravelController = stream.listen((DocumentSnapshot document) {
      travelInfo = TravelInfo.fromJson(document.data());

      if(travelInfo.status == 'accepted') {
        currentStatus = 'Aceptado';
        colorStatus = Colors.white;
        styleStatus = Colors.black;
        pickupTravel();
      } else if(travelInfo.status == 'started') {
        currentStatus = 'En curso';
        colorStatus = Color.fromRGBO(220, 0, 29, 1);
        styleStatus = Colors.white;
        startTravel();
      } else if (travelInfo.status == 'finished') {
        currentStatus = 'Finalizado';
        colorStatus = Colors.redAccent;
        styleStatus = Colors.white;
        finishTravel();
      }

      refresh();

    });
  }

  void startTravel() {
    if(!isStartTravel){
      isStartTravel = true;
      polylines = {};
      points = List();
      markers.remove(markers['from']);
      addSimpleMarker('to', travelInfo.toLat, travelInfo.toLng, 'Tu destino', '', toMarker);

      LatLng from = new LatLng(_driverLatLng.latitude, _driverLatLng.longitude);
      LatLng to = new LatLng(travelInfo.toLat, travelInfo.toLng);

      setPolylines(from, to);
      refresh();
    }
  }

  void finishTravel() {
    if(!isFinishTravel) {

      isFinishTravel = true;
      Navigator.pushNamedAndRemoveUntil(context, 'client/travel/calification', (route) => false,
          arguments: {
            'travelInfo': travelInfo.idTravelHistory,
            'numero_tarjeta' : numeroTarjeta,
            'codigo_tarjeta' : codigoTarjeta,
            'expiracion_tarjeta' : fechaTarjeta
          }
          );
    }

  }

  void getTravelInfo() async {
    travelInfo = await _travelInfoProvider.getById(_authProvider.getUser().uid);
    animateCameraToPosition(travelInfo.fromLat, travelInfo.fromLng);
    getDriverInfo(travelInfo.idDriver);
    getDriverLocation(travelInfo.idDriver);
  }

  Future<void> setPolylines (LatLng from, LatLng to) async {
    PointLatLng pointFromLatLng = PointLatLng(from.latitude, from.longitude);
    PointLatLng pointToLatLng = PointLatLng(to.latitude, to.longitude);

    PolylineResult result = await new PolylinePoints().getRouteBetweenCoordinates(
        Environment.api_key_maps,
        pointFromLatLng,
        pointToLatLng
    );

    for (PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
    }

    Polyline polyline = Polyline(
      polylineId: PolylineId('poly'),
      color: Color.fromRGBO(220, 0, 29, 1),
      points: points,
      width: 6,
    );

    polylines.add(polyline);

    //addMarker('to', toLatLng.latitude, toLatLng.longitude, 'Destino', '', toMarker);

    refresh();
  }

  void getDriverInfo (String id) async {
    driver = await _driverProvider.getById(id);
    refresh();
  }

  void dispose() {
    _statusSuscription?.cancel();
    _driverInfoSuscription?.cancel();
    _streamLocationController?.cancel();
    _streamTravelController?.cancel();
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]');
    _mapController.complete(controller);

    getTravelInfo();
  }

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if(isLocationEnabled) {
    } else {
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
      }
    }
  }

  Future animateCameraToPosition(double latitude, double longitude) async {
    GoogleMapController controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              bearing: 0,
              target: LatLng(latitude, longitude),
              zoom: 17
          )
      ));
    }
  }

  Future<BitmapDescriptor> createMarkerImageFromAsset(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor bitmapDescriptor = await BitmapDescriptor.fromAssetImage(configuration, path);
    return bitmapDescriptor;
  }

  void addSimpleMarker(String markerId, double lat, double lng, String title, String content, BitmapDescriptor iconMarker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
      markerId: id,
      icon: iconMarker,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(
        title: title,
        snippet: content,
      ),
    );

    markers[id] = marker;

  }
}