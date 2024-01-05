import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fizz_app/src/models/client.dart';
import 'package:fizz_app/src/models/driver.dart';
import 'package:fizz_app/src/models/prices.dart';
import 'package:fizz_app/src/models/travel_history.dart';
import 'package:fizz_app/src/models/travel_info.dart';
import 'package:fizz_app/src/providers/auth_provider.dart';
import 'package:fizz_app/src/providers/client_provider.dart';
import 'package:fizz_app/src/providers/driver_provider.dart';
import 'package:fizz_app/src/providers/geofire_provider.dart';
import 'package:fizz_app/src/providers/prices_provider.dart';
import 'package:fizz_app/src/providers/push_notifications_provider.dart';
import 'package:fizz_app/src/providers/travel_history_provider.dart';
import 'package:fizz_app/src/providers/travel_info_provider.dart';
import 'package:fizz_app/src/utils/my_progress_dialog.dart';
import 'package:fizz_app/src/widgets/bottom_sheet_driver_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:fizz_app/src/utils/snackbar.dart' as utils;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../../api/environment.dart';

class DriverTravelMapController {

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

  BitmapDescriptor _markerDriver;
  BitmapDescriptor fromMarker;
  BitmapDescriptor toMarker;

  GeofireProvider _geofireProvider;
  AuthProvider _authProvider;
  DriverProvider _driverProvider;
  PushNotificationsProvider _pushNotificationsProvider;
  TravelInfoProvider _travelInfoProvider;
  PricesProvider _pricesProvider;
  ClientProvider _clientProvider;
  TravelHistoryProvider _travelHistoryProvider;

  bool isConnect = false;
  ProgressDialog _progressDialog;

  StreamSubscription<DocumentSnapshot> _statusSuscription;
  StreamSubscription<DocumentSnapshot> _driverInfoSuscription;

  Set<Polyline> polylines = {};
  List<LatLng> points = new List();

  Driver driver;
  Client client;

  String _idTravel;
  TravelInfo travelInfo;

  String currentStatus = 'Iniciar viaje';
  Color colorStatus = Colors.white;
  Color styleStatus = Colors.black;
  
  double _distanceBetween;

  Timer _timer;
  Duration duration = Duration();
  int seconds = 0;
  int minutes = 0;
  int hours = 0;
  double mt = 0.0;
  double km = 0.0;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    _idTravel = ModalRoute.of(context).settings.arguments as String;

    _geofireProvider = new GeofireProvider();
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
    _travelInfoProvider = new TravelInfoProvider();
    _pricesProvider = new PricesProvider();
    _clientProvider = new ClientProvider();
    _travelHistoryProvider = new TravelHistoryProvider();
    _pushNotificationsProvider = new PushNotificationsProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Conectando...');

    _markerDriver = await createMarkerImageFromAsset('assets/img/Car_Icon_Red.png');
    fromMarker = await createMarkerImageFromAsset('assets/img/marker_person.png');
    toMarker = await createMarkerImageFromAsset('assets/img/end_travel.png');

    checkGPS();
    getDriverInfo();
  }

  void getClientInfo() async {
    client = await _clientProvider.getById(_idTravel);
  }

  Future<double> calculatePrice () async {
    Prices prices = await _pricesProvider.getAll();

    if(seconds < 60) seconds = 60;
    if(km == 0) km = 0.1;

    int min = seconds ~/ 60;

    double priceMin = min * prices.min;
    double priceKm = km * prices.km;

    double total = priceMin + priceKm;
    if(total < prices.minValue) {
      total = prices.minValue;
    }

    return total;

  }

  void startTimer () {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      //seconds = timer.tick;
      final addSeconds = 1;

      seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);

      //String twoDigits(int n) => n.toString().padLeft(2, '0');
      //minutes = twoDigits(duration.in)

      /*if(seconds == 60){
        seconds = 0;
        minutes = minutes + 1;
      }*/
      refresh();
    });
  }

  void isCloseToPickUpPosition (LatLng from, LatLng to) {
    _distanceBetween = Geolocator.distanceBetween(from.latitude, from.longitude, to.latitude, to.longitude);
  }

  void updateStatus () {
    if(travelInfo.status == 'accepted') {
      startTravel();
    } else if(travelInfo.status == 'started') {
      finishTravel();
    }
  }

  void startTravel() async {
    if (_distanceBetween <=300) {
      Map<String,dynamic> data = {
        'status': 'started'
      };
      await _travelInfoProvider.update(data, _idTravel);
      travelInfo.status = 'started';
      currentStatus = 'Finalizar viaje';
      colorStatus = Color.fromARGB(220, 0, 29, 1);
      styleStatus = Colors.white;

      polylines = {};
      points = List();
      //markers.remove(markers['from']);
      markers.removeWhere((key, marker) => marker.markerId.value == 'from');
      addSimpleMarker('to', travelInfo.toLat, travelInfo.toLng, 'Tu destino', '', toMarker);

      LatLng from = new LatLng(_position.latitude, _position.longitude);
      LatLng to = new LatLng(travelInfo.toLat, travelInfo.toLng);

      setPolylines(from, to);
      startTimer();
      refresh();

    } else {
      utils.Snackbar.showSnackbar(context, key, 'Aún no puedes iniciar el viaje');
    }
    refresh();
  }

  void finishTravel() async {
    _timer?.cancel();

    double total = await calculatePrice();

    saveTravelHistory(total);
  }

  void saveTravelHistory(double price) async {
    TravelHistory travelHistory = new TravelHistory(
      from: travelInfo.from,
      to: travelInfo.to,
      idDriver: _authProvider.getUser().uid,
      idClient: _idTravel,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      price: price
    );

    String id = await _travelHistoryProvider.create(travelHistory);

    Map<String,dynamic> data = {
      'status': 'finished',
      'idTravelHistory': id,
      'price' : price,
    };
    await _travelInfoProvider.update(data, _idTravel);
    travelInfo.status = 'finished';

    Navigator.pushNamedAndRemoveUntil(context, 'driver/travel/calification', (route) => false, arguments: id);
  }

  void getTravelInfo() async {
    travelInfo = await _travelInfoProvider.getById(_idTravel);
    LatLng from = new LatLng(_position.latitude, _position.longitude);
    LatLng to = new LatLng(travelInfo.toLat, travelInfo.toLng);

    addSimpleMarker('from', to.latitude, to.longitude, 'Tu cliente', '', fromMarker);
    setPolylines(from, to);
    getClientInfo();
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

  void getDriverInfo () {
    Stream<DocumentSnapshot> driverStream = _driverProvider.getByIDStream(_authProvider.getUser().uid);
    _driverInfoSuscription = driverStream.listen((DocumentSnapshot document) {
      driver = Driver.fromJson(document.data());
      refresh();
    });
  }

  void dispose() {
    _timer?.cancel();
    _positionStream?.cancel();
    _statusSuscription?.cancel();
    _driverInfoSuscription?.cancel();
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]');
    _mapController.complete(controller);
  }

  void saveLocation() async {
    await _geofireProvider.createWorking(_authProvider.getUser().uid, _position.latitude, _position.longitude);
    _progressDialog.hide();
  }

  void updateLocation () async {
    try {
      await _determinePosition();
      _position = await Geolocator.getLastKnownPosition();
      getTravelInfo();
      centerPosition();
      saveLocation();

      addMarker(
          'driver',
          _position.latitude,
          _position.longitude,
          'Tu posición',
          '',
          _markerDriver
      );
      refresh();
      _positionStream = Geolocator.getPositionStream(
          desiredAccuracy: LocationAccuracy.best,
          distanceFilter: 1
      ).listen((Position position) {

        if(travelInfo.status == 'started') {
          mt = mt + Geolocator.distanceBetween(_position.latitude, _position.longitude, position.latitude, position.longitude);
          km = mt / 1000;
        }

        _position = position;
        addMarker(
            'driver',
            _position.latitude,
            _position.longitude,
            'Tu posición',
            '',
            _markerDriver
        );
        animateCameraToPosition(_position.latitude, _position.longitude);
        if(travelInfo.fromLat != null && travelInfo.fromLng != null){
          LatLng from = new LatLng(_position.latitude, _position.longitude);
          LatLng to = new LatLng(travelInfo.fromLat, travelInfo.fromLng);

          isCloseToPickUpPosition(from, to);
        }
        saveLocation();
        refresh();
      });
    } catch (error) {
      print('Error en la localización: $error');
    }
  }

  void openBottomSheet() {
    if(client == null ) return;

    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => BottomSheetDriverInfo(
          imageUrl: client?.image,
          username: client?.username,
          email: client?.email,
        )
    );
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