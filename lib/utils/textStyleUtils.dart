import 'package:flutter/material.dart';

class TextStyleUtil {
  static final TextStyle splashTextStyle = TextStyle(
    fontSize: 60,
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.italic,
    shadows: [
      Shadow(
        blurRadius: 10.0,
        color: Colors.orange,
        offset: Offset(5.0, 5.0),
      ),
    ],
  );
}
