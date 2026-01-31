import 'package:flutter/material.dart';

/// Figma 디자인 시스템 색상 토큰
abstract class AppColors {
  static const AppColorScheme light = _LightColors();
  static const AppColorScheme dark = _DarkColors();
}

/// context.colors로 현재 테마 색상에 접근
extension AppColorsExtension on BuildContext {
  AppColorScheme get colors {
    final isDark = Theme.of(this).brightness == Brightness.dark;
    return isDark ? AppColors.dark : AppColors.light;
  }
}

abstract class AppColorScheme {
  const AppColorScheme();

  // ============================================
  // Background
  // ============================================
  Color get bgPrimary;
  Color get bgSecondary;
  Color get bgTertiary;
  Color get bgAccent;
  Color get bgAccentSubtle;

  // ============================================
  // Text
  // ============================================
  Color get textPrimary;
  Color get textSecondary;
  Color get textTertiary;
  Color get textAccent;
  Color get textOnAccent;
  Color get textAccentSubtle;

  // ============================================
  // Border
  // ============================================
  Color get borderPrimary;
  Color get borderSecondary;
  Color get borderFocus;

  // ============================================
  // Icon
  // ============================================
  Color get iconPrimary;
  Color get iconSecondary;
  Color get iconAccent;
  Color get iconOnAccent;

  // ============================================
  // Button
  // ============================================
  Color get buttonPrimaryBg;
  Color get buttonPrimaryText;
  Color get buttonSecondaryBg;
  Color get buttonSecondaryText;
  Color get buttonDisableBg;
  Color get buttonDisableText;

  // ============================================
  // Tab
  // ============================================
  Color get tabSelectedBg;
  Color get tabSelectedText;
  Color get tabUnselectedBg;
  Color get tabUnselectedText;

  // ============================================
  // Status
  // ============================================
  Color get statusError;
  Color get statusSuccess;
  Color get statusWarning;
  Color get statusInfo;
}

class _LightColors extends AppColorScheme {
  const _LightColors();

  // Background
  @override
  Color get bgPrimary => const Color(0xFFF3F4F6);
  @override
  Color get bgSecondary => const Color(0xFFFFFFFF);
  @override
  Color get bgTertiary => const Color(0xFFFAFAFA);
  @override
  Color get bgAccent => const Color(0xFFBFFF00);
  @override
  Color get bgAccentSubtle => const Color(0xFFE8FFB3);

  // Text
  @override
  Color get textPrimary => const Color(0xFF1A1A1A);
  @override
  Color get textSecondary => const Color(0xFF6B7280);
  @override
  Color get textTertiary => const Color(0xFF9CA3AF);
  @override
  Color get textAccent => const Color(0xFFBFFF00);
  @override
  Color get textOnAccent => const Color(0xFF1A1A1A);
  @override
  Color get textAccentSubtle => const Color(0xFF1A1A1A);

  // Border
  @override
  Color get borderPrimary => const Color(0xFFD1D5DB);
  @override
  Color get borderSecondary => const Color(0xFFE5E7EB);
  @override
  Color get borderFocus => const Color(0xFFBFFF00);

  // Icon
  @override
  Color get iconPrimary => const Color(0xFF1A1A1A);
  @override
  Color get iconSecondary => const Color(0xFF6B7280);
  @override
  Color get iconAccent => const Color(0xFFBFFF00);
  @override
  Color get iconOnAccent => const Color(0xFF1A1A1A);

  // Button
  @override
  Color get buttonPrimaryBg => const Color(0xFF1A1A1A);
  @override
  Color get buttonPrimaryText => const Color(0xFFBFFF00);
  @override
  Color get buttonSecondaryBg => const Color(0xFFFFFFFF);
  @override
  Color get buttonSecondaryText => const Color(0xFF1A1A1A);
  @override
  Color get buttonDisableBg => const Color(0xFFE5E7EB);
  @override
  Color get buttonDisableText => const Color(0xFF9CA3AF);

  // Tab
  @override
  Color get tabSelectedBg => const Color(0xFFBFFF00);
  @override
  Color get tabSelectedText => const Color(0xFF1A1A1A);
  @override
  Color get tabUnselectedBg => const Color(0xFFFFFFFF);
  @override
  Color get tabUnselectedText => const Color(0xFF6B7280);

  // Status
  @override
  Color get statusError => const Color(0xFFEF4444);
  @override
  Color get statusSuccess => const Color(0xFF22C55E);
  @override
  Color get statusWarning => const Color(0xFFF59E0B);
  @override
  Color get statusInfo => const Color(0xFF3B82F6);
}

class _DarkColors extends AppColorScheme {
  const _DarkColors();

  // Background
  @override
  Color get bgPrimary => const Color(0xFF0A0A0A);
  @override
  Color get bgSecondary => const Color(0xFF111827);
  @override
  Color get bgTertiary => const Color(0xFF1F2937);
  @override
  Color get bgAccent => const Color(0xFFBFFF00);
  @override
  Color get bgAccentSubtle => const Color(0xFF1A2E00);

  // Text
  @override
  Color get textPrimary => const Color(0xFFFFFFFF);
  @override
  Color get textSecondary => const Color(0xFF9CA3AF);
  @override
  Color get textTertiary => const Color(0xFF6B7280);
  @override
  Color get textAccent => const Color(0xFFBFFF00);
  @override
  Color get textOnAccent => const Color(0xFF1A1A1A);
  @override
  Color get textAccentSubtle => const Color(0xFF1A1A1A);

  // Border
  @override
  Color get borderPrimary => const Color(0xFF374151);
  @override
  Color get borderSecondary => const Color(0xFF1F2937);
  @override
  Color get borderFocus => const Color(0xFFBFFF00);

  // Icon
  @override
  Color get iconPrimary => const Color(0xFFFFFFFF);
  @override
  Color get iconSecondary => const Color(0xFF9CA3AF);
  @override
  Color get iconAccent => const Color(0xFFBFFF00);
  @override
  Color get iconOnAccent => const Color(0xFF1A1A1A);

  // Button
  @override
  Color get buttonPrimaryBg => const Color(0xFFBFFF00);
  @override
  Color get buttonPrimaryText => const Color(0xFF1A1A1A);
  @override
  Color get buttonSecondaryBg => const Color(0xFF1F2937);
  @override
  Color get buttonSecondaryText => const Color(0xFFFFFFFF);
  @override
  Color get buttonDisableBg => const Color(0xFF1F2937);
  @override
  Color get buttonDisableText => const Color(0xFF4B5563);

  // Tab
  @override
  Color get tabSelectedBg => const Color(0xFFBFFF00);
  @override
  Color get tabSelectedText => const Color(0xFF1A1A1A);
  @override
  Color get tabUnselectedBg => const Color(0xFF1F2937);
  @override
  Color get tabUnselectedText => const Color(0xFF9CA3AF);

  // Status
  @override
  Color get statusError => const Color(0xFFF87171);
  @override
  Color get statusSuccess => const Color(0xFF4ADE80);
  @override
  Color get statusWarning => const Color(0xFFFBBF24);
  @override
  Color get statusInfo => const Color(0xFF60A5FA);
}
