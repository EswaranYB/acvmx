import 'package:flutter/material.dart';
import '../../../Network/api_manager.dart';
import '../../../Network/api_service.dart';
import '../../../Network/api_response.dart';
import '../../../core/helper/app_log.dart';
import '../model/notification_model.dart';

class NotificationController with ChangeNotifier {
  final BaseApiManager apiManager = BaseApiManager();
  late final ApiServices _apiServices;

  NotificationController() {
    _apiServices = ApiServices(apiManager: apiManager);
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<NotificationData> _notifications = [];
  List<NotificationData> get notifications => _notifications;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      ApiResponse response = await _apiServices.getNotificationDetails();

      print("STATUS: ${response.status}");
      print("MESSAGE: ${response.message}");
      print("LIST DATA: ${response.listData}");

      if (response.status == 200 && response.listData != null) {
        _notifications = List<NotificationData>.from(
          response.listData!.map((item) => NotificationData.fromJson(item)),
        );
        AppLog.d("Notifications fetched: ${_notifications.length}");
      } else {
        _notifications = [];
        AppLog.d("Failed to fetch notifications. Status: ${response.status}");
      }
    } catch (e) {
      print("Error fetching notifications: $e");
      _notifications = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}