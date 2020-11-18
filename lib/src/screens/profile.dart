import 'package:flutter/material.dart';

class Profile extends StatelessWidget{
  const Profile({Key key}) : super(key:key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.yellow,
      body:Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.portable_wifi_off_outlined,
                size: 160.0,
                color: Colors.white,
              ),
              Text(
                "Tercer tab",
                style: TextStyle(
                  color:Colors.white
                ),
              )
            ],
          ),
        )
      )
    );
  }
}