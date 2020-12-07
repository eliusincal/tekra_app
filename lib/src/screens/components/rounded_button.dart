import 'package:flutter/material.dart';

class RoudedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color;
  final Color textColor;
  final Color borderColor;
  final bool withBorder;
  const RoudedButton(
      {Key key,
      this.text,
      this.press,
      this.color = Colors.blueAccent,
      this.borderColor = Colors.blueAccent,
      this.withBorder = false,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.7,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          decoration: withBorder ? BoxDecoration(
              border: Border.all(
            width: 2,
            color: borderColor,
          )) : BoxDecoration(
              border: Border.all(
            width: 0,
          )),
          child: FlatButton(
            padding: EdgeInsets.symmetric( vertical: withBorder? 15  : 17, horizontal: 40),
            color: color,
            onPressed: press,
            child: Text(
              text,
              style: TextStyle(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
