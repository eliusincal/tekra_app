import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tekra_app/src/global/global.dart';
import 'package:tekra_app/src/models/cliente.dart';
import 'package:tekra_app/src/models/type_product.dart';

import 'package:http/http.dart' as http;
import 'package:tekra_app/src/screens/components/rounded_button.dart';
import 'package:tekra_app/src/screens/edit_type_products.dart';
import 'package:tekra_app/src/screens/new_type_product.dart';
import 'dart:convert' as convert;

import 'package:tekra_app/src/utils/dialog.dart';

class ManageTypeProducts extends StatefulWidget {
  _ManageTypeProducts createState() => _ManageTypeProducts();
}

class _ManageTypeProducts extends State<ManageTypeProducts> {
  GlobalFunctions gFunct = GlobalFunctions();

  //Variables necesarias para los objetos relacionados a tipo de productos:
  static List<TypeProduct> typeProductList;
  bool isLoadTypeProduct = true;

  //Variables necesarias para los objetos relacionados a cliente:
  static List<Client> clientList;
  String uniqueClient = "";
  bool someClients = false;
  String clientValue;
  bool isLoadClientSelect = true;
  bool clientSelected = false;
  String client;

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
                height: 40,
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
              isLoadClientSelect
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 40.0, bottom: 20.00),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : someClients && clientList.length != 0
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 40.0),
                          child: Container(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 2),
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
                                items: clientList.map((client) {
                                  return new DropdownMenuItem(
                                      child: new Text(client.nombre != null
                                          ? client.nombre
                                          : "N/A"),
                                      value: client.cliente);
                                }).toList(),
                                onChanged: (val) {
                                  clientSelected = true;
                                  client = val;
                                  //saveClient(val);
                                  loadTypeProducts(val);
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
              isLoadTypeProduct
                  ? !clientSelected
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
                  : Flexible(
                      child: ListView.builder(
                          itemCount: typeProductList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 100,
                              child: Card(
                                color: Color(0xfff4fbfe),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 25, horizontal: 10),
                                          child: Text(
                                            typeProductList[index]
                                                        .tipoProductoDescripcion !=
                                                    null
                                                ? typeProductList[index]
                                                    .tipoProductoDescripcion
                                                : "N/A",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Color(0xff051228),
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          onTap: () {
                                            editTypeProduct(
                                                typeProductList[index]
                                                    .tipoProducto);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 10),
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.yellow,
                                                )),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          onTap: () {
                                            deleteTypeProduct(
                                                context,
                                                typeProductList[index]
                                                    .tipoProducto,
                                                typeProductList[index]
                                                    .tipoProductoDescripcion);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 10),
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: Icon(Icons.delete,
                                                    color: Colors.red)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
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
                      text: "Agregar Producto",
                      press: () {
                        newProduct();
                      },
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  deleteTypeProduct(context, tipoProducto, descripcion) {
    showAlertDialog(context, tipoProducto, descripcion);
  }

  showAlertDialog(BuildContext context, tipoProducto, descripcion) {
    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () async {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Eliminar"),
      onPressed: () async {
        print(tipoProducto);
        var clientSelect;
        var descripcion;
        var bienServicio;
        for (var typeProduct in typeProductList) {
          if (typeProduct.tipoProducto == tipoProducto) {
            descripcion = typeProduct.tipoProductoDescripcion;
            bienServicio = typeProduct.activo;
            clientSelect = client;
          }
        }
        ProgressDialog progressDialog = ProgressDialog(context);
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        var pnUsuario = sharedPreferences.get("user");
        var pnClave = sharedPreferences.get("pass");
        Map json = {
          "autenticacion": {"pn_usuario": pnUsuario, "pn_clave": pnClave},
          "parametros": {
            "pn_empresa": 1,
            "pn_cliente": clientSelect,
            "pn_accion": "M",
            "pn_producto_tipo": tipoProducto,
            "pn_descripcion": descripcion,
            "pn_bien_servicio": bienServicio,
            "pn_activo": 0
          }
        };
        var jsonData;
        var body = convert.jsonEncode(json);
        print(body);
        var response = await http.post(
            gFunct.globalURL +
                "certificaciones/catalogos/cliente_tipos_producto_gestion",
            headers: {"Content-Type": "application/json"},
            body: body);
        if (response.statusCode == 200) {
          Navigator.of(context).pop();
          progressDialog.show();
          jsonData = convert.jsonDecode(response.body);
          if (jsonData['resultado'][0]['error'] == 0) {
            progressDialog.dismiss();
            gFunct.showModalDialog("Eliminación exitosa",
                "El tipo de producto fue eliminado correctamente.", context);
            loadTypeProducts(client);
          } else {
            gFunct.showModalDialog(
                "Error al obtener información",
                "Hubo un error al solicitar sus opciones, intentelo en unos minutos",
                context);
            progressDialog.dismiss();
          }
        } else {
          Navigator.of(context).pop();
          gFunct.showModalDialog(
              "Error en el servidor",
              "Se generó un error en el servidor, intetelo en unos minutos",
              context);
          progressDialog.dismiss();
        }
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Confirmar eliminación"),
      content: Text(
          "El tipo de producto: $descripcion será eliminado, confirma esta acción"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  newProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewTypeProduct()),
    );
  }

  editTypeProduct(tipoProducto) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    for (var typeProduct in typeProductList) {
      if (typeProduct.tipoProducto == tipoProducto) {
        sharedPreferences.setString(
            "description_type_product", typeProduct.tipoProductoDescripcion);
        sharedPreferences.setString(
            "bien_servicio_type_product", typeProduct.bienServicio);
        sharedPreferences.setString("client_type_product", client);
      }
    }
    sharedPreferences.setString("id_type_product", tipoProducto);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditTypeProduct()),
    );
  }

  loadTypeProducts(client) async {
    setState(() {
      isLoadTypeProduct = true;
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

    var body = convert.jsonEncode(json);
    print(body);
    var response = await http.post(
        gFunct.globalURL +
            "certificaciones/catalogos/cliente_tipos_producto_listado",
        headers: {"Content-Type": "application/json"},
        body: body);
    if (response.statusCode == 200) {
      progressDialog.show();
      jsonData = convert.jsonDecode(response.body);
      if (jsonData['resultado'][0]['error'] == 0) {
        List<TypeProduct> _typeProducts = [];
        var datos = jsonData['datos'];
        for (var d in datos) {
          _typeProducts.add(TypeProduct.fromJson(d));
        }
        setState(() {
          typeProductList = _typeProducts;
          isLoadTypeProduct = false;
          progressDialog.dismiss();
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
        //Verifica si el usuario tienen uno cliente asignado o más para mostrar el select correspondiente.
        if (_clients.length == 1) {
          setState(() {
            loadTypeProducts(_clients[0].cliente);
            clientList = _clients;
            uniqueClient = "Client: ${_clients[0].nombre}";
            client = _clients[0].cliente;
            someClients = false;
            isLoadClientSelect = false;
            progressDialog.dismiss();
            clientSelected = true;
          });
        } else {
          setState(() {
            uniqueClient = "";
            clientList = _clients;
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
}
