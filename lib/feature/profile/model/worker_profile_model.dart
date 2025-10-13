// To parse this JSON data, do
//
//     final technicianDetailsByIdResponse = technicianDetailsByIdResponseFromJson(jsonString);

import 'dart:convert';

TechnicianDetailsByIdResponse technicianDetailsByIdResponseFromJson(String str) => TechnicianDetailsByIdResponse.fromJson(json.decode(str));

String technicianDetailsByIdResponseToJson(TechnicianDetailsByIdResponse data) => json.encode(data.toJson());

class TechnicianDetailsByIdResponse {
  int? id;
  String? uniqueId;
  String? employeeId;
  String? firstName;
  String? lastName;
  String? status;
  String? username;
  String? email;
  String? phoneNumber;
  dynamic gender;
  String? city;
  int? postalCode;
  String? address;
  String? image;
  DateTime? createdDate;

  TechnicianDetailsByIdResponse({
    this.id,
    this.uniqueId,
    this.employeeId,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.status,
    this.phoneNumber,
    this.gender,
    this.city,
    this.postalCode,
    this.address,
    this.image,
    this.createdDate,
  });

  factory TechnicianDetailsByIdResponse.fromJson(Map<String, dynamic> json) => TechnicianDetailsByIdResponse(
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
    status: json["active_status"],
    postalCode: json["postal_code"],
    address: json["address"],
    image: json["image"],
    createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
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
    "active_status": status,
    "created_date": createdDate?.toIso8601String(),
  };
}
