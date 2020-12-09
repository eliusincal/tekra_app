import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tekra_app/src/global/global.dart';
import 'package:tekra_app/src/models/cliente.dart';
import 'package:tekra_app/src/models/product.dart';
import 'package:tekra_app/src/models/type_product.dart';

import 'package:http/http.dart' as http;
import 'package:tekra_app/src/screens/components/rounded_button.dart';
import 'package:tekra_app/src/screens/edit_product.dart';
import 'package:tekra_app/src/screens/new_product.dart';
import 'dart:convert' as convert;

import 'package:tekra_app/src/utils/dialog.dart';

class ManageProducts extends StatefulWidget {
  _ManageProducts createState() => _ManageProducts();
}

class _ManageProducts extends State<ManageProducts> {
  GlobalFunctions gFunct = GlobalFunctions();
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

  //Variables necesarias para los objetos relacionas a Productos
  List<Product> productsList;
  bool isLoadProducts = true;
  bool lProducts = false;

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
                  : someClients && clientsList.length != 0
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
                                items: clientsList.map((cliente) {
                                  return new DropdownMenuItem(
                                      child: new Text(cliente.nombre != null
                                          ? cliente.nombre
                                          : "N/A"),
                                      value: cliente.cliente);
                                }).toList(),
                                onChanged: (val) {
                                  clientSelected = true;
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
                                value: typeProductValue,
                                hint: Text("Seleccionar tipo de producto"),
                                dropdownColor: Color(0xffff7f7f7),
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 36,
                                isExpanded: true,
                                underline: SizedBox(),
                                items: typeProductsList.map((typeProduct) {
                                  return new DropdownMenuItem(
                                      child: new Text(typeProduct
                                                  .tipoProductoDescripcion !=
                                              null
                                          ? typeProduct.tipoProductoDescripcion
                                          : "N/A"),
                                      value: typeProduct.tipoProducto);
                                }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    typeProductValue = val;
                                  });
                                  loadProducts();
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
                              uniqueTypeProduct != ""
                                  ? uniqueTypeProduct
                                  : "Tipo de producto no encontrado",
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
              Flexible(
                child: isLoadProducts
                    ? someTypeProduct && !lProducts
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                                top: 40.0,
                                bottom: 20.00),
                            child: Center(
                              child: Text("Seleccione un tipo de producto"),
                            ),
                          )
                        : lTypeProducts || !clientSelected
                            ? Center()
                            : Center(
                                child: CircularProgressIndicator(),
                              )
                    : productsList.length == 0
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                                top: 40.0,
                                bottom: 20.00),
                            child: Center(
                              child: Text(
                                  "No hay productos relacionados a este tipo de producto."),
                            ),
                          )
                        : ListView.builder(
                            itemCount: productsList.length,
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
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
                                              productsList[index].descripcion !=
                                                      null
                                                  ? productsList[index]
                                                      .descripcion
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
                                              editProduct(
                                                  productsList[index].producto);
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
                                              deleteProduct(
                                                  context,
                                                  productsList[index].producto,
                                                  productsList[index]
                                                      .descripcion);
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

  newProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewProduct()),
    );
  }

  deleteProduct(context, product, description) {
    showAlertDialog(context, product, description);
  }

  showAlertDialog(BuildContext context, productToDelete, description) {
    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () async {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Eliminar"),
      onPressed: () async {
        var pnDescription;
        var pntypeProduct;
        var pnIdentifier;
        var pnPrice;
        for (var product in productsList) {
          if (product.producto == productToDelete) {
            pnDescription = product.descripcion;
            pntypeProduct = product.tipoProducto;
            pnIdentifier = product.identificador;
            pnPrice = product.precioLista;
          }
        }
        ProgressDialog progressDialog = ProgressDialog(context);
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        var pnUsuario = sharedPreferences.get("user");
        var pnClave = sharedPreferences.get("pass");
        progressDialog.show();
        Map json = {
          "autenticacion": {"pn_usuario": pnUsuario, "pn_clave": pnClave},
          "parametros": {
            "pn_empresa": "1",
            "pn_cliente": clientValue,
            "pn_accion": "M",
            "pn_producto": productToDelete,
            "pn_producto_tipo": pntypeProduct,
            "pn_identificador": pnIdentifier,
            "pn_descripcion": pnDescription,
            "pn_precio_lista": pnPrice,
            "pn_activo": "0"
          }
        };
        var jsonData;
        var body = convert.jsonEncode(json);
        print(body);
        var response = await http.post(
            gFunct.globalURL +
                "certificaciones/catalogos/cliente_productos_gestion",
            headers: {"Content-Type": "application/json"},
            body: body);
        if (response.statusCode == 200) {
          Navigator.of(context).pop();
          jsonData = convert.jsonDecode(response.body);
          if (jsonData['resultado'][0]['error'] == 0) {
            progressDialog.dismiss();
            gFunct.showModalDialog("Eliminación exitosa",
                "El producto fue eliminado correctamente.", context);
            loadProducts();
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
          "El producto: $description será eliminado, confirma esta acción"),
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

  editProduct(producto) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    for (var product in productsList) {
      if (product.producto == producto) {
        sharedPreferences.setString("client_product_edit", clientValue);
        sharedPreferences.setString(
            "identifier_product_edit", product.identificador);
        sharedPreferences.setString(
            "description_product_edit", product.descripcion);
        sharedPreferences.setString("price_product_edit", product.precioLista);
        sharedPreferences.setString("type_product_edit", product.tipoProducto);
      }
    }
    sharedPreferences.setString("product_edit", producto);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProduct()),
    );
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
            clientsList = _clients;
            uniqueClient = "Client: ${_clients[0].nombre}";
            someClients = false;
            isLoadClientSelect = false;
            loadTypeProducts(_clients[0].cliente);
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
      isLoadProducts = true;
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
    var response = await http.post(
        gFunct.globalURL +
            "certificaciones/catalogos/cliente_tipos_producto_listado",
        headers: {"Content-Type": "application/json"},
        body: body);
    if (response.statusCode == 200) {
      //progressDialog.show();
      jsonData = convert.jsonDecode(response.body);
      if (jsonData['resultado'][0]['error'] == 0) {
        List<TypeProduct> _typeProducts = [];
        var datos = jsonData['datos'];
        for (var d in datos) {
          _typeProducts.add(TypeProduct.fromJson(d));
        }
        if (_typeProducts.length == 1) {
          setState(() {
            typeProductsList = _typeProducts;
            uniqueTypeProduct =
                "Tipo de producto: ${_typeProducts[0].tipoProductoDescripcion}";
            someTypeProduct = false;
            isLoadTypeProductSelect = false;
            typeProductValue = _typeProducts[0].tipoProducto;
            //progressDialog.dismiss();
            loadProducts();
            lTypeProducts = false;
          });
        } else {
          setState(() {
            uniqueTypeProduct = "";
            typeProductsList = _typeProducts;
            typeProductValue = _typeProducts[0].tipoProducto;
            isLoadTypeProductSelect = false;
            someTypeProduct = true;
            //progressDialog.dismiss();
            lTypeProducts = false;
            loadProducts();
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

  loadProducts() async {
    setState(() {
      lProducts = true;
      productsList = [];
      isLoadProducts = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var pnUsuario = sharedPreferences.get("user");
    var pnClave = sharedPreferences.get("pass");
    Map json = {
      "autenticacion": {"pn_usuario": pnUsuario, "pn_clave": pnClave},
      "parametros": {
        "pn_empresa": "1",
        "pn_cliente": clientValue,
        "pn_producto_tipo": typeProductValue,
        "pn_producto": "",
        "pn_activo": "1"
      }
    };
    var jsonData;
    var body = convert.jsonEncode(json);
    print(body);
    var response = await http.post(
        gFunct.globalURL +
            "certificaciones/catalogos/cliente_productos_listado",
        headers: {"Content-Type": "application/json"},
        body: body);
    if (response.statusCode == 200) {
      //progressDialog.show();
      jsonData = convert.jsonDecode(response.body);
      if (jsonData['resultado'][0]['error'] == 0) {
        List<Product> _products = [];
        var datos = jsonData['datos'];
        for (var d in datos) {
          _products.add(Product.fromJson(d));
        }
        setState(() {
          productsList = _products;
          isLoadProducts = false;
          //progressDialog.dismiss();
          lProducts = false;
        });
      } else {
        gFunct.showModalDialog(
            "Error al obtener información",
            "Hubo un error al solicitar sus opciones, intentelo en unos minutos",
            context);
        //progressDialog.dismiss();
      }
    } else {
      gFunct.showModalDialog(
          "Error en el servidor",
          "Se generó un error en el servidor, intetelo en unos minutos",
          context);
      //progressDialog.dismiss();
    }
  }

  saveInvoice(invoice) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("invoice", invoice);
  }
}
