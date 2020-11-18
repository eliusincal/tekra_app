import 'package:flutter/material.dart';
import 'package:tekra_app/src/screens/small_taxpayer_bill.dart';

class OptionsUser extends StatelessWidget{
  const OptionsUser({Key key}) : super(key:key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xfff7f7f7),
      body:Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal:15),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                CardOptions(),
                CardOptions(),
                CardOptions(),
                CardOptions(),
                CardOptions()
              ],
            ),
          ),
        )
      
    );
  }
}

class CardOptions extends StatelessWidget {
  const CardOptions({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { 
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context)=>SmallTaxpayerBill()
          )
        );
      },
      child: Container(
        height: 200,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          ),
          child: CustomListItem(
            user: 'Dash',
            viewCount: 884000,
            thumbnail: Image.asset('assets/images/icons/document@3x.png',
            fit: BoxFit.none,
            scale: 2.1,
            ),
            title: 'Nueva Factura Cambiaria Pequeño Contribuyente',
          ),
        ),
      ),
    );
  }
}

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    this.thumbnail,
    this.title,
    this.user,
    this.viewCount,
  });

  final Widget thumbnail;
  final String title;
  final String user;
  final int viewCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: thumbnail,
          ),
          Expanded(
            flex: 3,
            child: Container(  
              margin: EdgeInsets.symmetric(vertical: 15, horizontal:5),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 25,
                    color: Color(0xff051228),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}