import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tekra_app/src/global/global.dart';
import 'package:tekra_app/src/models/cliente.dart';
import 'package:tekra_app/src/models/contrato.dart';
import 'package:tekra_app/src/models/invoice.dart';
import 'package:tekra_app/src/screens/components/option_card_user.dart';
import 'package:http/http.dart' as http;
import 'package:tekra_app/src/screens/small_taxpayer_bill.dart';
import 'dart:convert' as convert;
import 'package:tekra_app/src/utils/dialog.dart';

class OptionsUser extends StatefulWidget {
  const OptionsUser({Key key}) : super(key: key);
  @override
  _OptionsUserState createState() => _OptionsUserState();
}

class _OptionsUserState extends State<OptionsUser> {
  GlobalFunctions gFunct = GlobalFunctions();
  //Variables necesarias para los objetos relacionados a cliente:
  List<Client> clients;
  String uniqueClient = "";
  bool someClients = false;
  String clientValue;
  bool isLoadClientSelect = true;
  bool clientSelected = false;

  //Variables necesarias para los objetos relacionados a Contract:
  List<Contract> contracts;
  String uniqueContract = "";
  bool someContracts = false;
  bool isLoadContractSelect = true;
  bool lContracts = false;
  String contractValue;

  //Variables necesarias para los objetos relacionas a Facturas
  List<Invoice> bills;
  bool isLoadBills = true;
  bool lBills = false;

  @override
  initState() {
    super.initState();
    GlobalFunctions().isAcces(context);
    loadClients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff7f7f7),
        body: Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Column(
              children: <Widget>[
                isLoadClientSelect
                    ? Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 40.0, bottom: 20.00),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : someClients && clients.length != 0
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, top: 40.0),
                            child: Container(
                              padding: EdgeInsets.only(left: 16, right: 16),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: new DropdownButton(
                                  value: clientValue,
                                  hint: Text("Seleccionar cliente"),
                                  dropdownColor: Color(0xffff7f7f7),
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 36,
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  items: clients.map((cliente) {
                                    return new DropdownMenuItem(
                                        child: new Text(cliente.nombre != null
                                            ? cliente.nombre
                                            : "N/A"),
                                        value: cliente.cliente);
                                  }).toList(),
                                  onChanged: (val) {
                                    clientSelected = true;
                                    saveClient(val);
                                    loadContracts(val);
                                    setState(() {
                                      clientValue = val;
                                    });
                                  }),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                                top: 40.0,
                                bottom: 20.00),
                            child: Center(
                              child: Text(
                                uniqueClient != "" ? uniqueClient : "N/A",
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                isLoadContractSelect
                    ? someClients && !lContracts
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                                top: 40.0,
                                bottom: 20.00),
                            child: Center(
                              child: Text("Seleccione a un cliente..."),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                                top: 40.0,
                                bottom: 20.00),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                    : someContracts && contracts.length != 0
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, top: 40.0),
                            child: Container(
                              padding: EdgeInsets.only(left: 16, right: 16),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: new DropdownButton(
                                  value: contractValue,
                                  hint: Text("Seleccionar contrato"),
                                  dropdownColor: Color(0xffff7f7f7),
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 36,
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  items: contracts.map((contract) {
                                    return new DropdownMenuItem(
                                        child: new Text(
                                            contract.noContrato != null
                                                ? "No. ${contract.noContrato}"
                                                : "N/A"),
                                        value: contract.correlativoContrato);
                                  }).toList(),
                                  onChanged: (val) {
                                    saveContract(val);
                                    loadBills(val);
                                    setState(() {
                                      contractValue = val;
                                    });
                                  }),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                                top: 40.0,
                                bottom: 20.00),
                            child: Center(
                              child: Text(
                                uniqueContract != ""
                                    ? uniqueContract
                                    : "Contrato no encontrado",
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                Flexible(
                  child: isLoadBills
                      ? someContracts && !lBills
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  top: 40.0,
                                  bottom: 20.00),
                              child: Center(
                                child: Text("Seleccione a un contrato..."),
                              ),
                            )
                          : lContracts || !clientSelected
                              ? Center()
                              : Center(
                                  child: CircularProgressIndicator(),
                                )
                      : bills.length == 0
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  top: 40.0,
                                  bottom: 20.00),
                              child: Center(
                                child: Text(
                                    "No hay facturas relacionadas a este contrato"),
                              ),
                            )
                          : ListView.builder(
                              itemCount: bills.length,
                              itemBuilder: (context, index) {
                                return CardOptions(
                                  title: bills[index].despliegue,
                                  route: SmallTaxpayerBill(),
                                );
                              }),
                ),
              ],
            ),
          ),
        ));
  }

  loadClients() async {
    ProgressDialog progressDialog = ProgressDialog(context);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var pnUsuario = sharedPreferences.get("user");
    var pnClave = sharedPreferences.get("pass");
    Map json = {
      'autenticacion': {'pn_usuario': pnUsuario, 'pn_clave': pnClave},
      'parametros': {'pn_usuario': pnUsuario, 'pn_estado': "1"}
    };
    var jsonData;

    var body = convert.jsonEncode(json);
    var response = await http.post(
        gFunct.globalURL + "administracion/usuarios/usuario_clientes_listado",
        headers: {"Content-Type": "application/json"},
        body: body);
    if (response.statusCode == 200) {
      progressDialog.show();
      jsonData = convert.jsonDecode(response.body);
      if (jsonData['resultado'][0]['error'] == 0) {
        List<Client> _clients = [];
        var datos = jsonData['datos'];
        for (var d in datos) {
          _clients.add(Client.fromJson(d));
        }
        //Verifica si el usuario tienen uno cliente asignado o más para mostrar el select correspondiente.
        if (_clients.length == 1) {
          setState(() {
            clients = _clients;
            uniqueClient = "Client: ${_clients[0].nombre}";
            someClients = false;
            isLoadClientSelect = false;
            saveClient(_clients[0].cliente);
            loadContracts(_clients[0].cliente);
            progressDialog.dismiss();
            clientSelected = true;
          });
        } else {
          setState(() {
            uniqueClient = "";
            clients = _clients;
            isLoadClientSelect = false;
            someClients = true;
            progressDialog.dismiss();
          });
        }
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

  saveClient(client) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("client", client);
    for(var c in clients){
      if(client == c.cliente){
        sharedPreferences.setString("clientName", c.nombre);
      }
    }
  }

  loadContracts(client) async {
    setState(() {
      isLoadContractSelect = true;
      lContracts = true;
      isLoadBills = true;
    });
    ProgressDialog progressDialog = ProgressDialog(context);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var pnUsuario = sharedPreferences.get("user");
    var pnClave = sharedPreferences.get("pass");
    Map json = {
      'autenticacion': {'pn_usuario': pnUsuario, 'pn_clave': pnClave},
      'parametros': {
        'pn_usuario': pnUsuario,
        'pn_cliente': client,
        'pn_contrato': "-1",
        'pn_estado': "1"
      }
    };
    var jsonData;

    var body = convert.jsonEncode(json);
    var response = await http.post(
        gFunct.globalURL +
            "administracion/usuarios/usuarios_contrato_cliente_listado",
        headers: {"Content-Type": "application/json"},
        body: body);
    if (response.statusCode == 200) {
      progressDialog.show();
      jsonData = convert.jsonDecode(response.body);
      if (jsonData['resultado'][0]['error'] == 0) {
        List<Contract> _contracts = [];
        var datos = jsonData['datos'];
        for (var d in datos) {
          _contracts.add(Contract.fromJson(d));
        }
        if (_contracts.length == 1) {
          setState(() {
            contracts = _contracts;
            uniqueContract = "No. de contrato: ${_contracts[0].noContrato}";
            someContracts = false;
            isLoadContractSelect = false;
            progressDialog.dismiss();
            loadBills(_contracts[0].correlativoContrato);
            saveContract(_contracts[0].correlativoContrato);
            lContracts = false;
          });
        } else {
          setState(() {
            uniqueContract = "";
            contracts = _contracts;
            isLoadContractSelect = false;
            someContracts = true;
            progressDialog.dismiss();
            lContracts = false;
          });
        }
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

  saveContract(contract) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    for(var con in contracts){
      if(con.correlativoContrato == contract){
        sharedPreferences.setString("startDateContract", con.fechaInicio);
        sharedPreferences.setString("endDateContract", con.fechaFinalizacion);
        if(con.finalizado == "1"){
          sharedPreferences.setString("finishContract", "Si");
        }else{
          sharedPreferences.setString("finishContract", "No");
        }  
      }
    }
    sharedPreferences.setString("contract", contract);
  }

  loadBills(contract) async {
    setState(() {
      lBills = true;
      bills = [];
      isLoadBills = true;
    });
    ProgressDialog progressDialog = ProgressDialog(context);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var pnUsuario = sharedPreferences.get("user");
    var pnClave = sharedPreferences.get("pass");
    var pnClient = sharedPreferences.get("client");
    Map json = {
      'autenticacion': {'pn_usuario': pnUsuario, 'pn_clave': pnClave},
      'parametros': {
        'pn_empresa': "1",
        'pn_cliente': pnClient,
        'pn_contrato': contract,
        'pn_estado': "1"
      }
    };
    var jsonData;
    var body = convert.jsonEncode(json);
    var response = await http.post(
        gFunct.globalURL +
            "certificaciones/clientes/cliente_contrato_tipo_documento_listado",
        headers: {"Content-Type": "application/json"},
        body: body);
    if (response.statusCode == 200) {
      progressDialog.show();
      jsonData = convert.jsonDecode(response.body);
      if (jsonData['resultado'][0]['error'] == 0) {
        List<Invoice> _bills = [];
        var datos = jsonData['datos'];
        for (var d in datos) {
          _bills.add(Invoice.fromJson(d));
        }
        setState(() {
          bills = _bills;
          isLoadBills = false;
          progressDialog.dismiss();
          lBills = false;
        });
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

  saveInvoice(invoice) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("invoice", invoice);
  }
}
