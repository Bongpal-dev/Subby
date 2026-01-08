import 'package:flutter/material.dart';

/// 나눔스퀘어 네오 폰트 기반 타이포그래피
abstract class AppTypography {
  static const String fontFamily = 'NanumSquareNeo';

  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // ============================================
  // Display - 큰 숫자, 금액
  // ============================================
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: extraBold,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: extraBold,
  );

  // ============================================
  // Headline - 페이지 제목
  // ============================================
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: bold,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: bold,
  );

  // ============================================
  // Title - 카드/리스트 제목
  // ============================================
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: bold,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: bold,
  );

  // ============================================
  // Body - 본문
  // ============================================
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: regular,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: regular,
  );

  // ============================================
  // Label - 버튼, 라벨
  // ============================================
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: bold,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: bold,
  );

  // ============================================
  // Caption - 보조 텍스트
  // ============================================
  static const TextStyle captionLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: regular,
  );

  static const TextStyle captionSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: regular,
  );
}
