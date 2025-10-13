class ApiResponse {
  final int status;
  final String? error;
  final String? message;
  final String? messageTxt;
  final Map<String, dynamic>? data;
  final List<dynamic>? listData;
  final String? dataString;
  final int? dataInteger;
  final double? dataDouble;
  final bool? isValid;
  final String? result;
  final bool? dataSuccess;

  // Constructor using named parameters with default values
  ApiResponse({
    this.status = 200,
    this.error,
    this.message,
    this.messageTxt,
    this.data,
    this.listData,
    this.dataString,
    this.dataInteger,
    this.dataDouble,
    this.isValid,
    this.result,
    this.dataSuccess,
  });

  // Factory constructor for creating a BaseResponse instance from JSON
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? extractedData;
    List<dynamic>? extractedListData;
    String? extractedString;
    int? extractedInteger;
    double? extractedDouble;
    bool? extractedBool;

    if (json['data'] != null) {
      if (json['data'] is String) {
        extractedString = json['data'] as String;
      } else if (json['data'] is Map<String, dynamic>) {
        extractedData = json['data'] as Map<String, dynamic>;
      } else if (json['data'] is List<dynamic>) {
        extractedListData = json['data'] as List<dynamic>;
      } else if (json['data'] is bool) {
        extractedBool = json['data'] as bool;
      } else if (json['data'] is int) {
        extractedInteger = json['data'] as int;
      } else if (json['data'] is double) {
        extractedDouble = json['data'] as double;
      }
    } else if (json['Records'] != null) {
      if (json['Records'] is Map<String, dynamic>) {
        extractedData = json['Records'] as Map<String, dynamic>;
      } else if (json['Records'] is List<dynamic>) {
        extractedListData = json['Records'] as List<dynamic>;
      }
    } else if (json['Result'] != null) {
      if (json['Result'] is String) {
        extractedString = json['Result'] as String;
      } else if (json['Result'] is List<dynamic>) {
        extractedListData = json['Result'] as List<dynamic>;
      }
    }

    return ApiResponse(
      status: json['status'] ?? 200,
      error: json['error'] as String?,
      message: json['message'] as String?,
      messageTxt: json['MessageText'] as String?,
      data: extractedData,
      listData: extractedListData,
      dataString: extractedString,
      dataInteger: extractedInteger,
      dataDouble: extractedDouble,
      isValid: json['IsValid'] as bool?,
      result: extractedString,
      dataSuccess: extractedBool,
    );
  }

  // Method to convert BaseResponse instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'error': error,
      'message': message,
      'MessageText': messageTxt,
      'data': data ??
          listData ??
          dataString ??
          dataInteger ??
          dataDouble ??
          dataSuccess,
      'IsValid': isValid,
      'Result': result,
    };
  }

  @override
  String toString() {
    return 'ApiResponse{status: $status, error: $error, message: $message, data: $data, listData: $listData, dataString: $dataString, dataInteger: $dataInteger, dataDouble: $dataDouble, isValid: $isValid, result: $result, dataSuccess: $dataSuccess}';
  }
}
