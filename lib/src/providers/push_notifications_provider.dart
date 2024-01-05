import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fizz_app/src/providers/client_provider.dart';
import 'package:fizz_app/src/providers/driver_provider.dart';
import 'package:fizz_app/src/utils/shared_pref.dart';
import 'package:http/http.dart' as http;

class PushNotificationsProvider {

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  StreamController _streamController = StreamController<Map<String,dynamic>>.broadcast();

  Stream<Map<String,dynamic>> get message => _streamController.stream;

  void initPushNotifications() async {

    //ON LAUNCH
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage message) {
      if(message != null) {
        Map<String,dynamic> data = message.data;

        SharedPref sharedPref = new SharedPref();
        sharedPref.save('isNotification', 'true');

        _streamController.sink.add(data);
      }
    });
    //ON MESSAGE
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      Map<String,dynamic> data = message.data;

      _streamController.sink.add(data);

    });
    //ON RESUME
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Map<String,dynamic> data = message.data;
      print('A new onMessageOpenedApp event was published!');

      _streamController.sink.add(data);
    });



  }

  void saveToken(String idUser, String typeUser) async {
    String token= await _firebaseMessaging.getToken();
    Map<String,dynamic> data = {
      'token': token
    };

    if (typeUser == 'client') {
      ClientProvider clientProvider = new ClientProvider();
      clientProvider.update(data, idUser);
    } else {
      DriverProvider driverProvider = new DriverProvider();
      driverProvider.update(data, idUser);
    }
  }

  Future<void> sendMessage(String to,Map<String,dynamic> data, String title, String body) async {
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String,String> {
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAA16GUpso:APA91bGIBhFhEMkvCX66IBQN7r24Ec1jyin6bs67L4Xunx3MRMAFjsOP2bPQ25vOm81e5lvrbHTT63VyFSzxUhNPBEfvFsxamNK0b8ynYE9oqiqHtkyFiuEDgk83RP8XRATZGdLG34o1',
      },
      body: jsonEncode(
        <String,dynamic> {
          'notification': <String, dynamic> {
            'body': body,
            'title': title,
          },
          'priority': 'high',
          'ttl': '4500s',
          'data': data,
          'to': to,
        }
      ),
    );
  }

  void dispose(){
    _streamController?.onCancel;
  }

}