import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tekra_app/src/screens/components/message_context_text.dart';
import 'package:tekra_app/src/screens/components/rounded_button.dart';
import 'package:tekra_app/src/screens/components/rounded_input_field.dart';
import 'package:tekra_app/src/screens/components/rounded_password_field.dart';
import 'package:tekra_app/src/mixins/validation.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:tekra_app/src/utils/dialog.dart';

// ignore: must_be_immutable
class ExpiredKey extends StatefulWidget{
  //Url para poder acceder a esta clase
  static const String routeName = "/expired_key";

  @override
  _ExpiredKey createState() => _ExpiredKey();
}

class _ExpiredKey extends State<ExpiredKey> with ValidationMixins {
  TextEditingController userController = TextEditingController();
  TextEditingController claveActualController = TextEditingController();
  TextEditingController claveNuevaController = TextEditingController();

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
                text: "Clave actual",
                onChanged: (value){},
                validator: validateContrasena,
                controller: claveActualController,
                pass: false,
              ),
              RoundedPasswordField(
                text: "Clave nueva",
                onChanged: (value){},
                validator: validateContrasena,
                controller: claveNuevaController,
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
                text: "SOLICITAR",
                press: (){
                  if(formKey.currentState.validate()){
                    _submit(this.context, userController.text, claveActualController.text, claveNuevaController.text);
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

  _submit(context, String user, String pass, String newPass) async{
    ProgressDialog2 progressDialog = ProgressDialog2(context);
    progressDialog.show();
    var result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.none){
      progressDialog.dismiss();
      _showDialog("Conexión no encontrada", "Actualmente no tienes acceso a Internet.");
    }else{
      Map data = {
        'autenticacion':{
          'pn_usuario':user,
          'pn_clave':pass,
        },
        'parametros':{
          'pn_origen':"L",
          'pn_usuario':user,
          'pn_clave_actual': pass,
          'pn_clave_nueva': newPass
        }
      };
      var body = convert.jsonEncode(data);
      print(body);
      var jsonData;
      var response = await http.put("http://apiseguimiento.desa.tekra.com.gt:8080/seguimiento/administracion/usuarios/usuarios_cambio_clave", headers: {"Content-Type": "application/json"}, body: body);
      if(response.statusCode == 200){
        jsonData = json.decode(response.body);
        if(jsonData['resultado'][0]['error'] == 0){
          _showDialogWithNav("Clave actualizada", "Tu clave ha sido actualizada, inicia sesión de nuevo", "/login");
        }else{
          progressDialog.dismiss();
          mensaje = jsonData['resultado'][0]['mensaje'];
        }
      }else if(response.statusCode == 500){
        progressDialog.dismiss();
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


