import 'package:fizz_app/src/providers/striper.dart';
import 'package:flutter/material.dart';
import 'package:fizz_app/src/utils/snackbar.dart' as utils;
import 'package:stripe_payment/stripe_payment.dart';

import '../../../models/travel_history.dart';
import '../../../providers/travel_history_provider.dart';
import '../../../utils/snack.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ClientTravelCalificationController {

  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey();
  Function refresh;

  String idTravelHistory;

  TravelHistoryProvider _travelHistoryProvider;
  TravelHistory travelHistory;
  StripeProvider stripeProvider = StripeProvider();
  double calification;
  double precioFinal;

  String numeroTarjeta;
  String codigoTarjeta;
  String fechaTarjeta;
  String month, year, date;


  Future init (BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;

    //idTravelHistory = ModalRoute.of(context).settings.arguments as String;
    Map<String,dynamic> arguments = ModalRoute.of(context).settings.arguments as Map<String,dynamic>;
    print('arguments'+arguments.toString());

    numeroTarjeta = arguments['numero_tarjeta'];
    codigoTarjeta = arguments['codigo_tarjeta'];
    fechaTarjeta = arguments['expiracion_tarjeta'];
    idTravelHistory = arguments['travelInfo'];
    print('idTravelHistory: '+idTravelHistory.toString());
    print('CARD: '+numeroTarjeta);
    print('CVV: '+codigoTarjeta);
    print('DATE: '+fechaTarjeta);
    if(fechaTarjeta.length == 6){
      month = fechaTarjeta.substring(0,2);
      year = fechaTarjeta.substring(2,6);
    }else{
      month = fechaTarjeta.substring(0,1);
      year = fechaTarjeta.substring(1,5);
    }

    print('MONT: '+month);
    print('YEAR: '+year);

    //idTravelHistory = ModalRoute.of(context).settings.arguments as String;

    _travelHistoryProvider = new TravelHistoryProvider();
    print('ID DEL TRAVEL HISTORY: $idTravelHistory');
    getTravelHistory();

    /*
    StripePayment.setOptions(
      StripeOptions(
        publishableKey:
        "pk_live_51KjprTKh484jWACTF0dDwQVq7fJ251WdAZGNp3OFGvg1ngCrfuwhayofgTpNunhq4c5F8oIpYR93aMfzbXhBk3sT00yoUyitsh",
      ),
    );
    print('price ${travelHistory?.price}');
    await confirmarPago(travelHistory?.price);
     */

  }

  void setError(dynamic error) {
    MySnackbar.show(context, "Ocurrio un error al procesar el pago " + error);
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      Map<String, String> headers = {
        'Authorization':
        'Bearer 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',
        'Content-Type': 'application/x-www-form-urlencoded'
      };

      Uri uri = Uri.https('api.stripe.com', 'v1/payment_intents');
      var response = await http.post(uri, body: body, headers: headers);
      return jsonDecode(response.body);
    } catch (e) {
      print('Error al realizar el pago $e');
      return null;
    }
  }

  Future confirmarPago(double precioFinal) async {
    PaymentMethod _paymentMethod;
    final CreditCard testCard = CreditCard(
      number: numeroTarjeta,
      expMonth: int.parse(month),
      expYear: int.parse(year),
      name: 'Test User',
      cvc: codigoTarjeta,
      addressLine1: 'Address 1',
      addressLine2: 'Address 2',
      addressCity: 'City',
      addressState: 'CA',
      addressZip: '1337',
    );

    await StripePayment.createPaymentMethod(
      PaymentMethodRequest(
        card: testCard,
      ),
    ).then((paymentMethod) {
      _paymentMethod = paymentMethod;
    }).catchError(setError);

    print('object');

    print(_paymentMethod);

    if (_paymentMethod != null) {
      print('precioFinal: '+precioFinal.toString());
      var paymentIntent = await createPaymentIntent(((precioFinal * 100).toStringAsFixed(0)).toString(), 'MXN');

      await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: _paymentMethod.id,
        ),
      ).then((paymentIntent) {
        if (paymentIntent.status == 'succeeded') {
          print('terminado');
          MySnackbar.show(context, "Transaccion exitosa!");
          //  Navigator.pushNamed(context, )
          return;
        } else {
          return MySnackbar.show(context, 'Transaccion fallida');
        }
      }).catchError(setError);
    }
  }

  void calificate() async {

    if (calification == null) {
      utils.Snackbar.showSnackbar(context, key, 'Por favor califica a tu cliente');
      return;
    }
    if (calification == 0) {
      utils.Snackbar.showSnackbar(context, key, 'La calificacion minima es 1');
      return;
    }
    Map<String, dynamic> data = {
      'calificationDriver': calification
    };

    await _travelHistoryProvider.update(data, idTravelHistory);
    Navigator.pushNamedAndRemoveUntil(context, 'client/map', (route) => false);
  }

  Future<void> getTravelHistory() async {
    travelHistory = await _travelHistoryProvider.getById(idTravelHistory);
    print('travelHistory: ' + travelHistory.toJson().toString());
    precioFinal = travelHistory?.price;
    StripePayment.setOptions(
      StripeOptions(
        publishableKey:
        "pk_live_51KjprTKh484jWACTF0dDwQVq7fJ251WdAZGNp3OFGvg1ngCrfuwhayofgTpNunhq4c5F8oIpYR93aMfzbXhBk3sT00yoUyitsh",
      ),
    );
    print('price $precioFinal');
    await confirmarPago(precioFinal);
    refresh();
  }


}