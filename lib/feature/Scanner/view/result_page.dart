import 'package:acvmx/core/responsive.dart';
import 'package:acvmx/core/routes/route_name.dart';
import 'package:acvmx/feature/Dashboard/view/widgets/appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_colors.dart';
import '../../../core/appbutton.dart';
import '../../../core/custom_text.dart';

class BarcodeResultScreen extends StatelessWidget {
  final String result;

  const BarcodeResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("Scanned Barcode Result: $result");
    }

    return PopScope(
      canPop: false, // This disables back navigation
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard on tap
        child: Scaffold(
          appBar: commonAppBar(context, title: 'Scan Result', showLeading: true),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColor.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColor.primaryColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  15.height,
                  CustomText(
                    text: 'Scan Result',
                    fontSize: AppFontSize.s20,
                    fontWeight: AppFontWeight.w600,
                    color: AppColor.primaryColor,
                  ),
                  10.height,
                  CustomText(
                    text: result,
                    fontSize: AppFontSize.s16,
                    fontWeight: AppFontWeight.w400,
                    color: AppColor.textColor000000,
                    textAlign: TextAlign.left,
                    softWrap: true,
                  ),
                  20.height,
                  AppButton(
                    text: 'Go to Record Screen',
                    onPressed: () {
                      context.pushNamed(RouteName.productDetailsScreen);
                    },
                    textColor: AppColor.primaryWhite,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
