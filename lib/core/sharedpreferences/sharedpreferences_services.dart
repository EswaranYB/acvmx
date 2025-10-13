import 'package:acvmx/core/sharedpreferences/preferences_keys.dart';
import 'package:acvmx/core/sharedpreferences/sharedpreferences_manager.dart';

class SharedPrefService {
  final SharedPreferencesManager _preferenceManager =
      SharedPreferencesManager();

  /// Set the auth token
  Future<void> setAuthToken(String token) async {
    await _preferenceManager.saveString(PreferencesKeys.token, token);
  }

  /// Get the auth token
  String? getAuthToken() {
    return _preferenceManager.getString(PreferencesKeys.token);
  }

  /// Clear the auth token
  Future<void> clearAuthToken() async {
    await _preferenceManager.remove(PreferencesKeys.token);
  }

  /// Set user type
  Future<void> setUserType(String userType) async {
    await _preferenceManager.saveString(PreferencesKeys.userType, userType);
  }

  /// Get user type
  Future<String?> getUserType() async {
    return _preferenceManager.getString(PreferencesKeys.userType);
  }

  /// clear user type

  Future<void> clearUserType() async {
    await _preferenceManager.remove(PreferencesKeys.userType);
  }

  /// Set login status
  Future<void> setIsLoggedIn(bool isLoggedIn) async {
    await _preferenceManager.saveBool(PreferencesKeys.isLoggedIn, isLoggedIn);
  }

  /// Get login status
  bool getIsLoggedIn() {
    return _preferenceManager.getBool(PreferencesKeys.isLoggedIn) ?? false;
  }

  /// Set user ID
  Future<void> setUserId(String userId) async {
    await _preferenceManager.saveString(PreferencesKeys.userId, userId);
  }

  /// Get user ID
  String? getUserId() {
    return _preferenceManager.getString(PreferencesKeys.userId);
  }

  Future<void> setLoginResponse(String json) async {
    await _preferenceManager.saveString(PreferencesKeys.loginResponse, json);
  }

  Future<String?> getLoginResponse() async {
    return _preferenceManager.getString(PreferencesKeys.loginResponse);
  }

  /// Set user name
  Future<void> setUserName(String userName) async {
    await _preferenceManager.saveString(PreferencesKeys.userName, userName);
  }

  /// Get user name
  String? getUserName() {
    return _preferenceManager.getString(PreferencesKeys.userName);
  }

  /// Set user email (optional example)
  Future<void> setUserEmail(String email) async {
    await _preferenceManager.saveString(PreferencesKeys.userEmail, email);
  }

  /// Get user email
  String? getUserEmail() {
    return _preferenceManager.getString(PreferencesKeys.userEmail);
  }

  /// Clear all user session data
  Future<void> clearUserSession() async {
    await _preferenceManager.remove(PreferencesKeys.token);
    await _preferenceManager.remove(PreferencesKeys.isLoggedIn);
    await _preferenceManager.remove(PreferencesKeys.userId);
    await _preferenceManager.setLoggedIn(false);
    await _preferenceManager.remove(PreferencesKeys.userType);
    await _preferenceManager.remove(PreferencesKeys.userName);
    await _preferenceManager.remove(PreferencesKeys.userEmail);
    await _preferenceManager.remove(PreferencesKeys.userPhone);
    await _preferenceManager.remove(PreferencesKeys.userProfileImage);
    await _preferenceManager.remove(PreferencesKeys.loginResponse);
  }
}
