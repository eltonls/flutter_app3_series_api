import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyThemeModel extends ChangeNotifier {
  bool _isDark = false;
  late MyTheme _myTheme;

  MyThemeModel() {
    _myTheme = MyTheme(color: const Color(0xff8716d5));
  }

  bool get isDark => _isDark;
  ThemeData get customTheme => _myTheme.customTheme;
  ThemeData get customThemeDark => _myTheme.customThemeDark;
  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  void updateThemeColor(Color newColor) {
    _myTheme = MyTheme(color: newColor);
    notifyListeners();
  }
}

class MyTheme {
  final Color color;

  late final ColorScheme colorScheme;
  late final ColorScheme colorSchemeDark;
  late final ThemeData customTheme;
  late final ThemeData customThemeDark;

  MyTheme({required this.color}) {
    _initializeThemes();
  }

  void _initializeThemes() {
    colorScheme = ColorScheme.fromSeed(
      seedColor: color,
      brightness: Brightness.light,
    );

    colorSchemeDark = ColorScheme.fromSeed(
      seedColor: color,
      brightness: Brightness.dark,
    );

    customTheme = _buildLightTheme();
    customThemeDark = _buildDarkTheme();
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      colorScheme: colorScheme,
      fontFamily: GoogleFonts.lato().fontFamily,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        toolbarHeight: 100,
        backgroundColor: colorScheme.primary,
        titleTextStyle: GoogleFonts.lobster(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: colorScheme.onPrimary,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onPrimary,
          size: 36,
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.secondaryContainer,
        shadowColor: colorScheme.onSurface,
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      colorScheme: colorSchemeDark,
      fontFamily: GoogleFonts.lato().fontFamily,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        toolbarHeight: 100,
        backgroundColor: colorSchemeDark.surface,
        titleTextStyle: GoogleFonts.lobster(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: colorSchemeDark.onSurface,
        ),
        iconTheme: IconThemeData(
          color: colorSchemeDark.onSurface,
          size: 36,
        ),
      ),
      cardTheme: CardThemeData(
        color: colorSchemeDark.secondaryContainer,
        shadowColor: colorSchemeDark.onSurface,
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}