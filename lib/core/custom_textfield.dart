import 'package:acvmx/core/app_dimensions.dart';
import 'package:acvmx/core/custom_text.dart';
import 'package:acvmx/core/responsive.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class CustomTextFieldWidget extends StatelessWidget {
  const CustomTextFieldWidget({
    super.key,
    required this.inputType,
    this.controller,
    this.hintStyle,
    this.contentPadding,
    this.focusedBorder,
    this.border,
    this.hintText,
    this.enabledBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.padding,
    this.validator,
    this.customErrorText,
    this.textAlign,
    this.textAlignVertical,
    this.expands=false,
    this.maxLines,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText,
    this.disabledBorder,
    this.autoFocus,
    this.onChanged,
    this.filled
  });

  final TextInputType inputType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextStyle? hintStyle;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? focusedErrorBorder;
  final InputBorder? errorBorder;
  final InputBorder? disabledBorder;
  final String? hintText;
  final String? customErrorText;
  final EdgeInsets? padding;
  final bool expands;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final int? maxLines;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;
  final bool? autoFocus;
  final bool? filled;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 0),
      child: TextFormField(
        cursorColor: AppColor.textColor000000,
        textAlign: textAlign ?? TextAlign.left,
        textAlignVertical: textAlignVertical,
        keyboardType: inputType,
        autofocus: autoFocus ?? false,
        expands: expands,
        maxLines: maxLines,
        obscureText: obscureText ?? false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: onChanged,

        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          fontSize: AppFontSize.s14,
          color: AppColor.textColor000000,
        ),
        decoration: InputDecoration(
          fillColor: AppColor.greyF4F4F4,
          filled: true,

          contentPadding: contentPadding ??
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: border ??
              OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: AppColor.greyF4F4F4)),
          enabledBorder: enabledBorder ?? OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: AppColor.greyF4F4F4)),
          focusedBorder: focusedBorder ??OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: AppColor.greyF4F4F4)),
          focusedErrorBorder: focusedErrorBorder ?? OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: AppColor.greyF4F4F4)),
          errorBorder: errorBorder ?? OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: AppColor.greyF4F4F4)),
          disabledBorder: disabledBorder ??OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: AppColor.greyF4F4F4)),
          hintText: hintText,
          hintStyle: hintStyle ??
              TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w200,
                fontSize: Rem.rem(AppFontSize.s14),
                color: AppColor.textColor000000.appWithValues(alpha: 0.8),
              ),
          errorMaxLines: 1,
        ),
        controller: controller,
        validator: validator,
      ),
    );
  }
}

