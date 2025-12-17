import 'package:flutter/foundation.dart';

import 'age_group.dart';
import 'child_profile.dart';
import 'parent_user.dart';
import 'user_session.dart';

/// Authentication status
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// Authentication state for the application
/// Supports both parent and child sessions
@immutable
class AuthState {
  final AuthStatus status;
  final UserSession? session;
  final String? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.session,
    this.error,
  });

  // ============================================================================
  // GETTERS
  // ============================================================================

  /// Whether the user is currently authenticated
  bool get isAuthenticated =>
      status == AuthStatus.authenticated && session != null;

  /// Whether currently loading
  bool get isLoading => status == AuthStatus.loading;

  /// Whether there's an error
  bool get hasError => status == AuthStatus.error && error != null;

  /// Get the parent user (available in both modes)
  ParentUser? get parent => session?.parent;

  /// Get the token
  String? get token => session?.token;

  /// Whether currently in parent mode
  bool get isParentMode => session?.isParentMode ?? false;

  /// Whether currently in child mode
  bool get isChildMode => session?.isChildMode ?? false;

  /// Get active child (only in child mode)
  ChildProfile? get activeChild => session?.activeChild;

  /// Get active age group (null in parent mode)
  AgeGroup? get activeAgeGroup => session?.activeAgeGroup;

  /// Get session type
  SessionType? get sessionType => session?.sessionType;

  /// Whether parent has children
  bool get hasChildren => parent?.hasChildren ?? false;

  /// Get all children
  List<ChildProfile> get children => parent?.children ?? [];

  // ============================================================================
  // FACTORY CONSTRUCTORS
  // ============================================================================

  /// Initial state - not authenticated, not loading
  factory AuthState.initial() => const AuthState(
        status: AuthStatus.initial,
      );

  /// Loading state
  factory AuthState.loading() => const AuthState(
        status: AuthStatus.loading,
      );

  /// Authenticated state with session
  factory AuthState.authenticated(UserSession session) => AuthState(
        status: AuthStatus.authenticated,
        session: session,
      );

  /// Unauthenticated state
  factory AuthState.unauthenticated() => const AuthState(
        status: AuthStatus.unauthenticated,
      );

  /// Error state
  factory AuthState.error(String message) => AuthState(
        status: AuthStatus.error,
        error: message,
      );

  // ============================================================================
  // COPY WITH
  // ============================================================================

  AuthState copyWith({
    AuthStatus? status,
    UserSession? session,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      session: session ?? this.session,
      error: error,
    );
  }

  /// Clear error while keeping other state
  AuthState clearError() {
    return AuthState(
      status: status == AuthStatus.error ? AuthStatus.initial : status,
      session: session,
    );
  }

  /// Update session (e.g., after adding/removing children)
  AuthState updateSession(UserSession newSession) {
    return AuthState(
      status: status,
      session: newSession,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthState &&
        other.status == status &&
        other.session == session &&
        other.error == error;
  }

  @override
  int get hashCode => Object.hash(status, session, error);

  @override
  String toString() {
    return 'AuthState(status: $status, session: $session, error: $error)';
  }
}
