import 'package:flutter/material.dart';

class RoundedDateInput extends StatefulWidget {
  final controller;
  const RoundedDateInput({Key key, this.controller}) : super(key: key);
  DateInput createState() => DateInput();
}

class DateInput extends State<RoundedDateInput> {
  String title = 'Date Picker';
  DateTime _date = DateTime.now();
  Future<Null> selectDate(BuildContext context) async {
    DateTime _datePicker = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(1947),
        lastDate: DateTime(2030));
    if (_datePicker != null && _datePicker != _date) {
      setState(() {
        _date = _datePicker;
      });
    }  
    setState(() {
      widget.controller.text = _date.toIso8601String().split('T').first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        child: Column(children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Fecha",
              style: TextStyle(color: Color(0xff051228), fontSize: 15.00),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (val){
              if(val.isEmpty){
                return("Dato necesario");
              }
              return null;
            },
            onChanged: (value) {
              print(value);
            },
            readOnly: true,
            onTap: () {
              setState(() {
                selectDate(context);
              });
            },
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.calendar_today),
              hintText: ("Fecha"),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Color(0xffa8e1f5), width: 2)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Color(0xffa8e1f5), width: 2)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Color(0xffa8e1f5), width: 2)),
              fillColor: Colors.white,
              filled: true,
            ),
            controller: widget.controller,
          ),
        ]),
      )
    ]);
  }
}
