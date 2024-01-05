import 'dart:convert';

import 'package:fizz_app/src/models/striperModel.dart';
import 'package:fizz_app/src/utils/snack.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';

class StripeProvider {
  BuildContext context;
  String secret = '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';
  Map<String,String> headers = {
    'Authorization':'Bearer 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',
    'Content-Type':'application/x-www-form-urlencoded'
  };

  void init(BuildContext context){
    this.context = context;
    StripePayment.setOptions(
      StripeOptions(
          publishableKey: 'pk_live_51KjprTKh484jWACTF0dDwQVq7fJ251WdAZGNp3OFGvg1ngCrfuwhayofgTpNunhq4c5F8oIpYR93aMfzbXhBk3sT00yoUyitsh',
          //para modo producción hay que quitar los dos valores de abajo IMPORTANTE
          merchantId: 'test',
          androidPayMode: 'test'
      ),
    );
  }


  Future<StripeTransactionResponse> payWithCard(String amount,String currency)async{
    Token _paymentToken;
    PaymentMethod _paymentMethod;
    Source _source;
    final CreditCard testCard = CreditCard(
      number: '4000002760003184',
      expMonth: 12,
      expYear: 21,
      name: 'Test User',
      cvc: '133',
      addressLine1: 'Address 1',
      addressLine2: 'Address 2',
      addressCity: 'City',
      addressState: 'CA',
      addressZip: '1337',
    );
    print('monto: '+ amount);


    //////////////


    StripePayment.createSourceWithParams(SourceParams(
      type: 'ideal',
      amount: 1099,
      currency: 'eur',
      returnURL: 'example://stripe-redirect',
    )).then((source) {
      _source = source;
      MySnackbar.show(context, 'Efinalizado');

    }).catchError((error)=>print('errror error: '+ error.toString()));


    ///////////

    StripePayment.createTokenWithCard(
      testCard,
    ).then((token) {

        _paymentToken = token;

    }).catchError((error)=>print('errror error: '+ error.toString()));


  //////////////////////



  StripePayment.createPaymentMethod(
  PaymentMethodRequest(
  card: testCard,
  ),
  ).then((paymentMethod) {
  _paymentMethod = paymentMethod;
  }).catchError((error)=>print('errror error: '+ error.toString()));


////////////////////
    ///  StripePayment.confirmPaymentIntent(
    ///    PaymentIntent(
    ///     clientSecret: paymnetIntent['client_secret'],
    ///     paymentMethodId: _paymentMethod!.id,
    ///    ),
    ///   ).then((paymentIntent) {
    ///       _paymentIntent = paymentIntent;
    ///  }).catchError((error)=>print('errror error: '+ error.toString()));




   // try {
     // var paymentMethod = await StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest());
    //    var paymnetIntent = await createPaymentIntent(amount,currency);
    //    var response = await StripePayment.confirmPaymentIntent(
    //      PaymentIntent(
    //          clientSecret: paymnetIntent['client_secret'],
    //          paymentMethodId: paymentMethod.id
    //      ),
    //   );
//
    //    if (response.status == 'succeeded') {
    //      return StripeTransactionResponse(message: 'Transaccion exitosa',success: true);

    //   } else {
    //      return StripeTransactionResponse(message: 'Transaccion fallo',success: false);

    //    }
    //   } catch (e) {
    //     print('Error al realizar la transaccion $e');
    //     MySnackbar.show(context, 'Error al realizar la transacción $e');

    //     return null;
    //   }
  }

  Future<Map<String,dynamic>> createPaymentIntent(String amount,String currency)async{
    try {
      Map<String,dynamic> body = {
        'amount':amount,
        'currency':currency,
        'payment_method_types[]':'card'
      };

      Uri uri = Uri.https('api.stripe.com', 'v1/payment_intents');
      var response =await http.post(uri,body: body,headers: headers);
      return jsonDecode(response.body);
    } catch (e) {
      print('Error al realizar el pago $e');
      return null;
    }
  }
}