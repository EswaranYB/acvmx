

class TicketByIdResponse {
  int id;
  String uniqueId;
  String jobId;
  String ticketId;
  String productId;
  String problems;
  String comments;
  String image;
  String video;
  String ticketStatus;
  String jobAssignedTime;
  String ticketAssignedTo;
  String usersId;
  String createdDate;
  String jobAssignedDate;
  String createdBy;
  String updatedDate;
  String updatedBy;
  int deletedStatus;
  String? jobUniqueId;
  TicketByIdResponse({
    required this.id,
    required this.jobId,
    required this.uniqueId,
    required this.ticketId,
    required this.productId,
    required this.problems,
    required this.comments,
    required this.jobAssignedDate,
    required this.image,
    required this.video,
    required this.ticketStatus,
    required this.ticketAssignedTo,
    required this.usersId,
    required this.createdDate,
    required this.createdBy,
    required this.updatedDate,
    required this.updatedBy,
    required this.deletedStatus,
    required this.jobUniqueId,
    required this.jobAssignedTime,
  });

  factory TicketByIdResponse.fromJson(Map<String, dynamic> json) => TicketByIdResponse(
    id: int.parse(json["id"].toString()),
    uniqueId: json["unique_id"]??"",
    ticketId: json["ticket_id"]??"",
    productId: json["product_id"]??"",
    problems: json["problems"]??"",
    jobId: json["job_id"]??"",
    comments: json["comments"]??"",
    image: json["image"]??"",
    video: json["video"]??"",
    ticketStatus: json["ticket_status"]??"",
    ticketAssignedTo: json["ticket_assigned_to"]??"",
    usersId: json["users_id"]??"",
    createdDate: json["created_date"]??"",
    jobAssignedDate: json["job_assigned_date"]??"",
    createdBy: json["created_by"]??"",
    updatedDate: json["updated_date"]??"",
    updatedBy: json["updated_by"]??"",
    deletedStatus: json["deleted_status"]??0,
    jobUniqueId: json["job_unique"]??"",
    jobAssignedTime: json["job_assigned_time"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "unique_id": uniqueId,
    "ticket_id": ticketId,
    "product_id": productId,
    "job_id": jobId,
    "problems": problems,
    "comments": comments,
    "image": image,
    "video": video,
    "ticket_status": ticketStatus,
    "ticket_assigned_to": ticketAssignedTo,
    "users_id": usersId,
    "created_date": createdDate,
    "job_assigned_date": jobAssignedDate,
    "created_by": createdBy,
    "updated_date": updatedDate,
    "updated_by": updatedBy,
    "deleted_status": deletedStatus,
    "job_unique": jobUniqueId,
    "job_assigned_time": jobAssignedTime,
  };
}
