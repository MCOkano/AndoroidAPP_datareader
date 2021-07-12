import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert' as convert;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'NextPage.dart';

void main() {
  initializeDateFormatting('ja');
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  var titleText = 'cookapp';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  String _date = "";
  String _kind = "";
  String rcvres = '';

  String _text = '';

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('登録確認'),
          centerTitle: true,
        ),
        body: new Center(
          child: new Column(
            children: <Widget>[
              new Container(
                child: new MaterialButton(
                  onPressed: scan,
                  child: new Text("日付入力"),
                  color: Colors.blue,
                ),
                padding: const EdgeInsets.all(8.0),
              ),
              new Row(children: <Widget>[
                new Text("　検索日付： "),
                new Text(_date),
              ]),
              new Container(
                child: new MaterialButton(
                  onPressed: send,
                  child: new Text("検索"),
                  color: Colors.blue,
                ),
                padding: const EdgeInsets.all(8.0),
              ),
            ],
          ),
        ));
  }

  Future scan() async {
    _selectDate(context);
  }

  Future<void> send() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return NextPage(date: _date, kind: _kind);
        },
      ),
    ).then((value) {
      setState(() {
        _date = "";
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2022),
    );
    if (selected != null) {
      setState(() {
        _date = (DateFormat('yyyy-MM-dd')).format(selected);
      });
    }
  }

}
