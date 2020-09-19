import 'package:aprenda_ingles/screens/Home.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: Home(),
  theme: ThemeData(
    primaryColor: Color(0xff795548),
    accentColor: Colors.white,
    scaffoldBackgroundColor: Color(0xfff5e9b9),
  ),
));
