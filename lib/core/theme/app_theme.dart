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
        primary: colors.bgAccent,
        secondary: colors.bgAccentSubtle,
        surface: colors.bgSecondary,
        error: colors.statusError,
        onPrimary: colors.textOnAccent,
        onSecondary: colors.textPrimary,
        onSurface: colors.textPrimary,
        onError: Colors.white,
        outline: colors.borderPrimary,
      ),
      scaffoldBackgroundColor: colors.bgPrimary,
      dividerTheme: DividerThemeData(
        color: colors.borderSecondary,
        thickness: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.bgPrimary,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.headline.copyWith(
          color: colors.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.bgSecondary,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.bgAccent,
        foregroundColor: colors.iconOnAccent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.bgSecondary,
        hintStyle: AppTypography.body.copyWith(color: colors.textTertiary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.borderPrimary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.borderPrimary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.bgAccent, width: 2),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.display.copyWith(color: colors.textPrimary),
        displaySmall: AppTypography.display.copyWith(color: colors.textPrimary),
        headlineLarge: AppTypography.headline.copyWith(color: colors.textPrimary),
        headlineSmall: AppTypography.headline.copyWith(color: colors.textPrimary),
        titleLarge: AppTypography.title.copyWith(color: colors.textPrimary),
        titleSmall: AppTypography.title.copyWith(color: colors.textPrimary),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: colors.textPrimary),
        bodySmall: AppTypography.body.copyWith(color: colors.textSecondary),
        labelLarge: AppTypography.label.copyWith(color: colors.textPrimary),
        labelSmall: AppTypography.label.copyWith(color: colors.textSecondary),
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
        primary: colors.bgAccent,
        secondary: colors.bgAccentSubtle,
        surface: colors.bgSecondary,
        error: colors.statusError,
        onPrimary: colors.textOnAccent,
        onSecondary: colors.textPrimary,
        onSurface: colors.textPrimary,
        onError: Colors.white,
        outline: colors.borderPrimary,
      ),
      scaffoldBackgroundColor: colors.bgPrimary,
      dividerTheme: DividerThemeData(
        color: colors.borderSecondary,
        thickness: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.bgPrimary,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.headline.copyWith(
          color: colors.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.bgSecondary,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.bgAccent,
        foregroundColor: colors.iconOnAccent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.bgSecondary,
        hintStyle: AppTypography.body.copyWith(color: colors.textTertiary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.borderPrimary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.borderPrimary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.bgAccent, width: 2),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.display.copyWith(color: colors.textPrimary),
        displaySmall: AppTypography.display.copyWith(color: colors.textPrimary),
        headlineLarge: AppTypography.headline.copyWith(color: colors.textPrimary),
        headlineSmall: AppTypography.headline.copyWith(color: colors.textPrimary),
        titleLarge: AppTypography.title.copyWith(color: colors.textPrimary),
        titleSmall: AppTypography.title.copyWith(color: colors.textPrimary),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: colors.textPrimary),
        bodySmall: AppTypography.body.copyWith(color: colors.textSecondary),
        labelLarge: AppTypography.label.copyWith(color: colors.textPrimary),
        labelSmall: AppTypography.label.copyWith(color: colors.textSecondary),
      ),
      listTileTheme: ListTileThemeData(
        textColor: colors.textPrimary,
        iconColor: colors.textSecondary,
      ),
    );
  }
}
