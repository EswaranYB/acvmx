import 'package:flutter/material.dart';

import 'app_colors.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final double? letterSpacing;
  final int? maxLines;

  final TextOverflow? textOverflow;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final double? textScaleFactor;
  final List<Shadow>? shadows;
  final EdgeInsets? padding;
  final bool softWrap;

  const CustomText({
    super.key,
    this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.letterSpacing,
    this.maxLines,
    this.textOverflow,
    this.decoration,
    this.decorationColor,
    this.textScaleFactor,
    this.shadows,
    this.softWrap = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Text(text ?? '',
          softWrap: true,
          overflow:maxLines==null?TextOverflow.visible: textOverflow ?? TextOverflow.ellipsis,
          maxLines: maxLines,
          style: TextStyle(
            fontFamily: "Inter, Regular",
            fontStyle: FontStyle.normal,
            shadows: shadows,
            letterSpacing: letterSpacing,
            fontSize: fontSize ?? 14,
            fontWeight: fontWeight,
            decoration: decoration,
            decorationColor: decorationColor,
            color: color ?? AppColor.textColor000000,
          ),
          textAlign: textAlign),
    );
  }
}

class AppFontSize {
  static double s8 = 8;
  static double s9 = 9;
  static double s10 = 10;
  static double s11 = 11;
  static double s12 = 12;
  static double s13 = 13;
  static double s14 = 14;
  static double s15 = 15;
  static double s16 = 16;
  static double s17 = 17;
  static double s18 = 18;
  static double s19 = 19;
  static double s20 = 20;
  static double s21 = 21;
  static double s22 = 22;
  static double s24 = 24;
  static double s25 = 25;
  static double s26 = 26;
  static double s28 = 28;
  static double s30 = 30;
  static double s32 = 32;
  static double s34 = 34;
  static double s40 = 40;
  static double s35 = 35;
}

class AppFontWeight {
  static FontWeight w200 = FontWeight.w200;
  static FontWeight w300 = FontWeight.w300;
  static FontWeight w400 = FontWeight.w400;
  static FontWeight w500 = FontWeight.w500;
  static FontWeight w600 = FontWeight.w600;
  static FontWeight w700 = FontWeight.w700;
  static FontWeight w800 = FontWeight.w800;
  static FontWeight w900 = FontWeight.w900;
}

Text f12({
  String? text,
  Color? color,
  FontWeight? fontWeight,
  TextAlign? textAlign,
  double? letterSpacing,
  int? maxLines,
  TextOverflow? textOverflow,
  TextDecoration? decoration,
  Color? decorationColor,
  double? textScaleFactor,
  List<Shadow>? shadows,
  EdgeInsets? padding,
  bool softWrap = true,
}) {
  return Text(
    text ?? '',
    softWrap: true,
    overflow: textOverflow ?? TextOverflow.ellipsis,
    maxLines: maxLines ?? 4,
    style: TextStyle(
      fontFamily: "Inter",
      fontStyle: FontStyle.normal,
      shadows: shadows,
      letterSpacing: letterSpacing,
      fontSize: 12,
      fontWeight: fontWeight ?? AppFontWeight.w400,
      decoration: decoration,
      decorationColor: decorationColor,
      color: color ?? AppColor.textColor000000,
    ),
    textAlign: textAlign,
  );
}

Text f14({
  String? text,
  Color? color,
  FontWeight? fontWeight,
  TextAlign? textAlign,
  double? letterSpacing,
  int? maxLines,
  TextOverflow? textOverflow,
  TextDecoration? decoration,
  Color? decorationColor,
  double? textScaleFactor,
  List<Shadow>? shadows,
  EdgeInsets? padding,
  bool softWrap = true,
}) {
  return Text(
    text ?? '',

    softWrap: true,
    overflow: textOverflow ?? TextOverflow.ellipsis,
    maxLines: maxLines ?? 4,
    style: TextStyle(
      fontFamily: "Inter",
      fontStyle: FontStyle.normal,
      shadows: shadows,
      letterSpacing: letterSpacing,
      fontSize: 14,
      fontWeight: fontWeight ?? AppFontWeight.w600,
      decoration: decoration,
      decorationColor: decorationColor,
      color: color ?? AppColor.textColor000000,
    ),
    textAlign: textAlign,
  );
}

Text f16({
  String? text,
  Color? color,
  FontWeight? fontWeight,
  TextAlign? textAlign,
  double? letterSpacing,
  int? maxLines,
  TextOverflow? textOverflow,
  TextDecoration? decoration,
  Color? decorationColor,
  double? textScaleFactor,
  List<Shadow>? shadows,
  EdgeInsets? padding,
  bool softWrap = true,
}) {
  return Text(
    text ?? '',

    softWrap: true,
    overflow: textOverflow ?? TextOverflow.ellipsis,
    maxLines: maxLines ?? 4,
    style: TextStyle(
      fontFamily: "Inter",
      fontStyle: FontStyle.normal,
      shadows: shadows,
      letterSpacing: letterSpacing,
      fontSize: 16,
      fontWeight: fontWeight ?? AppFontWeight.w600,
      decoration: decoration,
      decorationColor: decorationColor,
      color: color ?? AppColor.textColor000000,
    ),
    textAlign: textAlign,
  );
}
Text f15({
  String? text,
  Color? color,
  FontWeight? fontWeight,
  TextAlign? textAlign,
  double? letterSpacing,
  int? maxLines,
  TextOverflow? textOverflow,
  TextDecoration? decoration,
  Color? decorationColor,
  double? textScaleFactor,
  List<Shadow>? shadows,
  EdgeInsets? padding,
  bool softWrap = true,
}) {
  return Text(
    text ?? '',

    softWrap: true,
    overflow: textOverflow ?? TextOverflow.ellipsis,
    maxLines: maxLines ?? 4,
    style: TextStyle(
      fontFamily: "Inter",
      fontStyle: FontStyle.normal,
      shadows: shadows,
      letterSpacing: letterSpacing,
      fontSize: 15,
      fontWeight: fontWeight ?? AppFontWeight.w600,
      decoration: decoration,
      decorationColor: decorationColor,
      color: color ?? AppColor.textColor000000,
    ),
    textAlign: textAlign,
  );
}

