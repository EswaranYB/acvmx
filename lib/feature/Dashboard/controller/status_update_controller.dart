import 'package:flutter/material.dart';
import '../../../Network/api_manager.dart';
import '../../../Network/api_service.dart'; // your existing API service
import '../model/employee_status_update.dart';

class StatusUpdateController extends ChangeNotifier {
  final BaseApiManager apiManager = BaseApiManager();
  final ApiServices _apiServices = ApiServices(apiManager: BaseApiManager()); // your API service instance

  bool _updateLoading = false;
  bool get updateLoading => _updateLoading;

  StatusUpdateResponse? _updateStatusResponse;
  StatusUpdateResponse? get statusUpdateResponse => _updateStatusResponse;

  /// Update employee status (ACTIVE / INACTIVE)
  Future<void> updateEmployeeStatus(StatusUpdateRequest request) async {
    _updateLoading = true;
    notifyListeners(); // show loader in UI

    try {
      // Convert request to FormData
      final formData = await request.toFormData();

      // Call API service
      final apiResponse = await _apiServices.updateEmployeeStatus(formData);

      // Parse response
      if (apiResponse.status == 200 && apiResponse.data != null) {
        _updateStatusResponse = StatusUpdateResponse.fromJson(apiResponse.data!);
      } else {
        _updateStatusResponse = null;
        throw Exception(apiResponse.message ?? "Unknown error occurred");
      }
    } catch (e) {
      debugPrint("Update employee status failed: $e");
      _updateStatusResponse = null;
    } finally {
      _updateLoading = false;
      notifyListeners(); // hide loader in UI
    }
  }
}