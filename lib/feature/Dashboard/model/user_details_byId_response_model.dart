
import 'dart:convert';

UserDetailsByIdResponse userDetailsByIdResponseFromJson(String str) => UserDetailsByIdResponse.fromJson(json.decode(str));

String userDetailsByIdResponseToJson(UserDetailsByIdResponse data) => json.encode(data.toJson());

class UserDetailsByIdResponse {
  int? id;
  String? uniqueId;
  String? usersId;
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

  UserDetailsByIdResponse({
    this.id,
    this.uniqueId,
    this.usersId,
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
  });

  factory UserDetailsByIdResponse.fromJson(Map<String, dynamic> json) => UserDetailsByIdResponse(
    id: json["id"],
    uniqueId: json["unique_id"],
    usersId: json["users_id"],
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
    createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "unique_id": uniqueId,
    "users_id": usersId,
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
  };
}
