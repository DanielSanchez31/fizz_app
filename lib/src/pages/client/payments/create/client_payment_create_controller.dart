import 'dart:convert';

import 'package:fizz_app/src/db/db_sql.dart';
import 'package:fizz_app/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:fizz_app/src/utils/snackbar.dart' as utils;
import 'package:http/http.dart' as http;

import '../../../../models/client.dart';

class ClientPaymentCreateController {

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
  int expMonth;


  Client client;
  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    client = Client.fromJson(await _sharedPref.read('client'));
  }

  void createCardToken() async {

    if(cardNumber.isEmpty) {
      utils.Snackbar.showSnackbar(context, key, 'Ingresa el número de la tarjeta');
    } if(expireDate.isEmpty) {
      utils.Snackbar.showSnackbar(context, key, 'Ingresa la fecha de expiración');
    } if(cvvCode.isEmpty) {
      utils.Snackbar.showSnackbar(context, key, 'Ingresa el código de seguridad');
    } if(cardHolderName.isEmpty) {
      utils.Snackbar.showSnackbar(context, key, 'Ingresa el titular de la tarjeta');
    }

    if (expireDate != null) {
      List<String> list = expireDate.split('/');
      if(list.length == 2) {
        expMonth = int.parse(list[0]);
        expYear = '20${list[1]}';
      } else {
        utils.Snackbar.showSnackbar(context, key, 'Inserta el mes y año de expiración');
      }
    }

    if(cardNumber!= null) {
      cardNumber = cardNumber.replaceAll(RegExp(' '), '');
    }

    print('CVV: $cvvCode');
    print('Card Number: $cardNumber');
    print('Titular: $cardHolderName');
    print('Year: $expYear');
    print('Month: $expMonth');


  await  DBProvider.db.agregarTarjeta(int.parse(cardNumber),int.parse(cvvCode),expMonth.toString() + expYear.toString());
 //   expMonth.toString() + expYear.toString()
 Navigator.of(context).pop();

  }

  void onCreditCardModelChanged(CreditCardModel creditCardModel) {
    cardNumber = creditCardModel.cardNumber;
    expireDate = creditCardModel.expiryDate;
    cardHolderName = creditCardModel.cardHolderName;
    cvvCode = creditCardModel.cvvCode;
    isCvvFocused = creditCardModel.isCvvFocused;

    refresh();
  }

}