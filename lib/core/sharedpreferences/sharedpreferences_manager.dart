import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  // Singleton instance
  static final SharedPreferencesManager _instance = SharedPreferencesManager._internal();

  // Private constructor
  SharedPreferencesManager._internal();

  // Factory constructor
  factory SharedPreferencesManager() => _instance;

  late SharedPreferences _prefs;

  /// Initialize SharedPreferences and set default values
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    // Set default values if they don't exist
    _prefs.setString('example_key', _prefs.getString('example_key') ?? 'default_value');
    _prefs.setBool('is_logged_in', _prefs.getBool('is_logged_in') ?? false);
    _prefs.setInt('launch_count', (_prefs.getInt('launch_count') ?? 0) + 1);

    // First launch check
    bool isFirstLaunch = _prefs.getBool('is_first_launch') ?? true;
    if (isFirstLaunch) {
      print('First app launch detected.');
      await _prefs.setBool('is_first_launch', false);
    }
  }

  // Save methods
  Future<void> saveString(String key, String value) async => await _prefs.setString(key, value);
  Future<void> saveInt(String key, int value) async => await _prefs.setInt(key, value);
  Future<void> saveBool(String key, bool value) async => await _prefs.setBool(key, value);
  Future<void> saveDouble(String key, double value) async => await _prefs.setDouble(key, value);
  Future<void> saveStringList(String key, List<String> value) async => await _prefs.setStringList(key, value);

  // Get methods
  String? getString(String key) => _prefs.getString(key);
  int? getInt(String key) => _prefs.getInt(key);
  bool? getBool(String key) => _prefs.getBool(key);
  double? getDouble(String key) => _prefs.getDouble(key);
  List<String>? getStringList(String key) => _prefs.getStringList(key);

  // Utility methods
  bool containsKey(String key) => _prefs.containsKey(key);
  Future<void> remove(String key) async => await _prefs.remove(key);
  Future<void> clearAll() async => await _prefs.clear();

  /// Clear all preferences
  Future<void> clearPreferences() async {
    await _prefs.clear();
    print('All preferences cleared.');
  }
  /// Get the number of times the app has been launched
///
  int getLaunchCount() {
    return _prefs.getInt('launch_count') ?? 0;
  }

  /// Check if it's the first launch
  bool isFirstLaunch() {
    return _prefs.getBool('is_first_launch') ?? true;
  }
  /// Set the first launch flag to false
///
  Future<void> setFirstLaunch() async {
    await _prefs.setBool('is_first_launch', false);
  }
  /// Get the example string
///
  String getExampleString() {
    return _prefs.getString('example_key') ?? 'default_value';
  }

  /// Set the example string
  Future<void> setExampleString(String value) async {
    await _prefs.setString('example_key', value);
  }

  /// Get the login status
  bool isLoggedIn() {
    return _prefs.getBool('is_logged_in') ?? false;
  }

  /// Set the login status
  Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool('is_logged_in', value);
  }
  /// Get the user type
///
  String getUserType() {
    return _prefs.getString('user_type') ?? 'default_user_type';
  }

  /// Set the user type
  Future<void> setUserType(String value) async {
    await _prefs.setString('user_type', value);
  }
}
