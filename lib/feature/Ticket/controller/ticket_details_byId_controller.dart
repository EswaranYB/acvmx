import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../Network/api_manager.dart';
import '../../../Network/api_response.dart';
import '../../../Network/api_service.dart';
import '../../../core/app_locator.dart';
import '../../../core/helper/app_log.dart';
import '../model/update_ticket_by_technician_model.dart';
import '../model/view_ticket_model.dart';


class TicketDetailsController extends ChangeNotifier {
  final BaseApiManager apiManager = BaseApiManager();
  final ApiServices _apiServices= ApiServices(apiManager: BaseApiManager());

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TicketDetailsByIdResponse? _ticketDetailsByIdResponse;
  TicketDetailsByIdResponse? get ticketDetails => _ticketDetailsByIdResponse;


  String? _videoPath;
  String? get videoPath => _videoPath;
  setVideoPath(String? value) {
    _videoPath = value;
    notifyListeners();
  }

  Future<void> newFetchTicketByDetails(String ticketId) async {
    _isLoading = true;
    notifyListeners();

    try {
      ApiResponse response = await _apiServices.getTicketDetailsByTicketId(ticketId);
      print("========= FULL API RESPONSE =========$ticketId");
      print("STATUS: ${response.status}");
      print("MESSAGE: ${response.message}");
      print("RAW DATA: ${response.data}");
      print("LIST DATA: ${response.listData}");
      print("inside try");


      print(response.status);
      print(response.data);
      if (response.status == 200 && response.data != null) {
        _ticketDetailsByIdResponse = TicketDetailsByIdResponse.fromJson(response.data!);
        AppLog.d('Details Fetched ====> $_ticketDetailsByIdResponse');
        AppLog.d('Ticket ID ,,,,,,,,,,,,,,,,,,: ${ticketDetails}');
        print("successfully fetched ticket details: ${_ticketDetailsByIdResponse?.ticket?.ticketId}");
      } else {
        AppLog.d('Failed to fetch details. Status: ${response.status}');
      }
    } catch (e) {
      debugPrint("Exception in getUserDetailsApiCall: $e");

    } finally {
      _isLoading = false;
      print(isLoading);
      notifyListeners();
    }

  }


  bool _updateLoading = false;
  bool get updateLoading => _updateLoading;

  TicketStatusUpdateResponse? _updateTicketResponse;
  TicketStatusUpdateResponse? get updateTicketResponse => _updateTicketResponse;

  /// Function to update ticket using technician form data
  Future<void> updateTicketByTechnician(TicketStatusUpdateRequest request) async {
    _updateLoading = true;
    notifyListeners();

    try {
      final formData = await request.toFormData();

      final apiResponse = await _apiServices.updateTicketByTechnician(formData);

      if (apiResponse.status == 200 && apiResponse.data != null) {
        _updateTicketResponse =
            TicketStatusUpdateResponse.fromJson(apiResponse.data!);
      } else {
        _updateTicketResponse = null;
        throw Exception(apiResponse.message ?? "Unknown error occurred");
      }
    } catch (e) {
      debugPrint("Update ticket failed: $e");
      _updateTicketResponse = null;
    } finally {
      _updateLoading = false;
      notifyListeners();
    }
  }
  Future<Position> fetchLocation() async{
    late Position position;
    try{
      position = await getCurrentLocation();
    }catch(e){
      print('Get Current Location Error: $e');
    }
    return position;
  }



}