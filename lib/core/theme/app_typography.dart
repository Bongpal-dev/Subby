import 'package:flutter/material.dart';

/// Figma 디자인 시스템 타이포그래피 (Wanted Sans)
abstract class AppTypography {
  static const String fontFamily = 'WantedSans';

  // Font Weights
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // ============================================
  // Display - 큰 숫자, 금액
  // ============================================
  static const TextStyle display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: bold,
    height: 44 / 36,
  );

  // ============================================
  // Headline - 페이지 제목
  // ============================================
  static const TextStyle headline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: bold,
    height: 32 / 24,
  );

  // ============================================
  // Title - 섹션 제목
  // ============================================
  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: semiBold,
    height: 26 / 18,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: medium,
    height: 26 / 18,
  );

  // ============================================
  // Body - 본문
  // ============================================
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: regular,
    height: 24 / 16,
  );

  static const TextStyle bodyLargeSemi = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: semiBold,
    height: 24 / 16,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: regular,
    height: 20 / 14,
  );

  static const TextStyle bodySemi = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: semiBold,
    height: 20 / 14,
  );

  // ============================================
  // Label - 버튼, 라벨
  // ============================================
  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: medium,
    height: 16 / 12,
  );

  static const TextStyle labelBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: bold,
    height: 16 / 12,
  );

  // ============================================
  // Caption - 보조 텍스트
  // ============================================
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: regular,
    height: 14 / 11,
  );
}
