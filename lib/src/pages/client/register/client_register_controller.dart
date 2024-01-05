import 'package:fizz_app/src/models/client.dart';
import 'package:fizz_app/src/providers/auth_provider.dart';
import 'package:fizz_app/src/providers/client_provider.dart';
import 'package:fizz_app/src/utils/my_progress_dialog.dart';
import 'package:fizz_app/src/utils/snackbar.dart' as utils;
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ClientRegisterController {
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  AuthProvider _authProvider;
  ClientProvider _clientProvider;
  ProgressDialog _progressDialog;

  Future init (BuildContext context) {
    this.context = context;
    _authProvider = new AuthProvider();
    _clientProvider = new ClientProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Espere un momento...');
  }

  void register() async{
    String username = usernameController.text;
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    print('Email: $email');
    print('Password: $password');

    if(username.isEmpty & email.isEmpty & password.isEmpty & confirmPassword.isEmpty){
      print('No puede haber campos vacíos');
      utils.Snackbar.showSnackbar(context, key, 'No puede haber campos vacíos');
      return;
    }

    if (confirmPassword != password) {
      print('Las contraseñas no coinciden. Intenta de nuevo');
      utils.Snackbar.showSnackbar(context, key, 'Las contraseñas no coinciden. Intenta de nuevo');
      return;
    }

    if(password.length < 8) {
      print('El password debe tener al menos 8 caracteres');
      utils.Snackbar.showSnackbar(context, key, 'El password debe tener al menos 8 caracteres ');
    }

    _progressDialog.show();

    try {
      bool isRegister = await _authProvider.register(email, password);
      if (isRegister) {
        Client client = new Client(
          id:_authProvider.getUser().uid,
          username: username,
          email: _authProvider.getUser().email,
          password: password,
        );

        await _clientProvider.create(client);

        _progressDialog.hide();
        Navigator.pushNamedAndRemoveUntil(context, 'client/map', (route) => false);

        utils.Snackbar.showSnackbar(context, key, 'El usuario se registró correctamente');
        print('El usuario se registró correctamente');
      } else {

      }
    }catch (error) {
      _progressDialog.hide();
      utils.Snackbar.showSnackbar(context, key, 'No se pudo registrar. Error: $error');
      print('El usuario no se pudo registrar');
    }


  }
}