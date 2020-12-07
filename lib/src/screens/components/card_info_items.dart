import 'package:flutter/material.dart';

class CardInfoItems extends StatelessWidget {
  const CardInfoItems(
      {Key key,
      @required this.size,
      this.items = 1,
      this.total = 200.00,
      })
      : super(key: key);

  final Size size;
  final items;
  final total;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        color: Color(0xfff051228),
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            width: size.width * 0.8,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Totales",
                    style: TextStyle(
                      color: Color(0xffbbbbbb),
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "$items items",
                            style: TextStyle(
                              color: Color(0xffbbbbbb),
                              fontSize: 20,
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "GTQ $total",
                            style: TextStyle(
                              color: Color(0xffbbbbbb),
                              fontSize: 25,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
