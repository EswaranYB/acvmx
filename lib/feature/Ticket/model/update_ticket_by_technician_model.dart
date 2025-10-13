import 'dart:io';
import 'package:dio/dio.dart';

class TicketStatusUpdateRequest {
  final String ticketId;
  final String jobId;
  final String ticketStatus;
  final String remark;
  final String userId;
  final String? title;
  final File? video;

  final List<String> employeeStockUniqueIds;
  final List<String> usedItemQty;

  TicketStatusUpdateRequest({
    required this.ticketId,
    required this.jobId,
    required this.ticketStatus,
    required this.remark,
    required this.userId,
    this.title,
    this.video,
    this.employeeStockUniqueIds = const [],
    this.usedItemQty = const [],
  });

  Map<String, dynamic> toJson() => {
    "ticket_id": ticketId,
    "job_id": jobId,
    "ticket_status": ticketStatus,
    "remark": remark,
    "user_id": userId,
    "title": title,
    "employee_stock_unique_id": employeeStockUniqueIds,
    "used_item_qty": usedItemQty,
  };

  Future<FormData> toFormData() async {
    final formData = FormData();

    // Normal text fields
    formData.fields.add(MapEntry('ticket_id', ticketId));
    formData.fields.add(MapEntry('job_id', jobId));
    formData.fields.add(MapEntry('ticket_status', ticketStatus));
    formData.fields.add(MapEntry('remark', remark));
    formData.fields.add(MapEntry('user_id', userId));
    if (title != null) {
      formData.fields.add(MapEntry('title', title!));
    }

    for (final id in employeeStockUniqueIds) {
      formData.fields.add(MapEntry('employee_stock_unique_id[]', id));
    }
    for (final qty in usedItemQty) {
      formData.fields.add(MapEntry('used_item_qty[]', qty));
    }

    if (video != null) {
      formData.files.add(
        MapEntry(
          'video',
          await MultipartFile.fromFile(
            video!.path,
            filename: video!.path.split('/').last,
          ),
        ),
      );
    }

    return formData;
  }
}

class TicketStatusUpdateResponse {
  final String? videoUrl;

  TicketStatusUpdateResponse({this.videoUrl});

  factory TicketStatusUpdateResponse.fromJson(Map<String, dynamic> json) {
    return TicketStatusUpdateResponse(
      videoUrl: json['data']?['video_url'],
    );
  }

  Map<String, dynamic> toJson() => {
    "video_url": videoUrl,
  };
}