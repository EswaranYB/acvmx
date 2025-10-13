import 'package:flutter/cupertino.dart';

import '../../../Network/api_manager.dart';
import '../../../Network/api_response.dart';
import '../../../Network/api_service.dart';
import '../../../core/helper/app_log.dart';
import '../../Ticket/model/ticket_by_id_response.dart';


// class GetTicketByTechnicianJobController with ChangeNotifier {
//   final BaseApiManager apiManager = BaseApiManager();
//   late final ApiServices _apiServices;
//
//   GetTicketByTechnicianJobController() {
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