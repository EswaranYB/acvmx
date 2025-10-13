import 'package:acvmx/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/custom_text.dart';
import '../../../../core/responsive.dart';

PreferredSize commonAppBar(
    BuildContext context, {
      String? title,
      bool showLeading = true, // ✅ Control showing back button
      VoidCallback? onBack,
      double? bottomRadius,
      PreferredSizeWidget? bottom,
      Widget? flexibleSpace,
      List<Widget>? actions,
    }) {
  return PreferredSize(
    preferredSize: Size.fromHeight(
      ResponsiveUtils.isMobile(context)
          ? MediaQuery.of(context).size.height * .07
          : MediaQuery.of(context).size.height * .1,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(bottomRadius ?? 30),
      ),
      child: AppBar(
        backgroundColor: AppColor.primaryColor,
        leading: showLeading
            ? IconButton(
          onPressed: onBack ?? () => GoRouter.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColor.primaryWhite,
          ),
        )
            : SizedBox(width: 10,),
        title: CustomText(
          text: title?.toTitleCase() ?? '',
          fontSize: AppFontSize.s16,
          fontWeight: AppFontWeight.w600,
          color: AppColor.primaryWhite,
        ),
        bottom: bottom,
        flexibleSpace: flexibleSpace,
        actions: actions,
      ),
    ),
  );
}


extension StringCasingExtension on String {
  String toTitleCase() {
    return split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}
