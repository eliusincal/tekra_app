import 'package:flutter/material.dart';
import 'package:tekra_app/src/screens/components/message_context_text.dart';
import 'package:tekra_app/src/mixins/validation.dart';

// ignore: must_be_immutable
class TwoStepVerification extends StatelessWidget with ValidationMixins{
  //Url para poder acceder a esta clase
  static const String routeName = "/two_step_verification";

  //Controladores para el formulario de login
  TextEditingController codeController = TextEditingController();

  //Formulario para poder generar las validaciones
  final GlobalKey<FormState> formKey= new GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context){
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xfff4fbfe),
      body:Form(
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
              Image.asset(
                'assets/images/logo/logo3x-black.png',
                fit: BoxFit.none,
                scale: 2,
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal:20),
                width: size.width * 0.75,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Verificación de dos pasos",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xff051228),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Por tu seguridad se está efectuando la validación de cuenta en dos pasos, espera a que se te autorice el acceso a tu cuenta, esto no tomará más de unos minutos.",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff051228),
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Spacer(),
              MessageContextText(
                text: "¿No has logrado entrar a tu cuenta?",
                textaction: "Solicitar acceso de nuevo",
                size: size,
                ontap: (){},
              ),
              SizedBox(
                height: 20,
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


