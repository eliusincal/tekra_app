import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;

class PushNotificationProvider{
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _mensajesStreamController = StreamController<String>.broadcast();
  Stream<String> get mensajes => _mensajesStreamController.stream;

  initNotifications(){
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((token){
      print(token);
    });

    Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
      if (message.containsKey('data')) {
        // Handle data message
        final dynamic data = message['data'];
      }

      if (message.containsKey('notification')) {
        // Handle notification message
        final dynamic notification = message['notification'];
      }

      // Or do other work.
    }
    
    Future.delayed(Duration(seconds: 1), () {
      _firebaseMessaging.configure(
        onMessage: (info){
          print('========== On message =========');
          print(info);
          String argumento = 'no-data';
          if(Platform.isAndroid){
            argumento = info['data']['comida'] ?? 'no-data';
          }
          _mensajesStreamController.sink.add(argumento);
          return;
        },
        onLaunch: (info){
          print('========== On launch =========');
          print(info);
          String argumento = 'no-data';
          if(Platform.isAndroid){
            argumento = info['data']['comida'] ?? 'no-data';
          }
          _mensajesStreamController.sink.add(argumento);
          return;
        },
        onResume: (info){
          print('========== On resume =========');
          print(info);
          final noti = info['data']['comida'];
          print(noti);
          _mensajesStreamController.sink.add(noti);
          return;
        },
        onBackgroundMessage: myBackgroundMessageHandler
      );
    }
    );
  }

  dispose() {
    _mensajesStreamController?.close();
  }
}