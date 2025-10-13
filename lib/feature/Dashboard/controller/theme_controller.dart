// // theme/theme_notifier.dart
// import 'package:flutter/material.dart';
//
// import '../../../core/sharedpreferences/sharedpreferences_manager.dart';
//
// class ThemeNotifier extends ChangeNotifier {
//   final SharedPreferencesManager _preferenceManager =
//       SharedPreferencesManager();
//   static var lightTheme = ThemeData(
//     useMaterial3: true,
//     brightness: Brightness.light,
//     scaffoldBackgroundColor: Colors.white,
//     colorScheme: ColorScheme.light(),
//   );
//   static var darkTheme = ThemeData(
//     useMaterial3: true,
//     brightness: Brightness.dark,
//     scaffoldBackgroundColor: Colors.black,
//     colorScheme: ColorScheme.dark(),
//   );
//
//   static const _key = 'is_dark_mode';
//   bool _isDarkMode = false;
//   late ThemeData _currentTheme;
//
//   ThemeNotifier() {
//     _loadTheme();
//   }
//
//   ThemeData get currentTheme => _currentTheme;
//   bool get isDarkMode => _isDarkMode;
//
//   Future<void> _loadTheme() async {
//     _isDarkMode = _preferenceManager.getBool(_key)!;
//     _currentTheme = _isDarkMode ? darkTheme : lightTheme;
//     notifyListeners();
//   }
//
//   Future<void> toggleTheme() async {
//     _isDarkMode = !_isDarkMode;
//     _currentTheme = _isDarkMode ? darkTheme : lightTheme;
//     await _preferenceManager.saveBool(_key, _isDarkMode);
//     notifyListeners();
//   }
// }
