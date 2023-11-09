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
      headerLarge: font.copyWith(),
      headerMedium: font.copyWith(),
      headerSmall: font.copyWith(),
      cardTitle: font.copyWith(),
      paragraph: bodyFont(),
      paragraphMedium: bodyFont(),
      bold: bodyFont(),
      hyperlink: bodyFont(),
      buttonText: bodyFont(),
    );
  }

  AppTextStyle({required this.headerLarge, required this.headerMedium, required this.headerSmall, required this.cardTitle, required this.paragraph, required this.paragraphMedium, required this.bold, required this.hyperlink, required this.buttonText});
}
