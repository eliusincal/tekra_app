import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tekra_app/src/global/global.dart';
import 'package:tekra_app/src/screens/components/rounded_button.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:tekra_app/src/screens/components/rounded_input_field.dart';
import 'package:tekra_app/src/utils/dialog.dart';

class NewTypeProduct extends StatefulWidget {
  _NewTypeProduct createState() => _NewTypeProduct();
}

class _NewTypeProduct extends State<NewTypeProduct> {
  GlobalFunctions gFunct = GlobalFunctions();
  //Formulario para poder generar las validaciones
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  //Objetos necesarios para un nuevo tipo de producto
  TextEditingController descriptionController = TextEditingController();
  String typeProductValue;
  List<String> typeProductList = ["Bien", "Servicio"];

  //Variables necesarias para los objetos relacionados a cliente:
  String clientSelected = "";

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
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
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
                    Navigator.pushReplacementNamed(
                        context, "/manage_type_products");
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
                  "Nuevo tipo de producto",
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
                            "Cliente: $clientSelected",
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
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        width: size.width * 0.75,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Bien o servicio",
                                style: TextStyle(
                                    color: Color(0xff051228), fontSize: 15.00),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                              child: DropdownButtonFormField(
                                validator: (value) =>
                                    value == null ? 'Dato obligatorio' : null,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 2)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(
                                          color: Color(0xffa8e1f5), width: 2)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(
                                          color: Color(0xffa8e1f5), width: 2)),
                                ),
                                hint: Text("Bien o servicio"),
                                dropdownColor: Colors.white,
                                elevation: 5,
                                icon: Icon(Icons.arrow_drop_down),
                                isExpanded: true,
                                value: typeProductValue,
                                onChanged: (value) {
                                  setState(() {
                                    typeProductValue = value;
                                  });
                                },
                                items: typeProductList.map((tyeProduct) {
                                  return DropdownMenuItem(
                                      value: tyeProduct,
                                      child: Text(tyeProduct));
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
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
      clientSelected = sharedPreferences.get("clientNameTypeProductNew");
    });
  }

  saveInfo() async {
    if (formKey.currentState.validate()) {
      ProgressDialog2 progressDialog = ProgressDialog2(context);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var pnUsuario = sharedPreferences.get("user");
      var pnClave = sharedPreferences.get("pass");
      var pnClient = sharedPreferences.get("clientTypeProductNew");
      var tipo = 0;
      if (typeProductValue == "Bien") {
        tipo = 1;
      } else {
        tipo = 0;
      }
      Map json = {
        "autenticacion": {"pn_usuario": pnUsuario, "pn_clave": pnClave},
        "parametros": {
          "pn_empresa": 1,
          "pn_cliente": pnClient,
          "pn_accion": "A",
          "pn_producto_tipo": "",
          "pn_descripcion": descriptionController.text,
          "pn_bien_servicio": tipo,
          "pn_activo": 1
        }
      };
      var jsonData;
      var body = convert.jsonEncode(json);
      var response = await http.post(
          gFunct.globalURL +
              "certificaciones/catalogos/cliente_tipos_producto_gestion",
          headers: {"Content-Type": "application/json"},
          body: body);
      if (response.statusCode == 200) {
        progressDialog.show();
        jsonData = convert.jsonDecode(response.body);
        if (jsonData['resultado'][0]['error'] == 0) {
          progressDialog.dismiss();
          gFunct.showModalDialog(
              "Registro exitoso",
              "El tipo de producto ingresado fue ingresado con éxito.",
              context);
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
