import 'dart:convert';

class NotificationListModel {
  final int status;
  final String message;
  final List<NotificationData> data;

  NotificationListModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory NotificationListModel.fromJson(Map<String, dynamic> json) => NotificationListModel(
    status: json['status'],
    message: json['message'],
    data: List<NotificationData>.from(
        json['data'].map((x) => NotificationData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class NotificationData {
  final int id;
  final String uniqueId;
  final String ticketId;
  final String senderId;
  final String receiverId;
  final String notificationType;
  final String type;
  final int status;
  final int deletedStatus;
  final String message;
  final String createdAt;

  NotificationData({
    required this.id,
    required this.uniqueId,
    required this.ticketId,
    required this.senderId,
    required this.receiverId,
    required this.notificationType,
    required this.type,
    required this.status,
    required this.deletedStatus,
    required this.message,
    required this.createdAt,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    id: json['id'] ?? 0,
    uniqueId: json['unique_id'] ?? '',
    ticketId: json['ticket_id'].toString(),
    senderId: json['sender_id'].toString(),
    receiverId: json['receiver_id'].toString(),
    notificationType: json['notification_type'] ?? '',
    type: json['type'] ?? '',
    status: json['status'] ?? 0,
    deletedStatus: json['deleted_status'] ?? 0,
    message: json['message'] ?? '',
    createdAt: json['created_at'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'unique_id': uniqueId,
    'ticket_id': ticketId,
    'sender_id': senderId,
    'receiver_id': receiverId,
    'notification_type': notificationType,
    'type': type,
    'status': status,
    'deleted_status': deletedStatus,
    'message': message,
    'created_at': createdAt,
  };
}