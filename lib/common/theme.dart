import 'package:drink_reminder/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeChangeNotifier with ChangeNotifier {
  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: MyColor.primaryColor,
      splashColor: MyColor.blueAccentColor,
      scaffoldBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(
        secondary: MyColor.blackColor,
      ),
      textTheme: GoogleFonts.nunitoTextTheme(ThemeData.light().textTheme),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: MyColor.primaryColor,
      bottomAppBarColor: Colors.white,
      splashColor: MyColor.blueAccentColor,
      scaffoldBackgroundColor: const Color(0xFF2A0944),
      backgroundColor: const Color(0xFF2A0944),
      colorScheme: const ColorScheme.dark(
        secondary: Colors.white,
      ),
      textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme),
    );
  }

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  void setTheme(bool value) {
    _isDarkTheme = value;
    notifyListeners();
  }
}
