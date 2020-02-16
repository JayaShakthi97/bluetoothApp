import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:polthen_pahana_app/widgets/CustomBodyContainer.dart';

class MainPage extends StatefulWidget {
  final BluetoothDevice device;

  const MainPage({Key key, @required this.device}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  BluetoothConnection _bluetoothConnection;
  bool _connecting = true;

  @override
  void initState() {
    super.initState();
    _establishConnection();
  }

  void _establishConnection() {
    BluetoothConnection.toAddress(widget.device.address).then((con) {
      setState(() {
        _bluetoothConnection = con;
        _connecting = false;
      });
    }).catchError((err) {
      print(err.toString());
    });
  }

  void _sendMessage(String text) async {
    if (text.length > 0) {
      try {
        _bluetoothConnection.output.add(utf8.encode(text + "\r\n"));
        await _bluetoothConnection.output.allSent;
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBodyContainer(
        child: Container(
          child: Column(
            children: <Widget>[
              Center(
                child: Text(widget.device.name),
              ),
              RaisedButton(
                  child: Text(_connecting ? "Connecting" : "Send Message"),
                  onPressed: _connecting
                      ? null
                      : () {
                          _sendMessage("Hello");
                        })
            ],
          ),
        ),
      ),
    );
  }
}
