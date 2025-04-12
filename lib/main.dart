import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mokeb/screens/home_screen.dart';
import 'package:mokeb/utils/app_theme.dart';

void main() {
  runApp(MokebApp());
}

class MokebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   
    return MaterialApp(
      title: 'Mokeb App',
       theme: buildDarkTheme(),
      home: Directionality(textDirection: TextDirection.rtl,
      child: HomeScreen()),
      debugShowCheckedModeBanner: false,
    );
  }
}

