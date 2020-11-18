import 'package:flutter/material.dart';

class Settings extends StatelessWidget{
  const Settings({Key key}) : super(key:key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey,
      body:Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.settings,
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