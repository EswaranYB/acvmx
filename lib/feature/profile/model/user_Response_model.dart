class UserDetailsResponse {
  int? status;
  String? message;
  UserData? data;

  UserDetailsResponse({
    this.status,
    this.message,
    this.data,
  });

  factory UserDetailsResponse.fromJson(Map<String, dynamic> json) =>
      UserDetailsResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : UserData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class UserData {
  int? id;
  String? uniqueId;
  String? employeeId;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? phoneNumber;
  String? gender;
  String? city;
  int? postalCode;
  String? address;
  String? image;
  DateTime? createdDate;
  List<Ticket>? tickets;

  UserData({
    this.id,
    this.uniqueId,
    this.employeeId,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.phoneNumber,
    this.gender,
    this.city,
    this.postalCode,
    this.address,
    this.image,
    this.createdDate,
    this.tickets,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json["id"],
    uniqueId: json["unique_id"],
    employeeId: json["employee_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    username: json["username"],
    email: json["email"],
    phoneNumber: json["phone_number"],
    gender: json["gender"],
    city: json["city"],
    postalCode: json["postal_code"],
    address: json["address"],
    image: json["image"],
    createdDate: json["created_date"] == null
        ? null
        : DateTime.parse(json["created_date"]),
    tickets: json["tickets"] == null
        ? []
        : List<Ticket>.from(
        json["tickets"].map((x) => Ticket.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "unique_id": uniqueId,
    "employee_id": employeeId,
    "first_name": firstName,
    "last_name": lastName,
    "username": username,
    "email": email,
    "phone_number": phoneNumber,
    "gender": gender,
    "city": city,
    "postal_code": postalCode,
    "address": address,
    "image": image,
    "created_date": createdDate?.toIso8601String(),
    "tickets": tickets == null
        ? []
        : List<dynamic>.from(tickets!.map((x) => x.toJson())),
  };
}

class Ticket {
  int? id;
  String? uniqueId;
  String? companyId;
  String? branchId;
  String? ticketId;
  String? productId;
  String? problems;
  String? comments;
  String? image;
  String? video;
  String? ticketStatus;
  String? ticketAssignedTo;
  String? usersId;
  DateTime? createdDate;
  String? createdBy;
  String? createdType;
  String? updatedType;
  DateTime? updatedDate;
  String? updatedBy;
  int? deletedStatus;
  String? jobId;
  String? location;
  String? locationLatitude;
  String? locationLongitude;
  String? latestTicketStatus;

  Ticket({
    this.id,
    this.uniqueId,
    this.companyId,
    this.branchId,
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
    this.createdType,
    this.updatedType,
    this.updatedDate,
    this.updatedBy,
    this.deletedStatus,
    this.jobId,
    this.location,
    this.locationLatitude,
    this.locationLongitude,
    this.latestTicketStatus,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
    id: json["id"],
    uniqueId: json["unique_id"],
    companyId: json["company_id"],
    branchId: json["branch_id"],
    ticketId: json["ticket_id"],
    productId: json["product_id"],
    problems: json["problems"],
    comments: json["comments"],
    image: json["image"],
    video: json["video"],
    ticketStatus: json["ticket_status"],
    ticketAssignedTo: json["ticket_assigned_to"],
    usersId: json["users_id"],
    createdDate: json["created_date"] != null
        ?
    DateTime.parse(json["created_date"]):null,
    createdBy: json["created_by"],
    createdType: json["created_type"],
    updatedType: json["updated_type"],
    updatedDate: json["updated_date"] == null
        ? null
        : DateTime.parse(json["updated_date"]),
    updatedBy: json["updated_by"],
    deletedStatus: json["deleted_status"],
    jobId: json["job_id"],
    location: json["location"],
    locationLatitude: json["location_latitude"],
    locationLongitude: json["location_longitude"],
    latestTicketStatus: json["latest_ticket_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "unique_id": uniqueId,
    "company_id": companyId,
    "branch_id": branchId,
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
    "created_type": createdType,
    "updated_type": updatedType,
    "updated_date": updatedDate?.toIso8601String(),
    "updated_by": updatedBy,
    "deleted_status": deletedStatus,
    "job_id": jobId,
    "location": location,
    "location_latitude": locationLatitude,
    "location_longitude": locationLongitude,
    "latest_ticket_status": latestTicketStatus,
  };
}