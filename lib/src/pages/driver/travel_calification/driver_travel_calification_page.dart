import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


import '../../login/button_app.dart';
import 'driver_travel_calification_controller.dart';

class DriverTravelCalificationPage extends StatefulWidget {
  @override
  _DriverTravelCalificationPageState createState() => _DriverTravelCalificationPageState();
}

class _DriverTravelCalificationPageState extends State<DriverTravelCalificationPage> {

  DriverTravelCalificationController _con = new DriverTravelCalificationController();

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
      bottomNavigationBar: _buttonCalificate(),
      body: Column(
        children: [
          _bannerPriceInfo(),
          _listTileTravelInfo('Desde', _con.travelHistory?.from ?? '', Icons.location_on),
          _listTileTravelInfo('Hasta', _con.travelHistory?.to ?? '', Icons.trending_up),
          SizedBox(height: 30),
          _textCalificateYourDriver(),
          SizedBox(height: 15),
          _ratingBar()
        ],
      ),
    );
  }

  Widget _buttonCalificate() {
    return Container(
      height: 50,
      margin: EdgeInsets.all(30),
      child: ButtonApp(
        onPressed: _con.calificate,
        text: 'CALIFICAR',
        color: Color.fromRGBO(220, 0, 29, 1),
      ),
    );
  }

  Widget _ratingBar() {
    return Center(
      child: RatingBar.builder(
          itemBuilder: (context, _) => Icon(
            Icons.directions_car,
            color: Colors.amber,
          ),
          itemCount: 5,
          initialRating: 0,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemPadding: EdgeInsets.symmetric(horizontal: 4),
          unratedColor: Colors.grey[400],
          onRatingUpdate: (rating) {
            _con.calification = rating;
            print('RATING: $rating');
          }
      ),
    );
  }

  Widget _textCalificateYourDriver() {
    return Text(
      'CALIFICA A TU CLIENTE',
      style: TextStyle(
          color: Color.fromRGBO(220, 0, 29, 1),
          fontWeight: FontWeight.bold,
          fontSize: 18
      ),
    );
  }

  Widget _listTileTravelInfo(String title, String value, IconData icon) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14
          ),
          maxLines: 1,
        ),
        subtitle: Text(
          value,
          style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 14
          ),
          maxLines: 2,
        ),
        leading: Icon(icon, color: Colors.grey,),
      ),
    );
  }

  Widget _bannerPriceInfo() {
    return ClipPath(
      clipper: OvalBottomBorderClipper(),
      child: Container(
        height: MediaQuery.of(context).size.height * .38,
        width: double.infinity,
        color: Color.fromRGBO(220, 0, 29, 1),
        child: SafeArea(
          child: Column(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 80),
              SizedBox(height: 20),
              Text(
                'VIAJE CONCLUIDO',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
              SizedBox(height: 25),
              Text(
                'Total del viaje',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white
                ),
              ),
              SizedBox(height: 5),
              Text(
                '\$ ${_con.travelHistory?.price ?? '' }',
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight:FontWeight.bold
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
