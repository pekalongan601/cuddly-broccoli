import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/layout.dart';

/// Centralised theme data factory for SeaScape Banking.
abstract final class AppTheme {
  AppTheme._();

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final bool dark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: dark ? const Color(0xFF121212) : AppColors.background,
      splashFactory: InkRipple.splashFactory,
      dividerColor: dark ? Colors.white12 : AppColors.line,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.orange,
        brightness: brightness,
        primary: AppColors.orange,
        surface: dark ? const Color(0xFF1C1C1E) : AppColors.white,
      ),

      // ── AppBar ──────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),

      // ── Input fields ────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? const Color(0xFF29292D) : const Color(0xFFF5F6F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Layout.fieldRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Layout.fieldRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Layout.fieldRadius),
          borderSide: const BorderSide(color: AppColors.orange, width: 1.5),
        ),
      ),
    );
  }
}
