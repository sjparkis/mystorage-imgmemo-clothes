import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
  );
}
