import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

enum FontFamily { poppins, pacifico }

TextStyle appstyle(double size, Color color, FontWeight fw,
    {double? letterSpacing, FontFamily? fontFamily}) {
  switch (fontFamily) {
    case FontFamily.poppins:
      return GoogleFonts.poppins(
        fontSize: size.sp,
        color: color,
        fontWeight: fw,
        letterSpacing: letterSpacing,
      );
    case FontFamily.pacifico:
      return GoogleFonts.pacifico(
        fontSize: size.sp,
        color: color,
        fontWeight: fw,
        letterSpacing: letterSpacing,
      );
    default:
      return GoogleFonts.poppins(
        fontSize: size.sp,
        color: color,
        fontWeight: fw,
        letterSpacing: letterSpacing,
      );
  }
}
