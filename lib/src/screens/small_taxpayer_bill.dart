import 'package:flutter/material.dart';
import 'package:tekra_app/src/screens/components/rounded_date_input.dart';
import 'package:tekra_app/src/screens/components/rounded_input_field.dart';

class SmallTaxpayerBill extends StatefulWidget {
  SmallTaxpayer createState() => SmallTaxpayer();
}

class SmallTaxpayer extends State<SmallTaxpayerBill> {
  TextEditingController userController = TextEditingController();
  //Formulario para poder generar las validaciones
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final establecientoSeleccionado = TextEditingController();
  String _friendsVal;

  List _friendsName = [
    "Establecimiento 1",
    "Establecimiento 2",
    "Establecimiento 3",
    "Establecimiento 4"
  ];
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
                  "Nueva Factura Pequeño Contribuyente",
                  style: TextStyle(
                    color: Color(0xff051228),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Información de Emisión",
                style: TextStyle(
                  color: Color(0xff26b5e6),
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CardInfo(size: size),
              SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      RoundedDateInput(),
                      SizedBox(
                        height: 20,
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
                            dropdownColor: Colors.grey,
                            elevation: 5,
                            icon: Icon(Icons.arrow_drop_down),
                            isExpanded: true,
                            value: _friendsVal,
                            onChanged: (value) {
                              setState(() {
                                _friendsVal = value;
                              });
                            },
                            items: _friendsName.map((value) {
                              return DropdownMenuItem(
                                  value: value, child: Text(value));
                            }).toList(),
                          ),
                        ),
                      ]),
                      SizedBox(
                        height: 20,
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
                            hint: Text("GTQ - Quetzal"),
                            dropdownColor: Colors.grey,
                            elevation: 5,
                            icon: Icon(Icons.arrow_drop_down),
                            isExpanded: true,
                            value: _friendsVal,
                            onChanged: (value) {
                              setState(() {
                                _friendsVal = value;
                              });
                            },
                            items: _friendsName.map((value) {
                              return DropdownMenuItem(
                                  value: value, child: Text(value));
                            }).toList(),
                          ),
                        ),
                      ]),
                      SizedBox(
                        height: 20,
                      ),
                      RoundedInputField(
                        text: "Tipo de cambio",
                        onChanged: (value) {},
                        isNumber: false,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardInfo extends StatelessWidget {
  const CardInfo({
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
                      fontSize: 20,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Bayer, S.A. [2021100001]",
                    style: TextStyle(
                      color: Color(0xff555555),
                      fontSize: 25,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Contrato",
                      style: TextStyle(
                        fontSize: 19,
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
                      fontSize: 19,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "BAYER0001",
                    style: TextStyle(
                      color: Color(0xff555555),
                      fontSize: 20,
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
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "2020-10-05",
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
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "2020-11-05",
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
                            "No",
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
