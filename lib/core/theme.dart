import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SkyTheme {
  static const Color primaryGold = Color(0xFFE5A93C);
  static const Color backgroundDark = Color(0xFF0D0D0D);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textSecondary = Color(0xFFA0A0A0);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryGold,
      scaffoldBackgroundColor: backgroundDark,
      cardColor: surfaceDark,
      textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleMedium: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        bodyMedium: const TextStyle(color: textSecondary),
      ),
      colorScheme: const ColorScheme.dark(
        primary: primaryGold,
        secondary: primaryGold,
        surface: surfaceDark,
      ),
      useMaterial3: true,
      chipTheme: ChipThemeData(
        backgroundColor: surfaceDark,
        selectedColor: primaryGold,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        labelStyle: const TextStyle(fontSize: 16),
        secondaryLabelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: BorderSide.none,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGold,
          foregroundColor: Colors.black,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
