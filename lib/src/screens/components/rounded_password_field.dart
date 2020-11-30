import 'package:flutter/material.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool pass;
  final validator;
  final String text;
  final controller;
  const RoundedPasswordField({
    Key key,
    this.onChanged,
    this.pass = true,
    this.validator,
    this.text = "Contraseña",
    this.controller
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children:<Widget>[ 
        Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal:20),
          width: size.width * 0.75,
          child:Column(
            children:<Widget>[  
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  text,
                  style: TextStyle(
                    color: Color(0xff051228), 
                    fontSize: 15.00
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),  
              TextFormField(
                controller: controller,
                obscureText: true,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: text,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Color(0xffa8e1f5), width: 2)
                  ),  
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Color(0xffa8e1f5), width: 2)
                  ), 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Color(0xffa8e1f5), width: 2)
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
                validator: validator,
              ),
            ]
          ),
        ),
        pass ?
        GestureDetector(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal:20),
            padding: EdgeInsets.symmetric(horizontal:20, vertical:5),
            width: size.width * 0.85,
            child:  Align(
              alignment: Alignment.centerRight,
              child: Container(
                child:Text(
                  "Recuperar mi contraseña",
                  style: TextStyle(
                    fontSize: 11.00,
                    color: Color(0xff3482b7),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ),
          onTap: (){
            Navigator.pushReplacementNamed(context, "/recoveraccount");
          },
        ):    
        SizedBox(
          height: 0,
        ),       
      ]
    );
  }
}

