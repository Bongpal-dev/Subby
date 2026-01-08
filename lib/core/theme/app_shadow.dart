import 'package:flutter/material.dart';

/// 그림자 상수 (Material Design 3 elevation 기준)
abstract class AppShadow {
  // Light mode
  static const BoxShadow soft = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 3,
    offset: Offset(0, 1),
  );

  static const BoxShadow medium = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 6,
    offset: Offset(0, 2),
  );

  static const BoxShadow strong = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 12,
    offset: Offset(0, 4),
  );

  // Dark mode
  static const BoxShadow softDark = BoxShadow(
    color: Color(0x40000000),
    blurRadius: 3,
    offset: Offset(0, 1),
  );

  static const BoxShadow mediumDark = BoxShadow(
    color: Color(0x40000000),
    blurRadius: 6,
    offset: Offset(0, 2),
  );

  static const BoxShadow strongDark = BoxShadow(
    color: Color(0x40000000),
    blurRadius: 12,
    offset: Offset(0, 4),
  );
}
