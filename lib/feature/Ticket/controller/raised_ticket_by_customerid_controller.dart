import 'package:acvmx/Network/api_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../Network/api_manager.dart';
import '../../../Network/api_response.dart';
import '../../../Network/api_service.dart';
import '../model/raised_ticket_by_customerId_model.dart';

// class RaisedTicketsController with ChangeNotifier {
//   ApiServices _apiService = ApiServices(apiManager: BaseApiManager());
//   RaisedTicketsController() {
//     _apiService = ApiServices(apiManager: BaseApiManager());
//   }
//   List<RaisedTicketsById> _tickets = [];
//   List<RaisedTicketsById> get tickets => _tickets;
//
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//
//   Future<void> fetchTicketsByCustomerId(String customerId) async {
//     _isLoading = true;
//     notifyListeners();
//     try {
//       final response = await _apiService.getTicketByUserId(customerId);
//       if (response.status == 200 && response.data != null) {
//         _tickets = (response.data!['Data'])
//             .map((ticket) => RaisedTicketsById.fromJson(ticket))
//             .toList();
//         debugPrint('Tickets fetched successfully: ${_tickets.length}');
//       } else {
//         debugPrint('Failed to fetch tickets: ${response.error}');
//       }
//     } catch (e) {
//       debugPrint('Exception in fetchTicketsByCustomerId: $e');
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }

class RaisedTicketsController with ChangeNotifier {
  final ApiServices _apiService;

  RaisedTicketsController()
      : _apiService = ApiServices(apiManager: BaseApiManager());

  List<RaisedTicketsById> _allTickets = [];
  List<RaisedTicketsById> _filteredTickets = [];
  List<RaisedTicketsById> get tickets => _filteredTickets;

  int get ticketCount => _allTickets.length;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Active filters (applied to list)
  String _selectedStatus = '';
  String _sortOrder = 'desc';

  // Temporary filters (while user interacts in bottom sheet)
  String tempStatus = '';
  String tempSortOrder = 'desc';

  /// Fetch all tickets from API
  Future<void> fetchTicketsByCustomerId(String customerId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final ApiResponse response = await _apiService.getTicketByUserId(customerId);

      if (response.status == 200 && response.listData != null) {
        final json = response.listData!;
        _allTickets = json
            .map((e) => RaisedTicketsById.fromJson(e as Map<String, dynamic>))
            .toList();
        applyFilters(); // Refresh UI with latest filters
      } else {
        // API call succeeded but no data or known error
        _allTickets = [];
        _filteredTickets = [];
        debugPrint('fetchTicketsByCustomerId: No tickets found or API returned non-200');
      }
    } catch (error) {
      // Handle network/API errors
      _allTickets = [];
      _filteredTickets = [];

      String errorMessage = "Failed to load tickets.";
      if (error is ApiException) {
        errorMessage = error.message ?? errorMessage;
      } else if (error is DioException) {
        errorMessage = error.message ?? errorMessage;
      }

      debugPrint('Exception in fetchTicketsByCustomerId: $errorMessage');
      // Optionally: show error to user
      // showSnackBar(context, errorMessage); // <- pass context if needed
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  /// Apply temporary filters to actual list
  void applyFilters() {
    _selectedStatus = tempStatus;
    _sortOrder = tempSortOrder;

    _filteredTickets = _allTickets;

    if (_selectedStatus.isNotEmpty) {
      _filteredTickets = _filteredTickets
          .where((ticket) => ticket.ticketStatus == _selectedStatus)
          .toList();
    }

    _filteredTickets.sort((a, b) {
      final dateA = a.createdDate ?? DateTime.now();
      final dateB = b.createdDate ?? DateTime.now();
      return _sortOrder == 'asc'
          ? dateA.compareTo(dateB)
          : dateB.compareTo(dateA);
    });

    notifyListeners();
  }

  /// Clear all filters
  void clearFilters() {
    tempStatus = '';
    tempSortOrder = 'desc';
    applyFilters();
  }

  /// Update temporary status
  void setTempStatus(String status) {
    tempStatus = status;
    notifyListeners();
  }

  /// Update temporary sort order
  void setTempSortOrder(String order) {
    tempSortOrder = order;
    notifyListeners();
  }

  /// Optionally: expose currently applied status/sort (for UI)
  String get selectedStatus => _selectedStatus;
  String get selectedSortOrder => _sortOrder;
}



