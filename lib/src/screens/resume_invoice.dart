import 'package:flutter/material.dart';
import 'package:get_ip/get_ip.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tekra_app/src/global/global.dart';
import 'package:tekra_app/src/models/detail_invoice.dart';
import 'package:tekra_app/src/screens/components/rounded_button.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ResumeInvoice extends StatefulWidget {
  final List<DetailInvoice> detailBills;
  ResumeInvoice({Key key, @required this.detailBills}) : super(key: key);

  @override
  _ResumeInvoiceState createState() => _ResumeInvoiceState();
}

class _ResumeInvoiceState extends State<ResumeInvoice> {
  GlobalFunctions gFunct = GlobalFunctions();

  //Datos para el resumen de información parte 1
  String invoiceTitle = "N/A";
  String finished = "N/A";
  String transmitter = "N/A";
  String contractNumber = "N/A";
  String startDate = "0000-00-00";
  String endDate = "0000-00-00";

  //Datos para el resumen de información parte 2
  String dateIssue = "0000-00-00";
  String coin = "N/A";
  String typeDocument = "N/A";

  //Datos para el resumen de información parte 3
  String nit = "0";
  String name = "N/A";
  String address = "N/A";

  //Datos para el resumen de información parte 4
  String items = "0";
  String total = "0.00";

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
              // SizedBox(
              //   height: 30,
              // ),
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: GestureDetector(
              //     onTap: () {
              //       Navigator.pop(context);
              //     },
              //     child: Icon(Icons.close),
              //   ),
              // ),
              SizedBox(
                height: 40,
              ),

              Flexible(
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: [
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
                      "Resumen",
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
                    CardInfoDescription(
                      size: size,
                      date: dateIssue,
                      coin: coin,
                      typeDocument: typeDocument,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CardInfoClient(
                      size: size,
                      nit: nit,
                      name: name,
                      address: address,
                    ),
                    CardInfoTotals(
                      size: size,
                      totalItems: items,
                      totalInvoice: total,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Color(0xfff7f7f7),
                      child: Column(
                        children: <Widget>[
                          ExpansionTile(
                            title: Text(
                              "Items",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            children: new List.generate(
                                widget.detailBills.length,
                                (index) => Card(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      color: Color(0xfff4fbfe),
                                      child: Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                          width: size.width * 0.8,
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Item: ${index + 1}",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Cantidad",
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xff69717e),
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            widget
                                                                .detailBills[
                                                                    index]
                                                                .cantidad,
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xff051228),
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Producto/Servicio",
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xff69717e),
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            widget
                                                                .detailBills[
                                                                    index]
                                                                .bienServicio,
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xff051228),
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Valor unitario",
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xff69717e),
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            widget
                                                                .detailBills[
                                                                    index]
                                                                .valorUnitario,
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xff051228),
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Descuento unitario",
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xff69717e),
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            widget
                                                                .detailBills[
                                                                    index]
                                                                .descuentoUnitario,
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xff051228),
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Descripción",
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xff69717e),
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            widget
                                                                .detailBills[
                                                                    index]
                                                                .descripcion,
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xff051228),
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )),
                                    )),
                          )
                        ],
                      ),
                    ),
                  ],
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
                        Navigator.pop(context);
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
                      text: "FINALIZAR",
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
      invoiceTitle = sharedPreferences.get("invoiceTitle");
      transmitter = sharedPreferences.get("clientName");
      contractNumber = sharedPreferences.get("contract");
      if (sharedPreferences.get("startDateContract") != null) {
        startDate = sharedPreferences
            .get("startDateContract")
            .toString()
            .substring(0, 10);
      }
      if (sharedPreferences.get("endDateContract") != null) {
        endDate = sharedPreferences
            .get("endDateContract")
            .toString()
            .substring(0, 10);
      }
      finished = sharedPreferences.get("finishContract");
      dateIssue = sharedPreferences
          .get("dateGeneratedInvoice")
          .toString()
          .substring(0, 10);
      coin = sharedPreferences.get("coin");
      nit = sharedPreferences.get("nitInvoice");
      name = sharedPreferences.get("nameInvoice");
      address = sharedPreferences.get("addressInvoice");
      items = sharedPreferences.get("totalItems");
      total = sharedPreferences.get("totalInvoice");
    });
  }

  saveInfo() async {
    // Web service para poder generar el documento
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    ProgressDialog pr = ProgressDialog(context);
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    var pnUsuario = sharedPreferences.get("user");
    var pnClave = sharedPreferences.get("pass");
    var pnCliente = sharedPreferences.get("client");
    var pnContrato = sharedPreferences.get("contract");
    var pnEstablecimiento = sharedPreferences.get("establishment");
    var pnTipoDocumento = sharedPreferences.get("code_type_bill");
    var pnDate = sharedPreferences.get("dateGeneratedInvoice");
    var pnNIT = sharedPreferences.get("nitInvoice");
    var pnName = sharedPreferences.get("nameInvoice");
    var pnAddress = sharedPreferences.get("addressInvoice");
    var pnEmail = sharedPreferences.get("emailInvoice");
    var pnCoin = sharedPreferences.get("coin");
    var pnExchangeRate = sharedPreferences.get("exchangeRate");
    pr.style(
        message: '1/5. Creando documento',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    await pr.show();
    Map data = {
      "autenticacion": {"pn_usuario": pnUsuario, "pn_clave": pnClave},
      "parametros": {
        "pn_empresa": "1",
        "pn_cliente": pnCliente,
        "pn_contrato": pnContrato,
        "pn_accion": "A",
        "pn_documento": "",
        "pn_establecimiento": pnEstablecimiento,
        "pn_documento_tipo": pnTipoDocumento,
        "pn_fecha": pnDate,
        "pn_nit": pnNIT,
        "pn_nombre": pnName,
        "pn_direccion": pnAddress,
        "pn_correos_notificacion": pnEmail,
        "pn_moneda": pnCoin,
        "pn_tipo_cambio": pnExchangeRate
      }
    };

    var body = convert.jsonEncode(data);
    var jsonData;
    var response = await http.post(
        "http://apiseguimiento.desa.tekra.com.gt:8080/seguimiento/certificaciones/clientes/cliente_documentos_gestion",
        headers: {"Content-Type": "application/json"},
        body: body);

    if (response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      if (jsonData['resultado'][0]['error'] == 0) {
        pr.update(message: "2/5. Adjuntando detalles del documento");
        var documento = jsonData["resultado"][0]["documento"];
        //Web service para poder adjutarle los detalles de documento al documento ;)
        for (var di in widget.detailBills) {
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
              "pn_documento": documento,
              "pn_accion": "A",
              "pn_detalle": "",
              "pn_producto": di.producto,
              "pn_descripcion": di.descripcion,
              "pn_cantidad": di.cantidad,
              "pn_valor_unitario": di.valorUnitario,
              "pn_descuento_unitario": di.descuentoUnitario
            }
          };
          var body = convert.jsonEncode(data);
          response = await http.post(
              "http://apiseguimiento.desa.tekra.com.gt:8080/seguimiento/certificaciones/clientes/cliente_documento_detalle_gestion",
              headers: {"Content-Type": "application/json"},
              body: body);
          if (response.statusCode == 200) {
            print("success send detail invoice ;)");
          } else {
            gFunct.showModalDialog(
                "Error en el servidor",
                "Se generó un error en el servidor, intetelo en unos minutos",
                context);
          }
        }

        //Web service para poder obtener el xml a firmar ;)
        pr.update(message: "3/5. Recopilando información");
        var xmlFirmar = "";
        var pnEstado = "";
        var pnUsuario = sharedPreferences.get("user");
        var pnClave = sharedPreferences.get("pass");
        var pnCliente = sharedPreferences.get("client");
        var pnContrato = sharedPreferences.get("contract");
        var pnEstablecimiento = sharedPreferences.get("establishment");
        var pnTipoDocumento = sharedPreferences.get("code_type_bill");
        var pnDate = sharedPreferences.get("dateGeneratedInvoice");
        Map data = {
          "autenticacion": {"pn_usuario": pnUsuario, "pn_clave": pnClave},
          "parametros": {
            "pn_empresa": "1",
            "pn_cliente": pnCliente,
            "pn_fecha_inicio": pnDate,
            "pn_fecha_final": pnDate,
            "pn_contrato": pnContrato,
            "pn_establecimiento": pnEstablecimiento,
            "pn_documento_tipo": pnTipoDocumento,
            "pn_correlativo": documento,
            "pn_uuid": "",
            "pn_serie": "",
            "pn_numero_documeno": documento,
            "pn_estado": "-1"
          }
        };

        pr.update(message: "4/5. Firmando el documento");
        var body = convert.jsonEncode(data);
        response = await http.post(
            "http://apiseguimiento.desa.tekra.com.gt:8080/seguimiento/certificaciones/clientes/cliente_documentos_listado",
            headers: {"Content-Type": "application/json"},
            body: body);

        if (response.statusCode == 200) {
          jsonData = convert.jsonDecode(response.body);
          if (jsonData['resultado'][0]['error'] == 0) {
            xmlFirmar = jsonData['datos'][0]['xml_a_firmar'];
            pnEstado = jsonData['datos'][0]['estado'].toString();
          }
        }

        //WEb service para poder firmar el documento ;)
        String ipAddress = await GetIp.ipAddress;
        var bodySoap =
            '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsdl="http://apicertificacion.desa.tekra.com.gt:8080/certificacion/wsdl/">
          <soapenv:Header/>
            <soapenv:Body>
              <wsdl:CertificacionDocumento>
                <Autenticacion>
                  <pn_usuario>$pnUsuario</pn_usuario>
                  <pn_clave>$pnClave</pn_clave>
                  <pn_cliente>$pnCliente</pn_cliente>
                  <pn_contrato>$pnContrato</pn_contrato>
                  <pn_id_origen>AppMobil</pn_id_origen>
                  <pn_ip_origen>$ipAddress</pn_ip_origen>
                  <pn_firmar_emisor>SI</pn_firmar_emisor>
                </Autenticacion>
                <Documento><![CDATA[$xmlFirmar]]></Documento>
              </wsdl:CertificacionDocumento>
            </soapenv:Body>
          </soapenv:Envelope>''';
        print("servicio soap");
        print(bodySoap);
        response = await http.post(
            "http://apicertificacion.desa.tekra.com.gt:8080/certificacion/servicio.php",
            headers: {"Content-Type": "text/xml"},
            body: bodySoap);
        if (response.statusCode == 200) {
          //Web service para completar el ciclo
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
              "pn_documento": documento,
              "pn_estado": pnEstado,
              "pn_observaciones": "",
              "pn_uuid": "",
              "pn_serie": "",
              "pn_numero_documento": ""
            }
          };

          var body = convert.jsonEncode(data);

          pr.update(message: "5/5. Finalizando documento");
          response = await http.post(
              "http://apiseguimiento.desa.tekra.com.gt:8080/seguimiento/certificaciones/clientes/cliente_documento_estado_gestion",
              headers: {"Content-Type": "application/json"},
              body: body);

          if (response.statusCode == 200) {
            await pr.hide();
            jsonData = convert.jsonDecode(response.body);
            if (jsonData['resultado'][0]['error'] == 0) {
              var urlrg = jsonData['resultado'][0]['url_rg'];
              sharedPreferences.setString("url_documento", urlrg);
              sharedPreferences.setString("no_documento", documento.toString());
              gFunct.showDialogWithNav(
                  "Documento generado correctamente",
                  "El documento se generó sin problemas",
                  "/result_document",
                  context);
            }
          }
        }
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

class CardInfoClient extends StatelessWidget {
  const CardInfoClient({
    Key key,
    this.nit,
    this.name,
    this.address,
    @required this.size,
  }) : super(key: key);

  final Size size;
  final nit;
  final name;
  final address;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        color: Color(0xfff051228),
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            width: size.width * 0.8,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "NIT",
                    style: TextStyle(
                      color: Color(0xffa8e1f5),
                      fontSize: 17,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    nit,
                    style: TextStyle(
                      color: Color(0xffffffff),
                      fontSize: 19,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Nombre",
                    style: TextStyle(
                      color: Color(0xffa8e1f5),
                      fontSize: 17,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    name,
                    style: TextStyle(
                      color: Color(0xffffffff),
                      fontSize: 19,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Dirección",
                    style: TextStyle(
                      color: Color(0xffa8e1f5),
                      fontSize: 17,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    address,
                    style: TextStyle(
                      color: Color(0xffffffff),
                      fontSize: 19,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class CardInfoTotals extends StatelessWidget {
  const CardInfoTotals({
    Key key,
    this.totalItems,
    this.totalInvoice,
    @required this.size,
  }) : super(key: key);

  final Size size;
  final totalItems;
  final totalInvoice;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        color: Color(0xfff051228),
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            width: size.width * 0.8,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Totales",
                    style: TextStyle(
                      color: Color(0xffffffff),
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "$totalItems Items",
                        style: TextStyle(
                          color: Color(0xffffffff),
                          fontSize: 17,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "GTQ $totalInvoice",
                        style: TextStyle(
                          color: Color(0xffffffff),
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}

class CardInfoDescription extends StatelessWidget {
  const CardInfoDescription(
      {Key key, @required this.size, this.date, this.coin, this.typeDocument})
      : super(key: key);

  final Size size;
  final date;
  final coin;
  final typeDocument;

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          Text(
                            "Fecha",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff69717e),
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            date,
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xff69717e),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          Text(
                            "Moneda",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff69717e),
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            coin,
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xff69717e),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Tipo de documento",
                    style: TextStyle(
                      color: Color(0xffbbbbbb),
                      fontSize: 17,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    typeDocument,
                    style: TextStyle(
                      color: Color(0xff555555),
                      fontSize: 19,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
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
                SizedBox(
                  height: 10,
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
