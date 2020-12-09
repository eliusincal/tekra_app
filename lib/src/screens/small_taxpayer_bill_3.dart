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
import 'package:tekra_app/src/screens/small_taxpayer_bill_2.dart';
import 'dart:convert' as convert;

import 'package:tekra_app/src/utils/dialog.dart';

class SmallTaxpayerBill3 extends StatefulWidget {
  SmallTaxpayer3 createState() => SmallTaxpayer3();
}

class SmallTaxpayer3 extends State<SmallTaxpayerBill3> {
  GlobalFunctions gFunct = GlobalFunctions();
  //Formulario para poder generar las validaciones
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Map<String, TextEditingController> textEditingControllers = {};
  var quantityControllers = <TextFormField>[];
  var productsControllers = <TextFormField>[];
  var priceControllers = <TextFormField>[];
  var discountControllers = <TextFormField>[];
  var descriptionControllers = <TextFormField>[];

  //Variables necesarias para los objetos relacionados a TypeProduct:
  List<TypeProduct> typeProductsList = [];
  String uniqueTypeProduct = "";
  bool someTypeProduct = false;
  bool isLoadTypeProductSelect = true;
  bool lTypeProducts = false;

  static List<DetailInvoice> detailBills = [];

  String invoiceTitle = "N/A";
  static double totalInvoice = 0.00;

  @override
  initState() {
    loadTypeProducts();
    detailBills = [];
    detailBills = [DetailInvoice("", "", "", "", "", "", "")];
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
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SmallTaxpayerBill2()));
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
              ),
              Flexible(
                child: Form(
                  key: formKey,
                  child: detailBills.length != 0
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: detailBills.length,
                          itemBuilder: (context, index) {
                            return form(size, index, detailBills);
                          })
                      : Text("Agrege un detalle de documento"),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    detailBills.insert(
                        0, DetailInvoice("", "", "", "", "", "", ""));

                    setState(() {});
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
                                          child: GestureDetector(
                                            onTap: () {
                                              detailBills.insert(
                                                  0,
                                                  DetailInvoice("", "", "", "",
                                                      "", "", ""));
                                              setState(() {});
                                            },
                                            child: Icon(
                                              Icons.add_circle_outline,
                                              color: Colors.blueAccent,
                                            ),
                                          ))
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

  Widget form(size, index, List<DetailInvoice> detailBills) {
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Item ${detailBills.length - index}",
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
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  detailBills.removeAt(index);
                                });
                              },
                              child: Icon(
                                Icons.restore_from_trash,
                                color: Colors.redAccent,
                              ),
                            ))
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ProductDropDown(
                        size: size,
                        index: index,
                        typeProductsList: typeProductsList,
                        detailBills: detailBills)
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        InputQuantity(
                          size: size,
                          index: index,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        InputIdentifier(
                          size: size,
                          index: index,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        InputPrice(
                          size: size,
                          index: index,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        RoundedInputRow(
                          isNumber: true,
                          size: size,
                          text: "Descuento unitario",
                          validator: (val) {
                            if (val.isEmpty) {
                              return "Dato necesario";
                            }
                            return null;
                          },
                          onChange: (val) {
                            detailBills[index].descuentoUnitario = val;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InputDescription(
                      size: size,
                      index: index,
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }

  saveInfo() async {
    if (formKey.currentState.validate()) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ResumeInvoice(detailBills: detailBills,)));
    }
    //SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // sharedPreferences.setString("nitInvoice", nitController.text);
    // sharedPreferences.setString("nameInvoice", nameController.text);
    // sharedPreferences.setString("addressInvoice", addressController.text);
    // sharedPreferences.setString("emailIvoice", emailoController.text);
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
    ProgressDialog progressDialog = ProgressDialog(context);
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
        print(_typeProducts);
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

class InputDescription extends StatefulWidget {
  final size;
  final index;
  const InputDescription({Key key, this.size, this.index}) : super(key: key);

  @override
  _InputDescriptionState createState() => _InputDescriptionState();
}

class _InputDescriptionState extends State<InputDescription> {
  TextEditingController _descripctionController;

  @override
  void initState() {
    super.initState();
    _descripctionController = TextEditingController();
  }

  @override
  void dispose() {
    _descripctionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _descripctionController.text =
          SmallTaxpayer3.detailBills[widget.index].descripcion ?? '';
    });
    return Column(
      children: [
        Container(
          width: widget.size.width * 0.77,
          child: Text(
            "Descripción",
            style: TextStyle(color: Color(0xff051228), fontSize: 15.00),
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: widget.size.width * 0.77,
          child: TextFormField(
            controller: _descripctionController,
            validator: (val) {
              if (val.isEmpty) {
                return "Dato necesario";
              }
              return null;
            },
            onChanged: (val) {
              SmallTaxpayer3.detailBills[widget.index].descripcion = val;
            },
            decoration: InputDecoration(
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
              hintText: "Descripción",
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
          ),
        ),
      ],
    );
  }
}

class InputPrice extends StatefulWidget {
  final size;
  final index;
  const InputPrice({Key key, this.size, this.index}) : super(key: key);

  @override
  _InputPriceState createState() => _InputPriceState();
}

class _InputPriceState extends State<InputPrice> {
  TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _priceController.text =
          SmallTaxpayer3.detailBills[widget.index].valorUnitario ?? '';
    });
    return RoundedInputRow(
      controller: _priceController,
      size: widget.size,
      isNumber: true,
      text: "Valor unitario",
      validator: (val) {
        if (val.isEmpty) {
          return "Dato necesario";
        }
        return null;
      },
      onChange: (val) {
        GlobalFunctions gF = GlobalFunctions();
        SmallTaxpayer3.detailBills[widget.index].valorUnitario = val;
        SmallTaxpayer3.totalInvoice =
            gF.calculateTotal(SmallTaxpayer3.detailBills);
      },
    );
  }
}

class InputIdentifier extends StatefulWidget {
  final size;
  final index;
  const InputIdentifier({Key key, this.size, this.index}) : super(key: key);

  @override
  _InputIdentifierState createState() => _InputIdentifierState();
}

class _InputIdentifierState extends State<InputIdentifier> {
  TextEditingController _identifierController;

  @override
  void initState() {
    super.initState();
    _identifierController = TextEditingController();
  }

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _identifierController.text =
          SmallTaxpayer3.detailBills[widget.index].identificador ?? '';
    });
    return RoundedInputRow(
      controller: _identifierController,
      size: widget.size,
      isNumber: true,
      text: "Identificador",
      validator: (val) {
        if (val.isEmpty) {
          return "Dato necesario";
        }
        return null;
      },
      onChange: (val) {
        SmallTaxpayer3.detailBills[widget.index].identificador = val;
      },
    );
  }
}

class InputQuantity extends StatefulWidget {
  final size;
  final index;
  const InputQuantity({Key key, this.size, this.index}) : super(key: key);

  @override
  _InputQuantityState createState() => _InputQuantityState();
}

class _InputQuantityState extends State<InputQuantity> {
  TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _quantityController.text =
          SmallTaxpayer3.detailBills[widget.index].cantidad ?? '';
    });

    return RoundedInputRow(
      controller: _quantityController,
      isNumber: true,
      size: widget.size,
      text: "Cantidad",
      validator: (val) {
        if (val.isEmpty) {
          return "Dato necesario";
        }
        return null;
      },
      onChange: (val) {
        SmallTaxpayer3.detailBills[widget.index].cantidad = val;
      },
    );
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
          width: size.width * 0.35,
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
          width: size.width * 0.35,
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
  final index;
  final List<TypeProduct> typeProductsList;
  final List<DetailInvoice> detailBills;
  ProductDropDown(
      {this.size, this.index, this.typeProductsList, this.detailBills});
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<ProductDropDown> {
  //Variables necesarias para los objetos relacionas a Productos
  List<Product> productList = [];
  bool isLoadProducts = false;
  bool lProducts = false;
  bool isEmptyProducts = false;

  GlobalFunctions gFunct = GlobalFunctions();

  String typeProductValue;
  String productValue;

  @override
  void initState() {
    super.initState();
    if (widget.detailBills[widget.index].tipoProducto != "") {
      typeProductValue = widget.detailBills[widget.index].tipoProducto;
    } else {
      typeProductValue = widget.typeProductsList[0].tipoProducto;
    }

    if (widget.detailBills[widget.index].producto != "") {
      loadProducts();
      productValue = widget.detailBills[widget.index].producto;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.typeProductsList.length != 0
        ?
        //Text(productList[0].descripcion)
        Column(
            children: [
              Column(
                children: [
                  Container(
                    width: widget.size.width * 0.77,
                    child: Text(
                      "Tipo de producto",
                      style:
                          TextStyle(color: Color(0xff051228), fontSize: 15.00),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    width: widget.size.width * 0.77,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffa8e1f5), width: 2),
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
                            SmallTaxpayer3
                                .detailBills[widget.index].tipoProducto = val;
                            SmallTaxpayer3.detailBills[widget.index].producto =
                                "";
                          });
                          loadProducts();
                        }),
                  ),
                ],
              ),
              productList.length != 0
                  ?
                  //Text(productList[0].descripcion)
                  !isEmptyProducts
                      ? Column(
                          children: [
                            Container(
                              width: widget.size.width * 0.77,
                              child: Text(
                                "Producto",
                                style: TextStyle(
                                    color: Color(0xff051228), fontSize: 15.00),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(5.0),
                              width: widget.size.width * 0.77,
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
                                    selectProduct(val);
                                  }),
                            ),
                          ],
                        )
                      : Column(children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text("No hay productos registrados"),
                        ])
                  : isLoadProducts
                      ? Text("Cargando datos...")
                      : Text("Seleccione un tipo de producto"),
            ],
          )
        : Text("Cargando datos...");
  }

  selectProduct(product) {
    for (var p in productList) {
      if (p.producto == product) {
        setState(() {
          SmallTaxpayer3.detailBills[widget.index].producto = p.producto;
          SmallTaxpayer3.detailBills[widget.index].valorUnitario =
              p.precioLista;
          SmallTaxpayer3.detailBills[widget.index].identificador =
              p.identificador;
          SmallTaxpayer3.detailBills[widget.index].descripcion = p.descripcion;
        });
      }
    }
  }

  loadProducts() async {
    ProgressDialog progressDialog = ProgressDialog(context);
    setState(() {
      isLoadProducts = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var pnUsuario = sharedPreferences.get("user");
    var pnClave = sharedPreferences.get("pass");
    var pnCliente = sharedPreferences.get("client");
    var pnTipoProducto = SmallTaxpayer3.detailBills[widget.index].tipoProducto;
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
        setState(() {
          if (_products.length == 0) {
            progressDialog.dismiss();
            isEmptyProducts = true;
          } else {
            isEmptyProducts = false;
            if (SmallTaxpayer3.detailBills[widget.index].producto != "") {
              productValue = SmallTaxpayer3.detailBills[widget.index].producto;
            } else {
              productValue = _products[0].producto;
              SmallTaxpayer3.detailBills[widget.index].producto =
                  _products[0].producto;
              SmallTaxpayer3.detailBills[widget.index].valorUnitario =
                  _products[0].precioLista;
              SmallTaxpayer3.detailBills[widget.index].identificador =
                  _products[0].identificador;
              SmallTaxpayer3.detailBills[widget.index].descripcion =
                  _products[0].descripcion;
            }
            progressDialog.dismiss();
            productList = _products;
          }
        });
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
