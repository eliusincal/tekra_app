import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardOptions extends StatelessWidget {
  const CardOptions({
    this.title,
    this.route,
    this.codeTypeBill
  });

  final String title;
  final route;
  final codeTypeBill;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString("invoiceTitle", title);
        sharedPreferences.setString("code_type_bill", codeTypeBill);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => route));
      },
      child: Container(
        height: 200,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          child: CustomListItem(
            title: title,
          ),
        ),
      ),
    );
  }
}

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
              child: Image.asset(
                'assets/images/icons/document@3x.png',
                fit: BoxFit.none,
                scale: 2.5,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff051228),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
