import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_typography.dart';

abstract class AppTheme {
  static ThemeData get light {
    const colors = SubbyColor.light;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: AppTypography.fontFamily,
      colorScheme: ColorScheme.light(
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        primaryContainer: colors.primaryContainer,
        onPrimaryContainer: colors.onPrimaryContainer,
        secondary: colors.secondary,
        secondaryContainer: colors.secondaryContainer,
        onSecondaryContainer: colors.onSecondaryContainer,
        surface: colors.surfaceContainer,
        onSurface: colors.onSurface,
        surfaceContainerHighest: colors.surfaceContainerHighest,
        onSurfaceVariant: colors.onSurfaceVariant,
        outline: colors.outline,
        outlineVariant: colors.outlineVariant,
        error: colors.error,
        onError: colors.onError,
      ),
      scaffoldBackgroundColor: colors.surface,
      dividerTheme: DividerThemeData(
        color: colors.outlineVariant,
        thickness: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.headline.copyWith(
          color: colors.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.surfaceContainer,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceContainerHighest,
        hintStyle: AppTypography.body.copyWith(color: colors.onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.display.copyWith(color: colors.onSurface),
        displaySmall: AppTypography.display.copyWith(color: colors.onSurface),
        headlineLarge: AppTypography.headline.copyWith(color: colors.onSurface),
        headlineSmall: AppTypography.headline.copyWith(color: colors.onSurface),
        titleLarge: AppTypography.title.copyWith(color: colors.onSurface),
        titleSmall: AppTypography.title.copyWith(color: colors.onSurface),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: colors.onSurface),
        bodySmall: AppTypography.body.copyWith(color: colors.onSurfaceVariant),
        labelLarge: AppTypography.label.copyWith(color: colors.onSurface),
        labelSmall: AppTypography.label.copyWith(color: colors.onSurfaceVariant),
      ),
      listTileTheme: ListTileThemeData(
        textColor: colors.onSurface,
        iconColor: colors.onSurfaceVariant,
      ),
    );
  }

  static ThemeData get dark {
    const colors = SubbyColor.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: AppTypography.fontFamily,
      colorScheme: ColorScheme.dark(
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        primaryContainer: colors.primaryContainer,
        onPrimaryContainer: colors.onPrimaryContainer,
        secondary: colors.secondary,
        secondaryContainer: colors.secondaryContainer,
        onSecondaryContainer: colors.onSecondaryContainer,
        surface: colors.surfaceContainer,
        onSurface: colors.onSurface,
        surfaceContainerHighest: colors.surfaceContainerHighest,
        onSurfaceVariant: colors.onSurfaceVariant,
        outline: colors.outline,
        outlineVariant: colors.outlineVariant,
        error: colors.error,
        onError: colors.onError,
      ),
      scaffoldBackgroundColor: colors.surface,
      dividerTheme: DividerThemeData(
        color: colors.outlineVariant,
        thickness: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.headline.copyWith(
          color: colors.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.surfaceContainer,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceContainerHighest,
        hintStyle: AppTypography.body.copyWith(color: colors.onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.display.copyWith(color: colors.onSurface),
        displaySmall: AppTypography.display.copyWith(color: colors.onSurface),
        headlineLarge: AppTypography.headline.copyWith(color: colors.onSurface),
        headlineSmall: AppTypography.headline.copyWith(color: colors.onSurface),
        titleLarge: AppTypography.title.copyWith(color: colors.onSurface),
        titleSmall: AppTypography.title.copyWith(color: colors.onSurface),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: colors.onSurface),
        bodySmall: AppTypography.body.copyWith(color: colors.onSurfaceVariant),
        labelLarge: AppTypography.label.copyWith(color: colors.onSurface),
        labelSmall: AppTypography.label.copyWith(color: colors.onSurfaceVariant),
      ),
      listTileTheme: ListTileThemeData(
        textColor: colors.onSurface,
        iconColor: colors.onSurfaceVariant,
      ),
    );
  }
}
