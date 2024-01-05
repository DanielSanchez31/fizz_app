import 'package:fizz_app/src/pages/client/travel_map/client_travel_map_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class ClientTravelMapPage extends StatefulWidget {

  @override
  _ClientTravelMapPage createState() => _ClientTravelMapPage();
}

class _ClientTravelMapPage extends State<ClientTravelMapPage> {

  ClientTravelMapController _con = new ClientTravelMapController();

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
                    _cardStatusInfo(_con.currentStatus),
                    _buttonCenterPosition(),
                  ],
                ),
                Expanded(child: Container()),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _cardStatusInfo(String status) {
    return SafeArea(
        child: Container(
          width: 120 ,
          padding: EdgeInsets.symmetric(vertical: 5),
          margin: EdgeInsets.only( top: 10),
          decoration: BoxDecoration(
            color: _con.colorStatus,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Text(
            '${status ?? '0'}',
            style: TextStyle(
                color: _con.styleStatus,
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
        onTap: () {},
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
