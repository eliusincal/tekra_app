import 'package:flutter/material.dart';

class MessageContextText extends StatelessWidget {
  const MessageContextText({
    Key key,
    this.text,
    this.textaction,
    this.ontap,
    @required this.size,
  }) : super(key: key);

  final Size size;
  final String text;
  final String textaction;
  final ontap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
        Container(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11.00,
              color: Color(0xff555555),
            ),
          ),
        ),
        GestureDetector(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal:20),
            padding: EdgeInsets.symmetric(horizontal:20, vertical:5),
            width: size.width * 0.85,
            child:  Align(
              alignment: Alignment.center,
              child: Container(
                child:Text(
                  textaction,
                  style: TextStyle(
                    fontSize: 11.00,
                    color: Color(0xff051228),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ),
          onTap: ontap,
        ),
      ] 
    );
  }
}