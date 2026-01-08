import 'package:flutter/material.dart';

/// 라운딩 상수 (Material Design 3 기준)
abstract class AppRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 28;

  static BorderRadius get xsAll => BorderRadius.circular(xs);
  static BorderRadius get smAll => BorderRadius.circular(sm);
  static BorderRadius get mdAll => BorderRadius.circular(md);
  static BorderRadius get lgAll => BorderRadius.circular(lg);
  static BorderRadius get xlAll => BorderRadius.circular(xl);

  static BorderRadius get lgTop => const BorderRadius.vertical(
        top: Radius.circular(lg),
      );
  static BorderRadius get xlTop => const BorderRadius.vertical(
        top: Radius.circular(xl),
      );
}
