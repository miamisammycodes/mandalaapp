import 'dart:math';

import '../../models/auth/child_profile.dart';
import '../../models/auth/otp_verification.dart';
import '../../models/auth/parent_user.dart';
import '../../models/auth/user_session.dart';
import '../../core/services/storage_service.dart';

/// Repository for parent authentication
/// Handles Phone+OTP flow and child PIN verification
class ParentAuthRepository {
  final StorageService _storage = StorageService();
  final Random _random = Random();

  // Mock data storage (in a real app, this would come from API)
  static ParentUser? _mockParent;
  static const String _mockOtp = '123456'; // Demo OTP code

  // ============================================================================
  // OTP AUTHENTICATION
  // ============================================================================

  /// Send OTP to phone number
  /// Mock: Always succeeds after a short delay
  Future<OtpState> sendOtp(String phoneNumber) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // In production, this would call the API to send OTP
    // For prototype, we just simulate success
    return OtpState.sent(
      phoneNumber: phoneNumber,
      validityMinutes: 5,
      resendCooldown: 60,
    );
  }

  /// Verify OTP code
  /// Mock: Accepts any 6-digit code or the demo code '123456'
  Future<ParentUser> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // For prototype: accept any 6-digit code or the demo code
    if (code.length != 6) {
      throw Exception('Invalid OTP code');
    }

    // Check if parent exists (mock lookup)
    if (_mockParent != null && _mockParent!.phoneNumber == phoneNumber) {
      return _mockParent!;
    }

    // Create new parent (first time login)
    final parent = ParentUser(
      id: 'parent_${DateTime.now().millisecondsSinceEpoch}',
      phoneNumber: phoneNumber,
      name: 'Parent', // Will be updated during onboarding
      children: [],
      createdAt: DateTime.now(),
    );

    _mockParent = parent;
    return parent;
  }

  /// Create session after OTP verification
  Future<UserSession> createParentSession(ParentUser parent) async {
    final token = _generateToken();

    final session = UserSession.parentSession(
      parent: parent,
      token: token,
    );

    // Save session to storage
    await _storage.saveSession(session.toJson());
    await _storage.saveToken(token);

    return session;
  }

  // ============================================================================
  // CHILD PIN AUTHENTICATION
  // ============================================================================

  /// Verify child PIN
  /// Mock: Accepts any 4-digit PIN for demo
  Future<bool> verifyChildPin({
    required ChildProfile child,
    required String pin,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // For prototype: accept the stored PIN or any 4-digit PIN
    if (pin.length < 4) {
      return false;
    }

    // In production, verify against stored hash
    // For prototype, accept if PIN matches or is the demo PIN '1234'
    return pin == child.pin || pin == '1234';
  }

  /// Switch to child session
  Future<UserSession> switchToChild({
    required UserSession currentSession,
    required String childId,
    required String pin,
  }) async {
    final child = currentSession.parent.getChild(childId);
    if (child == null) {
      throw Exception('Child not found');
    }

    final isValid = await verifyChildPin(child: child, pin: pin);
    if (!isValid) {
      throw Exception('Invalid PIN');
    }

    final session = currentSession.switchToChild(childId);

    // Save updated session
    await _storage.saveSession(session.toJson());

    return session;
  }

  /// Switch back to parent session
  Future<UserSession> switchToParent(UserSession currentSession) async {
    final session = currentSession.switchToParent();

    // Save updated session
    await _storage.saveSession(session.toJson());

    return session;
  }

  // ============================================================================
  // CHILD MANAGEMENT
  // ============================================================================

  /// Add a child profile
  Future<UserSession> addChild({
    required UserSession currentSession,
    required String name,
    required DateTime dateOfBirth,
    required String pin,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final child = ChildProfile(
      id: 'child_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      dateOfBirth: dateOfBirth,
      pin: pin,
      createdAt: DateTime.now(),
    );

    final updatedParent = currentSession.parent.addChild(child);
    _mockParent = updatedParent;

    final session = currentSession.updateParent(updatedParent);

    // Save updated session
    await _storage.saveSession(session.toJson());

    return session;
  }

  /// Update a child profile
  Future<UserSession> updateChild({
    required UserSession currentSession,
    required ChildProfile updatedChild,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final updatedParent = currentSession.parent.updateChild(updatedChild);
    _mockParent = updatedParent;

    final session = currentSession.updateParent(updatedParent);

    // Save updated session
    await _storage.saveSession(session.toJson());

    return session;
  }

  /// Remove a child profile
  Future<UserSession> removeChild({
    required UserSession currentSession,
    required String childId,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final updatedParent = currentSession.parent.removeChild(childId);
    _mockParent = updatedParent;

    // If currently in child mode for this child, switch to parent
    UserSession session = currentSession.updateParent(updatedParent);
    if (session.activeChildId == childId) {
      session = session.switchToParent();
    }

    // Save updated session
    await _storage.saveSession(session.toJson());

    return session;
  }

  /// Update parent name
  Future<UserSession> updateParentName({
    required UserSession currentSession,
    required String name,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final updatedParent = currentSession.parent.copyWith(name: name);
    _mockParent = updatedParent;

    final session = currentSession.updateParent(updatedParent);

    // Save updated session
    await _storage.saveSession(session.toJson());

    return session;
  }

  // ============================================================================
  // SESSION MANAGEMENT
  // ============================================================================

  /// Check if there's an existing session
  Future<UserSession?> checkExistingSession() async {
    try {
      final sessionData = await _storage.getSession();
      if (sessionData == null) return null;

      final session = UserSession.fromJson(sessionData);

      // Also update mock parent
      _mockParent = session.parent;

      return session;
    } catch (e) {
      return null;
    }
  }

  /// Logout - clear session
  Future<void> logout() async {
    await _storage.deleteSession();
    await _storage.deleteToken();
    // Don't clear _mockParent so we can "login" again with same data
  }

  /// Clear all data (full reset)
  Future<void> clearAllData() async {
    await _storage.clearAll();
    _mockParent = null;
  }

  // ============================================================================
  // HELPERS
  // ============================================================================

  String _generateToken() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(64, (index) => chars[_random.nextInt(chars.length)])
        .join();
  }

  /// Get demo OTP for testing display
  String get demoOtp => _mockOtp;
}
