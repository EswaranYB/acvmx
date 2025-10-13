import 'package:acvmx/core/sharedpreferences/sharedpreferences_services.dart';
import 'package:dio/dio.dart';

import '../core/api_endpoints.dart';
import '../feature/auth/model/login_model.dart';
import 'api_manager.dart';
import 'api_response.dart';

class ApiServices {
  final BaseApiManager apiManager;
  SharedPrefService sharedPreferences = SharedPrefService();
  // final ApiManager _api = ApiManager();

  ApiServices({required this.apiManager});

  Map<String, String> get headers {
    final token = sharedPreferences.getAuthToken();
    if (token == null) {
      throw Exception("Token not found");
    }
    return {"Authorization": "Bearer $token"};
  }

  /// Login request
  Future<ApiResponse> loginRequest(LoginRequest request) {
    return apiManager.post(ApiEndPoints.login, data: request.toJson());
  }

  /// Get all tickets
  Future<ApiResponse> getTicketById(String ticketId) {
    return apiManager.get(ApiEndPoints.getTicketById,
        queryParameters: {"ticket_id": ticketId}, headers: headers);
  }

  /// Get ticket by technician ID
  Future<ApiResponse> getTicketByTechnician(String technicianId) {
    return apiManager.get(ApiEndPoints.getTicketByTechnician,
        queryParameters: {"user_id": technicianId},
        headers: headers);
  }

  /// Get ticket by user ID
  Future<ApiResponse> getTicketByUserId(String customerId) {
    return apiManager.get(ApiEndPoints.getTicketByUserId,
        queryParameters: {"user_id": customerId}, headers: headers);
  }

  Future<ApiResponse> getJobCountById(String userId) {
    return apiManager.get(ApiEndPoints.dashboardJobCount,
        queryParameters: {"user_id": userId}, headers: headers);
  }

  /// Get product details by serial number
  Future<ApiResponse> getProductDetailBySerialNumber(String barcode) async {
    return apiManager.get(ApiEndPoints.getProductDetailBySerialNumber,
        queryParameters: {"bar_code": barcode}, headers: headers);
  }

  /// Get user details by ID
  Future<ApiResponse> getCustomerDetailsById(String id) {
    return apiManager.get(ApiEndPoints.getUserDetailsById,
        queryParameters: {"user_unique_id": id}, headers: headers);
  }

  /// Raises a ticket by customer
  Future<ApiResponse> raiseTicketByCustomer(FormData formData) {
    final token = sharedPreferences.getAuthToken();
    if (token == null) {
      throw Exception("Token not found");
    }
    return apiManager.post(
      ApiEndPoints.raiseTicketByCustomer,
      data: formData,
      
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      },
    );
  }

  Future<ApiResponse> getTicketDetailsByTicketId(String ticketId) {
    return apiManager.get(ApiEndPoints.getTicketDetailsByTicketId,
        queryParameters: {"ticket_id": ticketId}, headers: headers);
  }


  Future<ApiResponse> updateTicketByTechnician(FormData formData) {
    final token = sharedPreferences.getAuthToken();
    if (token == null) {
      throw Exception("Token not found");
    }
    return apiManager.post(ApiEndPoints.updateTicketByTechnician,
       data: formData,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      },
    );
  }
  Future<ApiResponse> updateEmployeeStatus(FormData formData) {
    final token = sharedPreferences.getAuthToken();
    if (token == null) {
      throw Exception("Token not found");
    }
    return apiManager.post(ApiEndPoints.updateEmployeeStatus,
      data: formData,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      },
    );
  }
  Future<ApiResponse> acceptTicketStatus(FormData formData) {
    final token = sharedPreferences.getAuthToken();
    if (token == null) {
      throw Exception("Token not found");
    }
    return apiManager.post(ApiEndPoints.acceptTicketStatus,
      data: formData,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      },
    );
  }
  Future<ApiResponse> updateStockDetails(FormData formData) {
    final token = sharedPreferences.getAuthToken();
    if (token == null) {
      throw Exception("Token not found");
    }
    return apiManager.post(ApiEndPoints.acceptTicketStatus,
      data: formData,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      },
    );
  }

  Future<ApiResponse>getWorkerDetailsById(String userId){
    return apiManager.get(ApiEndPoints.profileDetailsById,
    queryParameters: {"user_id": userId}, headers: headers);
  }

  Future<ApiResponse>getStockDetails(){
    return apiManager.get(ApiEndPoints.getStockDetails,
        queryParameters: {}, headers: headers);
  }

  Future<ApiResponse>getNotificationDetails(){
    return apiManager.get(ApiEndPoints.getNotificationDetails,
        queryParameters: {}, headers: headers);
  }

  Future<ApiResponse> getEmployeeByUniqueId(String unique_id) {
    return apiManager.get(ApiEndPoints.getEmployeeByUniqueId,
        queryParameters: {"emp_id":unique_id }, headers: headers);
  }

}
