import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalFunctions {
  String globalURL = "http://apiseguimiento.desa.tekra.com.gt:8080/seguimiento/";

  isAcces(context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var now = new DateTime.now();
    if (sharedPreferences.get("timer_login") != null) {
      print(DateTime.parse(sharedPreferences.get('timer_login')).difference(now).inMinutes);
      if(DateTime.parse(sharedPreferences.get('timer_login')).difference(now).inMinutes <= 0) {
        print("Acceso caducido");
        sharedPreferences.clear();
        sharedPreferences.commit();
        showDialogWithNav("Acceso finalizado", "El tiempo de acceso a tu cuenta ha finalizado, vuelvete a loguear", "/login", context);
      }
    }
  }

  showDialogWithNav(title, text, rute, context){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            FlatButton(
              onPressed: (){
                Navigator.pushReplacementNamed(context, rute);
              },
              child: Text("Ir")
            )
          ],
        );
      }
    );
  }

  showModalDialog(title, text, context){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            FlatButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text("Ok")
            )
          ],
        );
      }
    );
  }
}
