import 'package:flutter/material.dart';

class Consults extends StatelessWidget{
  const Consults({Key key}) : super(key:key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body:Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.archive,
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