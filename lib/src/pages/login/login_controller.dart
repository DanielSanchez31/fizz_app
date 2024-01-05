import 'package:fizz_app/src/models/client.dart';
import 'package:fizz_app/src/models/driver.dart';
import 'package:fizz_app/src/providers/auth_provider.dart';
import 'package:fizz_app/src/providers/client_provider.dart';
import 'package:fizz_app/src/providers/driver_provider.dart';
import 'package:fizz_app/src/utils/my_progress_dialog.dart';
import 'package:fizz_app/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fizz_app/src/utils/snackbar.dart' as utils;

class LoginController {
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  SharedPref _sharedPref;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  AuthProvider _authProvider;
  ProgressDialog _progressDialog;
  DriverProvider _driverProvider;
  ClientProvider _clientProvider;

  String _typeUser, user;

  Future init (BuildContext context) async {
    this.context = context;
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
    _clientProvider = new ClientProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Iniciando sesión...');
    _sharedPref = new SharedPref();
    _typeUser = await _sharedPref.read('typeUser');
    if (_typeUser == 'client'){
      user = 'Cliente';
    } else if (_typeUser == 'driver'){
      user = 'Conductor';
    }
    print('Usuario: $user');
  }

  void goToRegisterPage() {
    if(_typeUser == 'client'){
      Navigator.pushNamed(context, 'client/register');
    } else {
      Navigator.pushNamed(context, 'driver/register');
    }

  }

  void returnUsers(){
    Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
  }

  void login() async{
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    print('Email: $email');
    print('Password: $password');

    _progressDialog.show();

    try {
      bool isLogin = await _authProvider.login(email, password);
      _progressDialog.hide();

      if (isLogin) {
        if(_typeUser == 'client'){
          Client client = await _clientProvider.getById(_authProvider.getUser().uid);
          print('Client $client');

          if (client != null) {
            Navigator.pushNamedAndRemoveUntil(context, 'client/map', (route) => false);
          } else {
            print('sesión terminada CLIENTE');
            utils.Snackbar.showSnackbar(context, key, 'El usuario o contraseña no es válido');
            await _authProvider.signOut();
          }
        } else if(_typeUser == 'driver'){
          Driver driver = await _driverProvider.getById(_authProvider.getUser().uid);
          print('Driver $driver');

          if (driver != null) {
            Navigator.pushNamedAndRemoveUntil(context, 'driver/map', (route) => false);
          } else {
            print('sesión terminada');
            utils.Snackbar.showSnackbar(context, key, 'El usuario o contraseña no es válido');
            await _authProvider.signOut();
          }
        }
      } else {
        utils.Snackbar.showSnackbar(context, key, 'El usuario no se pudo autenticar');
        print('El usuario no se pudo autenticar');
      }
    }catch (error) {
      _progressDialog.hide();
      utils.Snackbar.showSnackbar(context, key, 'Error: $error');
      print('Error: $error');
    }


  }
}