import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tekra_app/src/global/global.dart';
import 'package:tekra_app/src/screens/components/rounded_button.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:tekra_app/src/screens/components/rounded_input_field.dart';
import 'package:tekra_app/src/utils/dialog.dart';

class NewProduct extends StatefulWidget {
  _NewProduct createState() => _NewProduct();
}

class _NewProduct extends State<NewProduct> {
  GlobalFunctions gFunct = GlobalFunctions();
  //Formulario para poder generar las validaciones
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  //Objetos necesarios para un nuevo producto
  TextEditingController descriptionController = TextEditingController();
  TextEditingController precioController = TextEditingController();
  TextEditingController identificadorController = TextEditingController();

  //Variables necesarias para los objetos relacionados a cliente:
  String clientValue;
  String clientSelected;

  //Variables necesarias para los objetos relacionados a TypeProduct:
  String typeProductValue;
  String typeProductSelected;

  @override
  initState() {
    super.initState();
    GlobalFunctions().isAcces(context);
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          width: size.width * 0.9,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "/manage_products");
                  },
                  child: Icon(Icons.close),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Nuevo producto",
                  style: TextStyle(
                    color: Color(0xff051228),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                key: formKey,
                child: Card(
                  elevation: 0,
                  color: Color(0xfff4fbfe),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 22),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Cliente seleccionado: $clientSelected",
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 22),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Tipo de producto seleccionado: $typeProductSelected",
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RoundedInputField(
                        text: "Descripción",
                        onChanged: (val) {},
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Dato obligatorio";
                          }
                          return null;
                        },
                        controller: descriptionController,
                      ),
                      RoundedInputField(
                        text: "Precio unitario",
                        onChanged: (val) {},
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Dato obligatorio";
                          }
                          return null;
                        },
                        controller: precioController,
                        isNumber: true,
                      ),
                      RoundedInputField(
                        text: "Identificador",
                        onChanged: (val) {},
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Dato obligatorio";
                          }
                          return null;
                        },
                        controller: identificadorController,
                        isNumber: false,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 56,
        margin: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                    alignment: Alignment.center,
                    child: RoudedButton(
                      color: Color(0xff26b5e6),
                      textColor: Colors.white,
                      text: "GUARDAR",
                      press: () {
                        saveInfo();
                      },
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  loadData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      clientValue = sharedPreferences.get("clientProductNew");
      typeProductValue = sharedPreferences.get("typeProductNew");
      clientSelected = sharedPreferences.get("clientNameProductNew");
      typeProductSelected = sharedPreferences.get("typeProductNameNew");
    });
  }

  saveInfo() async {
    if (formKey.currentState.validate()) {
      ProgressDialog2 progressDialog = ProgressDialog2(context);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var pnUsuario = sharedPreferences.get("user");
      var pnClave = sharedPreferences.get("pass");
      print(clientValue);
      Map json = {
        "autenticacion": {"pn_usuario": pnUsuario, "pn_clave": pnClave},
        "parametros": {
          "pn_empresa": "1",
          "pn_cliente": clientValue,
          "pn_accion": "A",
          "pn_producto": "",
          "pn_producto_tipo": typeProductValue,
          "pn_identificador": identificadorController.text,
          "pn_descripcion": descriptionController.text,
          "pn_precio_lista": precioController.text,
          "pn_activo": "1"
        }
      };
      var jsonData;
      var body = convert.jsonEncode(json);
      print(body);
      progressDialog.show();
      var response = await http.post(
          gFunct.globalURL +
              "certificaciones/catalogos/cliente_productos_gestion",
          headers: {"Content-Type": "application/json"},
          body: body);
      if (response.statusCode == 200) {
        jsonData = convert.jsonDecode(response.body);
        if (jsonData['resultado'][0]['error'] == 0) {
          progressDialog.dismiss();
          print("Sin error");
          gFunct.showModalDialog("Registro exitoso",
              "El producto fue ingresado con éxito.", context);
        } else {
          gFunct.showModalDialog(
              "Error al obtener información",
              "Hubo un error al solicitar sus opciones, intentelo en unos minutos",
              context);
          progressDialog.dismiss();
        }
      } else {
        gFunct.showModalDialog(
            "Error en el servidor",
            "Se generó un error en el servidor, intetelo en unos minutos",
            context);
        progressDialog.dismiss();
      }
    }
  }
}
