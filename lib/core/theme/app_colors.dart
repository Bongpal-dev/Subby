import 'package:flutter/material.dart';

/// Subby 앱 전용 색상 시스템
/// Material 3 ColorScheme 기반이지만 래핑하여 관리
@immutable
class SubbyColor {
  const SubbyColor({
    // Primary
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    // Secondary
    required this.secondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    // Surface
    required this.surface,
    required this.onSurface,
    required this.surfaceContainer,
    required this.surfaceContainerHighest,
    required this.onSurfaceVariant,
    // Outline
    required this.outline,
    required this.outlineVariant,
    // Status
    required this.error,
    required this.onError,
    required this.warning,
    required this.success,
  });

  // === Primary ===
  /// #BFFF00 - FAB, CTA, 진행바, 토글 ON, 선택된 Chip
  final Color primary;

  /// #1A1A1A - primary 위 텍스트/아이콘
  final Color onPrimary;

  /// Light:#1A1A1A, Dark:#2A2A2A - Primary 버튼 배경
  final Color primaryContainer;

  /// #FFFFFF - primaryContainer 위 텍스트
  final Color onPrimaryContainer;

  // === Secondary ===
  /// Light:#6B7280, Dark:#9CA3AF - 보조 텍스트, 비활성 아이콘
  final Color secondary;

  /// Light:#E5E7EB, Dark:#333333 - 비활성 Chip 배경
  final Color secondaryContainer;

  /// Light:#6B7280, Dark:#9CA3AF - 비활성 Chip 텍스트
  final Color onSecondaryContainer;

  // === Surface ===
  /// Light:#F0F1F3, Dark:#121212 - 앱 전체 배경 (Scaffold)
  final Color surface;

  /// Light:#1A1A1A, Dark:#F1F5F9 - 주 텍스트
  final Color onSurface;

  /// Light:#FFFFFF, Dark:#1E1E1E - 카드, 시트, 다이얼로그 배경
  final Color surfaceContainer;

  /// Light:#E5E7EB, Dark:#333333 - 입력필드 배경, 토글 OFF 배경
  final Color surfaceContainerHighest;

  /// Light:#6B7280, Dark:#9CA3AF - 보조 텍스트, 아이콘
  final Color onSurfaceVariant;

  // === Outline ===
  /// Light:#D1D5DB, Dark:#444444 - 입력필드 보더, Outline 버튼 보더
  final Color outline;

  /// Light:#E5E7EB, Dark:#333333 - 연한 구분선, 비활성 Chip 보더
  final Color outlineVariant;

  // === Status ===
  /// Light:#EF4444, Dark:#F87171 - 에러, 삭제
  final Color error;

  /// Light:#FFFFFF, Dark:#1A1A1A - error 위 텍스트
  final Color onError;

  /// Light:#F97316, Dark:#FB923C - 결제 임박 경고
  final Color warning;

  /// Light:#3B82F6, Dark:#60A5FA - 성공, 링크
  final Color success;

  // === Light Theme ===
  static const light = SubbyColor(
    // Primary
    primary: Color(0xFFBFFF00),
    onPrimary: Color(0xFF1A1A1A),
    primaryContainer: Color(0xFF1A1A1A),
    onPrimaryContainer: Color(0xFFFFFFFF),
    // Secondary
    secondary: Color(0xFF6B7280),
    secondaryContainer: Color(0xFFE5E7EB),
    onSecondaryContainer: Color(0xFF6B7280),
    // Surface
    surface: Color(0xFFF0F1F3),
    onSurface: Color(0xFF1A1A1A),
    surfaceContainer: Color(0xFFFFFFFF),
    surfaceContainerHighest: Color(0xFFE5E7EB),
    onSurfaceVariant: Color(0xFF6B7280),
    // Outline
    outline: Color(0xFFD1D5DB),
    outlineVariant: Color(0xFFE5E7EB),
    // Status
    error: Color(0xFFEF4444),
    onError: Color(0xFFFFFFFF),
    warning: Color(0xFFF97316),
    success: Color(0xFF3B82F6),
  );

  // === Dark Theme ===
  static const dark = SubbyColor(
    // Primary
    primary: Color(0xFFBFFF00),
    onPrimary: Color(0xFF1A1A1A),
    primaryContainer: Color(0xFF2A2A2A),
    onPrimaryContainer: Color(0xFFFFFFFF),
    // Secondary
    secondary: Color(0xFF9CA3AF),
    secondaryContainer: Color(0xFF333333),
    onSecondaryContainer: Color(0xFF9CA3AF),
    // Surface
    surface: Color(0xFF121212),
    onSurface: Color(0xFFF1F5F9),
    surfaceContainer: Color(0xFF1E1E1E),
    surfaceContainerHighest: Color(0xFF333333),
    onSurfaceVariant: Color(0xFF9CA3AF),
    // Outline
    outline: Color(0xFF444444),
    outlineVariant: Color(0xFF333333),
    // Status
    error: Color(0xFFF87171),
    onError: Color(0xFF1A1A1A),
    warning: Color(0xFFFB923C),
    success: Color(0xFF60A5FA),
  );
}

/// context.subbyColor로 현재 테마 색상에 접근
extension SubbyColorExtension on BuildContext {
  SubbyColor get subbyColor {
    final isDark = Theme.of(this).brightness == Brightness.dark;
    return isDark ? SubbyColor.dark : SubbyColor.light;
  }
}
