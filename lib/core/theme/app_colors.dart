import 'package:flutter/material.dart';

abstract class AppColors {
  // Light Mode
  static const light = _LightColors();

  // Dark Mode
  static const dark = _DarkColors();
}

class _LightColors {
  const _LightColors();

  final Color primary = const Color(0xFF5DADEC);
  final Color secondary = const Color(0xFFFFD93D);
  final Color background = const Color(0xFFF5F9FC);
  final Color surface = const Color(0xFFFFFFFF);
  final Color textPrimary = const Color(0xFF2D3436);
  final Color textSecondary = const Color(0xFF636E72);
  final Color error = const Color(0xFFE74C3C);
  final Color success = const Color(0xFF27AE60);
}

class _DarkColors {
  const _DarkColors();

  final Color primary = const Color(0xFF5DADEC);
  final Color secondary = const Color(0xFFFFD93D);
  final Color background = const Color(0xFF1A1A2E);
  final Color surface = const Color(0xFF25253D);
  final Color textPrimary = const Color(0xFFFFFFFF);
  final Color textSecondary = const Color(0xFFA0A0A0);
  final Color error = const Color(0xFFFF6B6B);
  final Color success = const Color(0xFF6BCB77);
}
