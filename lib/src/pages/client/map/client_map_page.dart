import 'package:fizz_app/src/pages/client/map/client_map_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientMapPage extends StatefulWidget {
  @override
  _ClientMapPageState createState() => _ClientMapPageState();
}

class _ClientMapPageState extends State<ClientMapPage> {

  ClientMapController _con = new ClientMapController();

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
                _buttonDrawer(),
                _cardGooglePlace(),
                _buttonChangeTo(),
                _buttonCenterPosition(),
                Expanded(child: Container()),
                _buttonRequest(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: _iconMyLocation(),
          )
        ],
      ),
    );
  }

  Widget _iconMyLocation () {
    return Image.asset(
        'assets/img/location_red.png',
      width: 35,
      height: 35,
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
                    _con.client?.username ?? 'Nombre de Usuario',
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
                    _con.client?.email ?? 'Email',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: 10),
                CircleAvatar(
                  backgroundImage: _con.client?.image != null
                      ? NetworkImage(_con.client?.image)
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
            title: Text ('Métodos de pago'),
            trailing: Icon(Icons.credit_card),
            onTap: _con.goToPaymentPage,
          ),
          ListTile(
            title: Text ('Historial de viajes'),
            trailing: Icon(Icons.date_range),
            onTap: _con.goToHistoryPage,
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
      alignment: Alignment.centerRight,
      margin: EdgeInsets.symmetric(horizontal: 10),
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

  Widget _buttonChangeTo() {
    return Container(
      alignment: Alignment.centerRight,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: _con.changeFromTo,
        child: Card(
          shape: CircleBorder(),
          elevation: 4.0,
          child: Container(
              padding: EdgeInsets.all(6.5),
              child: Icon(
                Icons.place_outlined,
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

  Widget _buttonRequest() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
      child: RaisedButton(
        color: Color.fromRGBO(220, 0, 29, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        onPressed: _con.requestDriver,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'SOLICITAR',
                style:  TextStyle(color: Colors.white),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: CircleAvatar(
                radius: 15,
                child: Icon(Icons.arrow_forward_ios_outlined, color: Colors.white),
                backgroundColor: Color.fromRGBO(220, 0, 29, 1),
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
      onCameraMove: (position){
        _con.initialPosition =  position;
      },
      onCameraIdle: () async {
        await _con.setLocationDraggableInfo();
      },
    );
  }

  Widget _cardGooglePlace () {
    return Container(
      width: MediaQuery.of(context).size.width * .95,
      child: Card (
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoCardLocation(
                  'Desde',
                  _con.from ?? 'Lugar de inicio',
                  () async {
                    await _con.showGoogleAutocomplete(true);
                  }
              ),
              SizedBox(height: 5),
              Divider(color: Colors.grey[400],),
              SizedBox(height: 5),
              _infoCardLocation(
                  'Hasta',
                  _con.to ?? 'Lugar de destino',
                      () async {
                    await _con.showGoogleAutocomplete(false);
                  }
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCardLocation (String title, String value, Function function) {
    return GestureDetector(
      onTap: function ,
      child: Column (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 10
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  void refresh(){
    setState(() {});
  }
}
