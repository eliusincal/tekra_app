import 'package:flutter/material.dart';
import 'package:tekra_app/src/global/global.dart';
import 'package:tekra_app/src/screens/consults.dart';
import 'package:tekra_app/src/screens/options_user.dart';
import 'package:tekra_app/src/screens/profile.dart';
import 'package:tekra_app/src/screens/settings.dart';

class Home extends StatefulWidget{
  static const String routeName = "/home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{

  int _currentIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    OptionsUser(),
    Consults(),
    Profile(),
    Settings(),
  ];

  @override
  void initState() {
    super.initState();
    GlobalFunctions().isAcces(context);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label:"Inicio",
            backgroundColor: Colors.blueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive),
            label:"Consultas",
            backgroundColor: Colors.blueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle),
            label:"Perfil",
            backgroundColor: Colors.blueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label:"Ajustes",
            backgroundColor: Colors.blueAccent,
          ),
        ],
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );  
  }
}