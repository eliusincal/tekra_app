import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tekra_app/src/provider/notifications.dart';

class SplashScreen extends StatefulWidget{
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen>{


  @override
  // ignore: must_call_super
  void initState() {
    super.initState();
    PushNotificationProvider pushNotificationProvider = new PushNotificationProvider();
    pushNotificationProvider.initNotifications();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("autorizado") == null){
      Future.delayed(
        Duration(milliseconds: 2000),
          () => Navigator.pushReplacementNamed(context, "/login"),
      );
    }else{
       Future.delayed(
        Duration(milliseconds: 2000),
          () => Navigator.pushReplacementNamed(context, "/home"),
      );
    }
  }

  @override
  Widget build(BuildContext context){
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      backgroundColor: Color(0xff26b5e6),
      body:SafeArea(
        child: Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
            Spacer(),
            Center(
              child: FractionallySizedBox(
                child: Image.asset(
                  'assets/images/logo/logo2x.png',
                  fit: BoxFit.none,
                  scale: 2,
                )
              ),
            ),
            Spacer(),
            CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      )
    );
  }
}