import 'package:flutter/material.dart';
import 'package:fizz_app/src/models/driver.dart';
import 'package:fizz_app/src/providers/auth_provider.dart';
import 'package:fizz_app/src/providers/driver_provider.dart';
import 'package:fizz_app/src/providers/travel_history_provider.dart';
import 'package:fizz_app/src/models/travel_history.dart';

class ClientHistoryController {

  Function refresh;
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TravelHistoryProvider _travelHistoryProvider;
  AuthProvider _authProvider;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _travelHistoryProvider = new TravelHistoryProvider();
    _authProvider = new AuthProvider();

    refresh();
  }

  Future<String> getName (String idDriver) async {
    DriverProvider driverProvider = new DriverProvider();
    Driver driver = await driverProvider.getById(idDriver);
    return driver.username;
  }

  Future<List<TravelHistory>> getAll() async {
    return await _travelHistoryProvider.getByIdClient(_authProvider.getUser().uid);
  }

  void goToDetailHistory(String id) {
    Navigator.pushNamed(context, 'client/history/detail', arguments: id);
  }

}