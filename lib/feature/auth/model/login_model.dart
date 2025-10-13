class UserModel {
  final String email;
  final String password;
  final String userType;

  UserModel(
      {required this.email, required this.password, required this.userType});

  // Convert UserModel to a map
  Map<String, String> toMap() {
    return {
      'email': email,
      'password': password,
      'userType': userType,
    };
  }

  // Create UserModel from a map
  factory UserModel.fromMap(Map<String, String> map) {
    return UserModel(
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      userType: map['userType'] ?? '',
    );
  }
}

class LoginRequest {
  String username;
  String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
        username: json["username"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
      };
}

class LoginResponse {
  String id;
  String uniqueId;
  String username;
  String email;
  String token;
  String user_type;
  String firstName;
  String lastName;

  LoginResponse({
    required this.id,
    required this.uniqueId,
    required this.username,
    required this.email,
    required this.user_type,
    required this.token,
    required this.firstName,
    required this.lastName,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        id: json["id"] ?? "",
        uniqueId: json["user_id"] ?? "",
        username: json["username"] ?? "",
        email: json["email"] ?? "",
        token: json["token"] ?? "",
        user_type: json["user_type"] ?? "",
        firstName: json["first_name"] ?? "",
        lastName: json["last_name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": uniqueId,
        "username": username,
        "email": email,
        "token": token,
        "user_type": user_type,
        "first_name": firstName,
        "last_name": lastName,
      };
}
