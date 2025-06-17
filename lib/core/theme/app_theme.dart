import 'package:flutter/material.dart';

class AppTheme {
  // Design tokens - Exact Figma design system
  static const _primaryYellow =
      Color(0xFFD8DF20); // Bright lime yellow from Figma
  static const _secondaryYellow = Color(0xFFD8DF20); // Secondary yellow
  static const _accentYellow = Color(0xFFD8DF20); // Light yellow for highlights
  static const _primaryBlack = Color(0xFF1A1A1A); // Primary black text
  static const _secondaryGray = Color(0xFF666666); // Secondary gray text
  static const _lightGray = Color(0xFFE0E0E0); // Light gray for borders
  static const _backgroundWhite =
      Color(0xFFFAFAFA); // Slightly off-white background
  static const _cardWhite = Color(0xFFFFFFFF); // Pure white for cards
  static const _errorColor = Color(0xFFE53E3E);

  // Typography from Figma - Using system fonts
  static const String _fallbackFont = 'SF Pro Display'; // iOS system font

  // Spacing system (8px base) - matching Figma design
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;
  static const double spacing64 = 64.0;
  static const double spacing2xl = 80.0;

  // Additional spacing values referenced in the codebase
  static const double spacingXs = 2.0;
  static const double spacingSm = 6.0;
  static const double spacingMd = 10.0;
  static const double spacingLg = 14.0;
  static const double spacingXl = 18.0;
  static const double spacing3xl = 24.0;
  static const double spacing4xl = 32.0;

  // Border radius system - matching Figma design
  static const double radius4 = 4.0;
  static const double radius8 = 8.0;
  static const double radius12 = 12.0;
  static const double radius16 = 16.0;
  static const double radius20 = 20.0;
  static const double radius24 = 24.0;
  static const double radiusFull = 999.0;
  static const double radiusLg = 20.0; // Figma uses larger radius

  // Additional radius values referenced in the codebase
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusXl = 28.0;
  static const double radius2xl = 36.0;

  // Elevation system
  static const double elevation0 = 0.0;
  static const double elevation2 = 2.0;
  static const double elevation4 = 4.0;
  static const double elevation8 = 8.0;
  static const double elevation16 = 16.0;

  // Additional elevation values
  static const double elevationSm = 1.0;
  static const double elevationMd = 6.0;

  // Additional properties matching Figma design
  static const Gradient primaryGradient = LinearGradient(
    colors: [_primaryYellow, _secondaryYellow],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static List<BoxShadow> get cardShadow => [
        const BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.08),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ];

  static ThemeData get lightTheme {
    const colorScheme = ColorScheme.light(
      brightness: Brightness.light,
      primary: _primaryYellow,
      onPrimary: _primaryBlack,
      secondary: _secondaryYellow,
      onSecondary: _primaryBlack,
      tertiary: _accentYellow,
      onTertiary: _primaryBlack,
      error: _errorColor,
      onError: Colors.white,
      surface: _backgroundWhite,
      onSurface: _primaryBlack,
      surfaceContainerHighest: _cardWhite,
      onSurfaceVariant: _secondaryGray,
      outline: _lightGray,
      shadow: _primaryBlack,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: _fallbackFont,

      // App Bar Theme - Figma style header
      appBarTheme: const AppBarTheme(
        elevation: elevation0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: _primaryBlack,
        titleTextStyle: TextStyle(
          fontFamily: _fallbackFont,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: _primaryBlack,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(
          color: _primaryBlack,
          size: 24,
        ),
      ),

      // Card Theme - Figma style cards with proper shadows
      cardTheme: CardTheme(
        elevation: elevation0, // Custom shadow instead
        color: _cardWhite,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
        shadowColor: Colors.transparent,
        margin: EdgeInsets.zero,
      ),

      // Elevated Button Theme - Figma yellow buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: elevation0,
          backgroundColor: _primaryYellow,
          foregroundColor: _primaryBlack,
          disabledBackgroundColor: _lightGray,
          disabledForegroundColor: _secondaryGray,
          padding: const EdgeInsets.symmetric(
            horizontal: spacing24,
            vertical: spacing16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLg),
          ),
          textStyle: const TextStyle(
            fontFamily: _fallbackFont,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryBlack,
          padding: const EdgeInsets.symmetric(
            horizontal: spacing20,
            vertical: spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius12),
          ),
          textStyle: const TextStyle(
            fontFamily: _fallbackFont,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.2,
          ),
        ),
      ),

      // Input Decoration Theme - Figma style inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _cardWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius16),
          borderSide: BorderSide(color: _lightGray, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius16),
          borderSide: BorderSide(color: _lightGray, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius16),
          borderSide: BorderSide(color: _primaryYellow, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius16),
          borderSide: BorderSide(color: _errorColor, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacing20,
          vertical: spacing16,
        ),
        hintStyle: const TextStyle(
          fontFamily: _fallbackFont,
          color: _secondaryGray,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Bottom Navigation Bar Theme - Figma style
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: elevation0,
        backgroundColor: _primaryYellow,
        selectedItemColor: _primaryBlack,
        unselectedItemColor: _secondaryGray,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontFamily: _fallbackFont,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: _fallbackFont,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Typography - Matching Figma design system
      textTheme: const TextTheme(
        // Large Display Text
        displayLarge: TextStyle(
          fontFamily: _fallbackFont,
          fontSize: 36,
          fontWeight: FontWeight.w800,
          color: _primaryBlack,
          height: 1.1,
          letterSpacing: -1.0,
        ),
        displayMedium: TextStyle(
          fontFamily: _fallbackFont,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: _primaryBlack,
          height: 1.2,
          letterSpacing: -0.8,
        ),
        displaySmall: TextStyle(
          fontFamily: _fallbackFont,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: _primaryBlack,
          height: 1.2,
          letterSpacing: -0.6,
        ),

        // Headlines
        headlineLarge: TextStyle(
          fontFamily: _fallbackFont,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: _primaryBlack,
          height: 1.3,
          letterSpacing: -0.4,
        ),
        headlineMedium: TextStyle(
          fontFamily: _fallbackFont,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _primaryBlack,
          height: 1.3,
          letterSpacing: -0.3,
        ),
        headlineSmall: TextStyle(
          fontFamily: _fallbackFont,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _primaryBlack,
          height: 1.4,
          letterSpacing: -0.2,
        ),

        // Titles
        titleLarge: TextStyle(
          fontFamily: _fallbackFont,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _primaryBlack,
          height: 1.4,
          letterSpacing: -0.2,
        ),
        titleMedium: TextStyle(
          fontFamily: _fallbackFont,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: _primaryBlack,
          height: 1.4,
          letterSpacing: -0.1,
        ),
        titleSmall: TextStyle(
          fontFamily: _fallbackFont,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _primaryBlack,
          height: 1.4,
        ),

        // Body Text
        bodyLarge: TextStyle(
          fontFamily: _fallbackFont,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: _primaryBlack,
          height: 1.5,
          letterSpacing: -0.1,
        ),
        bodyMedium: TextStyle(
          fontFamily: _fallbackFont,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _primaryBlack,
          height: 1.5,
          letterSpacing: -0.1,
        ),
        bodySmall: TextStyle(
          fontFamily: _fallbackFont,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: _secondaryGray,
          height: 1.5,
        ),

        // Labels
        labelLarge: TextStyle(
          fontFamily: _fallbackFont,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _primaryBlack,
          height: 1.4,
          letterSpacing: -0.1,
        ),
        labelMedium: TextStyle(
          fontFamily: _fallbackFont,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _secondaryGray,
          height: 1.4,
        ),
        labelSmall: TextStyle(
          fontFamily: _fallbackFont,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: _secondaryGray,
          height: 1.4,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
      brightness: Brightness.dark,
      primary: _primaryYellow,
      onPrimary: _primaryBlack,
      secondary: _secondaryYellow,
      onSecondary: _primaryBlack,
      tertiary: _accentYellow,
      onTertiary: _primaryBlack,
      error: _errorColor,
      onError: Colors.white,
      surface: Color(0xFF121212),
      onSurface: Colors.white,
      surfaceContainerHighest: Color(0xFF1E1E1E),
      onSurfaceVariant: Color(0xFFB0B0B0),
      outline: Color(0xFF424242),
      shadow: Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: _fallbackFont,
      // Dark theme implementation would go here
    );
  }

  // Utility methods for consistent styling
  static BoxShadow get softShadow => const BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.04),
        blurRadius: 8,
        offset: Offset(0, 2),
      );

  static BoxShadow get mediumShadow => const BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.08),
        blurRadius: 16,
        offset: Offset(0, 4),
      );

  static BoxShadow get strongShadow => const BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.12),
        blurRadius: 24,
        offset: Offset(0, 8),
      );

  // Color constants for easy access
  static const Color primaryYellow = _primaryYellow;
  static const Color secondaryYellow = _secondaryYellow;
  static const Color accentYellow = _accentYellow;
  static const Color primaryBlack = _primaryBlack;
  static const Color secondaryGray = _secondaryGray;
  static const Color lightGray = _lightGray;
  static const Color backgroundWhite = _backgroundWhite;
  static const Color cardWhite = _cardWhite;

  // Legacy AppStyles compatibility constants
  static const Color yellow = _primaryYellow;
  static const Color primaryColor = _backgroundWhite;
  static const Color secondaryColor = _primaryYellow;
  static const Color textField = _cardWhite;
  static const double paddingMain = spacing16;
  static const double borderRadius = radius12;
  static const double pictureLength = 40.0;

  // Legacy text styles
  static const TextStyle textStyleSoFoSans = TextStyle(
    fontFamily: _fallbackFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: _primaryBlack,
    letterSpacing: -0.1,
  );
}
