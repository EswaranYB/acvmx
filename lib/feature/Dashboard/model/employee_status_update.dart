import 'package:dio/dio.dart';

class StatusUpdateRequest {
  final String status; // ACTIVE / INACTIVE

  StatusUpdateRequest({
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    "active_status": status.toUpperCase(), // ensure uppercase
  };

  /// To send via Dio as multipart/form-data
  Future<FormData> toFormData() async {
    return FormData.fromMap({
      "active_status": status.toUpperCase(),
    });
  }
}
class StatusUpdateResponse {
  final int? status;
  final String? message;

  StatusUpdateResponse({
    this.status,
    this.message,
  });

  factory StatusUpdateResponse.fromJson(Map<String, dynamic> json) {
    return StatusUpdateResponse(
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}