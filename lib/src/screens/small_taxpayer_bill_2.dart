import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tekra_app/src/global/global.dart';
import 'package:tekra_app/src/screens/components/rounded_button.dart';
import 'package:tekra_app/src/screens/components/rounded_input_field_invoice.dart';
import 'package:tekra_app/src/screens/home.dart';
import 'package:tekra_app/src/screens/small_taxpayer_bill.dart';
import 'package:tekra_app/src/screens/small_taxpayer_bill_3.dart';
import 'package:tekra_app/src/utils/dialog.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class SmallTaxpayerBill2 extends StatefulWidget {
  SmallTaxpayer2 createState() => SmallTaxpayer2();
}

class SmallTaxpayer2 extends State<SmallTaxpayerBill2> {
  TextEditingController nitController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailoController = TextEditingController();
  //Formulario para poder generar las validaciones
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String invoiceTitle = "N/A";
  String finished = "N/A";
  String transmitter = "N/A";
  String contractNumber = "N/A";
  String startDate = "0000-00-00";
  String endDate = "0000-00-00";
  String mensajeNIT = "";

  @override
  initState() {
    super.initState();
    print("Entro esta opcion");
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
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Home()));
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
                  invoiceTitle,
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
              Text(
                "Información de Cliente",
                style: TextStyle(
                  color: Color(0xff26b5e6),
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                key: formKey,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      RoundedInputFieldInvoice(
                        text: "NIT",
                        onChanged: (value) {
                          verifyNIT(value);
                        },
                        isNumber: true,
                        isLocked: false,
                        controller: nitController,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Dato necesario";
                          }
                          if (val.length != 9) return null;
                        },
                      ),
                      Text(
                        mensajeNIT,
                        style: TextStyle(color: Colors.redAccent),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RoundedInputFieldInvoice(
                        text: "Nombre",
                        onChanged: (value) {},
                        isNumber: false,
                        isLocked: true,
                        controller: nameController,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Dato necesario";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RoundedInputFieldInvoice(
                        text: "Dirección",
                        onChanged: (value) {},
                        isNumber: false,
                        isLocked: true,
                        controller: addressController,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Dato necesario";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RoundedInputFieldInvoice(
                        text: "Correo(s) para la notificacion",
                        onChanged: (value) {},
                        isNumber: false,
                        isLocked: false,
                        controller: emailoController,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Dato necesario";
                          }
                          bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val);
                          if(!emailValid){
                            return "Email no válido";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
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
                      withBorder: true,
                      color: Colors.white,
                      textColor: Color(0xff26b5e6),
                      borderColor: Color(0xff26b5e6),
                      text: "ANTERIOR",
                      press: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SmallTaxpayerBill()));
                      },
                    )),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                    alignment: Alignment.center,
                    child: RoudedButton(
                      color: Color(0xff26b5e6),
                      textColor: Colors.white,
                      text: "SIGUIENTE",
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

  verifyNIT(nit) async {
    ProgressDialog progressDialog = ProgressDialog(context);
    GlobalFunctions global = GlobalFunctions();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (nitController.text.length >= 8 && nitController.text.length <= 9) {
      progressDialog.show();
      Map data = {
        "autenticacion": {
          "pn_usuario": sharedPreferences.get("user"),
          "pn_clave": sharedPreferences.get("pass")
        },
        "parametros": {
          "pn_empresa": "1",
          "pn_cliente": sharedPreferences.get("client"),
          "pn_contrato": sharedPreferences.get("contract"),
          "pn_nit": nitController.text
        }
      };
      var body = convert.jsonEncode(data);
      print(body);
      var jsonData;
      var response = await http.post(
          "http://apiseguimiento.desa.tekra.com.gt:8080/seguimiento/certificaciones/contribuyente/contribuyente_consulta",
          headers: {"Content-Type": "application/json"},
          body: body);
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        if (jsonData['resultado'][0]['error'] == 0) {
          progressDialog.dismiss();
          if (jsonData['datos'].length == 0) {
            setState(() {
              nameController.text = "";
              addressController.text = "";
              mensajeNIT = "NIT no existente";
            });
          } else {
            setState(() {
              mensajeNIT = "  ";
              nameController.text = jsonData['datos'][0]['nombre'];
              addressController.text =
                  jsonData['datos'][0]['direccion_completa'];
            });
          }
        } else {
          progressDialog.dismiss();
          global.showModalDialog(
              "Error en el servidor",
              "Se generó un error al intentar conectarse al servidor, intentelo de nuevo o espere un momento.",
              context);
        }
      } else if (response.statusCode == 500) {
        progressDialog.dismiss();
        global.showModalDialog(
            "Error en el servidor",
            "Se generó un error al intentar conectarse al servidor, intentelo de nuevo o espere un momento.",
            context);
      }
    } else {
      setState(() {
        nameController.text = "";
        addressController.text = "";
        mensajeNIT = "";
      });
    }
  }

  saveInfo() async {
    if (formKey.currentState.validate()) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("nitInvoice", nitController.text);
      sharedPreferences.setString("nameInvoice", nameController.text);
      sharedPreferences.setString("addressInvoice", addressController.text);
      sharedPreferences.setString("emailInvoice", emailoController.text);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SmallTaxpayerBill3()));
    }
  }

  loadData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var title = "N/A";
    var finish = "N/A";
    var transm = "N/A";
    var contractNum = "N/A";
    var eDate = "0000-00-00";
    var sDate = "0000-00-00";
    if (sharedPreferences.get("invoiceTitle") != null) {
      title = sharedPreferences.get("invoiceTitle");
    }
    if (sharedPreferences.get("startDateContract") != null) {
      sDate = sharedPreferences
          .get("startDateContract")
          .toString()
          .substring(0, 10);
    }
    if (sharedPreferences.get("endDateContract") != null) {
      eDate =
          sharedPreferences.get("endDateContract").toString().substring(0, 10);
    }
    if (sharedPreferences.get("finishContract") != null) {
      finish = sharedPreferences.get("finishContract");
    }
    if (sharedPreferences.get("contract") != null) {
      contractNum = sharedPreferences.get("contract");
    }
    print(sharedPreferences.get("clientName"));
    if (sharedPreferences.get("clientName") != null) {
      transm = sharedPreferences.get("clientName");
    }
    setState(() {
      invoiceTitle = title;
      startDate = sDate;
      transmitter = transm;
      endDate = eDate;
      contractNumber = contractNum;
      finished = finish;
    });
  }
}
