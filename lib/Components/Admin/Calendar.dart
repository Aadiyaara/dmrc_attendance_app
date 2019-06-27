import 'package:flutter/material.dart';
import 'dart:async';

class Calendar extends StatefulWidget {

  final String supervisorId;
  Calendar({Key key, this.supervisorId}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

  DateTime _date = DateTime.now();

  Future<Null> _selectDate () async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2016),
        lastDate: DateTime(2099)
    );
    List data = [];
    data.add(widget.supervisorId);
    data.add(picked.toString().split(' ')[0]);
    Navigator.pushNamed(context, '/attendance', arguments: data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: RaisedButton(
            child: Text('Select Date'),
            onPressed: () {
              _selectDate();
            }
          ),
        ),
      ),
    );
  }

}
