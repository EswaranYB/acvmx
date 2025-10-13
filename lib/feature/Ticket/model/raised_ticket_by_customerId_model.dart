class RaisedTicketsById {
  int? id;
  String? uniqueId;
  String? ticketId;
  String? productId; // Changed from enum to String
  String? problems;
  String? comments;
  String? image;
  String? video;
  String? ticketStatus; // Changed from enum to String
  String? ticketAssignedTo;
  String? usersId;
  DateTime? createdDate;
  String? createdBy;
  DateTime? updatedDate;
  dynamic updatedBy;
  int? deletedStatus;
  String? jobId;
  String? location; // Changed from enum to String

  RaisedTicketsById({
    this.id,
    this.uniqueId,
    this.ticketId,
    this.productId,
    this.problems,
    this.comments,
    this.image,
    this.video,
    this.ticketStatus,
    this.ticketAssignedTo,
    this.usersId,
    this.createdDate,
    this.createdBy,
    this.updatedDate,
    this.updatedBy,
    this.deletedStatus,
    this.jobId,
    this.location,
  });

  factory RaisedTicketsById.fromJson(Map<String, dynamic> json) =>
      RaisedTicketsById(
        id: json["id"],
        uniqueId: json["unique_id"],
        ticketId: json["ticket_id"],
        productId: json["product_id"],
        problems: json["problems"],
        comments: json["comments"],
        image: json["image"],
        video: json["video"],
        ticketStatus: json["ticket_status"],
        ticketAssignedTo: json["ticket_assigned_to"]?.toString(),
        usersId: json["users_id"],
        createdDate: DateTime.tryParse(json["created_date"] ?? ''),
        createdBy: json["created_by"]?.toString(),
        updatedDate: DateTime.tryParse(json["updated_date"] ?? ''),
        updatedBy: json["updated_by"],
        deletedStatus: json["deleted_status"],
        jobId: json["job_id"]?.toString(),
        location: json["location"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "unique_id": uniqueId,
        "ticket_id": ticketId,
        "product_id": productId,
        "problems": problems,
        "comments": comments,
        "image": image,
        "video": video,
        "ticket_status": ticketStatus,
        "ticket_assigned_to": ticketAssignedTo,
        "users_id": usersId,
        "created_date": createdDate?.toIso8601String(),
        "created_by": createdBy,
        "updated_date": updatedDate?.toIso8601String(),
        "updated_by": updatedBy,
        "deleted_status": deletedStatus,
        "job_id": jobId,
        "location": location,
      };
}
