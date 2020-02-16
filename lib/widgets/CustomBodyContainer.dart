import 'package:flutter/material.dart';

class CustomBodyContainer extends StatelessWidget {
  final Widget child;
  final Color color;

  const CustomBodyContainer({Key key, @required this.child, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: this.child,
          ),
        ),
      ),
    );
  }
}
