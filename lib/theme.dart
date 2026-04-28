import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF000000);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF131B2E);
  static const Color onPrimaryContainer = Color(0xFF7C839B);
  static const Color primaryFixed = Color(0xFFDAE2FD);
  static const Color primaryFixedDim = Color(0xFFBEC6E0);
  static const Color onPrimaryFixed = Color(0xFF131B2E);
  static const Color onPrimaryFixedVariant = Color(0xFF3F465C);

  static const Color secondary = Color(0xFF515F74);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFD5E3FD);
  static const Color onSecondaryContainer = Color(0xFF57657B);
  static const Color secondaryFixed = Color(0xFFD5E3FD);
  static const Color secondaryFixedDim = Color(0xFFB9C7E0);
  static const Color onSecondaryFixed = Color(0xFF0D1C2F);
  static const Color onSecondaryFixedVariant = Color(0xFF3A485C);

  static const Color tertiary = Color(0xFF000000);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF001E2F);
  static const Color onTertiaryContainer = Color(0xFF008CC7);
  static const Color tertiaryFixed = Color(0xFFC9E6FF);
  static const Color tertiaryFixedDim = Color(0xFF89CEFF);
  static const Color onTertiaryFixed = Color(0xFF001E2F);
  static const Color onTertiaryFixedVariant = Color(0xFF004C6E);

  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  static const Color background = Color(0xFFF7F9FB);
  static const Color onBackground = Color(0xFF191C1E);
  
  static const Color surface = Color(0xFFF7F9FB);
  static const Color onSurface = Color(0xFF191C1E);
  static const Color surfaceVariant = Color(0xFFE0E3E5);
  static const Color onSurfaceVariant = Color(0xFF45464D);
  static const Color surfaceBright = Color(0xFFF7F9FB);
  static const Color surfaceDim = Color(0xFFD8DADC);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F4F6);
  static const Color surfaceContainer = Color(0xFFECEEF0);
  static const Color surfaceContainerHigh = Color(0xFFE6E8EA);
  static const Color surfaceContainerHighest = Color(0xFFE0E3E5);
  static const Color surfaceTint = Color(0xFF565E74);
  
  static const Color inverseSurface = Color(0xFF2D3133);
  static const Color inverseOnSurface = Color(0xFFEFF1F3);
  static const Color inversePrimary = Color(0xFFBEC6E0);
  
  static const Color outline = Color(0xFF76777D);
  static const Color outlineVariant = Color(0xFFC6C6CD);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiary,
        onTertiary: onTertiary,
        tertiaryContainer: tertiaryContainer,
        onTertiaryContainer: onTertiaryContainer,
        error: error,
        onError: onError,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
        surface: surface,
        onSurface: onSurface,
        surfaceContainerLowest: surfaceContainerLowest,
        surfaceContainerLow: surfaceContainerLow,
        surfaceContainer: surfaceContainer,
        surfaceContainerHigh: surfaceContainerHigh,
        surfaceContainerHighest: surfaceContainerHighest,
        outline: outline,
        outlineVariant: outlineVariant,
        inverseSurface: inverseSurface,
        onInverseSurface: inverseOnSurface,
        inversePrimary: inversePrimary,
        surfaceTint: surfaceTint,
      ),
      scaffoldBackgroundColor: background,
      textTheme: TextTheme(
        // displayLg
        displayLarge: GoogleFonts.publicSans(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          height: 38 / 30,
          letterSpacing: -0.02,
          color: onSurface,
        ),
        // headlineMd
        headlineMedium: GoogleFonts.publicSans(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 28 / 20,
          color: onSurface,
        ),
        // bodyBase -> bodyMedium
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 20 / 14,
          color: onSurface,
        ),
        // bodySm -> bodySmall
        bodySmall: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          height: 18 / 13,
          color: onSurfaceVariant,
        ),
        // labelCaps -> labelSmall
        labelSmall: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          height: 12 / 11,
          letterSpacing: 0.05,
          color: onSurfaceVariant,
        ),
        // tableData -> titleSmall
        titleSmall: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          height: 16 / 13,
          letterSpacing: 0.01,
          color: onSurface,
        ),
      ),
    );
  }

  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFF6DA5FF); // Bright blue accent
  static const Color darkOnPrimary = Color(0xFF002B5E);
  static const Color darkPrimaryContainer = Color(0xFF00418A);
  static const Color darkOnPrimaryContainer = Color(0xFFD5E3FD);

  static const Color darkSecondary = Color(0xFFB9C7E0);
  static const Color darkOnSecondary = Color(0xFF233144);
  static const Color darkSecondaryContainer = Color(0xFF3A485C);
  static const Color darkOnSecondaryContainer = Color(0xFFD5E3FD);

  static const Color darkTertiary = Color(0xFF6DCCFF);
  static const Color darkOnTertiary = Color(0xFF00344F);
  static const Color darkTertiaryContainer = Color(0xFF004C6E);
  static const Color darkOnTertiaryContainer = Color(0xFFC9E6FF);

  static const Color darkError = Color(0xFFFFB4AB);
  static const Color darkOnError = Color(0xFF690005);
  static const Color darkErrorContainer = Color(0xFF93000A);
  static const Color darkOnErrorContainer = Color(0xFFFFDAD6);

  static const Color darkSurface = Color(0xFF10131A); // Deep slate background
  static const Color darkOnSurface = Color(0xFFE2E2E6);
  static const Color darkSurfaceContainerLowest = Color(0xFF0B0E14);
  static const Color darkSurfaceContainerLow = Color(0xFF161922);
  static const Color darkSurfaceContainer = Color(0xFF1D2028);
  static const Color darkSurfaceContainerHigh = Color(0xFF282B34);
  static const Color darkOutline = Color(0xFF8D919A);
  static const Color darkOutlineVariant = Color(0xFF434750);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimary,
        onPrimary: darkOnPrimary,
        primaryContainer: darkPrimaryContainer,
        onPrimaryContainer: darkOnPrimaryContainer,
        secondary: darkSecondary,
        onSecondary: darkOnSecondary,
        secondaryContainer: darkSecondaryContainer,
        onSecondaryContainer: darkOnSecondaryContainer,
        tertiary: darkTertiary,
        onTertiary: darkOnTertiary,
        tertiaryContainer: darkTertiaryContainer,
        onTertiaryContainer: darkOnTertiaryContainer,
        error: darkError,
        onError: darkOnError,
        errorContainer: darkErrorContainer,
        onErrorContainer: darkOnErrorContainer,
        surface: darkSurface,
        onSurface: darkOnSurface,
        surfaceContainerLowest: darkSurfaceContainerLowest,
        surfaceContainerLow: darkSurfaceContainerLow,
        surfaceContainer: darkSurfaceContainer,
        surfaceContainerHigh: darkSurfaceContainerHigh,
        surfaceContainerHighest: darkSurfaceContainerHigh, // fallback
        outline: darkOutline,
        outlineVariant: darkOutlineVariant,
      ),
      scaffoldBackgroundColor: darkSurface,
      cardTheme: CardThemeData(
        color: darkSurfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: darkOutlineVariant, width: 1),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.publicSans(
          fontSize: 30, fontWeight: FontWeight.w700, letterSpacing: -0.02, color: darkOnSurface, height: 38 / 30,
        ),
        headlineMedium: GoogleFonts.publicSans(
          fontSize: 20, fontWeight: FontWeight.w600, height: 28 / 20, color: darkOnSurface,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w400, height: 20 / 14, color: darkOnSurface,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 13, fontWeight: FontWeight.w400, height: 18 / 13, color: const Color(0xFFB0B3B8),
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.05, height: 12 / 11, color: const Color(0xFFB0B3B8),
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.01, height: 16 / 13, color: darkOnSurface,
        ),
      ),
    );
  }
}
