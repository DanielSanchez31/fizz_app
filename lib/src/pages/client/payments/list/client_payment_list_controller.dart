


import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../db/db_sql.dart';
import '../../../../models/client.dart';
import '../../../../utils/shared_pref.dart';

class ClientPaymentListController {

  BuildContext context;
  Function refresh;
  GlobalKey<FormState> keyForm = new GlobalKey();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  String cardNumber = '';
  String expireDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  String expYear;
  // List listadoDeTarjetas;
  int expMonth;
  bool boleano;

  String from;
  LatLng fromLatLng;
  String to;
  LatLng toLatLng;

  Client client;
  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    Map<String,dynamic> arguments = ModalRoute.of(context).settings.arguments as Map<String,dynamic>;
    boleano = arguments['boleano'];
    from = arguments['from'];
    to = arguments['to'];
    fromLatLng = arguments['fromLatLng'];
    toLatLng = arguments['toLatLng'];
    print('boleano: '+boleano.toString());
    //await DBProvider.db.eliminarTarjeta(4242424242424242);

    // listadoDeTarjetas = await DBProvider.db.listarTarjetas();
   // print(listadoDeTarjetas);
    refresh();

    client = Client.fromJson(await _sharedPref.read('client'));

  }


}