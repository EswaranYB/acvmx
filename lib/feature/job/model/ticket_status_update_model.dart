import 'package:dio/dio.dart';

class TicketUpdateRequest {
  final String ticketId;
  final String status;
  final String uniqueId;

  TicketUpdateRequest({
    required this.status,
    required this.ticketId,
    required this.uniqueId,
  });

  Map<String, dynamic> toJson() => {
    "ticket_id":ticketId , // ensure uppercase
    "ticket_accept_status":status , // ensure uppercase
    "job_unique_id":uniqueId , // ensure uppercase
  };

  /// To send via Dio as multipart/form-data
  Future<FormData> toFormData() async {
    return FormData.fromMap({
      "ticket_id": ticketId,
      "ticket_accept_status": status,
      "job_unique_id":uniqueId ,
    });
  }
}
class  TicketUpdateResponse{
  final int? status;
  final String? message;
  final String? data;

  TicketUpdateResponse({
    this.status,
    this.message,
    this.data,
  });

  factory TicketUpdateResponse.fromJson(Map<String, dynamic> json) {
    return TicketUpdateResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data,
  };
}