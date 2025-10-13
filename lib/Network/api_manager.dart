// base_api_manager.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:acvmx/core/app_decoration.dart';
import 'package:acvmx/core/appstring.dart';
import 'package:dio/dio.dart';

import '../core/helper/app_log.dart';
import '../core/sharedpreferences/sharedpreferences_services.dart';
import 'api_error.dart';
import 'api_response.dart';

class BaseApiManager {
  // Singleton instance
  static final BaseApiManager _instance = BaseApiManager._internal();

  factory BaseApiManager() => _instance;

  late final Dio dio;

  BaseApiManager._internal() {
    dio = Dio(BaseOptions(
      baseUrl: _getBaseUrl(),
      connectTimeout: const Duration(seconds: 5000), // Adjusted timeout
      receiveTimeout: const Duration(seconds: 5000),
      responseType: ResponseType.plain, // Changed to JSON for automatic parsing
      validateStatus: (status) {
        return status != null && status >= 200 && status < 400;
      },
    ));

    _setAuthorizationHeader();

    // Add interceptors
    dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
      LogInterceptor(
        request: false, // Disable if not needed
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        logPrint: AppLog.dObj,
      ),
    ]);
  }

  /// Retrieves the base URL based on environment or configuration.
  String _getBaseUrl() {
    return Constants.baseUrl;
  }

  /// Sets the Authorization header if the access token exists.
  void _setAuthorizationHeader() {
    const token = "";
    if (token.isNotEmpty) {
      dio.options.headers["Authorization"] = "Bearer $token";
      // Optionally, set content-type if needed
      dio.options.headers["Content-Type"] = "application/json";
    }
  }

  /// Request Interceptor
  void _onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLog.d("Request: [${options.method}] ${options.baseUrl}${options.path}");
    AppLog.d("Headers: ${options.headers}");
    AppLog.d("Data: ${options.data}");
    handler.next(options); // Continue with the request
  }

  /// Response Interceptor
  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLog.d(
        "Response: [${response.statusCode}] ${response.requestOptions.method} ${response.requestOptions.path}");
    AppLog.d("Data: ${response.data}");
    handler.next(response); // Continue with the response
  }


  /// Error Interceptor with Token Refresh Logic
  Future<void> _onError(
      DioException err, ErrorInterceptorHandler handler) async {
    AppLog.d("Error: ${err.message}");
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final newToken = await _refreshToken();
        if (newToken != null) {
          // Retry the failed request with the new token
          final requestOptions = err.requestOptions;
          requestOptions.headers["Authorization"] = "Bearer $newToken";
          final clonedRequest = await dio.request(
            requestOptions.path,
            options: Options(
              method: requestOptions.method,
              headers: requestOptions.headers,
              contentType: requestOptions.contentType,
            ),
            data: requestOptions.data,
            queryParameters: requestOptions.queryParameters,
          );
          handler.resolve(clonedRequest);
          return;
        }
      } catch (e) {
        AppLog.d("Token refresh failed: $e");
        // Optionally, navigate the user to the login screen or perform other actions
      } finally {
        _isRefreshing = false;
      }
    }
    handler.next(err); // Pass the error to the next interceptor
  }

  bool _isRefreshing = false;
  // final List<Function(String)> _refreshSubscribers = [];

  /// Token Refresh Logic
  Future<String?> _refreshToken() async {
    AppLog.d("Attempting to refresh token...");
    const token = "";
    final url = "${_getBaseUrl()}gateway/token";

    try {
      final response = await dio.post(
        url,
        data: {},
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        final newToken = response.data["data"] as String?;
        if (newToken != null && newToken.isNotEmpty) {
          _setAuthorizationHeader(); // Update Dio instance with new token
          AppLog.d("Token refreshed successfully: $newToken");
          return newToken;
        }
      }
      AppLog.d("Failed to refresh token. Status code: ${response.statusCode}");
      return null;
    } catch (e) {
      AppLog.d("Exception during token refresh: $e");
      return null;
    }
  }

  /// Generic method to execute requests with ApiResponse
  Future<ApiResponse> executeRequest({
    required String method,
    required String url,
    dynamic data,
    Options? options,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await dio.request(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          method: method,
          headers: headers,
        ),
      );

      return _parseResponse(response);
    } on TimeoutException catch (_) {
      throw ApiException("Unexpected error occurred: $_");
    } on SocketException catch (e) {
      throw ApiException("Unexpected error occurred: $e");
    } on DioException catch (dioError) {
      throw ApiException.fromDioError(dioError);
    } catch (e) {
      throw ApiException("Unexpected error occurred: $e");
    }
  }

  /// Parse Dio Response to ApiResponse
  ApiResponse _parseResponse(Response response) {
    try {
      if (response.data is String) {
        // If responseType is plain, parse the string
        final decoded = jsonDecode(response.data);
        return ApiResponse.fromJson(decoded);
      } else if (response.data is Map<String, dynamic>) {
        return ApiResponse.fromJson(response.data);
      } else {
        AppLog.d("Unexpected response format.");
        return ApiResponse(
          status: response.statusCode ?? 500,
          error: "Unexpected response format.",
          message: "Unexpected response format.",
        );
      }
    } catch (e) {
      AppLog.d("Failed to parse response: $e");
      return ApiResponse(
        status: response.statusCode ?? 500,
        error: "Failed to parse response.",
        message: "Failed to parse response.",
      );
    }
  }

  /// Convenience methods for REST APIs

  Future<ApiResponse> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    Map<String, String>? headers,
  }) async {
    return executeRequest(
      method: 'GET',
      url: url,
      options: Options(),
      queryParameters: queryParameters,
      headers: headers,
    );
  }

  Future<ApiResponse> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    Map<String, String>? headers,
  }) async {
    return executeRequest(
      method: 'POST',
      url: url,
      data: data,
      options: Options(),
      queryParameters: queryParameters,
      headers: headers,
    );
  }

  Future<ApiResponse> put(
    String url, {
    dynamic data,
    Options? options,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return executeRequest(
      method: 'PUT',
      url: url,
      data: data,
      options: Options(),
      queryParameters: queryParameters,
      headers: headers,
    );
  }

  Future<ApiResponse> delete(
    String url, {
    dynamic data,
    Options? options,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return executeRequest(
      method: 'DELETE',
      url: url,
      options: Options(),
      data: data,
      queryParameters: queryParameters,
      headers: headers,
    );
  }

  Future<ApiResponse> patch(
    String url, {
    dynamic data,
    Options? options,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return executeRequest(
      method: 'PATCH',
      url: url,
      data: data,
      options: Options(),
      queryParameters: queryParameters,
      headers: headers,
    );
  }
}

class AppHttpHears {
  static Map<String, String> get contentTypeJson =>
      {"content-Type": "application/json"};
  static Map<String, String> withAuthorization(String jwtToken) => {
        "content-Type": "application/json",
        "authorization": "Bearer $jwtToken",
      };
}

/// Detailed error model
class ApiError1 {
  /// network, timeout, cancel, badCertificate, client, server, unexpected
  final String type;
  final String message;
  final int? statusCode;

  ApiError1({required this.type, required this.message, this.statusCode});

  @override
  String toString() =>
      'ApiError(type: $type, code: $statusCode, msg: $message)';
}

/// Unified response wrapper
class ApiResponse1<T> {
  final T? data;
  final ApiError1? error;

  bool get isSuccess => error == null && data != null;

  ApiResponse1.success(this.data) : error = null;
  ApiResponse1.failure(this.error) : data = null;
}

/// Helper to queue requests during token refresh
class _QueuedRequest {
  final RequestOptions request;
  final Completer<Response> completer = Completer<Response>();
  _QueuedRequest(this.request);
}

/// Single, all-in-one API manager
class ApiManager {
  static final ApiManager _instance = ApiManager._internal();
  factory ApiManager() => _instance;

  final Dio _dio = Dio();
  final SharedPrefService _prefs = SharedPrefService();
  bool _refreshing = false;
  final List<_QueuedRequest> _queue = [];

  ApiManager._internal() {
    // 1) Base options
    _dio.options = BaseOptions(
      baseUrl: Constants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      contentType: 'application/json',
      responseType: ResponseType.json,
      validateStatus: (status) => status != null && status < 500,
    );

    // 2) Logging interceptor
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
    ));

    // 3) Auth & refresh interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = _prefs.getAuthToken();
        if (token?.isNotEmpty == true) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        options.headers['Accept'] = 'application/json';
        handler.next(options);
      },
      onError: (DioException err, handler) async {
        // If 401 and not already refreshing, attempt refresh
        if (err.response?.statusCode == 401 && !_refreshing) {
          _refreshing = true;
          try {
            final newToken = await _refreshToken();
            if (newToken != null) {
              // Retry original request
              final opts = err.requestOptions;
              opts.headers['Authorization'] = 'Bearer $newToken';
              final cloned = await _dio.request(
                opts.path,
                options: Options(
                  method: opts.method,
                  headers: opts.headers,
                ),
                data: opts.data,
                queryParameters: opts.queryParameters,
              );
              handler.resolve(cloned);

              // Replay queued requests
              for (var qr in _queue) {
                final rq = qr.request;
                rq.headers['Authorization'] = 'Bearer $newToken';
                _dio
                    .request(
                      rq.path,
                      options: Options(
                        method: rq.method,
                        headers: rq.headers,
                      ),
                      data: rq.data,
                      queryParameters: rq.queryParameters,
                    )
                    .then(qr.completer.complete)
                    .catchError(qr.completer.completeError);
              }
              _queue.clear();
              return;
            }
          } finally {
            _refreshing = false;
          }
        }

        // If 401 while refreshing, queue
        if (err.response?.statusCode == 401 && _refreshing) {
          final qr = _QueuedRequest(err.requestOptions);
          _queue.add(qr);
          qr.completer.future
              .then((resp) => handler.resolve(resp))
              .catchError((e) => handler.next(e));
        } else {
          handler.next(err);
        }
      },
    ));
  }

  /// Attempt to refresh token; return new or null
  Future<String?> _refreshToken() async {
    try {
      final resp = await _dio.post('auth/refresh');
      final token = resp.data['accessToken'] as String?;
      if (token != null && token.isNotEmpty) {
        await _prefs.setAuthToken(token);
        return token;
      }
    } catch (_) {}
    return null;
  }

  /// Map DioException to ApiError
  ApiError1 _mapError(DioException e) {
    switch (e.type) {
      case DioExceptionType.cancel:
        return ApiError1(type: 'cancel', message: 'Request cancelled');
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiError1(type: 'timeout', message: 'Connection timeout');
      case DioExceptionType.badCertificate:
        return ApiError1(type: 'badCertificate', message: 'SSL error');
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        final data = e.response?.data;
        String msg = 'Error $code';
        if (data is Map && data['message'] is String) {
          msg = data['message'];
        } else if (code != null && code >= 500) {
          msg = 'Server error ($code)';
        } else if (code != null && code >= 400) {
          msg = 'Client error ($code)';
        }
        return ApiError1(type: 'http', message: msg, statusCode: code);
      case DioExceptionType.unknown:
      default:
        return ApiError1(type: 'network', message: 'No internet connection');
    }
  }

  /// Internal helper to perform any request
  Future<ApiResponse1<T>> _request<T>(
    Future<Response> Function() fn,
    T Function(dynamic json)? parser,
  ) async {
    try {
      final resp = await fn();
      final parsed = parser != null ? parser(resp.data) : resp.data as T;
      return ApiResponse1.success(parsed);
    } on DioException catch (e) {
      return ApiResponse1.failure(_mapError(e));
    } catch (e) {
      return ApiResponse1.failure(
        ApiError1(type: 'unexpected', message: e.toString()),
      );
    }
  }

  /// GET
  Future<ApiResponse1<T>> get<T>(
    String path, {
    dynamic queryParams,
    Map<String, String>? headers,
    T Function(dynamic json)? parser,
  }) =>
      _request(
        () => _dio.get(path,
            queryParameters: queryParams, options: Options(headers: headers)),
        parser,
      );

  /// POST
  Future<ApiResponse1<T>> post<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    T Function(dynamic json)? parser,
  }) =>
      _request(
        () => _dio.post(path,
            data: body,
            queryParameters: queryParams,
            options: Options(headers: headers)),
        parser,
      );

  /// PUT
  Future<ApiResponse1<T>> put<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    T Function(dynamic json)? parser,
  }) =>
      _request(
        () => _dio.put(path,
            data: body,
            queryParameters: queryParams,
            options: Options(headers: headers)),
        parser,
      );

  /// PATCH
  Future<ApiResponse1<T>> patch<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    T Function(dynamic json)? parser,
  }) =>
      _request(
        () => _dio.patch(path,
            data: body,
            queryParameters: queryParams,
            options: Options(headers: headers)),
        parser,
      );

  /// DELETE
  Future<ApiResponse1<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    T Function(dynamic json)? parser,
  }) =>
      _request(
        () => _dio.delete(path,
            queryParameters: queryParams, options: Options(headers: headers)),
        parser,
      );
}
