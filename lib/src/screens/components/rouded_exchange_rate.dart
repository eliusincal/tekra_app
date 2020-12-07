import 'package:flutter/material.dart';

class RoudedExchangeRate extends StatelessWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final bool isNumber;
  final validator;
  final controller;
  final isLocked;
  const RoudedExchangeRate({
    Key key,
    this.text,
    this.onChanged,
    this.isNumber = false,
    this.validator,
    this.controller,
    this.isLocked = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children:<Widget>[
        Container(
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
                readOnly: isLocked,
                keyboardType: isNumber ? TextInputType.number : TextInputType.text,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: text,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: isLocked ? Colors.grey : Color(0xffa8e1f5), width: 2)
                  ),  
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: isLocked ? Colors.grey : Color(0xffa8e1f5), width: 2)
                  ), 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: isLocked ? Colors.grey : Color(0xffa8e1f5), width: 2)
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