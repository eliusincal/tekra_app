import 'package:flutter/material.dart';
import 'package:tekra_app/src/screens/components/message_context_text.dart';
import 'package:tekra_app/src/screens/components/rounded_button.dart';
import 'package:tekra_app/src/screens/components/rounded_input_field.dart';
import 'package:tekra_app/src/screens/components/rounded_password_field.dart';
import 'package:tekra_app/src/mixins/validation.dart';

// ignore: must_be_immutable
class Login extends StatelessWidget with ValidationMixins{
  //Url para poder acceder a esta clase
  static const String routeName = "/login";

  //Controladores para el formulario de login
  TextEditingController userController = TextEditingController();
  TextEditingController contrasenaController = TextEditingController();

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
              RoundedInputField(
                text: "Usuario",
                onChanged: (value){
                },
                validator: validateUsuario,
                controller: userController,
              ),
              RoundedPasswordField(
                onChanged: (value){},
                validator: validateContrasena,
                controller: contrasenaController,
                pass: false,
              ),
              Spacer(),
              MessageContextText(
                text: "¿Olvidaste tu contraseña?",
                textaction: "Recuperar contraseña",
                size: size,
                ontap: (){},
              ),
              SizedBox(
                height: 20,
              ),
              RoudedButton(
                text: "INICIAR SESIÓN",
                press: (){
                  if(formKey.currentState.validate()){
                    print(userController.value);
                    print(contrasenaController.value);
                    Navigator.pushReplacementNamed(context, "/two_step_verification");
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


