import 'package:acvmx/core/responsive.dart';
import 'package:acvmx/feature/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:acvmx/core/app_colors.dart';
import 'package:acvmx/core/appbutton.dart';
import 'package:acvmx/core/appstring.dart';
import 'package:acvmx/core/custom_text.dart';
import 'package:acvmx/core/custom_textfield.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Consumer<AuthController>(
        builder: (context,authController,child) {
          return Scaffold(
            backgroundColor: AppColor.primaryWhite,
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(40),
                child: Form(
                  key: authController.loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: AppString.login,
                        fontSize: AppFontSize.s24,
                        fontWeight: AppFontWeight.w600,
                        color: AppColor.textColor000000,
                      ),
                      12.height,
                      f14(text: AppString.loginMessage),
                      60.height,

                      /// Email Field
                      f14(text: AppString.userName),
                      13.height,
                      CustomTextFieldWidget(
                        controller: authController.emailController,
                        inputType: TextInputType.emailAddress,
                        hintText: AppString.userName,
                        validator: authController.validateEmail,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      32.height,

                      /// Password Field
                      f14(text: AppString.password),
                      13.height,
                      CustomTextFieldWidget(
                        controller: authController.passwordController,
                        inputType: TextInputType.visiblePassword,
                        hintText: AppString.password,
                        validator: authController.validatePassword,
                        obscureText: authController.obscurePassword,
                        maxLines: 1,
                        suffixIcon: IconButton(
                          icon: Icon(
                            authController.obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: authController.togglePasswordVisibility,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      48.height,

                      /// Login Button
                      AppButton(
                        height: 50,
                        text: authController.isLoading ? '' : 'Login',
                        onPressed: authController.isLoading
                            ? null
                            : () => authController.loginApiCall(context),
                        child: authController.isLoading
                            ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            value: 3,

                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}

