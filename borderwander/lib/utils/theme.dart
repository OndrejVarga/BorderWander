import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MyTheme {
  ThemeData theme;

  static ThemeData getTheme(BuildContext context) {
    return ThemeData(
      backgroundColor: HexColor('182C25'),
      primaryColor: HexColor('2E7D32'),
      cardColor: HexColor('455B55'),
      accentColor: HexColor('00B349'),
      textTheme: TextTheme(
        headline1: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700),
        headline2: TextStyle(
          color: Colors.white,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400,
        ),
        headline3: TextStyle(
          color: Colors.white,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w300,
        ),
        headline4: TextStyle(
          color: Colors.white,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w200,
        ),
      ),
    );
  }
}
