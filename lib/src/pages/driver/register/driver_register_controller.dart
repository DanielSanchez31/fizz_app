import 'package:fizz_app/src/models/client.dart';
import 'package:fizz_app/src/models/driver.dart';
import 'package:fizz_app/src/providers/auth_provider.dart';
import 'package:fizz_app/src/providers/client_provider.dart';
import 'package:fizz_app/src/providers/driver_provider.dart';
import 'package:fizz_app/src/utils/my_progress_dialog.dart';
import 'package:fizz_app/src/utils/snackbar.dart' as utils;
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class DriverRegisterController {
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController electorController = new TextEditingController();
  TextEditingController autoController = new TextEditingController();
  TextEditingController modelController = new TextEditingController();

  TextEditingController pin1Controller = new TextEditingController();
  TextEditingController pin2Controller = new TextEditingController();
  TextEditingController pin3Controller = new TextEditingController();
  TextEditingController pin4Controller = new TextEditingController();
  TextEditingController pin5Controller = new TextEditingController();
  TextEditingController pin6Controller = new TextEditingController();
  TextEditingController pin7Controller = new TextEditingController();

  TextEditingController interController = new TextEditingController();
  TextEditingController cardController = new TextEditingController();
  TextEditingController accountController = new TextEditingController();

  AuthProvider _authProvider;
  DriverProvider _driverProvider;
  ProgressDialog _progressDialog;

  Future init (BuildContext context) {
    this.context = context;
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Espere un momento...');
  }

  void nextRegisterPage() {
    Navigator.pushNamed(context, 'driver/register2');
  }

  void register() async{
    String username = usernameController.text;
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String elector = electorController.text.trim();
    String auto = autoController.text.trim();
    String model = modelController.text.trim();

    String pin1 = pin1Controller.text.trim();
    String pin2 = pin2Controller.text.trim();
    String pin3 = pin3Controller.text.trim();
    String pin4 = pin4Controller.text.trim();
    String pin5 = pin5Controller.text.trim();
    String pin6 = pin6Controller.text.trim();
    String pin7 = pin7Controller.text.trim();

    String plate = '$pin1$pin2$pin3-$pin4$pin5$pin6$pin7';

    print('Email: $email');
    print('Password: $password');
    print('Placas: $plate');

    if(username.isEmpty & email.isEmpty & password.isEmpty & elector.isEmpty & auto.isEmpty & model.isEmpty){
      print('No puede haber campos vacíos');
      utils.Snackbar.showSnackbar(context, key, 'No puede haber campos vacíos');
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
        Driver driver = new Driver(
          id:_authProvider.getUser().uid,
          username: username,
          email: _authProvider.getUser().email,
          password: password,
          plate: plate,
          auto: auto,
          model: model,
          identification: elector
        );

        await _driverProvider.create(driver);

        _progressDialog.hide();
        Navigator.pushNamedAndRemoveUntil(context, 'driver/map', (route) => false);

        utils.Snackbar.showSnackbar(context, key, 'El conductor se registró correctamente');
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