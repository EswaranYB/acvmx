import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_decoration.dart';
import 'custom_text.dart';

class AppButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final double? fontSize;
  final double? width;
  final double? height;
  final Color? color;
  final Color? textColor;
  final Widget? child;
  final EdgeInsets? padding;

  const AppButton({
    super.key,
    this.text,
    this.onPressed,
    this.fontSize,
    this.width,
    this.height,
    this.color,
    this.textColor,
    this.child,
    this.padding
  }) : assert(
  text != null || child != null,
  'Either text or child must be provided',
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color ?? AppColor.primaryColor,
              color ?? AppColor.primaryColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        padding:padding?? EdgeInsets.symmetric(
          vertical: height == null ? 5 : 1,
          horizontal: 6,
        ),
        child: child ??
            CustomText(
              text: text!,
              fontWeight: FontWeight.w700,
              fontSize: fontSize ?? AppFontSize.s14,
              color: textColor ?? AppColor.primaryWhite,
            ),
      ),
    );
  }
}
