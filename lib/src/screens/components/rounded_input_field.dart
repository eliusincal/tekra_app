import 'package:flutter/material.dart';

class RoundedInputField extends StatelessWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final bool isNumber;
  final validator;
  final controller;
  const RoundedInputField({
    Key key,
    this.text,
    this.onChanged,
    this.isNumber = false,
    this.validator,
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
          child: Column(
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
                keyboardType: isNumber ? TextInputType.number : TextInputType.text,
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
                controller: controller,
              ),
            ]
          ),
        )
      ]
    );
  }
}