import 'package:flutter/material.dart';

/// AppTheme defines the color palette, typography, and component themes
/// for the Toko_Ku e-commerce marketplace application.
class AppTheme {
  // Primary & Accent Colors
  static const Color primaryColor = Color(0xFFFF4B26); // Coral / Orange accent
  static const Color primaryDark = Color(0xFFE03A16);
  static const Color primaryLight = Color(0xFFFFECE8); // Soft coral pill background

  // Backgrounds & Neutrals
  static const Color scaffoldBackground = Color(0xFFFAFAFC);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color surfaceGrey = Color(0xFFF3F4F6); // Grey component background
  static const Color surfaceGreyLight = Color(0xFFF8F9FA);
  static const Color dividerColor = Color(0xFFE5E7EB);

  // Typography Colors
  static const Color textPrimary = Color(0xFF111418); // Dark navy / black
  static const Color textSecondary = Color(0xFF6B7280); // Muted grey
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textLight = Color(0xFFFFFFFF);

  // Status & Utility Colors
  static const Color bottomNavBackground = Color(0xFF12141A); // Dark capsule navigation
  static const Color ratingStar = Color(0xFFFFB800);
  static const Color discountBadge = Color(0xFFFF4B26);
  static const Color discountBadgeBackground = Color(0xFFFFECE8);
  static const Color inStockGreen = Color(0xFF10B981);

  // Application ThemeData
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: scaffoldBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        surface: cardBackground,
        brightness: Brightness.light,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFF0F0F2), width: 1),
        ),
      ),
    );
  }
}
