import 'dart:developer' as developer;

class AppLog {
  static void d(String log) {
    developer.log(log);
  }
  static void dObj(Object log) {
    developer.log(log.toString());
  }

  static void e(String log) {
    developer.log("Error : ", error: log);
  }
}