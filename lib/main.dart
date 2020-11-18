import 'package:flutter/material.dart';
import 'package:tekra_app/src/screens/home.dart';
import 'package:tekra_app/src/screens/login.dart';
import 'package:tekra_app/src/screens/splash_screen.dart';
import 'package:tekra_app/src/screens/two_step_verification.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    routes: <String, WidgetBuilder>{
      Login.routeName :(BuildContext context) => Login(),
      TwoStepVerification.routeName : (BuildContext context)=> TwoStepVerification(),
      Home.routeName:(BuildContext context)=> Home(),
    },
  ));
}