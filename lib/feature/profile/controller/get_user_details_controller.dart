import 'package:acvmx/Network/api_response.dart';
import 'package:acvmx/core/helper/app_log.dart';
import 'package:flutter/cupertino.dart';

import '../../../Network/api_manager.dart';
import '../../../Network/api_service.dart';
import '../model/get_customer_details_byId_model.dart';

class GetUserDetailsProvider with ChangeNotifier {
  final BaseApiManager apiManager = BaseApiManager();
  late final ApiServices _apiServices;

  GetUserDetailsProvider() {
    _apiServices = ApiServices(apiManager: apiManager);
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  GetUserDetailsByIdResponse? _userDetailsByIdResponse;
  GetUserDetailsByIdResponse? get userDetailsByIdResponse =>
      _userDetailsByIdResponse;

  Future<void> getUserDetailsApiCall(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      ApiResponse response = await _apiServices.getCustomerDetailsById(id);

      if (response.status == 200 && response.data != null) {
        _userDetailsByIdResponse =
            GetUserDetailsByIdResponse.fromJson(response.data!);
        AppLog.d('Details Fetched ====> $_userDetailsByIdResponse');
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
