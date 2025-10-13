import 'dart:io';
import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  // Factory constructor to create an ApiException from DioError
  factory ApiException.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        return ApiException("Request to API server was cancelled.");
      case DioExceptionType.connectionTimeout:
        return ApiException("Connection timeout with API server.");
      case DioExceptionType.receiveTimeout:
        return ApiException("Receive timeout in connection with API server.");
      case DioExceptionType.sendTimeout:
        return ApiException("Send timeout in connection with API server.");
      case DioExceptionType.badResponse:
        return ApiException(_handleResponseError(dioError.response));
      case DioExceptionType.unknown:
        if (dioError.error is SocketException) {
          return ApiException("No Internet connection.");
        }
        return ApiException("Unexpected error occurred.");
      default:
        return ApiException("Something went wrong.");
    }
  }

  // Handle response errors based on status codes
  static String _handleResponseError(Response? response) {
    if (response == null) {
      return "Received invalid status code.";
    }

    switch (response.statusCode) {
      case 400:
        return 'Bad Request.';
      case 401:
        return 'Unauthorized. Please check your credentials.';
      case 403:
        return 'Forbidden. You do not have access.';
      case 404:
        return 'Not Found. The requested resource does not exist.';
      case 408:
        return 'Request Timeout. Please try again later.';
      case 500:
        return 'Internal Server Error. Please try again later.';
      case 502:
        return 'Bad Gateway.';
      case 503:
        return 'Service Unavailable.';
      case 504:
        return 'Gateway Timeout.';
      default:
        return response.statusMessage ?? "Received invalid status code.";
    }
  }

  @override
  String toString() => message;
}