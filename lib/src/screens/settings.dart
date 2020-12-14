import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tekra_app/src/screens/components/option_card_user.dart';
import 'package:tekra_app/src/screens/manage_products.dart';
import 'package:tekra_app/src/screens/manage_type_products.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  initState() {
    super.initState();
    start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff7f7f7),
        body: Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Column(
              children: <Widget>[
                Flexible(
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      CardOptions(
                        title: "Administrar tipo de productos",
                        route: ManageTypeProducts(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CardOptions(
                        title: "Administrar productos",
                        route: ManageProducts(),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  start() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("clientProductNew", "");
    sharedPreferences.setString("typeProductNew", "");
    sharedPreferences.setString("clientNameProductNew", "");
    sharedPreferences.setString("typeProductNameNew", "");
    sharedPreferences.setString("clientTypeProductNew", "");
    sharedPreferences.setString("clientNameTypeProductNew", "");
  }
}
