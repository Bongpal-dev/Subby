import 'package:flutter/material.dart';

abstract class AppColors {
  // Light Mode
  static const AppColorScheme light = _LightColors();

  // Dark Mode
  static const AppColorScheme dark = _DarkColors();
}

abstract class AppColorScheme {
  const AppColorScheme();

  // 메인 컬러
  Color get primary;
  Color get secondary;

  // 배경
  Color get background;
  Color get surface;

  // 텍스트
  Color get textPrimary;
  Color get textSecondary;
  Color get textTertiary;

  // 상태
  Color get error;
  Color get success;
  Color get warning;

  // UI 요소
  Color get border;
  Color get divider;
  Color get disabled;
  Color get selectedBg;
  Color get overlay;
}

class _LightColors extends AppColorScheme {
  const _LightColors();

  // 메인 컬러
  final Color primary = const Color(0xFF5DADEC);
  final Color secondary = const Color(0xFFFFD93D);

  // 배경
  final Color background = const Color(0xFFF5F9FC);
  final Color surface = const Color(0xFFFFFFFF);

  // 텍스트
  final Color textPrimary = const Color(0xFF2D3436);
  final Color textSecondary = const Color(0xFF636E72);
  final Color textTertiary = const Color(0xFF9E9E9E);

  // 상태
  final Color error = const Color(0xFFE74C3C);
  final Color success = const Color(0xFF27AE60);
  final Color warning = const Color(0xFFFF9800);

  // UI 요소
  final Color border = const Color(0xFFE0E0E0);
  final Color divider = const Color(0xFFEEEEEE);
  final Color disabled = const Color(0xFFBDBDBD);
  final Color selectedBg = const Color(0x1A5DADEC); // primary 10%
  final Color overlay = const Color(0x52000000); // black 32%
}

class _DarkColors extends AppColorScheme {
  const _DarkColors();

  // 메인 컬러
  final Color primary = const Color(0xFF5DADEC);
  final Color secondary = const Color(0xFFFFD93D);

  // 배경
  final Color background = const Color(0xFF1A1A2E);
  final Color surface = const Color(0xFF25253D);

  // 텍스트
  final Color textPrimary = const Color(0xFFFFFFFF);
  final Color textSecondary = const Color(0xFFA0A0A0);
  final Color textTertiary = const Color(0xFF707070);

  // 상태
  final Color error = const Color(0xFFFF6B6B);
  final Color success = const Color(0xFF6BCB77);
  final Color warning = const Color(0xFFFFB74D);

  // UI 요소
  final Color border = const Color(0xFF3D3D5C);
  final Color divider = const Color(0xFF2D2D4A);
  final Color disabled = const Color(0xFF505050);
  final Color selectedBg = const Color(0x335DADEC); // primary 20%
  final Color overlay = const Color(0x7A000000); // black 48%
}
