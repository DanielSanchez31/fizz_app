import 'package:fizz_app/src/pages/driver/map/driver_map_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverMapPage extends StatefulWidget {
  @override
  _DriverMapPageState createState() => _DriverMapPageState();
}

class _DriverMapPageState extends State<DriverMapPage> {

  DriverMapController _con = new DriverMapController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('Ejecutar DISPOSE');
    _con.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      drawer: _drawer(),
      body: Stack(
        children: [
          _googleMapsWidget(),
          SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buttonDrawer(),
                    _buttonCenterPosition(),
                  ],
                ),
                Expanded(child: Container()),
                _buttonConnect(),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _drawer () {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    _con.driver?.username ?? 'Nombre de Usuario',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                    maxLines: 1,
                  ),
                ),
                Container(
                  child: Text(
                    _con.driver?.email ?? 'Email',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                    ),
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: 10),
                CircleAvatar(
                  backgroundImage: _con.driver?.image != null
                      ? NetworkImage(_con.driver?.image)
                      : AssetImage('assets/img/profile.jpg'),
                  radius: 40,
                )
              ],
            ),
            decoration: BoxDecoration(
              color: Color.fromRGBO(220, 0, 29, 1),
            ),
          ),
          ListTile(
            title: Text ('Editar perfil'),
            trailing: Icon(Icons.edit),
            onTap: _con.goToEditPage,
          ),
          ListTile(
            title: Text ('Cerrar sesión'),
            trailing: Icon(Icons.exit_to_app),
            onTap: _con.signOut,
          )
        ],
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

  Widget _buttonDrawer(){
    return  Container(
        alignment:  Alignment.centerLeft,
        child: IconButton(
          onPressed: _con.openDrawer,
          icon: Icon(Icons.menu, color: Colors.white, size: 20,),
        ),
      );
  }

  Widget _buttonConnect() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
      child: RaisedButton(
        color: !_con.isConnect ? Color.fromRGBO(220, 0, 29, 1) : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        onPressed: _con.connet,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                _con.isConnect ? 'DESCONECTARSE' : 'CONECTARSE',
                style:  TextStyle(color: !_con.isConnect ? Colors.white : Colors.grey[500]),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: CircleAvatar(
                radius: 15,
                child: Icon(Icons.arrow_forward_ios_outlined, color: !_con.isConnect ? Colors.white : Colors.grey[500]),
                backgroundColor: !_con.isConnect ? Color.fromRGBO(220, 0, 29, 1) : Colors.white,
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
    );
  }

  void refresh(){
    setState(() {});
  }
}
