// import 'dart:convert';
//
// import 'package:acvmx/core/sharedpreferences/sharedpreferences_services.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../core/app_decoration.dart';
// import '../../../core/routes/route_name.dart';
// import '../model/login_model.dart';
//
// class AuthProvider with ChangeNotifier {
//   SharedPrefService sharedPreferences = SharedPrefService();
//   UserModel? _user;
//   bool _isLoading = false;
//
//   UserModel? get user => _user;
//   bool get isLoading => _isLoading;
//
//   void _setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }
//
//   Future<void> login(
//       String email, String password, BuildContext context) async {
//     // Dummy validation
//     String? userType;
//     if (email == "1234" && password == "1234") {
//       userType = "worker";
//     } else if (email == "4321" && password == "1234") {
//       userType = "customer";
//     } else {
//       showSnackBar(context, "Invalid Username or Password");
//       return;
//     }
//
//     _setLoading(true); // <- only show loading now
//     await Future.delayed(const Duration(seconds: 1));
//
//     sharedPreferences.setUserType(userType);
//     _user = UserModel(email: email, password: password, userType: userType);
//
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString("userData", jsonEncode(_user!.toMap()));
//
//     _setLoading(false);
//
//     if (context.mounted) {
//       context.goNamed(
//         RouteName.dashboardScreen,
//         pathParameters: {'userType': userType},
//         queryParameters: {'tab': '0'},
//       );
//     }
//   }
//
//   Future<void> loadUser() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? userData = prefs.getString("userData");
//
//     if (userData != null) {
//       _user = UserModel.fromMap(Map<String, String>.from(jsonDecode(userData)));
//       notifyListeners();
//     }
//   }
//
//   Future<void> logout(BuildContext context) async {
//     _user = null;
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove("userData");
//     sharedPreferences.clearAuthToken();
//     sharedPreferences.clearUserType();
//     sharedPreferences.setIsLoggedIn(false);
//
//     if (context.mounted) {
//       context.goNamed(RouteName.loginScreen);
//     }
//   }
// }
