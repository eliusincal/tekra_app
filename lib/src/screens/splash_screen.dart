import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget{
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen>{
  @override
  // ignore: must_call_super
  void initState() {
    Future.delayed(
        Duration(milliseconds: 2000),
          () => Navigator.pushReplacementNamed(context, "/login"),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xff26b5e6),
      body:SafeArea(
        child: Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
            Spacer(),
            Center(
              child: FractionallySizedBox(
                widthFactor:.6,
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