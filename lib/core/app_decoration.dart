import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'custom_text.dart';

List<BoxShadow> greyBoxShadow() {
  return [
    BoxShadow(
        color: AppColor.textColor000000.withValues(alpha: 0.2),
        blurRadius: 5,
        offset: const Offset(0, 0),
        spreadRadius: 0)
  ];
}

ScaffoldMessengerState showSnackBar(BuildContext context, String message,
    {Color? textColor, Color? backgroundColor, double? fontSize}) {
  return ScaffoldMessenger.of(context)
    ..showSnackBar(
      SnackBar(
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
        behavior: SnackBarBehavior.floating,
        content:CustomText(text: message,
        fontSize: AppFontSize.s16,
        color: AppColor.primaryWhite),
        backgroundColor: backgroundColor ?? AppColor.primaryColor,
        duration: const Duration(seconds: 3),
      ),
    );
}
