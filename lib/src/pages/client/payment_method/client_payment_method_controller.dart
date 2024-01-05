
import 'package:fizz_app/src/models/client.dart';
import 'package:fizz_app/src/providers/auth_provider.dart';
import 'package:fizz_app/src/providers/client_provider.dart';
import 'package:fizz_app/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class ClientPaymentMethodController {


  BuildContext context;
  Function refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey();

  ClientProvider _clientProvider;
  AuthProvider _authProvider;

  Client client;
  SharedPref _sharedPref;

  String nombre, apellido;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    
    client = Client.fromJson(await _sharedPref.read('client'));

    _clientProvider = new ClientProvider();
    _authProvider = new AuthProvider();

    getClientInfo();
  }

  void getClientInfo() async {
    client = await _clientProvider.getById(_authProvider.getUser().uid);
  }

  void newUser() async {
    print('Username ${client.username}');
    String username = client.username;
    if (username != null) {
      List<String> list = username.split(' ');
      if(list.length == 2) {
        nombre = list[0];
        apellido = list[1];
      } else {
        print('Error al separar');
      }
    }

    print('Nombre: $nombre');
    print('Apellido: $apellido');
    print('Email: ${client.email}');

    //await _mercadoPago.newUser(nombre, apellido, client.email);
  }

  void irAPagos (){

  }

}