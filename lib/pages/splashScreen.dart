import 'package:flutter/material.dart';
import 'package:polthen_pahana_app/utils/routeUtil.dart';
import 'package:polthen_pahana_app/utils/textStyleUtils.dart';
import 'package:polthen_pahana_app/widgets/CustomBodyContainer.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 2000))
        .then((_) => RouteUtil.connectPage(context));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBodyContainer(
        child: Container(
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "SIYOTH",
                    style: TextStyleUtil.splashTextStyle,
                  ),
                  Text(
                    "SARANIYA",
                    style: TextStyleUtil.splashTextStyle,
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
