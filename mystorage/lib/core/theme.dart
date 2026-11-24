import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _cream = Color(0xFFF7F3EE);
  static const _warmWhite = Color(0xFFFFFBF7);
  static const _brown = Color(0xFF8B7355);
  static const _darkBrown = Color(0xFF2C2416);
  static const _warmGrey = Color(0xFF9B8E7E);
  static const _border = Color(0xFFE8E0D5);
  static const _lightBorder = Color(0xFFF0EAE0);

  static TextTheme get _textTheme => TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          color: _darkBrown, fontWeight: FontWeight.w700, letterSpacing: -1),
        displayMedium: GoogleFonts.playfairDisplay(
          color: _darkBrown, fontWeight: FontWeight.w700),
        headlineLarge: GoogleFonts.playfairDisplay(
          color: _darkBrown, fontSize: 32, fontWeight: FontWeight.w700, height: 1.1),
        headlineMedium: GoogleFonts.playfairDisplay(
          color: _darkBrown, fontSize: 24, fontWeight: FontWeight.w700, height: 1.2),
        headlineSmall: GoogleFonts.playfairDisplay(
          color: _darkBrown, fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.cormorant(
          color: _darkBrown, fontSize: 17, fontWeight: FontWeight.w600, letterSpacing: 0.3),
        titleMedium: GoogleFonts.inter(
          color: _darkBrown, fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.2),
        titleSmall: GoogleFonts.inter(
          color: _darkBrown, fontSize: 13, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.inter(color: _darkBrown, fontSize: 14, height: 1.6),
        bodyMedium: GoogleFonts.inter(color: _warmGrey, fontSize: 13, height: 1.5),
        labelLarge: GoogleFonts.inter(
          color: _darkBrown, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.5),
        labelSmall: GoogleFonts.inter(
          color: _warmGrey, fontSize: 11, letterSpacing: 1),
      );

  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: _cream,
        colorScheme: const ColorScheme.light(
          primary: _brown,
          onPrimary: _warmWhite,
          secondary: _warmGrey,
          surface: _warmWhite,
          onSurface: _darkBrown,
          outline: _border,
        ),
        useMaterial3: true,
        textTheme: _textTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: _cream,
          foregroundColor: _darkBrown,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.cormorant(
            color: _darkBrown,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
          ),
          iconTheme: const IconThemeData(color: _darkBrown),
          surfaceTintColor: Colors.transparent,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: _warmWhite,
          indicatorColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return GoogleFonts.inter(
                  color: _darkBrown, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5);
            }
            return GoogleFonts.inter(color: _warmGrey, fontSize: 10, letterSpacing: 0.5);
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: _darkBrown, size: 22);
            }
            return const IconThemeData(color: _warmGrey, size: 22);
          }),
        ),
        cardTheme: CardThemeData(
          color: _warmWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
            side: const BorderSide(color: _lightBorder),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: _warmWhite,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: _border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: _border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: _brown, width: 1.5),
          ),
          labelStyle: GoogleFonts.inter(color: _warmGrey, fontSize: 13, letterSpacing: 0.3),
          hintStyle: GoogleFonts.inter(color: _warmGrey, fontSize: 13),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: _brown,
            foregroundColor: _warmWhite,
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            textStyle: GoogleFonts.inter(
                fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 2),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: _darkBrown,
            side: const BorderSide(color: _darkBrown),
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 2),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: _warmGrey,
            textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.3),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: _brown,
          foregroundColor: _warmWhite,
          elevation: 0,
          shape: CircleBorder(),
        ),
        dividerTheme: const DividerThemeData(color: _border, thickness: 1),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: _darkBrown,
          contentTextStyle: GoogleFonts.inter(color: _warmWhite, fontSize: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          behavior: SnackBarBehavior.floating,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(color: _brown),
        iconTheme: const IconThemeData(color: _darkBrown),
        chipTheme: ChipThemeData(
          backgroundColor: _lightBorder,
          selectedColor: _brown,
          side: const BorderSide(color: _border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          labelStyle: GoogleFonts.inter(fontSize: 12, color: _darkBrown),
        ),
      );
}
