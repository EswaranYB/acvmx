import 'package:acvmx/core/app_decoration.dart';
import 'package:acvmx/core/helper/app_log.dart';
import 'package:acvmx/feature/Ticket/model/raise_ticket_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../Network/api_error.dart';
import '../../../Network/api_manager.dart';
import '../../../Network/api_response.dart';
import '../../../Network/api_service.dart';

class RaiseTicketController with ChangeNotifier {
  final BaseApiManager apiManager = BaseApiManager();
  late final ApiServices _apiServices;

  RaiseTicketController() {
    _apiServices = ApiServices(apiManager: apiManager);
  }
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  RaiseTicketResponse? _raiseTicketResponse;
  RaiseTicketResponse? get raiseTicketResponse => _raiseTicketResponse;

  Future<void> raiseTicketApiCall(BuildContext context, RaiseTicketRequest request) async {
    try {
      _isLoading = true;
      notifyListeners();

      final formData = await request.toFormData();
      final ApiResponse response = await _apiServices.raiseTicketByCustomer(formData);

      AppLog.d('API Response: ${response.data}');

      if (response.status == 200 && response.data != null) {
        _raiseTicketResponse = RaiseTicketResponse.fromJson(response.data!);
        showSnackBar(context, 'Ticket raised successfully');
      } else {
        final String message = response.message ?? "Something went wrong while raising the ticket.";
        showSnackBar(context, message);
      }
    } catch (error) {
      // Handle unexpected or Dio/network errors
      AppLog.e("raiseTicketApiCall Error: $error");

      String errorMessage = "An unexpected error occurred.";
      if (error is ApiException) {
        // Custom error object from Dio wrapper
        errorMessage = error.message ?? errorMessage;
        showSnackBar(context, errorMessage);
      } else if (error is DioException) {
        // Direct Dio error fallback
        errorMessage = error.message ?? errorMessage;
      }

      showSnackBar(context, errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}
