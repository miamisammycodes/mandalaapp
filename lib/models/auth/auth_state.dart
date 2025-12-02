import 'package:flutter/foundation.dart';

import 'user.dart';

/// Authentication state for the application
@immutable
class AuthState {
  final User? user;
  final String? token;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.token,
    this.isLoading = false,
    this.error,
  });

  /// Whether the user is currently authenticated
  bool get isAuthenticated => user != null && token != null;

  /// Initial state - not authenticated, not loading
  factory AuthState.initial() => const AuthState();

  /// Loading state
  factory AuthState.loading() => const AuthState(isLoading: true);

  /// Authenticated state
  factory AuthState.authenticated({
    required User user,
    required String token,
  }) =>
      AuthState(user: user, token: token);

  /// Error state
  factory AuthState.error(String message) => AuthState(error: message);

  /// Create a copy with modified fields
  AuthState copyWith({
    User? user,
    String? token,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthState &&
        other.user == user &&
        other.token == token &&
        other.isLoading == isLoading &&
        other.error == error;
  }

  @override
  int get hashCode {
    return Object.hash(user, token, isLoading, error);
  }

  @override
  String toString() {
    return 'AuthState(user: $user, token: ${token != null ? '***' : null}, isLoading: $isLoading, error: $error)';
  }
}
