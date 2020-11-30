import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;

import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationProvider{

  final _mensajeController = StreamController<String>.broadcast();
  Stream<String> get mensajes =>_mensajeController.stream;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  initNotifications(){
    if(Platform.isIOS){
      _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings());
    }

    Future.delayed(Duration(seconds: 1), () {
      _firebaseMessaging.configure(
        onMessage: (info){
          print(info);
          String argumento = 'no-data';
          if(Platform.isAndroid){
            argumento = info['data']['codigo'] ?? 'no-data';
          }else{
            argumento = info['codigo'] ?? 'no-data';
          }
          verifyAccess(argumento);
          _mensajeController.sink.add(argumento);
          return;
        },
        onLaunch: (info){
          String argumento = 'no-data';
          if(Platform.isAndroid){
            argumento = info['data']['codigo'] ?? 'no-data';
          }else{
            argumento = info['codigo'] ?? 'no-data';
          }
          verifyAccess(argumento);
          _mensajeController.sink.add(argumento);
          return;
        },
        onResume: (info){
          print(info);
          String argumento = 'no-data';
          if(Platform.isAndroid){
            argumento = info['data']['codigo'] ?? 'no-data';
          }else{
            argumento = info['codigo'] ?? 'no-data';
          }
          print(argumento);
          verifyAccess(argumento);
          _mensajeController.sink.add(argumento);
          return;
        },
      );
    }
    );
  }

  dispose(){
    _mensajeController?.close();
  }

  verifyAccess(argumento){
    if(argumento != "no-data"){
      if(argumento == "123456"){
        authorize();
      }
    }
  }

  authorize() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var now = new DateTime.now();
    now = now.add(new Duration(minutes:20));
    var difference = now.difference(new DateTime.now()).inMinutes;
    print(difference);
    sharedPreferences.setString("auth", "true");
    sharedPreferences.setString("timer_login", now.toString());
  }
}