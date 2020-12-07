import 'package:flutter/material.dart';
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
                      CardOptions(
                        title: "Administrar tipo de productos", 
                        route: ManageTypeProducts(),
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
}
