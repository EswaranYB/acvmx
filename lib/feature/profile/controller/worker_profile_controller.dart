import 'package:acvmx/Network/api_response.dart';
import 'package:acvmx/core/helper/app_log.dart';
import 'package:acvmx/feature/profile/model/worker_profile_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../Network/api_manager.dart';
import '../../../Network/api_service.dart';

class WorkerProfileController with ChangeNotifier {
  final BaseApiManager apiManager = BaseApiManager();
  late final ApiServices _apiServices;

  WorkerProfileController() {
    _apiServices = ApiServices(apiManager: apiManager);
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TechnicianDetailsByIdResponse? _workerDetailsByIdResponse;
  TechnicianDetailsByIdResponse? get workerDetailsByIdResponse =>
      _workerDetailsByIdResponse;

  Future<void> getWorkerDetailsApiCall(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      ApiResponse response = await _apiServices.getWorkerDetailsById(id);

      if (response.status == 200 && response.data != null) {
        _workerDetailsByIdResponse =
            TechnicianDetailsByIdResponse.fromJson(response.data!);
        AppLog.d('Details Fetched ====> $_workerDetailsByIdResponse');
      } else {
        AppLog.d('Failed to fetch details. Status: ${response.status}');
      }
    } catch (e) {
      debugPrint("Exception in getUserDetailsApiCall: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
