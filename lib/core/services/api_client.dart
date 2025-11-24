import 'dart:async';
import 'package:dio/dio.dart';
import '../config/app_config.dart';

/// API Client for handling HTTP requests
///
/// Currently configured for MOCK DATA mode - returns dummy data instead of
/// making real HTTP calls. When backend is ready, swap mock responses with
/// actual Dio HTTP calls.
///
/// Features:
/// - Simulated network delay for realistic UX
/// - Request/response logging in debug mode
/// - Error handling and retry logic
/// - Singleton pattern for single instance
class ApiClient {
  // Singleton instance
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio _dio;

  // Private constructor
  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: Duration(milliseconds: AppConfig.apiTimeout),
        receiveTimeout: Duration(milliseconds: AppConfig.apiTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(_LoggingInterceptor());
    _dio.interceptors.add(_ErrorInterceptor());
  }

  /// Get Dio instance for direct access if needed
  Dio get dio => _dio;

  // ============================================================================
  // HTTP METHODS (Currently return mock data)
  // ============================================================================

  /// Perform GET request
  ///
  /// In mock mode: Returns dummy data after simulated delay
  /// In production: Makes actual HTTP GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    if (AppConfig.useMockData) {
      return _mockResponse(path, 'GET', queryParameters: queryParameters);
    }

    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Perform POST request
  ///
  /// In mock mode: Returns dummy success response after simulated delay
  /// In production: Makes actual HTTP POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    if (AppConfig.useMockData) {
      return _mockResponse(path, 'POST', data: data);
    }

    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Perform PUT request
  ///
  /// In mock mode: Returns dummy success response after simulated delay
  /// In production: Makes actual HTTP PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    if (AppConfig.useMockData) {
      return _mockResponse(path, 'PUT', data: data);
    }

    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Perform DELETE request
  ///
  /// In mock mode: Returns dummy success response after simulated delay
  /// In production: Makes actual HTTP DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    if (AppConfig.useMockData) {
      return _mockResponse(path, 'DELETE');
    }

    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // ============================================================================
  // MOCK RESPONSE SYSTEM
  // ============================================================================

  /// Simulate API response with delay
  ///
  /// This method simulates network delay and returns mock data.
  /// Replace this with actual API calls when backend is ready.
  Future<Response> _mockResponse(
    String path,
    String method, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    // Simulate network delay
    await Future.delayed(
      Duration(milliseconds: AppConfig.mockNetworkDelay),
    );

    if (AppConfig.enableLogging) {
      print('🔵 MOCK $method: $path');
      if (queryParameters != null) {
        print('   Query: $queryParameters');
      }
      if (data != null) {
        print('   Data: $data');
      }
    }

    // Return mock response
    // Repositories will provide their own mock data
    return Response(
      requestOptions: RequestOptions(path: path),
      statusCode: 200,
      data: {
        'success': true,
        'message': 'Mock response - data should be provided by repository',
        'path': path,
        'method': method,
      },
    );
  }

  // ============================================================================
  // TOKEN MANAGEMENT
  // ============================================================================

  /// Set authorization token for authenticated requests
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
    if (AppConfig.enableLogging) {
      print('🔑 Auth token set');
    }
  }

  /// Clear authorization token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
    if (AppConfig.enableLogging) {
      print('🔑 Auth token cleared');
    }
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Cancel all pending requests
  void cancelRequests() {
    _dio.close(force: true);
  }
}

// ==============================================================================
// INTERCEPTORS
// ==============================================================================

/// Logging interceptor for debugging
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (AppConfig.enableLogging) {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📤 REQUEST: ${options.method} ${options.path}');
      print('Headers: ${options.headers}');
      if (options.queryParameters.isNotEmpty) {
        print('Query Parameters: ${options.queryParameters}');
      }
      if (options.data != null) {
        print('Data: ${options.data}');
      }
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (AppConfig.enableLogging) {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📥 RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
      print('Data: ${response.data}');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (AppConfig.enableLogging) {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('❌ ERROR: ${err.requestOptions.method} ${err.requestOptions.path}');
      print('Type: ${err.type}');
      print('Message: ${err.message}');
      if (err.response != null) {
        print('Status Code: ${err.response?.statusCode}');
        print('Data: ${err.response?.data}');
      }
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }
    super.onError(err, handler);
  }
}

/// Error handling interceptor
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Convert DioException to ApiException for logging/handling
    // You can use _handleError(err) here for custom error handling
    // or implement retry logic if needed

    // For now, just pass the error along
    handler.next(err);
  }

  ApiException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Connection timeout. Please check your internet connection.',
          statusCode: 408,
          type: ApiExceptionType.timeout,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        final message = error.response?.data['message'] ??
            'Server error occurred. Please try again.';

        if (statusCode == 401) {
          return ApiException(
            message: 'Unauthorized. Please login again.',
            statusCode: statusCode,
            type: ApiExceptionType.unauthorized,
          );
        } else if (statusCode == 404) {
          return ApiException(
            message: 'Resource not found.',
            statusCode: statusCode,
            type: ApiExceptionType.notFound,
          );
        } else if (statusCode >= 500) {
          return ApiException(
            message: 'Server error. Please try again later.',
            statusCode: statusCode,
            type: ApiExceptionType.server,
          );
        }

        return ApiException(
          message: message,
          statusCode: statusCode,
          type: ApiExceptionType.badResponse,
        );

      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request cancelled.',
          statusCode: 0,
          type: ApiExceptionType.cancel,
        );

      case DioExceptionType.unknown:
      default:
        return ApiException(
          message: 'Network error. Please check your connection.',
          statusCode: 0,
          type: ApiExceptionType.network,
        );
    }
  }
}

// ==============================================================================
// API EXCEPTION
// ==============================================================================

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final ApiExceptionType type;

  ApiException({
    required this.message,
    required this.statusCode,
    required this.type,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

/// Types of API exceptions
enum ApiExceptionType {
  network,
  timeout,
  unauthorized,
  notFound,
  server,
  badResponse,
  cancel,
  unknown,
}
