import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_typography.dart';

abstract class AppTheme {
  static ThemeData get light {
    final colors = AppColors.light;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: AppTypography.fontFamily,
      colorScheme: ColorScheme.light(
        primary: colors.primary,
        secondary: colors.secondary,
        surface: colors.surface,
        error: colors.error,
        onPrimary: Colors.white,
        onSecondary: colors.textPrimary,
        onSurface: colors.textPrimary,
        onError: Colors.white,
        outline: colors.border,
      ),
      scaffoldBackgroundColor: colors.background,
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: colors.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        hintStyle: AppTypography.bodySmall.copyWith(color: colors.textTertiary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(color: colors.textPrimary),
        displaySmall: AppTypography.displaySmall.copyWith(color: colors.textPrimary),
        headlineLarge: AppTypography.headlineLarge.copyWith(color: colors.textPrimary),
        headlineSmall: AppTypography.headlineSmall.copyWith(color: colors.textPrimary),
        titleLarge: AppTypography.titleLarge.copyWith(color: colors.textPrimary),
        titleSmall: AppTypography.titleSmall.copyWith(color: colors.textPrimary),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: colors.textPrimary),
        bodySmall: AppTypography.bodySmall.copyWith(color: colors.textSecondary),
        labelLarge: AppTypography.labelLarge.copyWith(color: colors.textPrimary),
        labelSmall: AppTypography.labelSmall.copyWith(color: colors.textSecondary),
      ),
      listTileTheme: ListTileThemeData(
        textColor: colors.textPrimary,
        iconColor: colors.textSecondary,
      ),
    );
  }

  static ThemeData get dark {
    final colors = AppColors.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: AppTypography.fontFamily,
      colorScheme: ColorScheme.dark(
        primary: colors.primary,
        secondary: colors.secondary,
        surface: colors.surface,
        error: colors.error,
        onPrimary: Colors.white,
        onSecondary: colors.textPrimary,
        onSurface: colors.textPrimary,
        onError: Colors.white,
        outline: colors.border,
      ),
      scaffoldBackgroundColor: colors.background,
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: colors.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        hintStyle: AppTypography.bodySmall.copyWith(color: colors.textTertiary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(color: colors.textPrimary),
        displaySmall: AppTypography.displaySmall.copyWith(color: colors.textPrimary),
        headlineLarge: AppTypography.headlineLarge.copyWith(color: colors.textPrimary),
        headlineSmall: AppTypography.headlineSmall.copyWith(color: colors.textPrimary),
        titleLarge: AppTypography.titleLarge.copyWith(color: colors.textPrimary),
        titleSmall: AppTypography.titleSmall.copyWith(color: colors.textPrimary),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: colors.textPrimary),
        bodySmall: AppTypography.bodySmall.copyWith(color: colors.textSecondary),
        labelLarge: AppTypography.labelLarge.copyWith(color: colors.textPrimary),
        labelSmall: AppTypography.labelSmall.copyWith(color: colors.textSecondary),
      ),
      listTileTheme: ListTileThemeData(
        textColor: colors.textPrimary,
        iconColor: colors.textSecondary,
      ),
    );
  }
}
