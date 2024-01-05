import 'package:fizz_app/src/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController _con = new HomeController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(220, 0, 29, 1),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              _bannerApp(context),
              SizedBox(height: 100),
              _typeUserC(context, 'client'),
              SizedBox(height: 20),
              _typeUserD(context, 'driver'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bannerApp(BuildContext context) {
    return ClipPath(
      clipper: WaveClipperTwo(),
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 0.35,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/img/FizzApp_Logo_Rojo.png',
              width: 150,
              height: 100,
            )
          ],
        ),
      ),
    );
  }

  Widget _typeUserC(BuildContext context, String typeUser) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      height: 50,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          onPressed: () => _con.goToLoginPage(typeUser),
          color: Colors.white,
          child: Center(
            child: Text(
              'Cliente',
              style: TextStyle(
                color: Color.fromRGBO(220, 0, 29, 1),
                fontSize: 20,
              ),
            ),

          ),
        ),
    );
  }

  Widget _typeUserD(BuildContext context, String typeUser) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      height: 50,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        onPressed: () => _con.goToLoginPage(typeUser),
        color: Colors.white,
        child: Center(
          child: Text(
            'Conductor',
            style: TextStyle(
              color: Color.fromRGBO(220, 0, 29, 1),
              fontSize: 20,
            ),
          ),

        ),
      ),
    );
  }
}
