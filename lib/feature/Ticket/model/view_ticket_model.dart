// // class TicketDetailsByIdResponse {
// //   UserDetails? userDetails;
// //   AssignedTicket? ticket;
// //
// //   TicketDetailsByIdResponse({
// //     this.ticket,
// //     this.userDetails,
// //   });
// //
// //   factory TicketDetailsByIdResponse.fromJson(Map<String, dynamic> json) => TicketDetailsByIdResponse(
// //     userDetails: json["user_details"]== null ? null : UserDetails.fromJson(json["user_details"]),
// //     ticket: json["ticket"] == null ? null : AssignedTicket.fromJson(json["ticket"]),
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "ticket": ticket?.toJson(),
// //     "user_details": userDetails?.toJson(),
// //   };
// // }
// class TicketDetailsByIdResponse {
//   final int status;
//   final String? message;
//   final TicketDetailsByIdData? data;
//
//   TicketDetailsByIdResponse({
//     required this.status,
//     this.message,
//     this.data,
//   });
//
//   factory TicketDetailsByIdResponse.fromJson(Map<String, dynamic> json) =>
//       TicketDetailsByIdResponse(
//         status: json['status'] ?? 0,
//         message: json['message'],
//         data: json['data'] != null
//             ? TicketDetailsByIdData.fromJson(json['data'])
//             : null,
//       );
//
//   Map<String, dynamic> toJson() => {
//     'status': status,
//     'message': message,
//     'data': data?.toJson(),
//   };
// }
//
// class TicketDetailsByIdData {
//   final UserDetails? userDetails;
//   final AssignedTicket? ticket;
//   final List<dynamic> updates;
//
//   TicketDetailsByIdData({
//     this.userDetails,
//     this.ticket,
//     required this.updates,
//   });
//
//   factory TicketDetailsByIdData.fromJson(Map<String, dynamic> json) {
//     final userRaw = json["user_details"];
//     return TicketDetailsByIdData(
//       userDetails: (userRaw is Map<String, dynamic>) ? UserDetails.fromJson(userRaw) : null,
//       ticket: json["ticket"] != null ? AssignedTicket.fromJson(json["ticket"]) : null,
//       updates: json["updates"] ?? [],
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     "user_details": userDetails?.toJson(),
//     "ticket": ticket?.toJson(),
//     "updates": updates,
//   };
// }
//
//
//
// class AssignedTicket {
//   int? id;
//   String? uniqueId;
//   String? ticketId;
//   String? productId;
//   String? problems;
//   String? comments;
//   String? video;
//   String? ticketStatus;
//   dynamic ticketAssignedTo;
//   String? usersId;
//   DateTime? createdDate;
//   String? createdBy;
//   DateTime? updatedDate;
//   dynamic updatedBy;
//   int? deletedStatus;
//   dynamic jobId;
//   String? locationLongitude;
//   String? locationLatitude;
//
//   AssignedTicket({
//     this.id,
//     this.uniqueId,
//     this.ticketId,
//     this.productId,
//     this.problems,
//     this.comments,
//     this.video,
//     this.ticketStatus,
//     this.ticketAssignedTo,
//     this.usersId,
//     this.createdDate,
//     this.createdBy,
//     this.updatedDate,
//     this.updatedBy,
//     this.deletedStatus,
//     this.jobId,
//     this.locationLatitude,
//     this.locationLongitude
//   });
//
//   factory AssignedTicket.fromJson(Map<String, dynamic> json) => AssignedTicket(
//       id: json["id"],
//       uniqueId: json["unique_id"],
//       ticketId: json["ticket_id"],
//       productId: json["product_id"],
//       problems: json["problems"],
//       comments: json["comments"],
//       video: json["video"] is String
//           ? json["video"]
//           : (json["video"] != null ? json["video"]["url"] : null),
//       ticketStatus: json["ticket_status"],
//       ticketAssignedTo: json["ticket_assigned_to"],
//       usersId: json["users_id"],
//       createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
//       createdBy: json["created_by"],
//       updatedDate: json["updated_date"] == null ? null : DateTime.parse(json["updated_date"]),
//       updatedBy: json["updated_by"],
//       deletedStatus: json["deleted_status"],
//       jobId: json["job_id"],
//       locationLatitude: json["location_latitude"],
//       locationLongitude: json["location_longitude"]
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "unique_id": uniqueId,
//     "ticket_id": ticketId,
//     "product_id": productId,
//     "problems": problems,
//     "comments": comments,
//     "video": video,
//     "ticket_status": ticketStatus,
//     "ticket_assigned_to": ticketAssignedTo,
//     "users_id": usersId,
//     "created_date": createdDate?.toIso8601String(),
//     "created_by": createdBy,
//     "updated_date": updatedDate?.toIso8601String(),
//     "updated_by": updatedBy,
//     "deleted_status": deletedStatus,
//     "job_id": jobId,
//   };
// }
//
//
// class UserDetails {
//   int? id;
//   String? uniqueId;
//   String? usersId;
//   String? firstName;
//   String? lastName;
//   String? username;
//   String? password;
//   String? email;
//   String? phoneNumber;
//   String? gender;
//   String? city;
//   String? postalCode; // CHANGED to String?
//   String? address;
//   String? image;
//   DateTime? createdDate;
//   int? deletedStatus;
//
//   UserDetails({
//     this.id,
//     this.uniqueId,
//     this.usersId,
//     this.firstName,
//     this.lastName,
//     this.username,
//     this.password,
//     this.email,
//     this.phoneNumber,
//     this.gender,
//     this.city,
//     this.postalCode,
//     this.address,
//     this.image,
//     this.createdDate,
//     this.deletedStatus,
//   });
//
//   factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
//     id: json["id"],
//     uniqueId: json["unique_id"],
//     usersId: json["users_id"],
//     firstName: json["first_name"],
//     lastName: json["last_name"],
//     username: json["username"],
//     password: json["password"],
//     email: json["email"],
//     phoneNumber: json["phone_number"],
//     gender: json["gender"],
//     city: json["city"],
//     postalCode: json["postal_code"]?.toString(), // force to String
//     address: json["address"],
//     image: json["image"],
//     createdDate: json["created_date"] == null
//         ? null
//         : DateTime.tryParse(json["created_date"]),
//     deletedStatus: json["deleted_status"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "unique_id": uniqueId,
//     "users_id": usersId,
//     "first_name": firstName,
//     "last_name": lastName,
//     "username": username,
//     "password": password,
//     "email": email,
//     "phone_number": phoneNumber,
//     "gender": gender,
//     "city": city,
//     "postal_code": postalCode,
//     "address": address,
//     "image": image,
//     "created_date": createdDate?.toIso8601String(),
//     "deleted_status": deletedStatus,
//   };
// }
//
//
//
//
//
//
// // TicketDetailsByIdResponse loginResponseFromJson(String str) => TicketDetailsByIdResponse.fromJson(json.decode(str));
// //
// // String loginResponseToJson(TicketDetailsByIdResponse data) => json.encode(data.toJson());
// //
// // class TicketDetailsByIdResponse {
// //   final int status;
// //   final String message;
// //   final TicketDetailsByIdData? data;
// //
// //   TicketDetailsByIdResponse({
// //     required this.status,
// //     required this.message,
// //     required this.data,
// //   });
// //
// //   factory TicketDetailsByIdResponse.fromJson(Map<String, dynamic> json) =>
// //       TicketDetailsByIdResponse(
// //         status: json["status"],
// //         message: json["message"],
// //         data: json["data"] != null ? TicketDetailsByIdData.fromJson(json["data"]) : null,
// //       );
// //
// //   Map<String, dynamic> toJson() => {
// //     "status": status,
// //     "message": message,
// //     "data": data?.toJson(),
// //   };
// // }
// //
// //
// // class TicketDetailsByIdData {
// //   UserDetails userDetails;
// //   AssignedTicket ticket;
// //   List<dynamic> updates;
// //
// //   TicketDetailsByIdData({
// //     required this.userDetails,
// //     required this.ticket,
// //     required this.updates,
// //   });
// //
// //   factory TicketDetailsByIdData.fromJson(Map<String, dynamic> json) => TicketDetailsByIdData(
// //     userDetails: UserDetails.fromJson(json["user_details"]),
// //     ticket: AssignedTicket.fromJson(json["ticket"]),
// //     updates: List<dynamic>.from(json["updates"].map((x) => x)),
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "user_details": userDetails.toJson(),
// //     "ticket": ticket.toJson(),
// //     "updates": List<dynamic>.from(updates.map((x) => x)),
// //   };
// // }
// //
// // class AssignedTicket {
// //   int id;
// //   String uniqueId;
// //   String ticketId;
// //   String productId;
// //   String problems;
// //   String comments;
// //   String video;
// //   String ticketStatus;
// //   String ticketAssignedTo;
// //   String usersId;
// //   DateTime createdDate;
// //   String createdBy;
// //   DateTime updatedDate;
// //   dynamic updatedBy;
// //   int deletedStatus;
// //   String jobId;
// //
// //   AssignedTicket({
// //     required this.id,
// //     required this.uniqueId,
// //     required this.ticketId,
// //     required this.productId,
// //     required this.problems,
// //     required this.comments,
// //     required this.video,
// //     required this.ticketStatus,
// //     required this.ticketAssignedTo,
// //     required this.usersId,
// //     required this.createdDate,
// //     required this.createdBy,
// //     required this.updatedDate,
// //     required this.updatedBy,
// //     required this.deletedStatus,
// //     required this.jobId,
// //   });
// //
// //   factory AssignedTicket.fromJson(Map<String, dynamic> json) => AssignedTicket(
// //     id: json["id"],
// //     uniqueId: json["unique_id"],
// //     ticketId: json["ticket_id"],
// //     productId: json["product_id"],
// //     problems: json["problems"],
// //     comments: json["comments"],
// //     video: json["video"],
// //     ticketStatus: json["ticket_status"],
// //     ticketAssignedTo: json["ticket_assigned_to"],
// //     usersId: json["users_id"],
// //     createdDate: DateTime.parse(json["created_date"]),
// //     createdBy: json["created_by"],
// //     updatedDate: DateTime.parse(json["updated_date"]),
// //     updatedBy: json["updated_by"],
// //     deletedStatus: json["deleted_status"],
// //     jobId: json["job_id"],
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "id": id,
// //     "unique_id": uniqueId,
// //     "ticket_id": ticketId,
// //     "product_id": productId,
// //     "problems": problems,
// //     "comments": comments,
// //     "video": video,
// //     "ticket_status": ticketStatus,
// //     "ticket_assigned_to": ticketAssignedTo,
// //     "users_id": usersId,
// //     "created_date": createdDate.toIso8601String(),
// //     "created_by": createdBy,
// //     "updated_date": updatedDate.toIso8601String(),
// //     "updated_by": updatedBy,
// //     "deleted_status": deletedStatus,
// //     "job_id": jobId,
// //   };
// // }
// //
// // class UserDetails {
// //   int id;
// //   String uniqueId;
// //   String companyId;
// //   String branchId;
// //   String usersId;
// //   String firstName;
// //   String lastName;
// //   String username;
// //   String password;
// //   String email;
// //   String phoneNumber;
// //   String gender;
// //   String city;
// //   String postalCode;
// //   String address;
// //   String image;
// //   DateTime createdDate;
// //   int deletedStatus;
// //
// //   UserDetails({
// //     required this.id,
// //     required this.uniqueId,
// //     required this.companyId,
// //     required this.branchId,
// //     required this.usersId,
// //     required this.firstName,
// //     required this.lastName,
// //     required this.username,
// //     required this.password,
// //     required this.email,
// //     required this.phoneNumber,
// //     required this.gender,
// //     required this.city,
// //     required this.postalCode,
// //     required this.address,
// //     required this.image,
// //     required this.createdDate,
// //     required this.deletedStatus,
// //   });
// //
// //   factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
// //     id: json["id"],
// //     uniqueId: json["unique_id"],
// //     companyId: json["company_id"],
// //     branchId: json["branch_id"],
// //     usersId: json["users_id"],
// //     firstName: json["first_name"],
// //     lastName: json["last_name"],
// //     username: json["username"],
// //     password: json["password"],
// //     email: json["email"],
// //     phoneNumber: json["phone_number"],
// //     gender: json["gender"],
// //     city: json["city"],
// //     postalCode: json["postal_code"],
// //     address: json["address"],
// //     image: json["image"],
// //     createdDate: DateTime.parse(json["created_date"]),
// //     deletedStatus: json["deleted_status"],
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "id": id,
// //     "unique_id": uniqueId,
// //     "company_id": companyId,
// //     "branch_id": branchId,
// //     "users_id": usersId,
// //     "first_name": firstName,
// //     "last_name": lastName,
// //     "username": username,
// //     "password": password,
// //     "email": email,
// //     "phone_number": phoneNumber,
// //     "gender": gender,
// //     "city": city,
// //     "postal_code": postalCode,
// //     "address": address,
// //     "image": image,
// //     "created_date": createdDate.toIso8601String(),
// //     "deleted_status": deletedStatus,
// //   };
// // }

class TicketDetailsByIdResponse {
  AssignedTicket? ticket;
  UserDetails? userDetails;
  List<Updates>? updates;

  TicketDetailsByIdResponse({
    this.ticket,
    this.userDetails,
    this.updates,
  });

  factory TicketDetailsByIdResponse.fromJson(Map<String, dynamic> json) =>
      TicketDetailsByIdResponse(
        ticket: json["ticket"] == null
            ? null
            : AssignedTicket.fromJson(json["ticket"]),
        userDetails: json["user_details"] is Map<String, dynamic>
            ? UserDetails.fromJson(json["user_details"])
            : null,
        updates: json["updates"] is List
            ? List<Updates>.from(
            json["updates"].map((x) => Updates.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
    "ticket": ticket?.toJson(),
    "user_details": userDetails?.toJson(),
    "updates": updates == null
        ? []
        : List<dynamic>.from(updates!.map((x) => x.toJson())),
  };
}

class AssignedTicket {
  int? id;
  String? uniqueId;
  String? ticketId;
  String? productId;
  String? problems;
  String? comments;
  String? remarks;
  String? video;
  String? ticketStatus;
  dynamic ticketAssignedTo;
  String? usersId;
  DateTime? createdDate;
  String? createdBy;
  DateTime? updatedDate;
  dynamic updatedBy;
  int? deletedStatus;
  dynamic jobId;
  String? location;
  String? locationLatitude;
  String? locationLongitude;

  AssignedTicket({
    this.id,
    this.uniqueId,
    this.ticketId,
    this.productId,
    this.problems,
    this.comments,
    this.remarks,
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
    this.locationLatitude,
    this.locationLongitude,
  });

  factory AssignedTicket.fromJson(Map<String, dynamic> json) => AssignedTicket(
    id: json["id"],
    uniqueId: json["unique_id"],
    ticketId: json["ticket_id"],
    productId: json["product_id"],
    problems: json["problems"],
    comments: json["comments"],
    remarks: json["remarks"],
    video: json["video"] is String
        ? json["video"]
        : (json["video"] != null ? json["video"]["url"] : null),
    ticketStatus: json["ticket_status"],
    ticketAssignedTo: json["ticket_assigned_to"],
    usersId: json["users_id"],
    createdDate: json["created_date"] == null
        ? null
        : DateTime.parse(json["created_date"]),
    createdBy: json["created_by"],
    updatedDate: json["updated_date"] == null
        ? null
        : DateTime.parse(json["updated_date"]),
    updatedBy: json["updated_by"],
    deletedStatus: json["deleted_status"],
    jobId: json["job_id"],
    location: json["location"],
    locationLatitude: json["location_latitude"],
    locationLongitude: json["location_longitude"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "unique_id": uniqueId,
    "ticket_id": ticketId,
    "product_id": productId,
    "problems": problems,
    "comments": comments,
    "remarks": remarks,
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
    "location_latitude": locationLatitude,
    "location_longitude": locationLongitude,
  };
}

class UserDetails {
  int? id;
  String? uniqueId;
  String? companyId;
  String? branchId;
  String? usersId;
  String? lotitude;
  String? langitude;
  String? firstName;
  String? lastName;
  String? username;
  String? password;
  String? email;
  String? phoneNumber;
  String? gender;
  String? city;
  String? postalCode;
  String? address;
  String? image;
  DateTime? createdDate;
  int? deletedStatus;

  UserDetails({
    this.id,
    this.uniqueId,
    this.companyId,
    this.branchId,
    this.usersId,
    this.firstName,
    this.lastName,
    this.username,
    this.password,
    this.lotitude,
    this.langitude,
    this.email,
    this.phoneNumber,
    this.gender,
    this.city,
    this.postalCode,
    this.address,
    this.image,
    this.createdDate,
    this.deletedStatus,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
    id: json["id"],
    uniqueId: json["unique_id"],
    companyId: json["company_id"],
    branchId: json["branch_id"],
    usersId: json["users_id"],
    lotitude: json["location_latitude"],
    langitude: json["location_longitude"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    username: json["username"],
    password: json["password"],
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
    deletedStatus: json["deleted_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "unique_id": uniqueId,
    "company_id": companyId,
    "branch_id": branchId,
    "users_id": usersId,
    "location_latitude": lotitude,
    "location_longitude": langitude,
    "first_name": firstName,
    "last_name": lastName,
    "username": username,
    "password": password,
    "email": email,
    "phone_number": phoneNumber,
    "gender": gender,
    "city": city,
    "postal_code": postalCode,
    "address": address,
    "image": image,
    "created_date": createdDate?.toIso8601String(),
    "deleted_status": deletedStatus,
  };
}

class Updates {
  int? id;
  String? jobId;
  String? ticketStatus;
  String? problems;
  String? remarks;
  String? image;
  String? video;
  dynamic updatedBy;
  DateTime? updatedDate;

  Updates({
    this.id,
    this.jobId,
    this.ticketStatus,
    this.problems,
    this.remarks,
    this.image,
    this.video,
    this.updatedBy,
    this.updatedDate,
  });

  factory Updates.fromJson(Map<String, dynamic> json) => Updates(
    id: json["id"],
    jobId: json["job_id"],
    ticketStatus: json["ticket_status"],
    problems: json["problems"],
    remarks: json["remarks"],
    image: json["image"],
    video: json["video"],
    updatedBy: json["updated_by"],
    updatedDate: json["updated_date"] == null
        ? null
        : DateTime.parse(json["updated_date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "job_id": jobId,
    "ticket_status": ticketStatus,
    "problems": problems,
    "remarks": remarks,
    "image": image,
    "video": video,
    "updated_by": updatedBy,
    "updated_date": updatedDate?.toIso8601String(),
  };
}