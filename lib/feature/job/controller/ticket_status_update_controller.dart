import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Network/api_manager.dart';
import '../../../Network/api_service.dart';
import '../../Ticket/model/update_ticket_by_technician_model.dart';
import '../model/ticket_status_update_model.dart';

class TicketStatusUpdateController extends ChangeNotifier {
  // API manager and service
  final BaseApiManager apiManager = BaseApiManager();
  final ApiServices _apiServices = ApiServices(apiManager: BaseApiManager());

  // Loader flag
  bool _updateLoading = false;
  bool get updateLoading => _updateLoading;

  // Last ticket update response
  TicketUpdateResponse? _ticketUpdateResponse;
  TicketUpdateResponse? get ticketUpdateResponse => _ticketUpdateResponse;

  // Store last status for each ticket in memory
  final Map<String, String> _savedJobStatus = {};

  TicketStatusUpdateController() {
    _loadSavedStatuses(); // Load previously saved data on app start
  }

  /// Load all saved job statuses from SharedPreferences
  Future<void> _loadSavedStatuses() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    for (var key in keys) {
      if (key.startsWith('job_status_')) {
        _savedJobStatus[key.replaceFirst('job_status_', '')] =
            prefs.getString(key) ?? '';
      }
    }
    notifyListeners();
  }

  /// Save status permanently in SharedPreferences
  Future<void> _saveJobStatus(String ticketId, String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('job_status_$ticketId', status);
  }

  /// Update ticket status (Accept / Reject / Scheduled)
  Future<void> updateTicketStatus(TicketUpdateRequest request) async {
    _updateLoading = true;
    notifyListeners(); // start loader

    try {
      final formData = await request.toFormData();
      final apiResponse = await _apiServices.acceptTicketStatus(formData);

      if (apiResponse != null) {
        _ticketUpdateResponse = TicketUpdateResponse.fromJson({
          "status": apiResponse.status,
          "message": apiResponse.message,
          "data": apiResponse.data,
        });

        // Save the status locally (in memory + shared prefs)
        if (request.ticketId.isNotEmpty && request.status.isNotEmpty) {
          _savedJobStatus[request.ticketId] = request.status;
          await _saveJobStatus(request.ticketId, request.status);
        }
      } else {
        _ticketUpdateResponse = null;
        throw Exception("Unknown error occurred");
      }
    } catch (e) {
      debugPrint("Update ticket status failed: $e");
      _ticketUpdateResponse = null;
    } finally {
      _updateLoading = false;
      notifyListeners(); // stop loader
    }
  }

  /// Get the saved job status for a given ticket ID
  String? getSavedJobStatus(String ticketId) {
    return _savedJobStatus[ticketId]; // Returns "Accept", "Reject", or null
  }

  /// Optional: clear saved status for testing
  Future<void> clearSavedJobStatus() async {
    final prefs = await SharedPreferences.getInstance();
    for (var key in prefs.getKeys()) {
      if (key.startsWith('job_status_')) {
        await prefs.remove(key);
      }
    }
    _savedJobStatus.clear();
    notifyListeners();
  }
}