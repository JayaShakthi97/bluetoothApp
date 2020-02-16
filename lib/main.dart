import 'package:flutter/material.dart';
import 'package:polthen_pahana_app/pages/splashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        canvasColor: Colors.orange,
        primarySwatch: Colors.brown,
      ),
      home: SplashScreen(),
    );
  }
}
