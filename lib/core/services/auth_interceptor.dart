import 'package:dio/dio.dart';

import 'storage_service.dart';

/// Interceptor that adds authentication token to API requests
/// and handles 401 unauthorized responses
class AuthInterceptor extends Interceptor {
  final StorageService _storageService;

  /// Callback when user is unauthorized (401)
  /// This should trigger a logout
  final void Function()? onUnauthorized;

  AuthInterceptor({
    StorageService? storageService,
    this.onUnauthorized,
  }) : _storageService = storageService ?? StorageService();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get token from secure storage
    final token = await _storageService.getToken();

    // Add Authorization header if token exists
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Continue with the request
    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    // Just pass through successful responses
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized
    if (err.response?.statusCode == 401) {
      // Clear stored credentials
      await _storageService.clearAuth();

      // Notify about unauthorized state
      onUnauthorized?.call();
    }

    // Continue with error handling
    handler.next(err);
  }
}

/// Extension to add auth interceptor to Dio instance
extension DioAuthExtension on Dio {
  /// Add auth interceptor to this Dio instance
  void addAuthInterceptor({
    StorageService? storageService,
    void Function()? onUnauthorized,
  }) {
    interceptors.add(
      AuthInterceptor(
        storageService: storageService,
        onUnauthorized: onUnauthorized,
      ),
    );
  }
}
