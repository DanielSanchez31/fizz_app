import 'package:fizz_app/src/pages/client/travel_info/client_travel_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stripe_payment/stripe_payment.dart';

import 'client_travel_pay_controller.dart';

class ClientTravelPayPage extends StatefulWidget {
  @override
  _ClientTravelPayPageState createState() => _ClientTravelPayPageState();
}

class _ClientTravelPayPageState extends State<ClientTravelPayPage> {
  ClientTravelPayController _con = new ClientTravelPayController();

  PaymentMethod paymentMethod;

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
          Align(
            child: _googleMapsWidget(),
            alignment: Alignment.topCenter,
          ),
          Align(
            child: _cardTravelInfo(),
            alignment: Alignment.bottomCenter,
          ),
          Align(
            child: _buttonBack(),
            alignment: Alignment.topLeft,
          ),
          Align(
            child:_cardKmInfo(_con.km ?? '0 km'),
            alignment: Alignment.topRight,
          ),
          Align(
            child:_cardMinInfo(_con.min ?? '0 min'),
            alignment: Alignment.topRight,
          ),
        ],
      ),
    );
  }

  Widget _cardKmInfo(String km) {
    return SafeArea(
        child: Container(

          width: 120 ,
          margin: EdgeInsets.only(right: 10, top: 10),
          padding: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: Color.fromRGBO(220, 0, 29, 1),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
         child: Text(
           km ?? '0 km',
           style: TextStyle(
             color: Colors.white,
             fontWeight: FontWeight.bold,
             fontSize: 15
           ),
           maxLines: 1,
         ),
        )
    );
  }

  Widget _cardMinInfo(String min) {
    return SafeArea(
        child: Container(
          width: 120,
          margin: EdgeInsets.only(right: 10, top: 35),
          padding: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Text(
            min ?? '0 min',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15
            ),
            maxLines: 1,
          ),
        )
    );
  }

  Widget _buttonBack() {
    return GestureDetector(
      onTap: _con.goToSelectTravel,
      child: SafeArea(
        child: Container (
          margin: EdgeInsets.only(left: 10, top: 10),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back, color: Colors.black,),
          ),
        ),
      ),
    );
  }

  Widget _cardTravelInfo() {
    return Container (
      padding: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))
      ),
      child: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'Necesitamos tu información de pago',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),
          ),
          SizedBox(height: 15,),
          Text(
            'Ingresa una nueva tarjeta o selecciona una de las existentes...',
            style: TextStyle(
                fontSize: 16
            ),
          ),
          Spacer(),
          Container(
            height: 50,
            //margin: EdgeInsets.symmetric(horizontal: 20),
            child: RaisedButton(
              color: Color.fromRGBO(220, 0, 29, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              onPressed: _con.elegirTarjeta,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Método de Pago',
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
          )
        ],
      ),
    );
  }

  Widget _googleMapsWidget() {
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

  void refresh() {
    setState(() {});
  }
}
