import 'package:acvmx/Network/api_manager.dart';
import 'package:acvmx/Network/api_service.dart';
import 'package:acvmx/core/app_decoration.dart';
import 'package:acvmx/core/sharedpreferences/sharedpreferences_services.dart';
import 'package:acvmx/feature/auth/model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../Network/api_response.dart';
import '../../../core/helper/app_log.dart';
import '../../../core/routes/route_name.dart';

class AuthController with ChangeNotifier {
  final BaseApiManager apiManager = BaseApiManager();
  late final ApiServices _apiServices;
  final SharedPrefService sharedPreferences = SharedPrefService();

  // Constructor
  AuthController() {
    _apiServices = ApiServices(apiManager: apiManager);
  }

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Login response and user type
  LoginResponse? _loginResponse;
  LoginResponse? get loginResponse => _loginResponse;

  late String _userType = 'customer';
  String get userTypeValue => _userType;

  // Text controllers and form key
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  /// Validation methods
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    // if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value.trim())) {
    //   return 'Enter a valid email';
    // }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  /// Validate form before API call
  bool validateLoginForm() {
    return loginFormKey.currentState?.validate() ?? false;
  }

  /// Login API call
  Future<void> loginApiCall(BuildContext context) async {
    if (!validateLoginForm()) return;

    final request = LoginRequest(
      username: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    try {
      _isLoading = true;
      notifyListeners();

      final ApiResponse response = await _apiServices.loginRequest(request);

      if (response.status == 200 && response.data != null) {
        _loginResponse = LoginResponse.fromJson(response.data!);

        await sharedPreferences.setAuthToken(_loginResponse!.token);
        await sharedPreferences.setIsLoggedIn(true);
        await sharedPreferences.setUserId(_loginResponse!.uniqueId);
        await sharedPreferences.setUserType(_loginResponse!.user_type);
        await sharedPreferences.setUserName(_loginResponse!.username);

        _userType = _loginResponse!.user_type;

        AppLog.d('Login successful: ${_loginResponse!.uniqueId}');

        if (_userType != null && context.mounted) {
          context.goNamed(
            RouteName.dashboardScreen,
            pathParameters: {
              'userType': _userType == 'employee' ? 'worker' : 'customer',
            },
            queryParameters: {'tab': '0'},
          );
        }
        showSnackBar(context, 'Login successful! Welcome ${_loginResponse!.username}');
        emailController.clear();
        passwordController.clear();
      } else {
        // Handles both API response errors and null data cases
        AppLog.e("Login failed: ${response.message ?? 'Unknown error'}");
        if (context.mounted) {
          showSnackBar(context, response.message ?? 'Invalid username or password. Please try again.');
        }
      }
    } catch (error, stackTrace) {
      AppLog.e("Login error: $error\n$stackTrace");
      if (context.mounted) {
        showSnackBar(context, 'Something went wrong. Please try again later.');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  /// Logout
  Future<void> logout(BuildContext context) async {
    try {
      await sharedPreferences.clearUserSession();
      _loginResponse = null;
      _userType = 'customer';

      if (context.mounted) {
        context.goNamed(RouteName.loginScreen);
      }
    } catch (error) {
      AppLog.e("Logout error: $error");
    }
  }

  /// Dispose controllers
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

