
import 'package:flutter/cupertino.dart';

import '../../../Network/api_manager.dart';
import '../../../Network/api_response.dart';
import '../../../Network/api_service.dart';
import '../../../core/helper/app_log.dart';

import '../model/user_Response_model.dart';

class GetEmployeeController with ChangeNotifier {
  final BaseApiManager apiManager = BaseApiManager();
  late final ApiServices _apiServices;

  GetEmployeeController() {
    _apiServices = ApiServices(apiManager: apiManager);
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserDetailsResponse? _userDetailsResponse;
  UserDetailsResponse? get userDetailsResponse => _userDetailsResponse;

  Future<void> getEmployeeDetails(String uniqueId) async {
    _isLoading = true;
    notifyListeners();

    try {
      ApiResponse response = await _apiServices.getEmployeeByUniqueId(uniqueId);
      print("========= FULL API RESPONSE =========$uniqueId");
      print("STATUS: ${response.status}");
      print("MESSAGE: ${response.message}");
      print("RAW DATA: ${response.data}");
      print("LIST DATA: ${response.listData}");

      if (response.status == 200 && response.data != null) {
        // Correct way: map response.data directly to UserData inside UserDetailsResponse
        _userDetailsResponse = UserDetailsResponse(
          status: response.status,
          message: response.message,
          data: UserData.fromJson(response.data!), // <- directly parse data
        );

        AppLog.d('Details Fetched ====> $_userDetailsResponse');
      } else {
        AppLog.d('Failed to fetch details. Status: ${response.status}');
      }
    } catch (e) {
      debugPrint("Exception in getEmployeeDetails: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}