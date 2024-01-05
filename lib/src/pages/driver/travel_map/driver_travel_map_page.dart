import 'package:fizz_app/src/pages/driver/travel_map/driver_travel_map_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverTravelMapPage extends StatefulWidget {

  @override
  _DriverTravelMapPageState createState() => _DriverTravelMapPageState();
}

class _DriverTravelMapPageState extends State<DriverTravelMapPage> {

  DriverTravelMapController _con = new DriverTravelMapController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      body: Stack(
        children: [
          _googleMapsWidget(),
          SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buttonUserInfo(),
                    Column(
                      children: [
                        _cardKmInfo(_con.km?.toStringAsFixed(1)),
                        _cardMinInfo(_con.minutes?.toString(), _con.seconds?.toString()),
                      ],
                    ),
                    _buttonCenterPosition(),
                  ],
                ),
                Expanded(child: Container()),
                _buttonStatus(),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _cardKmInfo(String km) {
    return SafeArea(
        child: Container(
          width: 120 ,
          margin: EdgeInsets.only( top: 10),
          decoration: BoxDecoration(
            color: Color.fromRGBO(220, 0, 29, 1),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Text(
            '${km ?? '0'} km',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15
            ),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        )
    );
  }

  Widget _cardMinInfo(String min, String sec) {
    String twoDigits(int n) => n.toString().padLeft(2,'0');
    min = twoDigits(_con.duration.inMinutes.remainder(60));
    sec = twoDigits(_con.duration.inSeconds.remainder(60));
    return SafeArea(
        child: Container(
          width: 120 ,
          margin: EdgeInsets.only( top: 10),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Text(
            '${min ?? '0'} m ${sec ?? '0'} s',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15
            ),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        )
    );
  }

  Widget _buttonUserInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: _con.openBottomSheet,
        child: Card(
          shape: CircleBorder(),
          elevation: 4.0,
          child: Container(
              padding: EdgeInsets.all(6.5),
              child: Icon(
                Icons.person,
                size: 20,
              )
          ),
        ),
      ),
    );
  }

  Widget _buttonCenterPosition() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: _con.centerPosition,
        child: Card(
          shape: CircleBorder(),
          elevation: 4.0,
          child: Container(
              padding: EdgeInsets.all(6.5),
              child: Icon(
                Icons.location_searching_outlined,
                size: 20,
              )
          ),
        ),
      ),
    );
  }

  Widget _buttonStatus() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
      child: RaisedButton(
        color: _con.colorStatus,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        onPressed: _con.updateStatus,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                _con.currentStatus,
                style:  TextStyle(color: _con.styleStatus),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: CircleAvatar(
                radius: 15,
                child: Icon(Icons.arrow_forward_ios_outlined, color: Colors.white),
                backgroundColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _googleMapsWidget () {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      markers: Set<Marker>.of(_con.markers.values),
      polylines: _con.polylines,
    );
  }

  void refresh(){
    setState(() {});
  }
}
