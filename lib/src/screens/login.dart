import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tekra_app/src/screens/components/message_context_text.dart';
import 'package:tekra_app/src/screens/components/rounded_button.dart';
import 'package:tekra_app/src/screens/components/rounded_input_field.dart';
import 'package:tekra_app/src/screens/components/rounded_password_field.dart';
import 'package:tekra_app/src/mixins/validation.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'dart:convert' as convert;

// ignore: must_be_immutable
class Login extends StatefulWidget{
  //Url para poder acceder a esta clase
  static const String routeName = "/login";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with ValidationMixins {
  TextEditingController userController = TextEditingController();

  TextEditingController contrasenaController = TextEditingController();

  final GlobalKey<FormState> formKey= new GlobalKey<FormState>();
  String mensaje = "";

  @override
  Widget build(BuildContext context){
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xfff4fbfe),
      body:Form(
        key: formKey,
        child: Container(
          width: double.infinity,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 56,
              ),
              Image.asset(
                'assets/images/logo/logo3x-black.png',
                fit: BoxFit.none,
                scale: 2,
              ),
              Spacer(),
              RoundedInputField(
                text: "Usuario",
                onChanged: (value){
                },
                validator: validateUsuario,
                controller: userController,
              ),
              RoundedPasswordField(
                onChanged: (value){},
                validator: validateContrasena,
                controller: contrasenaController,
                pass: false,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                mensaje,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 15,
                ),
              )
              ,
              Spacer(),
              MessageContextText(
                text: "¿Olvidaste tu contraseña?",
                textaction: "Recuperar contraseña",
                size: size,
                ontap: (){},
              ),
              SizedBox(
                height: 20,
              ),
              RoudedButton(
                text: "INICIAR SESIÓN",
                press: (){
                  if(formKey.currentState.validate()){
                    _login(userController.text, contrasenaController.text);
                  }
                },
                color: Color(0xff26b5e6),
                textColor: Colors.white,
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),  
    );
  }

  _login(String user, String pass) async{
    var result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.none){
      _showDialog("Conexión no encontrada", "Actualmente no tienes acceso a Internet.");
    }else{
      String pnClave = "";     
      FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
      _firebaseMessaging.requestNotificationPermissions();
      final token = await _firebaseMessaging.getToken();
      if(Platform.isAndroid){
        pnClave = "ADR";
      }else if(Platform.isIOS){
        pnClave = "IOS";
      }
      Map data = {
        'parametros':{
          'pn_usuario':user,
          'pn_clave':pass,
          'pn_origen': pnClave,
          'pn_identificador': token
        }
      };
      var body = convert.jsonEncode(data);
      print(body);
      var jsonData;
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var response = await http.post("http://apiseguimiento.desa.tekra.com.gt:8080/seguimiento/administracion/login/usuarios_login", headers: {"Content-Type": "application/json"}, body: body);
      if(response.statusCode == 200){
        jsonData = json.decode(response.body);
        if(jsonData['resultado'][0]['error'] == 0){
          if(jsonData['datos'][0]['clave_vencida']==1){
            _showDialogWithNav("Clave vencida", "Tu clave ha expirado, vuelve a solicitar una clave", "/two_step_verification");
          }else{
            sharedPreferences.setString("key", jsonData['datos'][0]['codigo_autorizacion']);
            Navigator.pushReplacementNamed(context, "/two_step_verification");
            //_showDialog("Todo nice", "te salio el login");
          }
        }else{
          mensaje = jsonData['resultado'][0]['mensaje'];
        }
      }else if(response.statusCode == 500){
        _showDialog("Error en el servidor", "Se generó un error al intentar conectarse al servidor, intentelo de nuevo o espere un momento.");
      }
    }
  }

  _showDialog(title, text){
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
  _showDialogWithNav(title, text, rute){
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
}


