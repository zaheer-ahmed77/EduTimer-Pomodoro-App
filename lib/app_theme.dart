import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryLightBlue = Color.fromARGB(255, 162, 212, 241);
  static const Color primaryOffWhite = Color(0xFFEEEAE6);
  static const Color primaryDarkText = Color(0xFF5A5A5A);
  static const Color primaryLightText = Color(0xFFAAAAAA);
}

final appTheme = ThemeData(
  fontFamily: GoogleFonts.nunito().fontFamily,

  primaryColor: AppColors.primaryOffWhite,

  scaffoldBackgroundColor: AppColors.primaryLightBlue,

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primaryOffWhite,
    elevation: 2,
    shadowColor: Colors.black26,
    titleTextStyle: TextStyle(
      color: AppColors.primaryDarkText,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: AppColors.primaryDarkText),
  ),

  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: AppColors.primaryDarkText, fontSize: 16),
    headlineLarge: TextStyle(
      color: AppColors.primaryDarkText,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      color: AppColors.primaryDarkText,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(color: AppColors.primaryDarkText),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromRGBO(6, 130, 202, 1),
      foregroundColor: const Color.fromRGBO(247, 246, 246, 1),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 5,
      textStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: GoogleFonts.nunito().fontFamily,
      ),
    ),
  ),

  cardTheme: CardThemeData(
    color: AppColors.primaryOffWhite,
    elevation: 2,
    shadowColor: Colors.black26,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.primaryOffWhite,
    hintStyle: const TextStyle(color: AppColors.primaryLightText),
    labelStyle: const TextStyle(color: AppColors.primaryDarkText),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(15),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.primaryDarkText, width: 2),
      borderRadius: BorderRadius.circular(15),
    ),
  ),

  iconTheme: const IconThemeData(color: AppColors.primaryDarkText),
);
