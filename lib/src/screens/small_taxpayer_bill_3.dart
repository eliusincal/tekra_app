import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tekra_app/src/global/global.dart';
import 'package:tekra_app/src/models/detail_invoice.dart';
import 'package:tekra_app/src/models/product.dart';
import 'package:tekra_app/src/models/type_product.dart';
import 'package:tekra_app/src/screens/components/card_info_items.dart';
import 'package:tekra_app/src/screens/components/rounded_button.dart';

import 'package:http/http.dart' as http;
import 'package:tekra_app/src/screens/resume_invoice.dart';
import 'dart:convert' as convert;

import 'package:tekra_app/src/utils/dialog.dart';

class SmallTaxpayerBill3 extends StatefulWidget {
  SmallTaxpayer3 createState() => SmallTaxpayer3();
}

class SmallTaxpayer3 extends State<SmallTaxpayerBill3> {
  GlobalFunctions gFunct = GlobalFunctions();
  //Formulario para poder generar las validaciones
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  //Variables necesarias para los objetos relacionados a TypeProduct:
  List<TypeProduct> typeProductsList = [];
  String uniqueTypeProduct = "";
  bool someTypeProduct = false;
  bool isLoadTypeProductSelect = true;
  bool lTypeProducts = false;
  static String typeProductValue;
  static String productValue;
  static String quantity;
  static String identifier;
  static String price;
  static String discount;
  static String description;
  static String bienServicio;

  static List<DetailInvoice> detailBills = [];

  String invoiceTitle = "N/A";
  static double totalInvoice = 0.00;
  static int totalItems = 0;

  @override
  initState() {
    totalInvoice = 0.00;
    totalItems = 0;
    detailBills.clear();
    loadTypeProducts();
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
                "Items",
                style: TextStyle(
                  color: Color(0xff26b5e6),
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CardInfoItems(
                total: totalInvoice,
                size: size,
                items: totalItems,
              ),
              detailBills.length != 0
                  ? Column(
                      children: new List.generate(
                          detailBills.length,
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Item: ${index + 1}",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                                setState(() {
                                                  detailBills.removeAt(index);
                                                });
                                                calculateTotal();
                                              },
                                              color: Colors.red,
                                            )
                                          ],
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Cantidad",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xffbbbbbb),
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      detailBills[index]
                                                          .cantidad,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff555555),
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Producto/Servicio",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xffbbbbbb),
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      detailBills[index]
                                                          .bienServicio,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff555555),
                                                        fontSize: 19,
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Valor unitario",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xffbbbbbb),
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      detailBills[index]
                                                          .valorUnitario,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff555555),
                                                        fontSize: 19,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Descuento unitario",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xffbbbbbb),
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      detailBills[index]
                                                          .descuentoUnitario,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff555555),
                                                        fontSize: 19,
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Descripción",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xffbbbbbb),
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      detailBills[index]
                                                          .descripcion,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff555555),
                                                        fontSize: 19,
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
                  : Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Agrege un detalle de documento",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
              GestureDetector(
                  onTap: () {
                    newItemInvoice(size);
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      color: Color(0xfff4fbfe),
                      child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Item",
                                          style: TextStyle(
                                            color: Color(0xff051228),
                                            fontSize: 20,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Icon(
                                          Icons.add_circle_outline,
                                          color: Colors.blueAccent,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ),
                  )),
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

  newItemInvoice(size) async {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  // Get available height and width of the build area of this widget. Make a choice depending on the size.
                  var width = MediaQuery.of(context).size.width;

                  return Container(
                    width: width - 100,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: <Widget>[
                        Form(
                          key: formKey,
                          child: ProductDropDown(
                              detailBills: detailBills,
                              size: size,
                              typeProductsList: typeProductsList),
                        ),
                      ]),
                    ),
                  );
                },
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancelar', style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(
                    'Agregar',
                  ),
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      detailBills.insert(
                          0,
                          DetailInvoice(
                              quantity,
                              productValue,
                              price,
                              discount,
                              description,
                              identifier,
                              typeProductValue,
                              bienServicio));
                      calculateTotal();
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          });
        });
  }

  calculateTotal() {
    var totalI = 0;
    var total = 0.00;
    for (var di in detailBills) {
      totalI++;
      var quantity = di.cantidad;
      var discount = di.descuentoUnitario;
      var price = di.valorUnitario;
      total += (double.parse(quantity) * double.parse(price)) -
          (double.parse(quantity) * double.parse(discount));
    }
    setState(() {
      totalInvoice = total;
      totalItems = totalI;
    });
  }

  saveInfo() async {
    if (detailBills.length != 0) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("totalItems", totalItems.toString());
      sharedPreferences.setString("totalInvoice", totalInvoice.toString());
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResumeInvoice(
                    detailBills: detailBills,
                  )));
    } else {
      gFunct.showModalDialog(
          "Sin items", "Necesita agregar un item como mínimo.", context);
    }
  }

  loadData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var title = "N/A";
    if (sharedPreferences.get("invoiceTitle") != null) {
      title = sharedPreferences.get("invoiceTitle");
    }
    setState(() {
      invoiceTitle = title;
    });
  }

  loadTypeProducts() async {
    setState(() {
      isLoadTypeProductSelect = true;
      lTypeProducts = true;
    });
    ProgressDialog2 progressDialog = ProgressDialog2(context);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var pnUsuario = sharedPreferences.get("user");
    var pnClave = sharedPreferences.get("pass");
    var pnClient = sharedPreferences.get("client");
    Map json = {
      "autenticacion": {"pn_usuario": pnUsuario, "pn_clave": pnClave},
      "parametros": {
        "pn_empresa": "1",
        "pn_cliente": pnClient,
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
            lTypeProducts = false;
          });
        } else {
          setState(() {
            uniqueTypeProduct = "";
            typeProductsList = _typeProducts;
            isLoadTypeProductSelect = false;
            someTypeProduct = true;
            lTypeProducts = false;
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

class RoundedInputRow extends StatelessWidget {
  const RoundedInputRow(
      {Key key,
      @required this.size,
      this.text,
      this.controller,
      this.onChange,
      this.isNumber = false,
      this.validator})
      : super(key: key);

  final Size size;
  final String text;
  final controller;
  final validator;
  final onChange;
  final bool isNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: size.width * 0.7,
          child: Text(
            text,
            style: TextStyle(color: Color(0xff051228), fontSize: 15.00),
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: size.width * 0.7,
          child: TextFormField(
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            onChanged: onChange,
            decoration: InputDecoration(
              hintText: text,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Color(0xffa8e1f5), width: 2)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Color(0xffa8e1f5), width: 2)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Color(0xffa8e1f5), width: 2)),
              fillColor: Colors.white,
              filled: true,
            ),
            validator: validator,
            controller: controller,
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class ProductDropDown extends StatefulWidget {
  final size;
  final List<TypeProduct> typeProductsList;
  final List<DetailInvoice> detailBills;
  ProductDropDown({this.size, this.typeProductsList, this.detailBills});
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<ProductDropDown> {
  //Variables necesarias para los objetos relacionas a Productos
  List<Product> productList = [];
  bool isLoadProducts = false;
  bool lProducts = false;
  bool isEmptyProducts = false;

  //Controladores
  TextEditingController quantityController = TextEditingController();
  TextEditingController identifieController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  GlobalFunctions gFunct = GlobalFunctions();

  String typeProductValue;
  String productValue;

  @override
  void initState() {
    super.initState();
    if (widget.typeProductsList.length != 0) {
      typeProductValue = widget.typeProductsList[0].tipoProducto;
      SmallTaxpayer3.typeProductValue = widget.typeProductsList[0].tipoProducto;
      loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          Text("Nuevo detalle de documento", style: TextStyle(fontSize: 19)),
          SizedBox(
            height: 10,
          ),
          widget.typeProductsList.length != 0
              ?
              //Text(productList[0].descripcion)
              Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: widget.size.width * 0.62,
                          child: Text(
                            "Tipo de producto",
                            style: TextStyle(
                                color: Color(0xff051228), fontSize: 15.00),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.all(3.0),
                          width: widget.size.width * 0.62,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xffa8e1f5), width: 2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: DropdownButton(
                              value: typeProductValue,
                              hint: Text("Seleccionar tipo de producto"),
                              dropdownColor: Color(0xffff7f7f7),
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 36,
                              isExpanded: true,
                              underline: SizedBox(),
                              items: widget.typeProductsList.map((tp) {
                                return new DropdownMenuItem(
                                    child: new Text(tp.tipoProductoDescripcion),
                                    value: tp.tipoProducto);
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  typeProductValue = val;
                                  SmallTaxpayer3.typeProductValue = val;
                                });
                                loadProducts();
                              }),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    !isLoadProducts && productList.length != 0
                        ? Column(
                            children: [
                              Container(
                                width: widget.size.width * 0.62,
                                child: Text(
                                  "Producto",
                                  style: TextStyle(
                                      color: Color(0xff051228),
                                      fontSize: 15.00),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.all(5.0),
                                width: widget.size.width * 0.62,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xffa8e1f5), width: 2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: DropdownButton(
                                    value: productValue,
                                    hint: Text("Seleccionar producto"),
                                    dropdownColor: Color(0xffff7f7f7),
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 36,
                                    isExpanded: true,
                                    underline: SizedBox(),
                                    items: productList.map((product) {
                                      return new DropdownMenuItem(
                                          child: new Text(product.descripcion),
                                          value: product.producto);
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        productValue = val;
                                      });
                                      selectProduct();
                                    }),
                              ),
                            ],
                          )
                        : isLoadProducts
                            ? Text("Cargando datos...")
                            : isEmptyProducts
                                ? Text("No hay productos registrados")
                                : Text("Seleccione un tipo de producto"),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: widget.size.width * 0.62,
                      child: RoundedInputRow(
                        onChange: (val) {
                          SmallTaxpayer3.identifier = val;
                        },
                        controller: identifieController,
                        isNumber: false,
                        size: widget.size,
                        text: "Identificador",
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Dato necesario";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: widget.size.width * 0.62,
                      child: RoundedInputRow(
                        onChange: (val) {
                          SmallTaxpayer3.price = val;
                        },
                        controller: priceController,
                        isNumber: true,
                        size: widget.size,
                        text: "Valor unitario",
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Dato necesario";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: widget.size.width * 0.62,
                      child: RoundedInputRow(
                        onChange: (val) {
                          SmallTaxpayer3.quantity = val;
                        },
                        controller: quantityController,
                        isNumber: true,
                        size: widget.size,
                        text: "Cantidad",
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Dato necesario";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: widget.size.width * 0.62,
                      child: RoundedInputRow(
                        onChange: (val) {
                          SmallTaxpayer3.discount = val;
                        },
                        controller: discountController,
                        isNumber: true,
                        size: widget.size,
                        text: "Descuento unitario",
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Dato necesario";
                          }
                          if (double.parse(val) >
                              double.parse(priceController.text)) {
                            return "Descuento mayor que el precio unitario";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Container(
                          width: widget.size.width * 0.6,
                          child: Text(
                            "Descripción",
                            style: TextStyle(
                                color: Color(0xff051228), fontSize: 15.00),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: widget.size.width * 0.6,
                          child: TextFormField(
                            controller: descriptionController,
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Dato necesario";
                              }
                              return null;
                            },
                            onChanged: (val) {
                              SmallTaxpayer3.description = val;
                            },
                            decoration: InputDecoration(
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 40.0, horizontal: 10.0),
                              hintText: "Descripción",
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                      color: Color(0xffa8e1f5), width: 2)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                      color: Color(0xffa8e1f5), width: 2)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                      color: Color(0xffa8e1f5), width: 2)),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Text("Cargando datos..."),
        ],
      ),
    );
  }

  selectProduct() {
    var select = false;
    for (var p in productList) {
      if (p.producto == productValue) {
        select = true;
        setState(() {
          descriptionController.text = p.descripcion;
          priceController.text = p.precioLista;
          identifieController.text = p.identificador;
          SmallTaxpayer3.description = p.descripcion;
          SmallTaxpayer3.price = p.precioLista;
          SmallTaxpayer3.identifier = p.identificador;
          SmallTaxpayer3.productValue = p.producto;
        });
      }
    }
    for (var tp in widget.typeProductsList) {
      if (tp.tipoProducto == typeProductValue) {
        SmallTaxpayer3.bienServicio = tp.bienServicioDescripcion;
      }
    }
    if (!select) {
      descriptionController.text = "";
      priceController.text = "";
      identifieController.text = "";
    }
  }

  loadProducts() async {
    ProgressDialog2 progressDialog = ProgressDialog2(context);
    setState(() {
      isLoadProducts = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var pnUsuario = sharedPreferences.get("user");
    var pnClave = sharedPreferences.get("pass");
    var pnCliente = sharedPreferences.get("client");
    var pnTipoProducto = typeProductValue;
    progressDialog.show();
    Map data = {
      "autenticacion": {"pn_usuario": pnUsuario, "pn_clave": pnClave},
      "parametros": {
        "pn_empresa": "1",
        "pn_cliente": pnCliente,
        "pn_producto_tipo": pnTipoProducto,
        "pn_producto": "",
        "pn_activo": "1"
      }
    };
    var body = convert.jsonEncode(data);
    print(body);
    var jsonData;
    var response = await http.post(
        "http://apiseguimiento.desa.tekra.com.gt:8080/seguimiento/certificaciones/catalogos/cliente_productos_listado",
        headers: {"Content-Type": "application/json"},
        body: body);

    if (response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      if (jsonData['resultado'][0]['error'] == 0) {
        List<Product> _products = [];
        var datos = jsonData['datos'];
        for (var d in datos) {
          _products.add(Product.fromJson(d));
        }
        print(_products);
        setState(() {
          isLoadProducts = false;
          if (_products.length == 0) {
            progressDialog.dismiss();
            isEmptyProducts = true;
          } else {
            isEmptyProducts = false;
            //SmallTaxpayer3.productValue = productValue;
            productValue = _products[0].producto;
            //SmallTaxpayer3.productValue = productValue;
            progressDialog.dismiss();
            productList = _products;
          }
        });
        selectProduct();
      } else {
        progressDialog.dismiss();
        gFunct.showModalDialog(
            "Error al obtener información",
            "Hubo un error al solicitar sus opciones, intentelo en unos minutos",
            context);
      }
    } else {
      progressDialog.dismiss();
      gFunct.showModalDialog(
          "Error en el servidor",
          "Se generó un error en el servidor, intetelo en unos minutos",
          context);
    }
  }
}
