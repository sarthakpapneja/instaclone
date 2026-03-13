import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Colors.black;
  static const Color secondaryColor = Colors.white;
  static const Color greyColor = Color(0xFF262626);
  static const Color lightGreyColor = Color(0xFFFAFAFA);
  static const Color softGreyColor = Color(0xFF8E8E8E);
  static const Color activeBlue = Color(0xFF0095F6);

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: primaryColor,
    primaryColor: primaryColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      iconTheme: IconThemeData(color: secondaryColor),
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    iconTheme: const IconThemeData(color: secondaryColor),
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: Color(0xFF121212),
    ),
  );

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: secondaryColor,
    primaryColor: secondaryColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: secondaryColor,
      elevation: 0.5,
      iconTheme: IconThemeData(color: primaryColor),
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
    iconTheme: const IconThemeData(color: primaryColor),
    colorScheme: const ColorScheme.light(
      primary: secondaryColor,
      secondary: primaryColor,
      surface: lightGreyColor,
    ),
  );
}
