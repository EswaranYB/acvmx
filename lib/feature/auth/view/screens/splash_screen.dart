import 'package:acvmx/core/sharedpreferences/sharedpreferences_services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/appstring.dart';
import '../../../../core/custom_text.dart';
import '../../../../core/routes/route_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPrefService sharedPreferences = SharedPrefService();
  @override
  void initState() {
    splashLoginCheck(context);
    super.initState();
  }

  Future<void> splashLoginCheck(BuildContext context) async {
    final token = sharedPreferences.getAuthToken();
    print('token: $token');
    final userType = await sharedPreferences.getUserType();
    print('userType: $userType');

    await Future.delayed(const Duration(seconds: 2));

    if (token != null && token.isNotEmpty && userType != null) {
      if (context.mounted) {
        context.goNamed(
          RouteName.dashboardScreen,
          pathParameters: {
            'userType': userType == 'employee' ? 'worker' : 'customer'
          },
          queryParameters: {'tab': '0'},
        );
      }
    } else {
      if (context.mounted) {
        context.goNamed(RouteName.loginScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColor.primaryColor.withAlpha(100),
              AppColor.primaryColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: CustomText(
            text: AppString.apptitle,
            fontSize: AppFontSize.s28,
            fontWeight: AppFontWeight.w700,
            color: AppColor.primaryWhite,
          ),
        ),
      ),
    );
  }
}
