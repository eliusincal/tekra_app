import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tekra_app/src/global/global.dart';
import 'package:tekra_app/src/models/product.dart';
import 'package:tekra_app/src/screens/components/card_info_items.dart';
import 'package:tekra_app/src/screens/components/rounded_button.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

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

  static List<DetailInvoice> detailBills = [];
  static List<Product> productList = [];

  String invoiceTitle = "N/A";
  double totalInvoice = 0.00;

  @override
  initState() {
    detailBills = [
      DetailInvoice(
          cantidad: "",
          producto: "",
          valorUnitario: "",
          descuentoUnitario: "",
          descripcion: "")
    ];
    loadProductsDropdown();
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
                      : Text("Cargando informacion"),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    detailBills.insert(
                        0,
                        DetailInvoice(
                            cantidad: "",
                            producto: "",
                            valorUnitario: "",
                            descuentoUnitario: "",
                            descripcion: ""));
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
                                                  DetailInvoice(
                                                      cantidad: "",
                                                      producto: "",
                                                      valorUnitario: "",
                                                      descuentoUnitario: "",
                                                      descripcion: ""));
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
                      press: () {},
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

  Widget form(size, index, detailBills) {
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
                    Column(
                      children: [
                        InputQuantity(
                          size: size,
                          index: index,
                        ),
                      ],
                    ),
                    productList.length != 0
                        ?
                        //Text(productList[0].descripcion)
                        Column(
                            children: [
                              Container(
                                width: size.width * 0.35,
                                child: Text(
                                  "Producto/servicio",
                                  style: TextStyle(
                                      color: Color(0xff051228),
                                      fontSize: 15.00),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ProductDropDown(
                                  product: productList[0],
                                  size: size,
                                  productList: productList,
                                  index: index)
                            ],
                          )
                        : Text("Cargando datos...")
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        RoundedInputRow(
                          size: size,
                          isNumber: true,
                          text: "Valor unitario",
                          validator: (val) {
                            if (val.isEmpty) {
                              return "Campo vacío";
                            }
                            return null;
                          },
                          onChange: (val) {
                            detailBills[index].valorUnitario = val;
                            calculateTotal();
                          },
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
                              return "Campo vacío";
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
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: size.width * 0.77,
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
                          width: size.width * 0.77,
                          child: TextFormField(
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Campo vacío";
                              }
                              return null;
                            },
                            onChanged: (val) {
                              detailBills[index].descripcion = val;
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
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }

  loadProductsDropdown() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var pnUsuario = sharedPreferences.get("user");
    var pnClave = sharedPreferences.get("pass");
    var pnCliente = sharedPreferences.get("client");
    Map data = {
      "autenticacion": {"pn_usuario": pnUsuario, "pn_clave": pnClave},
      "parametros": {
        "pn_empresa": "1",
        "pn_cliente": pnCliente,
        "pn_producto_tipo": "-1",
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
          productList = _products;
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

  saveInfo() async {
    if (formKey.currentState.validate()) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SmallTaxpayerBill3()));
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

  calculateTotal() {
    var cont = 1;
    var total = 0.00;
    for (var det in detailBills) {
      total += double.parse(det.valorUnitario);
      cont++;
    }
    setState(() {
      totalInvoice = total;
    });
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
          return "Campo vacío";
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
  List<Product> productList;
  Product product;
  final index;
  ProductDropDown({this.product, this.size, this.productList, this.index});
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<ProductDropDown> {
  String _value = "";
  @override
  void initState() {
    super.initState();
    if (SmallTaxpayer3.detailBills[widget.index].producto != "") {
      _value = SmallTaxpayer3.detailBills[widget.index].producto;
    }else{
      _value = widget.product.producto;
    }
  }

  @override
  void didUpdateWidget(ProductDropDown oldWidget) {
    if (oldWidget.product.producto !=
        SmallTaxpayer3.detailBills[widget.index].producto) {
      _value = widget.product.producto;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      width: widget.size.width * 0.35,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffa8e1f5), width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton(
          value: _value,
          hint: Text("Seleccionar producto"),
          dropdownColor: Color(0xffff7f7f7),
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 36,
          isExpanded: true,
          underline: SizedBox(),
          items: widget.productList.map((product) {
            return new DropdownMenuItem(
                child: new Text(product.despliegue), value: product.producto);
          }).toList(),
          onChanged: (val) {
            _value = val;
            SmallTaxpayer3.detailBills[widget.index].producto = val;
          }),
    );
  }
}

class DetailInvoice {
  String cantidad, producto, valorUnitario, descuentoUnitario, descripcion;
  DetailInvoice(
      {this.cantidad,
      this.producto,
      this.valorUnitario,
      this.descuentoUnitario,
      this.descripcion});
}
