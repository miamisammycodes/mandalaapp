import 'dart:math';

import '../../models/auth/user.dart';
import '../../core/services/storage_service.dart';

/// Authentication result containing user and token
class AuthResult {
  final User user;
  final String token;

  const AuthResult({required this.user, required this.token});
}

/// Repository for authentication operations
/// Currently uses mock data - will be replaced with real API calls when backend is ready
class AuthRepository {
  final StorageService _storageService;

  AuthRepository({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  /// Simulated network delay for realistic mock behavior
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(
      Duration(milliseconds: 500 + Random().nextInt(500)),
    );
  }

  /// Login with email and password
  /// Returns AuthResult with user and token on success
  /// Throws exception on failure
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    await _simulateNetworkDelay();

    // Simulate error for specific test cases
    if (email == 'error@test.com') {
      throw Exception('Invalid email or password');
    }

    if (password == 'wrongpassword') {
      throw Exception('Invalid email or password');
    }

    // Generate mock user and token
    final user = _generateMockUser(email: email);
    final token = _generateMockToken();

    // Save to secure storage
    await _storageService.saveToken(token);
    await _storageService.saveUser(user.toJson());

    return AuthResult(user: user, token: token);
  }

  /// Register a new user
  /// Returns AuthResult with user and token on success
  /// Throws exception on failure
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await _simulateNetworkDelay();

    // Simulate error for specific test cases
    if (email == 'existing@test.com') {
      throw Exception('Email already registered');
    }

    if (email == 'error@test.com') {
      throw Exception('Registration failed. Please try again.');
    }

    // Generate mock user and token
    final user = _generateMockUser(email: email, name: name);
    final token = _generateMockToken();

    // Save to secure storage
    await _storageService.saveToken(token);
    await _storageService.saveUser(user.toJson());

    return AuthResult(user: user, token: token);
  }

  /// Request password reset
  /// Returns success message on success
  /// Throws exception on failure
  Future<String> forgotPassword({required String email}) async {
    await _simulateNetworkDelay();

    // Simulate error for specific test cases
    if (email == 'error@test.com') {
      throw Exception('Email not found');
    }

    return 'Password reset instructions have been sent to $email';
  }

  /// Logout the current user
  Future<void> logout() async {
    await _storageService.clearAuth();
  }

  /// Refresh the authentication token
  /// Returns new token on success
  /// Throws exception on failure
  Future<String> refreshToken() async {
    await _simulateNetworkDelay();

    final currentToken = await _storageService.getToken();
    if (currentToken == null) {
      throw Exception('No token to refresh');
    }

    final newToken = _generateMockToken();
    await _storageService.saveToken(newToken);

    return newToken;
  }

  /// Check if user is currently authenticated
  /// Returns AuthResult if authenticated, null otherwise
  Future<AuthResult?> checkAuthStatus() async {
    final token = await _storageService.getToken();
    if (token == null) {
      return null;
    }

    final userJson = await _storageService.getUser();
    if (userJson == null) {
      return null;
    }

    try {
      final user = User.fromJson(userJson);
      return AuthResult(user: user, token: token);
    } catch (e) {
      // Invalid stored data, clear storage
      await _storageService.clearAuth();
      return null;
    }
  }

  /// Generate a mock user for testing
  User _generateMockUser({required String email, String? name}) {
    return User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: name ?? _extractNameFromEmail(email),
      avatar: null,
      role: 'user',
      createdAt: DateTime.now(),
    );
  }

  /// Extract a display name from email
  String _extractNameFromEmail(String email) {
    final localPart = email.split('@').first;
    // Capitalize first letter and replace dots/underscores with spaces
    return localPart
        .replaceAll(RegExp(r'[._]'), ' ')
        .split(' ')
        .map((word) =>
            word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
        .join(' ');
  }

  /// Generate a mock JWT token
  String _generateMockToken() {
    final random = Random();
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    String randomString(int length) {
      return List.generate(
        length,
        (index) => chars[random.nextInt(chars.length)],
      ).join();
    }

    // Mock JWT format: header.payload.signature
    return '${randomString(20)}.${randomString(40)}.${randomString(30)}';
  }
}
