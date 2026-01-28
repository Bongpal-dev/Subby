import 'package:flutter/material.dart';

/// Figma 디자인 시스템 라운딩 토큰
abstract class AppRadius {
  static const double none = 0;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double full = 9999;

  // BorderRadius helpers
  static BorderRadius get noneAll => BorderRadius.zero;
  static BorderRadius get smAll => BorderRadius.circular(sm);
  static BorderRadius get mdAll => BorderRadius.circular(md);
  static BorderRadius get lgAll => BorderRadius.circular(lg);
  static BorderRadius get xlAll => BorderRadius.circular(xl);
  static BorderRadius get fullAll => BorderRadius.circular(full);

  // Top only
  static BorderRadius get smTop => const BorderRadius.vertical(top: Radius.circular(sm));
  static BorderRadius get mdTop => const BorderRadius.vertical(top: Radius.circular(md));
  static BorderRadius get lgTop => const BorderRadius.vertical(top: Radius.circular(lg));
  static BorderRadius get xlTop => const BorderRadius.vertical(top: Radius.circular(xl));
}
