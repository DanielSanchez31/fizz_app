import 'package:fizz_app/src/providers/auth_provider.dart';
import 'package:fizz_app/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class HomeController {
  BuildContext context;
  SharedPref _sharedPref;

  AuthProvider _authProvider;
  String _typeUser;
  String _isNotification;

  Future init(BuildContext context) async {
    this.context = context;
    _sharedPref = new SharedPref();
    _authProvider = new AuthProvider();

    _typeUser = await _sharedPref.read('typeUser');
    _isNotification = await _sharedPref.read('isNotification');
    checkIfUserIsAuth();
  }

  void checkIfUserIsAuth() {
    bool isSigned = _authProvider.isSignedIn();
    if (isSigned) {

      if(_isNotification != 'true') {
        if (_typeUser == 'client'){
          Navigator.pushNamedAndRemoveUntil(context, 'client/map', (route) => false);
        } else{
          Navigator.pushNamedAndRemoveUntil(context, 'driver/map', (route) => false);
        }
      }

    }
  }

  void goToLoginPage(String typeUser) async {
    saveTypeUser(typeUser);
    Navigator.pushNamed(context, 'login');
  }

  void saveTypeUser(String typeUser) async {
    await _sharedPref.save('typeUser', typeUser);
  }

}