import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fizz_app/src/home/home_page.dart';
import 'package:fizz_app/src/pages/client/edit/client_edit_page.dart';
import 'package:fizz_app/src/pages/client/history/client_history_page.dart';
import 'package:fizz_app/src/pages/client/history_detail/client_history_detail_page.dart';
import 'package:fizz_app/src/pages/client/map/client_map_page.dart';
import 'package:fizz_app/src/pages/client/payment_method/client_payment_method_page.dart';
import 'package:fizz_app/src/pages/client/payments/create/client_payment_create_page.dart';
import 'package:fizz_app/src/pages/client/payments/list/client_payment_list.dart';
import 'package:fizz_app/src/pages/client/travel_calification/client_travel_calification_page.dart';
import 'package:fizz_app/src/pages/client/travel_info/client_travel_info_page.dart';
import 'package:fizz_app/src/pages/client/travel_map/client_travel_map_page.dart';
import 'package:fizz_app/src/pages/client/travel_pay/client_travel_pay_page.dart';
import 'package:fizz_app/src/pages/client/travel_request/client_travel_request_page.dart';
import 'package:fizz_app/src/pages/driver/edit/driver_edit_page.dart';
import 'package:fizz_app/src/pages/driver/map/driver_map_page.dart';
import 'package:fizz_app/src/pages/driver/register/driver_register_2_page.dart';
import 'package:fizz_app/src/pages/driver/register/driver_register_page.dart';
import 'package:fizz_app/src/pages/driver/travel_calification/driver_travel_calification_page.dart';
import 'package:fizz_app/src/pages/driver/travel_map/driver_travel_map_page.dart';
import 'package:fizz_app/src/pages/driver/travel_request/driver_travel_request_page.dart';
import 'package:fizz_app/src/pages/login/login_page.dart';
import 'package:fizz_app/src/pages/client/register/client_register_page.dart';
import 'package:fizz_app/src/providers/push_notifications_provider.dart';
import 'package:flutter/material.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a brackground message ${message.messageId}');
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    PushNotificationsProvider pushNotificationsProvider = new PushNotificationsProvider();
    pushNotificationsProvider.initPushNotifications();

    pushNotificationsProvider.message.listen((data) {

      navigatorKey.currentState.pushNamed('driver/travel/request', arguments: data);

    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fizz App',
      navigatorKey: navigatorKey,
      initialRoute: 'home',
      routes: {
        'home' : (BuildContext context) => HomePage(),
        'login' : (BuildContext context) => LoginPage(),
        'client/register' : (BuildContext context) => ClientRegisterPage(),
        'driver/register' : (BuildContext context) => DriverRegisterPage(),
        'driver/register2' : (BuildContext context) => DriverRegister2Page(),
        'client/map' : (BuildContext context) => ClientMapPage(),
        'client/edit' : (BuildContext context) => ClientEditPage(),
        'client/history' : (BuildContext context) => ClientHistoryPage(),
        'client/history/detail' : (BuildContext context) => ClientHistoryDetailPage(),
        'client/payment/create' : (BuildContext context) => ClientPaymentCreatePage(),
        'client/payment/list' : (BuildContext context) => ClientPaymentListPage(),
        'client/travel/pay' : (BuildContext context) => ClientTravelPayPage(),
        'client/payment/method' : (BuildContext context) => ClientPaymentMethodPage(),
        'driver/map' : (BuildContext context) => DriverMapPage(),
        'driver/edit' : (BuildContext context) => DriverEditPage(),
        'client/travel/info' : (BuildContext context) => ClientTravelInfoPage(),
        'client/travel/request' : (BuildContext context) => ClientTravelRequestPage(),
        'client/travel/calification' : (BuildContext context) => ClientTravelCalificationPage(),
        'driver/travel/request' : (BuildContext context) => DriverTravelRequestPage(),
        'client/travel/map' : (BuildContext context) => ClientTravelMapPage(),
        'driver/travel/map' : (BuildContext context) => DriverTravelMapPage(),
        'driver/travel/calification' : (BuildContext context) => DriverTravelCalificationPage(),
      },
    );
  }
}
