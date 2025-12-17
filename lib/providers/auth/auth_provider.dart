import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/auth/auth_state.dart';
import '../../models/auth/child_profile.dart';
import '../../models/auth/otp_verification.dart';
import '../../models/auth/parent_user.dart';
import '../../models/auth/user_session.dart';
import '../../repositories/auth/parent_auth_repository.dart';

/// Provider for the ParentAuthRepository
final parentAuthRepositoryProvider = Provider<ParentAuthRepository>((ref) {
  return ParentAuthRepository();
});

/// Provider for the current authentication state
final authStateProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(parentAuthRepositoryProvider);
  return AuthNotifier(repository);
});

/// Provider for OTP state (separate from auth state for UI)
final otpStateProvider = StateNotifierProvider<OtpNotifier, OtpState>((ref) {
  final repository = ref.watch(parentAuthRepositoryProvider);
  return OtpNotifier(repository);
});

// ============================================================================
// CONVENIENCE PROVIDERS
// ============================================================================

/// Check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isAuthenticated;
});

/// Get the current parent user
final currentParentProvider = Provider<ParentUser?>((ref) {
  return ref.watch(authStateProvider).parent;
});

/// Get the active child (in child mode)
final activeChildProvider = Provider<ChildProfile?>((ref) {
  return ref.watch(authStateProvider).activeChild;
});

/// Check if in parent mode
final isParentModeProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isParentMode;
});

/// Check if in child mode
final isChildModeProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isChildMode;
});

/// Get session type
final sessionTypeProvider = Provider<SessionType?>((ref) {
  return ref.watch(authStateProvider).sessionType;
});

/// Get all children
final childrenProvider = Provider<List<ChildProfile>>((ref) {
  return ref.watch(authStateProvider).children;
});

/// Check if parent has children
final hasChildrenProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).hasChildren;
});

// ============================================================================
// AUTH NOTIFIER
// ============================================================================

/// State notifier for authentication
class AuthNotifier extends StateNotifier<AuthState> {
  final ParentAuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState.initial()) {
    _checkExistingSession();
  }

  /// Check for existing session on app start
  Future<void> _checkExistingSession() async {
    try {
      final session = await _repository.checkExistingSession();
      if (session != null) {
        state = AuthState.authenticated(session);
      } else {
        state = AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.unauthenticated();
    }
  }

  /// Login with OTP verification result
  Future<bool> loginWithOtp(ParentUser parent) async {
    state = AuthState.loading();

    try {
      final session = await _repository.createParentSession(parent);
      state = AuthState.authenticated(session);
      return true;
    } catch (e) {
      state = AuthState.error(e.toString().replaceFirst('Exception: ', ''));
      return false;
    }
  }

  /// Switch to child mode
  Future<bool> switchToChild({
    required String childId,
    required String pin,
  }) async {
    if (state.session == null) return false;

    try {
      final session = await _repository.switchToChild(
        currentSession: state.session!,
        childId: childId,
        pin: pin,
      );
      state = AuthState.authenticated(session);
      return true;
    } catch (e) {
      // Don't change state on PIN error, just return false
      return false;
    }
  }

  /// Switch back to parent mode
  Future<void> switchToParent() async {
    if (state.session == null) return;

    try {
      final session = await _repository.switchToParent(state.session!);
      state = AuthState.authenticated(session);
    } catch (e) {
      // Keep current state on error
    }
  }

  /// Add a child profile
  Future<bool> addChild({
    required String name,
    required DateTime dateOfBirth,
    required String pin,
  }) async {
    if (state.session == null) return false;

    try {
      final session = await _repository.addChild(
        currentSession: state.session!,
        name: name,
        dateOfBirth: dateOfBirth,
        pin: pin,
      );
      state = AuthState.authenticated(session);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Update a child profile
  Future<bool> updateChild(ChildProfile child) async {
    if (state.session == null) return false;

    try {
      final session = await _repository.updateChild(
        currentSession: state.session!,
        updatedChild: child,
      );
      state = AuthState.authenticated(session);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Remove a child profile
  Future<bool> removeChild(String childId) async {
    if (state.session == null) return false;

    try {
      final session = await _repository.removeChild(
        currentSession: state.session!,
        childId: childId,
      );
      state = AuthState.authenticated(session);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Update parent name
  Future<bool> updateParentName(String name) async {
    if (state.session == null) return false;

    try {
      final session = await _repository.updateParentName(
        currentSession: state.session!,
        name: name,
      );
      state = AuthState.authenticated(session);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    await _repository.logout();
    state = AuthState.unauthenticated();
  }

  /// Clear error
  void clearError() {
    if (state.hasError) {
      state = state.clearError();
    }
  }
}

// ============================================================================
// OTP NOTIFIER
// ============================================================================

/// State notifier for OTP flow
class OtpNotifier extends StateNotifier<OtpState> {
  final ParentAuthRepository _repository;

  OtpNotifier(this._repository) : super(OtpState.initial());

  /// Send OTP to phone number
  Future<bool> sendOtp(String phoneNumber) async {
    state = OtpState.sending(phoneNumber);

    try {
      state = await _repository.sendOtp(phoneNumber);
      return true;
    } catch (e) {
      state = OtpState.error(e.toString().replaceFirst('Exception: ', ''));
      return false;
    }
  }

  /// Verify OTP code
  Future<ParentUser?> verifyOtp(String code) async {
    if (state.phoneNumber == null) return null;

    state = OtpState.verifying(state.phoneNumber!);

    try {
      final parent = await _repository.verifyOtp(
        phoneNumber: state.phoneNumber!,
        code: code,
      );
      state = OtpState.verified(state.phoneNumber!);
      return parent;
    } catch (e) {
      state = OtpState.error(e.toString().replaceFirst('Exception: ', ''));
      return null;
    }
  }

  /// Resend OTP
  Future<bool> resendOtp() async {
    if (state.phoneNumber == null) return false;
    return sendOtp(state.phoneNumber!);
  }

  /// Reset OTP state
  void reset() {
    state = OtpState.initial();
  }

  /// Get demo OTP for display
  String get demoOtp => _repository.demoOtp;
}
