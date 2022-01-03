import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class MyStyles {
  static final TextStyle heading = GoogleFonts.nunito(
      fontSize: 24, fontWeight: FontWeight.w700, color: MyColor.blackColor);

  static final TextStyle subHeading = GoogleFonts.nunito(
      fontSize: 16, fontWeight: FontWeight.w700, color: MyColor.blackColor);

  static final TextStyle extraLarge = GoogleFonts.nunito(
      fontSize: 48, fontWeight: FontWeight.w800, color: MyColor.blackColor);

  static final TextStyle body = GoogleFonts.nunito(
      fontSize: 14, fontWeight: FontWeight.w600, color: MyColor.blackColor);
}
