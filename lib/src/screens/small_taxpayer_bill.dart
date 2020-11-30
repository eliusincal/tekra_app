import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tekra_app/src/global/global.dart';
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

  String invoiceTitle = "Factura a emitir";
  String finished = "No";
  String transmitter = "Emisor";
  String contractNumber = "No. Contrato";
  String startDate = "0000-00-00";
  String endDate="0000-00-00";

  List _friendsName = [
    "Establecimiento 1",
    "Establecimiento 2",
    "Establecimiento 3",
    "Establecimiento 4"
  ];

  List _coindsList = [
    "QT - Quetzal",
    "US - Dolares",
    "EU - Euros"
  ];

  @override
  initState() {
    super.initState();
    print("Entro esta opcion");
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
              CardInfo(
                size: size,
                transmitter: transmitter,
                endDate: endDate,
                startDate: startDate,
                contractNumber: contractNumber,
                finished: finished,
              ),
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
                            items: _coindsList.map((value) {
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
  loadData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var title = "Factura a emitir";
    var finish = "No";
    var transm ="Emisor";
    var contractNum = "No.";
    var eDate="0000-00-00";
    var sDate = "0000-00-00";
    if(sharedPreferences.get("invoiceTitle") != null){
      title = sharedPreferences.get("invoiceTitle");
    }
    if(sharedPreferences.get("startDateContract") != null){
      sDate = sharedPreferences.get("startDateContract").toString().substring(0, 10);
    }
    if(sharedPreferences.get("endDateContract") != null){
      eDate = sharedPreferences.get("endDateContract").toString().substring(0, 10);
    }
    if(sharedPreferences.get("finishContract") != null){
      finish = sharedPreferences.get("finishContract");
    }
    if(sharedPreferences.get("contract") != null){
      contractNum = sharedPreferences.get("contract");
    }
    print(sharedPreferences.get("clientName"));
    if(sharedPreferences.get("clientName") != null){
      transm = sharedPreferences.get("clientName");
    }
    setState(() {
      invoiceTitle = title;
      startDate = sDate;
      transmitter = transm;
      endDate = eDate;
      contractNumber = contractNum;
      finished = finish;
    });
  }
}

class CardInfo extends StatelessWidget {
  const CardInfo({
    Key key,
    @required this.size,
    @required this.transmitter,
    @required this.contractNumber,
    @required this.startDate,
    @required this.endDate,
    @required this.finished
  }) : super(key: key);

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
