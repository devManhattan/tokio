import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color background = Color(0xFF16171B);
  static const Color surface = Color(0xFF26272C);
  static const Color surfaceLight = Color(0xFF303136);
  static const Color border = Color(0xFF3A3B42);

  static const Color primary = Color(0xFF15B2A6);
  static const Color primaryDark = Color(0xFF0E8A80);
  static const Color accent = Color(0xFFBFD63A);

  static const Color textPrimary = Color(0xFFF4F5F7);
  static const Color textSecondary = Color(0xFF9B9CA3);
  static const Color danger = Color(0xFFE25749);
  static const Color badge = Color(0xFFE8337D);

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, accent],
  );
}
