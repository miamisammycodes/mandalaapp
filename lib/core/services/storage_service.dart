import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';

/// Secure Storage Service
///
/// Wrapper for flutter_secure_storage providing secure key-value storage
/// for sensitive data like authentication tokens and user information.
///
/// Features:
/// - Encrypted storage on device
/// - Token management for authentication
/// - User data persistence
/// - Error handling for platform issues
/// - Singleton pattern for single instance
class StorageService {
  // Singleton instance
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;

  late final FlutterSecureStorage _storage;

  // Storage keys
  static const String _keyAuthToken = 'auth_token';
  static const String _keyUser = 'user_data';
  static const String _keyRefreshToken = 'refresh_token';

  // Private constructor
  StorageService._internal() {
    _storage = const FlutterSecureStorage();
  }

  // ============================================================================
  // TOKEN MANAGEMENT
  // ============================================================================

  /// Save authentication token
  ///
  /// Stores the JWT token securely for authenticated requests
  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _keyAuthToken, value: token);
      if (AppConfig.enableLogging) {
        print('🔐 Token saved to secure storage');
      }
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('❌ Error saving token: $e');
      }
      throw StorageException('Failed to save token: $e');
    }
  }

  /// Get authentication token
  ///
  /// Retrieves the stored JWT token, returns null if not found
  Future<String?> getToken() async {
    try {
      final token = await _storage.read(key: _keyAuthToken);
      if (AppConfig.enableLogging && token != null) {
        print('🔐 Token retrieved from secure storage');
      }
      return token;
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('❌ Error reading token: $e');
      }
      throw StorageException('Failed to read token: $e');
    }
  }

  /// Delete authentication token
  ///
  /// Removes the stored token (used during logout)
  Future<void> deleteToken() async {
    try {
      await _storage.delete(key: _keyAuthToken);
      if (AppConfig.enableLogging) {
        print('🔐 Token deleted from secure storage');
      }
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('❌ Error deleting token: $e');
      }
      throw StorageException('Failed to delete token: $e');
    }
  }

  /// Save refresh token
  ///
  /// Stores the refresh token for token renewal
  Future<void> saveRefreshToken(String refreshToken) async {
    try {
      await _storage.write(key: _keyRefreshToken, value: refreshToken);
      if (AppConfig.enableLogging) {
        print('🔐 Refresh token saved to secure storage');
      }
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('❌ Error saving refresh token: $e');
      }
      throw StorageException('Failed to save refresh token: $e');
    }
  }

  /// Get refresh token
  ///
  /// Retrieves the stored refresh token, returns null if not found
  Future<String?> getRefreshToken() async {
    try {
      final refreshToken = await _storage.read(key: _keyRefreshToken);
      if (AppConfig.enableLogging && refreshToken != null) {
        print('🔐 Refresh token retrieved from secure storage');
      }
      return refreshToken;
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('❌ Error reading refresh token: $e');
      }
      throw StorageException('Failed to read refresh token: $e');
    }
  }

  /// Delete refresh token
  ///
  /// Removes the stored refresh token
  Future<void> deleteRefreshToken() async {
    try {
      await _storage.delete(key: _keyRefreshToken);
      if (AppConfig.enableLogging) {
        print('🔐 Refresh token deleted from secure storage');
      }
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('❌ Error deleting refresh token: $e');
      }
      throw StorageException('Failed to delete refresh token: $e');
    }
  }

  // ============================================================================
  // USER DATA MANAGEMENT
  // ============================================================================

  /// Save user data
  ///
  /// Stores user information as JSON for session persistence
  Future<void> saveUser(Map<String, dynamic> user) async {
    try {
      final userJson = jsonEncode(user);
      await _storage.write(key: _keyUser, value: userJson);
      if (AppConfig.enableLogging) {
        print('👤 User data saved to secure storage');
      }
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('❌ Error saving user data: $e');
      }
      throw StorageException('Failed to save user data: $e');
    }
  }

  /// Get user data
  ///
  /// Retrieves stored user information, returns null if not found
  Future<Map<String, dynamic>?> getUser() async {
    try {
      final userJson = await _storage.read(key: _keyUser);
      if (userJson == null) return null;

      final user = jsonDecode(userJson) as Map<String, dynamic>;
      if (AppConfig.enableLogging) {
        print('👤 User data retrieved from secure storage');
      }
      return user;
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('❌ Error reading user data: $e');
      }
      throw StorageException('Failed to read user data: $e');
    }
  }

  /// Delete user data
  ///
  /// Removes stored user information
  Future<void> deleteUser() async {
    try {
      await _storage.delete(key: _keyUser);
      if (AppConfig.enableLogging) {
        print('👤 User data deleted from secure storage');
      }
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('❌ Error deleting user data: $e');
      }
      throw StorageException('Failed to delete user data: $e');
    }
  }

  // ============================================================================
  // GENERIC STORAGE METHODS
  // ============================================================================

  /// Save generic string value
  ///
  /// Store any string value with a custom key
  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
      if (AppConfig.enableLogging) {
        print('💾 Saved: $key');
      }
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('❌ Error writing $key: $e');
      }
      throw StorageException('Failed to write $key: $e');
    }
  }

  /// Read generic string value
  ///
  /// Retrieve any string value by key, returns null if not found
  Future<String?> read(String key) async {
    try {
      final value = await _storage.read(key: key);
      if (AppConfig.enableLogging && value != null) {
        print('💾 Read: $key');
      }
      return value;
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('❌ Error reading $key: $e');
      }
      throw StorageException('Failed to read $key: $e');
    }
  }

  /// Delete generic value
  ///
  /// Remove any value by key
  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
      if (AppConfig.enableLogging) {
        print('💾 Deleted: $key');
      }
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('❌ Error deleting $key: $e');
      }
      throw StorageException('Failed to delete $key: $e');
    }
  }

  /// Check if key exists
  ///
  /// Returns true if the key exists in storage
  Future<bool> containsKey(String key) async {
    try {
      final value = await _storage.read(key: key);
      return value != null;
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('❌ Error checking key $key: $e');
      }
      return false;
    }
  }

  /// Get all keys
  ///
  /// Returns a list of all stored keys
  Future<List<String>> getAllKeys() async {
    try {
      final all = await _storage.readAll();
      return all.keys.toList();
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('❌ Error getting all keys: $e');
      }
      throw StorageException('Failed to get all keys: $e');
    }
  }

  // ============================================================================
  // CLEAR & RESET
  // ============================================================================

  /// Clear all authentication data
  ///
  /// Removes token, refresh token, and user data (used during logout)
  Future<void> clearAuth() async {
    try {
      await Future.wait([
        deleteToken(),
        deleteRefreshToken(),
        deleteUser(),
      ]);
      if (AppConfig.enableLogging) {
        print('🧹 All auth data cleared from secure storage');
      }
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('❌ Error clearing auth data: $e');
      }
      throw StorageException('Failed to clear auth data: $e');
    }
  }

  /// Clear all storage
  ///
  /// Removes everything from secure storage
  /// Use with caution - this cannot be undone!
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
      if (AppConfig.enableLogging) {
        print('🧹 All data cleared from secure storage');
      }
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('❌ Error clearing all data: $e');
      }
      throw StorageException('Failed to clear all data: $e');
    }
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Check if user is logged in
  ///
  /// Returns true if auth token exists
  Future<bool> isLoggedIn() async {
    try {
      final token = await getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get authentication headers
  ///
  /// Returns a map with Authorization header if token exists
  Future<Map<String, String>> getAuthHeaders() async {
    try {
      final token = await getToken();
      if (token != null && token.isNotEmpty) {
        return {'Authorization': 'Bearer $token'};
      }
      return {};
    } catch (e) {
      return {};
    }
  }
}

// ==============================================================================
// STORAGE EXCEPTION
// ==============================================================================

/// Custom exception for storage errors
class StorageException implements Exception {
  final String message;

  StorageException(this.message);

  @override
  String toString() => 'StorageException: $message';
}
