import 'package:flutter/cupertino.dart';

import '../../../Network/api_manager.dart';
import '../../../Network/api_response.dart';
import '../../../Network/api_service.dart';
import '../../../core/app_decoration.dart';
import '../model/ticket_by_id_response.dart';
import '../../../core/helper/app_log.dart';

// class GetTicketByTechnicianController with ChangeNotifier {
//   final BaseApiManager apiManager = BaseApiManager();
//   late final ApiServices _apiServices;
//
//   GetTicketByTechnicianController() {
//     _apiServices = ApiServices(apiManager: apiManager);
//   }
//   // bool _isLoading = false;
//   bool isLoading = false;
//
//   String _ticketId = '';
//   String _jobUniqueId = '';
//   String get jobUniqueId => _jobUniqueId;
//
//   String get ticketId => _ticketId;
//   setTicketId(String ticketId, String jobUniqueId) {
//     _ticketId = ticketId;
//     _jobUniqueId = jobUniqueId;
//     notifyListeners();
//   }
//
//   final List<TicketByIdResponse>_getTicketByTechnician=[];
//   List<TicketByIdResponse> get ticketByTechnician => _getTicketByTechnician;
//
//   // Future<void> getTicketByTechnicianApiCall(String id) async {
//   //   try {
//   //     isLoading = true;
//   //     ApiResponse response = await _apiServices.getTicketByTechnician(id);
//   //
//   //     if (response.status == 200) {
//   //       List<dynamic> ticketList = response.listData??[];
//   //       List<TicketByIdResponse> list = ticketList.map((e)=> TicketByIdResponse.fromJson(e)).toList();
//   //       _getTicketByTechnician.clear();
//   //       _getTicketByTechnician.addAll(list);
//   //       print("TicketByTechnician: ${_getTicketByTechnician.length}");
//   //     } else {
//   //       // Handle error
//   //       AppLog.e("Error fetching tickets: ${response.message}");
//   //
//   //     }
//   //
//   //   } catch (error) {
//   //     AppLog.e("api:$error");
//   //     isLoading = false;
//   //     notifyListeners();
//   //   } finally {
//   //     isLoading = false;
//   //     notifyListeners();
//   //   }
//   // }
//   Future<List<TicketByIdResponse>> getTicketByTechnicianApiCall(String id) async {
//     try {
//       isLoading = true;
//       ApiResponse response = await _apiServices.getTicketByTechnician(id);
//
//       if (response.status == 200) {
//         List<dynamic> ticketList = response.listData ?? [];
//         List<TicketByIdResponse> list = ticketList.map((e) => TicketByIdResponse.fromJson(e)).toList();
//         _getTicketByTechnician.clear();
//         _getTicketByTechnician.addAll(list);
//         print("TicketByTechnician: ${_getTicketByTechnician.length}");
//         return list;
//       } else {
//         AppLog.e("Error fetching tickets: ${response.message}");
//         return []; // return empty list on error
//       }
//     } catch (error) {
//       AppLog.e("api:$error");
//       return []; // return empty list on exception
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
//
//
//
// }

class GetTicketByTechnicianController extends ChangeNotifier {
  final ApiServices _apiServices = ApiServices(apiManager: BaseApiManager());

  bool isLoading = false;

  final List<TicketByIdResponse> _allTickets = [];
  final List<TicketByIdResponse> _filteredTickets = [];

  List<TicketByIdResponse> get ticketByTechnician => _filteredTickets;

  //ticket count

  String _ticketId = '';
  String _jobUniqueId = '';
  String get ticketId => _ticketId;
  String get jobUniqueId => _jobUniqueId;

  void setTicketId(String ticketId, String jobUniqueId) {
    _ticketId = ticketId;
    _jobUniqueId = jobUniqueId;
    notifyListeners();
  }

  // Filters
  String _tempStatus = '';
  String _tempSortOrder = 'desc';
  String get tempStatus => _tempStatus;
  String get tempSortOrder => _tempSortOrder;

  void setTempStatus(String status) {
    _tempStatus = status;
    notifyListeners();
  }

  void setTempSortOrder(String order) {
    _tempSortOrder = order;
    notifyListeners();
  }

  void clearFilters() {
    _tempStatus = '';
    _tempSortOrder = 'desc';
    applyFilters();
  }

  Future<void> getTicketByTechnicianApiCall(
      BuildContext context, String technicianId) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await _apiServices.getTicketByTechnician(technicianId);

      if (response.status == 200 && response.listData != null) {
        List<dynamic> ticketList = response.listData ?? [];
        final List<TicketByIdResponse> tickets = ticketList
            .map<TicketByIdResponse>((e) => TicketByIdResponse.fromJson(e))
            .toList();

        _allTickets.clear();
        _allTickets.addAll(tickets);

        applyFilters();

        AppLog.d("Fetched ${_allTickets.length} tickets.");
      } else {
        AppLog.e("API error: ${response.message}");
        if (context.mounted) {
          showSnackBar(
              context,
              response.message ??
                  "Something went wrong while fetching tickets.");
        }
      }
    } catch (e, stackTrace) {
      AppLog.e(
          "Unexpected error in getTicketByTechnicianApiCall: $e\n$stackTrace");
      if (context.mounted) {
        showSnackBar(context, "Something went wrong: ${e.toString()}");
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void applyFilters() {
    List<TicketByIdResponse> filtered = [..._allTickets];

    if (_tempStatus.isNotEmpty) {
      filtered = filtered.where((t) => t.ticketStatus == _tempStatus).toList();
    }

    filtered.sort((a, b) {
      final aDate = DateTime.parse(a.createdDate);
      final bDate = DateTime.parse(b.createdDate);
      return _tempSortOrder == 'asc'
          ? aDate.compareTo(bDate)
          : bDate.compareTo(aDate);
    });

    _filteredTickets
      ..clear()
      ..addAll(filtered);

    notifyListeners();
  }
}
