import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tekra_app/src/global/global.dart';
import 'package:tekra_app/src/models/coin.dart';
import 'package:tekra_app/src/models/establishment.dart';
import 'package:tekra_app/src/screens/components/rouded_exchange_rate.dart';
import 'package:tekra_app/src/screens/components/rounded_button.dart';
import 'package:tekra_app/src/screens/components/rounded_date_input.dart';
import 'package:tekra_app/src/screens/home.dart';
import 'package:tekra_app/src/screens/small_taxpayer_bill_2.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class SmallTaxpayerBill extends StatefulWidget {
  SmallTaxpayer createState() => SmallTaxpayer();
}

class SmallTaxpayer extends State<SmallTaxpayerBill> {
  GlobalFunctions gFunct = GlobalFunctions();
  TextEditingController userController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  //Formulario para poder generar las validaciones
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final establecientoSeleccionado = TextEditingController();
  //Valores para el dropdown de Establecimiento
  String establishmentValue;
  //Valores para el dropdown de Moneda
  String coinVal;
  bool exchangeRateIsLocked = true;
  TextEditingController exchangeRateController = TextEditingController();

  String invoiceTitle = "N/A";
  String finished = "N/A";
  String transmitter = "N/A";
  String contractNumber = "N/A";
  String startDate = "0000-00-00";
  String endDate = "0000-00-00";

  List<Coin> coinList = [];
  List<Establishment> establishmentList = [];

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
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
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
                "Información de Emisión",
                style: TextStyle(
                  color: Color(0xff26b5e6),
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CardInfo(
                size: size,
                transmitter: transmitter,
                endDate: endDate,
                startDate: startDate,
                contractNumber: contractNumber,
                finished: finished,
              ),
              SizedBox(
                height: 10,
              ),
              Flexible(
                child: Form(
                  key: formKey,
                  child: ListView(
                    children: <Widget>[
                      RoundedDateInput(
                        controller: dateController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Estableciminento",
                            style: TextStyle(
                                color: Color(0xff051228), fontSize: 15.00),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
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
                            hint: Text("Establecimiento"),
                            dropdownColor: Colors.white,
                            elevation: 5,
                            icon: Icon(Icons.arrow_drop_down),
                            isExpanded: true,
                            value: establishmentValue,
                            onChanged: (value) {
                              setState(() {
                                establishmentValue = value;
                              });
                            },
                            items: establishmentList.map((establishment) {
                              return DropdownMenuItem(
                                  value: establishment.establecimiento,
                                  child: Text(establishment.despliegue));
                            }).toList(),
                          ),
                        ),
                      ]),
                      SizedBox(
                        height: 10,
                      ),
                      Column(children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Moneda",
                            style: TextStyle(
                                color: Color(0xff051228), fontSize: 15.00),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
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
                            hint: Text("Moneda"),
                            dropdownColor: Colors.white,
                            elevation: 5,
                            icon: Icon(Icons.arrow_drop_down),
                            isExpanded: true,
                            value: coinVal,
                            onChanged: (value) {
                              setState(() {
                                if (value == "GTQ") {
                                  exchangeRateIsLocked = true;
                                } else {
                                  exchangeRateIsLocked = false;
                                }
                                coinVal = value;
                              });
                            },
                            items: coinList.map((coin) {
                              return DropdownMenuItem(
                                  value: coin.moneda,
                                  child: Text(coin.nombreMoneda));
                            }).toList(),
                          ),
                        ),
                      ]),
                      SizedBox(
                        height: 10,
                      ),
                      RoudedExchangeRate(
                        text: "Tipo de cambio",
                        onChanged: (value) {},
                        isNumber: true,
                        isLocked: exchangeRateIsLocked,
                        controller: exchangeRateController,
                        validator: (val) {
                          if (coinVal != "GTQ" && val.isEmpty) {
                            return "Dato obligatorio";
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home()));
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

  saveInfo() async {
    if (formKey.currentState.validate()) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("dateGeneratedInvoice", dateController.text);
      sharedPreferences.setString("establishment", establishmentValue);
      sharedPreferences.setString("coin", coinVal);
      sharedPreferences.setString("exchangeRate", exchangeRateController.text);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SmallTaxpayerBill2()));
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
    var pnUsuario = sharedPreferences.get("user");
    var pnClave = sharedPreferences.get("pass");
    var pnCliente = sharedPreferences.get("client");
    var pnContrato = sharedPreferences.get("contract");
    Map data = {
      "autenticacion": {"pn_usuario": pnUsuario, "pn_clave": pnClave},
      "parametros": {
        "pn_empresa": "1",
        "pn_cliente": pnCliente,
        "pn_contrato": pnContrato,
        "pn_asignado": "1"
      }
    };
    var body = convert.jsonEncode(data);
    var jsonData;
    var response = await http.post(
        "http://apiseguimiento.desa.tekra.com.gt:8080/seguimiento/certificaciones/clientes/cliente_contrato_moneda_listado",
        headers: {"Content-Type": "application/json"},
        body: body);

    if (response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      if (jsonData['resultado'][0]['error'] == 0) {
        List<Coin> _coins = [];
        var datos = jsonData['datos'];
        for (var d in datos) {
          _coins.add(Coin.fromJson(d));
        }
        setState(() {
          coinList = _coins;
        });
      } else {
        gFunct.showModalDialog(
            "Error al obtener información",
            "Hubo un error al solicitar sus opciones, intentelo en unos minutos",
            context);
      }
    } else {
      gFunct.showModalDialog(
          "Error en el servidor",
          "Se generó un error en el servidor, intetelo en unos minutos",
          context);
    }

    Map dataEstablishment = {
      "autenticacion": {"pn_usuario": pnUsuario, "pn_clave": pnClave},
      "parametros": {
        "pn_empresa": "1",
        "pn_cliente": pnCliente,
        "pn_asignado": "1"
      }
    };
    var bodyEstablishment = convert.jsonEncode(dataEstablishment);
    var jsonDataEstablishment;
    var responseEstab = await http.post(
        "http://apiseguimiento.desa.tekra.com.gt:8080/seguimiento/certificaciones/clientes/cliente_establecimiento_listado",
        headers: {"Content-Type": "application/json"},
        body: bodyEstablishment);

    if (responseEstab.statusCode == 200) {
      jsonDataEstablishment = convert.jsonDecode(responseEstab.body);
      if (jsonDataEstablishment['resultado'][0]['error'] == 0) {
        List<Establishment> _establishments = [];
        var datos = jsonDataEstablishment['datos'];
        for (var d in datos) {
          _establishments.add(Establishment.fromJson(d));
        }
        setState(() {
          establishmentList = _establishments;
        });
      } else {
        gFunct.showModalDialog(
            "Error al obtener información",
            "Hubo un error al solicitar sus opciones, intentelo en unos minutos",
            context);
      }
    } else {
      gFunct.showModalDialog(
          "Error en el servidor",
          "Se generó un error en el servidor, intetelo en unos minutos",
          context);
    }
  }
}

class CardInfo extends StatelessWidget {
  const CardInfo(
      {Key key,
      @required this.size,
      @required this.transmitter,
      @required this.contractNumber,
      @required this.startDate,
      @required this.endDate,
      @required this.finished})
      : super(key: key);

  final Size size;
  final transmitter;
  final contractNumber;
  final startDate;
  final endDate;
  final finished;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        color: Color(0xfff4fbfe),
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            width: size.width * 0.8,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Emisor",
                    style: TextStyle(
                      color: Color(0xffbbbbbb),
                      fontSize: 18,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    transmitter,
                    style: TextStyle(
                      color: Color(0xff555555),
                      fontSize: 20,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Contrato",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xff69717e),
                      ),
                    ),
                    Expanded(
                      child: new Container(
                          margin:
                              const EdgeInsets.only(left: 20.0, right: 10.0),
                          child: Divider(
                            color: Colors.black,
                            height: 36,
                          )),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "No.",
                    style: TextStyle(
                      color: Color(0xffbbbbbb),
                      fontSize: 17,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    contractNumber,
                    style: TextStyle(
                      color: Color(0xff555555),
                      fontSize: 19,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Fecha inicio",
                            style: TextStyle(
                              color: Color(0xffbbbbbb),
                              fontSize: 17,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            startDate,
                            style: TextStyle(
                              color: Color(0xff555555),
                              fontSize: 19,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Fecha Fin",
                            style: TextStyle(
                              color: Color(0xffbbbbbb),
                              fontSize: 17,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            endDate,
                            style: TextStyle(
                              color: Color(0xff555555),
                              fontSize: 19,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Finalizado",
                            style: TextStyle(
                              color: Color(0xffbbbbbb),
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            finished,
                            style: TextStyle(
                              color: Color(0xff555555),
                              fontSize: 19,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
