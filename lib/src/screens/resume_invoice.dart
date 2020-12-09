import 'package:flutter/material.dart';
import 'package:get_ip/get_ip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tekra_app/src/global/global.dart';
import 'package:tekra_app/src/models/coin.dart';
import 'package:tekra_app/src/models/detail_invoice.dart';
import 'package:tekra_app/src/models/establishment.dart';
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
  TextEditingController userController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  //Formulario para poder generar las validaciones
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final establecientoSeleccionado = TextEditingController();
  //Valores para el dropdown de Establecimiento
  String establishmentValue;
  //Valores para el dropdown de Modena
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
                "Resumen",
                style: TextStyle(
                  color: Color(0xff26b5e6),
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Flexible(
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: [
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
                    CardInfoDescription(size: size),
                    SizedBox(
                      height: 10,
                    ),
                    CardInfoClient(size: size)
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

  saveInfo() async {
    // Web service para poder generar el documento
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
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
    print(body);
    var jsonData;
    var response = await http.post(
        "http://apiseguimiento.desa.tekra.com.gt:8080/seguimiento/certificaciones/clientes/cliente_documentos_gestion",
        headers: {"Content-Type": "application/json"},
        body: body);

    if (response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      if (jsonData['resultado'][0]['error'] == 0) {
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
          print("detalle de documento");
          print(body);
          response = await http.post(
              "http://apiseguimiento.desa.tekra.com.gt:8080/seguimiento/certificaciones/clientes/cliente_documento_detalle_gestion",
              headers: {"Content-Type": "application/json"},
              body: body);
          print(convert.jsonDecode(response.body));
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
        var xmlFirmar = "";
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

        var body = convert.jsonEncode(data);
        print("Obtiene el documento para firmar");
        print(body);
        response = await http.post(
            "http://apiseguimiento.desa.tekra.com.gt:8080/seguimiento/certificaciones/clientes/cliente_documentos_listado",
            headers: {"Content-Type": "application/json"},
            body: body);

        if (response.statusCode == 200) {
          jsonData = convert.jsonDecode(response.body);
          if (jsonData['resultado'][0]['error'] == 0) {
            xmlFirmar = jsonData['datos'][0]['xml_a_firmar'];
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
        print(response.body);
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

loadData() async {
  // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  // var title = "N/A";
  // var finish = "N/A";
  // var transm = "N/A";
  // var contractNum = "N/A";
  // var eDate = "0000-00-00";
  // var sDate = "0000-00-00";
  // if (sharedPreferences.get("invoiceTitle") != null) {
  //   title = sharedPreferences.get("invoiceTitle");
  // }
  // if (sharedPreferences.get("startDateContract") != null) {
  //   sDate =
  //       sharedPreferences.get("startDateContract").toString().substring(0, 10);
  // }
  // if (sharedPreferences.get("endDateContract") != null) {
  //   eDate =
  //       sharedPreferences.get("endDateContract").toString().substring(0, 10);
  // }
  // if (sharedPreferences.get("finishContract") != null) {
  //   finish = sharedPreferences.get("finishContract");
  // }
  // if (sharedPreferences.get("contract") != null) {
  //   contractNum = sharedPreferences.get("contract");
  // }
  // if (sharedPreferences.get("clientName") != null) {
  //   transm = sharedPreferences.get("clientName");
  // }
}

class CardInfoClient extends StatelessWidget {
  const CardInfoClient({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

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
                    "1234567-8",
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
                    "SERVICIOS Y CONSULTAS, S.A.",
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
                    "GUATEMALA, GUATEMALA",
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

class CardInfoDescription extends StatelessWidget {
  const CardInfoDescription({
    Key key,
    @required this.size, //this.date
  }) : super(key: key);

  final Size size;
  //final date;

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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Align(
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
                              "10",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xff69717e),
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
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
                              "GTQ - Quetzal",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xff69717e),
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
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
                    "Factura Pequeño Contribuyente",
                    style: TextStyle(
                      color: Color(0xff555555),
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
                    "No. de documento",
                    style: TextStyle(
                      color: Color(0xffbbbbbb),
                      fontSize: 17,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "203418745109",
                    style: TextStyle(
                      color: Color(0xff555555),
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
                    "Estado",
                    style: TextStyle(
                      color: Color(0xffbbbbbb),
                      fontSize: 17,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Ingresado",
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
