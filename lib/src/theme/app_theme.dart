import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF2E7D32); 
  static const accent  = Color(0xFF00BFA6);
  static const warning = Color(0xFFF9A825);
  static const paper   = Color(0xFFF5F7F5);
}

class AppTheme {
  static ThemeData get light => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.paper,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static ThemeData get dark => ThemeData.dark(useMaterial3: true).copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: Brightness.dark),
  );
}
