import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weatherly/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme => _buildTheme(Brightness.light);
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final baseTheme = brightness == Brightness.light
        ? ThemeData.light(useMaterial3: true)
        : ThemeData.dark(useMaterial3: true);

    final isLight = brightness == Brightness.light;
    final textPrimary = isLight
        ? AppColors.textPrimaryLight
        : AppColors.textPrimary;
    final textSecondary = isLight
        ? AppColors.textSecondaryLight
        : AppColors.textSecondary;
    final cardBackground = isLight
        ? AppColors.cardBackgroundLight
        : AppColors.cardBackground;
    final cardBorder = isLight
        ? AppColors.cardBorderLight
        : AppColors.cardBorder;
    final scaffoldBackground = isLight
        ? AppColors.scaffoldBackgroundLight
        : AppColors.scaffoldBackgroundDark;

    return baseTheme.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: brightness,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
      ),
      scaffoldBackgroundColor: scaffoldBackground,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
      ),
      textTheme: GoogleFonts.outfitTextTheme(
        baseTheme.textTheme,
      ).apply(bodyColor: textPrimary, displayColor: textPrimary),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 2,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          side: BorderSide(color: cardBorder, width: 1),
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
      ),
      iconTheme: IconThemeData(color: textPrimary),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBackground,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        hintStyle: TextStyle(color: textSecondary),
        prefixIconColor: textSecondary,
        suffixIconColor: textSecondary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shadowColor: Colors.black26,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }
}
