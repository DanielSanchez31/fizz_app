import 'package:fizz_app/src/pages/driver/travel_request/driver_travel_request_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class DriverTravelRequestPage extends StatefulWidget {

  @override
  _DriverTravelRequestPageState createState() => _DriverTravelRequestPageState();
}

class _DriverTravelRequestPageState extends State<DriverTravelRequestPage> {

  DriverTravelRequestController _con = new DriverTravelRequestController();

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
      body: Column(
        children: [
          _bannerClientInfo(),
          _textFromTo(_con.from ?? '', _con.to ?? ''),
          _textTimeLimit(),
        ],
      ),
      bottomNavigationBar: _buttonsAction(),
    );
  }

  Widget _buttonsAction() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            child: RaisedButton(
              color: Colors.grey[500],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              onPressed: () {},
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'CANCELAR',
                      style:  TextStyle(color: Colors.white,fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            child: RaisedButton(
              color: Color.fromRGBO(220, 0, 29, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              onPressed: _con.acceptTravel,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'ACEPTAR',
                      style:  TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _textTimeLimit() {
    return Container (
      margin: EdgeInsets.symmetric(vertical: 30),
      child: Text(
        _con.seconds.toString(),
        style: TextStyle(
          fontSize: 50
        ),
      ),
    );
  }

  Widget _textFromTo(String from, String to) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Recoger en: ',
            style: TextStyle(
              fontSize: 22
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              from,
              style: TextStyle(
                  fontSize: 18
              ),
            ),
          ),
          SizedBox(height: 30),
          Text(
            'Destino en: ',
            style: TextStyle(
                fontSize: 22
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              to,
              style: TextStyle(
                  fontSize: 18
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _bannerClientInfo() {
    return ClipPath(
      clipper: OvalBottomBorderClipper(),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * .30,
        color: Color.fromRGBO(220, 0, 29, 1),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/img/profile.jpg'),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                child: Text(
                  _con.client?.username ?? 'Cliente',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {

    });
  }

}
