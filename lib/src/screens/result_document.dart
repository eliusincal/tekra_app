import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tekra_app/src/global/global.dart';
import 'package:tekra_app/src/screens/components/rounded_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tekra_app/src/mixins/validation.dart';

// ignore: must_be_immutable
class ResultDocument extends StatefulWidget {
  //Url para poder acceder a esta clase
  static const String routeName = "/result_document";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<ResultDocument> with ValidationMixins {
  TextEditingController userController = TextEditingController();
  TextEditingController contrasenaController = TextEditingController();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  GlobalFunctions global = GlobalFunctions();

  String mensaje = "";
  String url;
  String numDocument;

  @override
  initState() {
    super.initState();
    GlobalFunctions().isAcces(context);
    loadData();
  }
  
  loadData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      url = sharedPreferences.get("url_documento");
      numDocument = sharedPreferences.get("no_documento");
      print(url);
    });
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xfff4fbfe),
      body: Form(
        key: formKey,
        child: Container(
          width: double.infinity,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 56,
              ),
              Spacer(),
              Text("Documento generado exitosamente"),
              SizedBox(
                height: 20,
              ),
              Text("No. de documento: $numDocument"),
              SizedBox(
                height: 20,
              ),
              Center(
                child: new InkWell(
                    child: new Text('Abrir documento generado'),
                    onTap: () => launch(
                        url)),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                mensaje,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 15,
                ),
              ),
              Spacer(),
              SizedBox(
                height: 20,
              ),
              RoudedButton(
                text: "Ir al inicio",
                press: () {
                  if (formKey.currentState.validate()) {
                    Navigator.pushReplacementNamed(context, "/home");
                  }
                },
                color: Color(0xff26b5e6),
                textColor: Colors.white,
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
