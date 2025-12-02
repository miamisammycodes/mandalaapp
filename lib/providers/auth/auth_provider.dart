import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/auth/auth_state.dart';
import '../../models/auth/user.dart';
import '../../repositories/auth/auth_repository.dart';

/// Provider for the AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Provider for the current authentication state
final authStateProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

/// Convenience provider to check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isAuthenticated;
});

/// Convenience provider to get the current user
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).user;
});

/// State notifier for authentication
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState.initial()) {
    // Check auth status on initialization
    _checkAuthStatus();
  }

  /// Check if user is already authenticated (on app start)
  Future<void> _checkAuthStatus() async {
    try {
      final result = await _repository.checkAuthStatus();
      if (result != null) {
        state = AuthState.authenticated(
          user: result.user,
          token: result.token,
        );
      }
    } catch (e) {
      // Silently fail - user is not authenticated
      state = AuthState.initial();
    }
  }

  /// Login with email and password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = AuthState.loading();

    try {
      final result = await _repository.login(
        email: email,
        password: password,
      );

      state = AuthState.authenticated(
        user: result.user,
        token: result.token,
      );

      return true;
    } catch (e) {
      state = AuthState.error(e.toString().replaceFirst('Exception: ', ''));
      return false;
    }
  }

  /// Register a new user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = AuthState.loading();

    try {
      final result = await _repository.register(
        name: name,
        email: email,
        password: password,
      );

      state = AuthState.authenticated(
        user: result.user,
        token: result.token,
      );

      return true;
    } catch (e) {
      state = AuthState.error(e.toString().replaceFirst('Exception: ', ''));
      return false;
    }
  }

  /// Request password reset
  Future<String?> forgotPassword({required String email}) async {
    state = AuthState.loading();

    try {
      final message = await _repository.forgotPassword(email: email);
      state = AuthState.initial();
      return message;
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      state = AuthState.error(errorMessage);
      return null;
    }
  }

  /// Logout the current user
  Future<void> logout() async {
    await _repository.logout();
    state = AuthState.initial();
  }

  /// Clear any error state
  void clearError() {
    if (state.error != null) {
      state = state.copyWith(error: null);
    }
  }
}
