import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class YachayTheme {
  YachayTheme._();

  // ─── Andean Color Palette ───
  static const Color primaryPurple = Color(0xFF6B21A8);
  static const Color primaryPurpleLight = Color(0xFF9333EA);
  static const Color primaryPurpleDark = Color(0xFF4C1D95);
  static const Color secondaryGold = Color(0xFFF59E0B);
  static const Color secondaryGoldLight = Color(0xFFFBBF24);
  static const Color accentTerracotta = Color(0xFFDC5F00);
  static const Color backgroundCream = Color(0xFFFFF8F0);
  static const Color backgroundWhite = Color(0xFFFFFDF9);
  static const Color successGreen = Color(0xFF10B981);
  static const Color successGreenLight = Color(0xFFD1FAE5);
  static const Color errorPink = Color(0xFFF43F5E);
  static const Color errorPinkLight = Color(0xFFFFE4E6);
  static const Color warningOrange = Color(0xFFF97316);
  static const Color textDark = Color(0xFF1F1523);
  static const Color textMedium = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color surfacePurple = Color(0xFFF3E8FF);
  static const Color surfaceGold = Color(0xFFFEF3C7);

  // ─── Subject Colors ───
  static const Color mathColor = Color(0xFF7C3AED);
  static const Color scienceColor = Color(0xFF059669);
  static const Color socialColor = Color(0xFFDB2777);
  static const Color aymaraColor = Color(0xFFE67E22);

  // ─── Gradients ───
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPurple, primaryPurpleLight],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryGold, Color(0xFFFFD700)],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF3E8FF), backgroundCream],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPurpleDark, primaryPurple, primaryPurpleLight],
  );

  // ─── Shadows ───
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: primaryPurple.withValues(alpha: 0.10),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: primaryPurple.withValues(alpha: 0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  // ─── Border Radius ───
  static BorderRadius get radiusSmall => BorderRadius.circular(12);
  static BorderRadius get radiusMedium => BorderRadius.circular(20);
  static BorderRadius get radiusLarge => BorderRadius.circular(28);
  static BorderRadius get radiusXLarge => BorderRadius.circular(36);

  // ─── Theme Data ───
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPurple,
        primary: primaryPurple,
        secondary: secondaryGold,
        surface: backgroundCream,
        error: errorPink,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: backgroundCream,
      textTheme: _textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        iconTheme: const IconThemeData(color: textDark, size: 28),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: radiusMedium),
          textStyle: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          elevation: 4,
          shadowColor: primaryPurple.withValues(alpha: 0.3),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryPurple,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: radiusMedium),
          side: const BorderSide(color: primaryPurple, width: 2),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: radiusMedium,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radiusMedium,
          borderSide: BorderSide(color: surfacePurple, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radiusMedium,
          borderSide: const BorderSide(color: primaryPurple, width: 2),
        ),
        hintStyle: GoogleFonts.nunito(color: textLight, fontSize: 16),
        labelStyle: GoogleFonts.nunito(color: textMedium, fontSize: 16),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: radiusMedium),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryPurple,
        unselectedItemColor: textLight,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: GoogleFonts.nunito(fontSize: 12),
        elevation: 20,
      ),
    );
  }

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: GoogleFonts.outfit(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: textDark,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.outfit(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: textDark,
      ),
      headlineLarge: GoogleFonts.outfit(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: textDark,
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textDark,
      ),
      headlineSmall: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textDark,
      ),
      titleLarge: GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: textDark,
      ),
      titleMedium: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textDark,
      ),
      titleSmall: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textMedium,
      ),
      bodyLarge: GoogleFonts.nunito(
        fontSize: 16,
        color: textDark,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.nunito(
        fontSize: 14,
        color: textMedium,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.nunito(
        fontSize: 12,
        color: textLight,
      ),
      labelLarge: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      labelMedium: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
