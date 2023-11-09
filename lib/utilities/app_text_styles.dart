import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  final TextStyle headerLarge;
  final TextStyle headerMedium;
  final TextStyle headerSmall;

  final TextStyle cardTitle;

  final TextStyle paragraph;
  final TextStyle paragraphMedium;
  final TextStyle bold;

  final TextStyle hyperlink;
  final TextStyle buttonText;

  factory AppTextStyle.init() {
    var bodyFont = GoogleFonts.montserrat;
    var font = const TextStyle(fontFamily: "Verdana");

    return AppTextStyle(
      headerLarge: font.copyWith(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        height: 1.224,
        letterSpacing: 0,
      ),
      headerMedium: font.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 0,
      ),
      headerSmall: font.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 0,
      ),
      cardTitle: font.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 0,
      ),
      paragraph: bodyFont(
        fontSize: 12,
        letterSpacing: 0,
      ),
      paragraphMedium: bodyFont(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
      bold: bodyFont(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 0,
      ),
      hyperlink: bodyFont(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
      buttonText: bodyFont(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
    );
  }

  AppTextStyle(
      {required this.headerLarge,
      required this.headerMedium,
      required this.headerSmall,
      required this.cardTitle,
      required this.paragraph,
      required this.paragraphMedium,
      required this.bold,
      required this.hyperlink,
      required this.buttonText});
}
