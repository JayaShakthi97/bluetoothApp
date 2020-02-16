import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:polthen_pahana_app/pages/connectPage.dart';
import 'package:polthen_pahana_app/pages/mainPage/mainPage.dart';

class RouteUtil {
  static void connectPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ConnectPage(),
      ),
    );
  }

  static void mainPage(BuildContext context, BluetoothDevice device) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage(device: device),
      ),
    );
  }
}
