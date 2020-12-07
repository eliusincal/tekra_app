import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tekra_app/src/global/global.dart';
import 'package:tekra_app/src/models/cliente.dart';
import 'package:tekra_app/src/models/type_product.dart';
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
  List<Client> clientsList;
  String uniqueClient = "";
  bool someClients = false;
  String clientValue;
  bool isLoadClientSelect = true;
  bool clientSelected = false;

  //Variables necesarias para los objetos relacionados a TypeProduct:
  List<TypeProduct> typeProductsList;
  String uniqueTypeProduct = "";
  bool someTypeProduct = false;
  bool isLoadTypeProductSelect = true;
  bool lTypeProducts = false;
  String typeProductValue;

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
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
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
                        isNumber: true,
                      ),
                      isLoadClientSelect
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  top: 40.0,
                                  bottom: 20.00),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : someClients && clientsList.length != 0
                              ? Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  width: size.width * 0.75,
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Cliente",
                                          style: TextStyle(
                                              color: Color(0xff051228),
                                              fontSize: 15.00),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      DropdownButtonFormField(
                                        validator: (value) => value == null
                                            ? 'Dato obligatorio'
                                            : null,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 2)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              borderSide: BorderSide(
                                                  color: Color(0xffa8e1f5),
                                                  width: 2)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              borderSide: BorderSide(
                                                  color: Color(0xffa8e1f5),
                                                  width: 2)),
                                        ),
                                        hint: Text("Cliente"),
                                        dropdownColor: Colors.white,
                                        elevation: 5,
                                        icon: Icon(Icons.arrow_drop_down),
                                        isExpanded: true,
                                        value: clientValue,
                                        onChanged: (value) {
                                          setState(() {
                                            print(value);
                                            clientValue = value;
                                          });
                                          loadTypeProducts(value);
                                        },
                                        items: clientsList.map((client) {
                                          return DropdownMenuItem(
                                              child: new Text(
                                                  client.nombre != null
                                                      ? client.nombre
                                                      : "N/A"),
                                              value: client.cliente);
                                        }).toList(),
                                      ),
                                    ],
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
                      isLoadTypeProductSelect
                          ? someClients && !lTypeProducts
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
                          : someTypeProduct && typeProductsList.length != 0
                              ? Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  width: size.width * 0.75,
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Tipo de producto",
                                          style: TextStyle(
                                              color: Color(0xff051228),
                                              fontSize: 15.00),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      DropdownButtonFormField(
                                        validator: (value) => value == null
                                            ? 'Dato obligatorio'
                                            : null,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 2)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              borderSide: BorderSide(
                                                  color: Color(0xffa8e1f5),
                                                  width: 2)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              borderSide: BorderSide(
                                                  color: Color(0xffa8e1f5),
                                                  width: 2)),
                                        ),
                                        hint: Text("Tipo de producto"),
                                        dropdownColor: Colors.white,
                                        elevation: 5,
                                        icon: Icon(Icons.arrow_drop_down),
                                        isExpanded: true,
                                        value: typeProductValue,
                                        onChanged: (value) {
                                          setState(() {
                                            print(value);
                                            typeProductValue = value;
                                          });
                                        },
                                        items:
                                            typeProductsList.map((typeProduct) {
                                          return DropdownMenuItem(
                                              child: new Text(typeProduct
                                                          .tipoProductoDescripcion !=
                                                      null
                                                  ? typeProduct
                                                      .tipoProductoDescripcion
                                                  : "N/A"),
                                              value: typeProduct.tipoProducto);
                                        }).toList(),
                                      ),
                                    ],
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
                                      uniqueTypeProduct != ""
                                          ? uniqueTypeProduct
                                          : "Tipo de producto no encontrado",
                                      style: TextStyle(fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
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
        print(_clients);
        //Verifica si el usuario tienen uno cliente asignado o más para mostrar el select correspondiente.
        print("HOLA");
        if (_clients.length == 1) {
          setState(() {
            clientsList = _clients;
            uniqueClient = "Client: ${_clients[0].nombre}";
            someClients = false;
            isLoadClientSelect = false;
            progressDialog.dismiss();
            clientSelected = true;
          });
        } else {
          setState(() {
            uniqueClient = "";
            clientsList = _clients;
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

  loadTypeProducts(client) async {
    setState(() {
      isLoadTypeProductSelect = true;
      lTypeProducts = true;
    });
    ProgressDialog progressDialog = ProgressDialog(context);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var pnUsuario = sharedPreferences.get("user");
    var pnClave = sharedPreferences.get("pass");
    Map json = {
      "autenticacion": {"pn_usuario": pnUsuario, "pn_clave": pnClave},
      "parametros": {
        "pn_empresa": "1",
        "pn_cliente": client,
        "pn_producto_tipo": "",
        "pn_activo": "1"
      }
    };
    var jsonData;

    progressDialog.show();
    var body = convert.jsonEncode(json);
    var response = await http.post(
        gFunct.globalURL +
            "certificaciones/catalogos/cliente_tipos_producto_listado",
        headers: {"Content-Type": "application/json"},
        body: body);
    if (response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      if (jsonData['resultado'][0]['error'] == 0) {
        List<TypeProduct> _typeProducts = [];
        var datos = jsonData['datos'];
        for (var d in datos) {
          _typeProducts.add(TypeProduct.fromJson(d));
        }
        print(_typeProducts);
        if (_typeProducts.length == 1) {
          setState(() {
            typeProductsList = _typeProducts;
            uniqueTypeProduct =
                "No. de contrato: ${_typeProducts[0].tipoProductoDescripcion}";
            someTypeProduct = false;
            isLoadTypeProductSelect = false;
            progressDialog.dismiss();
            lTypeProducts = false;
          });
        } else {
          setState(() {
            uniqueTypeProduct = "";
            typeProductsList = _typeProducts;
            isLoadTypeProductSelect = false;
            someTypeProduct = true;
            progressDialog.dismiss();
            lTypeProducts = false;
            typeProductValue = typeProductsList[0].tipoProducto;
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

  saveInfo() async {
    if (formKey.currentState.validate()) {
      ProgressDialog progressDialog = ProgressDialog(context);
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
