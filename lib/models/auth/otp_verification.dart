import 'package:flutter/foundation.dart';

/// OTP verification state
enum OtpStatus {
  idle,
  sending,
  sent,
  verifying,
  verified,
  error,
}

/// OTP request model
@immutable
class OtpRequest {
  final String phoneNumber;
  final DateTime requestedAt;

  const OtpRequest({
    required this.phoneNumber,
    required this.requestedAt,
  });

  factory OtpRequest.create(String phoneNumber) {
    return OtpRequest(
      phoneNumber: phoneNumber,
      requestedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'requestedAt': requestedAt.toIso8601String(),
    };
  }

  @override
  String toString() => 'OtpRequest(phone: $phoneNumber)';
}

/// OTP verification model
@immutable
class OtpVerification {
  final String phoneNumber;
  final String code;
  final DateTime verifiedAt;

  const OtpVerification({
    required this.phoneNumber,
    required this.code,
    required this.verifiedAt,
  });

  factory OtpVerification.create({
    required String phoneNumber,
    required String code,
  }) {
    return OtpVerification(
      phoneNumber: phoneNumber,
      code: code,
      verifiedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'code': code,
      'verifiedAt': verifiedAt.toIso8601String(),
    };
  }

  @override
  String toString() => 'OtpVerification(phone: $phoneNumber, verified: true)';
}

/// OTP state for UI
@immutable
class OtpState {
  final OtpStatus status;
  final String? phoneNumber;
  final String? error;
  final DateTime? expiresAt;
  final int? resendCooldown; // Seconds until can resend

  const OtpState({
    this.status = OtpStatus.idle,
    this.phoneNumber,
    this.error,
    this.expiresAt,
    this.resendCooldown,
  });

  bool get canResend => resendCooldown == null || resendCooldown! <= 0;
  bool get isExpired =>
      expiresAt != null && DateTime.now().isAfter(expiresAt!);

  factory OtpState.initial() => const OtpState();

  factory OtpState.sending(String phoneNumber) => OtpState(
        status: OtpStatus.sending,
        phoneNumber: phoneNumber,
      );

  factory OtpState.sent({
    required String phoneNumber,
    int validityMinutes = 5,
    int resendCooldown = 60,
  }) =>
      OtpState(
        status: OtpStatus.sent,
        phoneNumber: phoneNumber,
        expiresAt: DateTime.now().add(Duration(minutes: validityMinutes)),
        resendCooldown: resendCooldown,
      );

  factory OtpState.verifying(String phoneNumber) => OtpState(
        status: OtpStatus.verifying,
        phoneNumber: phoneNumber,
      );

  factory OtpState.verified(String phoneNumber) => OtpState(
        status: OtpStatus.verified,
        phoneNumber: phoneNumber,
      );

  factory OtpState.error(String message) => OtpState(
        status: OtpStatus.error,
        error: message,
      );

  OtpState copyWith({
    OtpStatus? status,
    String? phoneNumber,
    String? error,
    DateTime? expiresAt,
    int? resendCooldown,
  }) {
    return OtpState(
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      error: error,
      expiresAt: expiresAt ?? this.expiresAt,
      resendCooldown: resendCooldown ?? this.resendCooldown,
    );
  }

  @override
  String toString() => 'OtpState(status: $status, phone: $phoneNumber)';
}
