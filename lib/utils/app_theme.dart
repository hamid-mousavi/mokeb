 import 'package:flutter/material.dart';

ThemeData buildDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFF121212), // پس‌زمینه
    fontFamily: 'Vazirmatn',
    textTheme:const TextTheme(
      
    ),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: Color(0xFF9C27B0), // بنفش تم
      secondary: Color(0xFFA084DC), // بنفش روشن‌تر
    ),
    cardColor: const Color(0xFF1E1E1E),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}
