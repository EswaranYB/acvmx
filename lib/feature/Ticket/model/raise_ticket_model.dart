import 'dart:io';

import 'package:dio/dio.dart';

class RaiseTicketRequest {
  final String id;
  final String productId;
  final String problems;
  final String comments;
  final String location;
  final File? video;
  final String priority_type;

  RaiseTicketRequest({
    required this.id,
    required this.productId,
    required this.problems,
    required this.comments,
    required this.location,
    required this.priority_type,
    this.video,
  });

  Map<String, dynamic> toJson() => {
        "user_id": id,
        "product_id": productId,
        "problems": problems,
        "comments": comments,
        "location": location,
        "priority_type":priority_type

        // video is not included here since files can't be directly serialized to JSON
      };

  /// To send this with Dio as multipart form data
  Future<FormData> toFormData() async {
    return FormData.fromMap({
      "user_id": id,
      "product_id": productId,
      "problems": problems,
      "comments": comments,
      "location": location,
      "priority_type":priority_type,
      if (video != null)
        "video": await MultipartFile.fromFile(video!.path,
            filename: video!.path.split('/').last),
    });
  }
}

class RaiseTicketResponse {
  String? ticketId;
  String? imageUrl;
  String? videoUrl;

  RaiseTicketResponse({
    this.ticketId,
    this.imageUrl,
    this.videoUrl,
  });

  factory RaiseTicketResponse.fromJson(Map<String, dynamic> json) =>
      RaiseTicketResponse(
        ticketId: json["ticket_id"],
        imageUrl: json["image_url"],
        videoUrl: json["video_url"],
      );

  Map<String, dynamic> toJson() => {
        "ticket_id": ticketId,
        "image_url": imageUrl,
        "video_url": videoUrl,
      };
}
