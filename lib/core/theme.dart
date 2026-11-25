import 'package:flutter/material.dart';

class AppColors {
  static const bg = Color(0xFFEFF5D0); // hijau lime pucet (background)
  static const primary = Color(0xFFA9C23F); // hijau lime (cardnya)
  static const accent = Color(0xFF7F9B0B); // hijau tua (teks)
  static const dark = Color(0xFF1C0A0A); // coklat gelap (buttonya)
  static const yellow = Color(0xFFFFD36B);
}

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
  );
}
