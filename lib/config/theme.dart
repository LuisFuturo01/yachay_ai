import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class YachayTheme {
  YachayTheme._();

  // ─── Andean Color Palette ───
  static const Color primaryPurple = Color(0xFF7C3AED);
  static const Color primaryPurpleLight = Color(0xFFA78BFA);
  static const Color primaryPurpleDark = Color(0xFF5B21B6);
  static const Color secondaryGold = Color(0xFFFBBF24);
  static const Color secondaryGoldLight = Color(0xFFFDE68A);
  static const Color accentTerracotta = Color(0xFFF97316);
  static const Color backgroundCream = Color(0xFFFFFBEB);
  static const Color backgroundWhite = Color(0xFFFFFDF9);
  static const Color successGreen = Color(0xFF10B981);
  static const Color successGreenLight = Color(0xFFD1FAE5);
  static const Color errorPink = Color(0xFFEF4444);
  static const Color errorPinkLight = Color(0xFFFEE2E2);
  static const Color warningOrange = Color(0xFFF97316);
  static const Color textDark = Color(0xFF1E1B4B);
  static const Color textMedium = Color(0xFF475569);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color surfacePurple = Color(0xFFEDE9FE);
  static const Color surfaceGold = Color(0xFFFEF3C7);

  // ─── Subject Colors ───
  static const Color mathColor = Color(0xFF7C3AED);
  static const Color scienceColor = Color(0xFF059669);
  static const Color socialColor = Color(0xFFDB2777);
  static const Color aymaraColor = Color(0xFFEA580C);

  // ─── Vibrant Subject Gradients ───
  static const LinearGradient mathGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B5CF6), Color(0xFF4C1D95)],
  );

  static const LinearGradient scienceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF064E3B)],
  );

  static const LinearGradient socialGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEC4899), Color(0xFF9D174D)],
  );

  static const LinearGradient aymaraGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF97316), Color(0xFF7C2D12)],
  );

  static const LinearGradient teacherGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0EA5E9), Color(0xFF1E3A8A)],
  );

  // ─── Gradients ───
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPurple, Color(0xFF6D28D9)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryGold, Color(0xFFF59E0B)],
  );

  // Kid-friendly backgrounds: Sky, clouds, rainbow accents
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE0F2FE), Color(0xFFFFFBEB)], // Light sky blue to amber cream
  );

  static const LinearGradient playfulBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFDDD6FE), Color(0xFFFEE2E2), Color(0xFFFFFBEB)], // Violet to rose to cream
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4C1D95), Color(0xFF7C3AED), Color(0xFF06B6D4)], // Deep purple to cyan
  );

  // ─── Shadows & 3D styling ───
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: primaryPurple.withValues(alpha: 0.15),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: primaryPurple.withValues(alpha: 0.1),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  // 3D Pressable Button style shadow (Duolingo style)
  static List<BoxShadow> getButton3DShadow(Color darkColor) => [
    BoxShadow(
      color: darkColor,
      offset: const Offset(0, 5),
    ),
  ];

  // ─── Border Radius ───
  static BorderRadius get radiusSmall => BorderRadius.circular(14);
  static BorderRadius get radiusMedium => BorderRadius.circular(22);
  static BorderRadius get radiusLarge => BorderRadius.circular(30);
  static BorderRadius get radiusXLarge => BorderRadius.circular(40);

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
          fontSize: 22,
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
          elevation: 0, // styled manually for 3D or flat
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
