import 'package:flutter/foundation.dart';

import 'age_group.dart';

/// Child profile model
/// Represents a child associated with a parent account
@immutable
class ChildProfile {
  final String id;
  final String name;
  final DateTime dateOfBirth;
  final String pin; // 4-6 digit PIN for child login
  final String? avatar;
  final DateTime createdAt;

  const ChildProfile({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.pin,
    this.avatar,
    required this.createdAt,
  });

  /// Get the child's age group
  AgeGroup get ageGroup => AgeGroup.fromDateOfBirth(dateOfBirth);

  /// Get age display text
  String get ageDisplay => AgeGroup.getAgeDisplay(dateOfBirth);

  /// Get exact age in years
  int get age => AgeGroup.calculateAge(dateOfBirth);

  /// Whether this is an expected child (pregnancy)
  bool get isExpecting => dateOfBirth.isAfter(DateTime.now());

  /// Verify PIN
  bool verifyPin(String inputPin) => pin == inputPin;

  ChildProfile copyWith({
    String? id,
    String? name,
    DateTime? dateOfBirth,
    String? pin,
    String? avatar,
    DateTime? createdAt,
  }) {
    return ChildProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      pin: pin ?? this.pin,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ChildProfile.fromJson(Map<String, dynamic> json) {
    return ChildProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      pin: json['pin'] as String,
      avatar: json['avatar'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'pin': pin,
      'avatar': avatar,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChildProfile &&
        other.id == id &&
        other.name == name &&
        other.dateOfBirth == dateOfBirth &&
        other.pin == pin &&
        other.avatar == avatar &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, dateOfBirth, pin, avatar, createdAt);
  }

  @override
  String toString() {
    return 'ChildProfile(id: $id, name: $name, ageGroup: $ageGroup, age: $ageDisplay)';
  }
}
