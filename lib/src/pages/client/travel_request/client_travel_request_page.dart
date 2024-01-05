import 'package:fizz_app/src/pages/client/travel_request/client_travel_request_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:lottie/lottie.dart';

class ClientTravelRequestPage extends StatefulWidget {

  @override
  _ClientTravelRequestPageState createState() => _ClientTravelRequestPageState();
}

class _ClientTravelRequestPageState extends State<ClientTravelRequestPage> {

  ClientTravelRequestController _con = new ClientTravelRequestController();

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
    _con.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      body: Column(
        children: [
          _driverInfo(),
          _lottieAnimation(),
          _textLookingFor(),
          _textCounter(),
        ],
      ),
      bottomNavigationBar: _buttonCancel(),
    );
  }

  Widget _lottieAnimation () {
    return Lottie.asset(
      'assets/json/car_control.json',
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width * 0.95,
      fit: BoxFit.fill,
    );
  }

  Widget _textLookingFor() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      child: Text(
        'Buscando conductores...',
        style: TextStyle(
          fontSize: 16
        ),
      ),
    );
  }

  Widget _textCounter() {
    return Container(
      child: Text(
        '0',
        style: TextStyle(
          fontSize: 30
        ),
      ),
    );
  }

  Widget _buttonCancel () {
    return Container(
      height: 50,
      margin: EdgeInsets.all(30),
      child: RaisedButton(
        color: Color.fromRGBO(220, 0, 29, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        onPressed: () {},
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Cancelar viaje',
                style:  TextStyle(color: Colors.white),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: CircleAvatar(
                radius: 15,
                child: Icon(Icons.cancel_outlined, color: Colors.white),
                backgroundColor: Color.fromRGBO(220, 0, 29, 1),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _driverInfo() {
      return ClipPath(
        clipper: OvalBottomBorderClipper(),
        child: Container(
          color: Color.fromRGBO(220, 0, 29,1),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/img/profile.jpg'),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Tu Conductor',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      );
  }

  void refresh() {
    setState(() {});
  }
}
