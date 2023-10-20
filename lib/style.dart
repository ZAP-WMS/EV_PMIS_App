import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color blue = const Color.fromARGB(255, 9, 83, 161);
Color lightblue = Colors.blue;
Color white = Colors.white;
Color black = Colors.black;
Color grey = Colors.grey;
Color red = Colors.red;
Color yellow = Colors.yellow;

TextStyle headline = GoogleFonts.ibmPlexSans(
    fontSize: 12, fontWeight: FontWeight.w400, color: black);

TextStyle headlineBold = GoogleFonts.ibmPlexSans(
    fontSize: 18, fontWeight: FontWeight.w600, color: black);

TextStyle logoheadline = GoogleFonts.ibmPlexSans(
    fontSize: 35, fontWeight: FontWeight.w600, color: black);

TextStyle button = GoogleFonts.ibmPlexSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25,
    color: white);

TextStyle subtitleWhite = GoogleFonts.ibmPlexSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    color: blue);

TextStyle tableheader = const TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 12,
);

TextStyle tableheadersubtitle =
    TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: red);

TextStyle tableheaderwhitecolor =
    TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: white);

TextStyle tablefontsize = const TextStyle(fontSize: 12, color: Colors.black);

EdgeInsets tablepadding =
    const EdgeInsets.symmetric(horizontal: 5, vertical: 14);

TextStyle normaltext = GoogleFonts.ibmPlexSans(
  fontWeight: FontWeight.w600,
  letterSpacing: 0.5,
  fontSize: 16,
);

TextStyle normalboldtext = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

TextStyle buttonWhite = GoogleFonts.ibmPlexSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25,
    color: black);

TextStyle subtitle1White = GoogleFonts.ibmPlexSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    color: black);
