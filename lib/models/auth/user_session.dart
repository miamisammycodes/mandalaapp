import 'package:flutter/foundation.dart';

import 'age_group.dart';
import 'child_profile.dart';
import 'parent_user.dart';

/// Session type - parent or child
enum SessionType {
  parent,
  child,
}

/// User session model
/// Tracks current session including parent/child mode
@immutable
class UserSession {
  final ParentUser parent;
  final SessionType sessionType;
  final String? activeChildId; // Only set when sessionType is child
  final String token;
  final DateTime createdAt;

  const UserSession({
    required this.parent,
    required this.sessionType,
    this.activeChildId,
    required this.token,
    required this.createdAt,
  });

  /// Whether currently in parent mode
  bool get isParentMode => sessionType == SessionType.parent;

  /// Whether currently in child mode
  bool get isChildMode => sessionType == SessionType.child;

  /// Get active child profile (only in child mode)
  ChildProfile? get activeChild {
    if (activeChildId == null) return null;
    return parent.getChild(activeChildId!);
  }

  /// Get active age group (null in parent mode, child's age group in child mode)
  AgeGroup? get activeAgeGroup => activeChild?.ageGroup;

  /// Create a parent session
  factory UserSession.parentSession({
    required ParentUser parent,
    required String token,
  }) {
    return UserSession(
      parent: parent,
      sessionType: SessionType.parent,
      token: token,
      createdAt: DateTime.now(),
    );
  }

  /// Create a child session
  factory UserSession.childSession({
    required ParentUser parent,
    required String childId,
    required String token,
  }) {
    return UserSession(
      parent: parent,
      sessionType: SessionType.child,
      activeChildId: childId,
      token: token,
      createdAt: DateTime.now(),
    );
  }

  /// Switch to parent mode
  UserSession switchToParent() {
    return UserSession(
      parent: parent,
      sessionType: SessionType.parent,
      activeChildId: null,
      token: token,
      createdAt: createdAt,
    );
  }

  /// Switch to child mode
  UserSession switchToChild(String childId) {
    return UserSession(
      parent: parent,
      sessionType: SessionType.child,
      activeChildId: childId,
      token: token,
      createdAt: createdAt,
    );
  }

  UserSession copyWith({
    ParentUser? parent,
    SessionType? sessionType,
    String? activeChildId,
    String? token,
    DateTime? createdAt,
  }) {
    return UserSession(
      parent: parent ?? this.parent,
      sessionType: sessionType ?? this.sessionType,
      activeChildId: activeChildId ?? this.activeChildId,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Update parent in session (e.g., after adding/removing children)
  UserSession updateParent(ParentUser updatedParent) {
    return copyWith(parent: updatedParent);
  }

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      parent: ParentUser.fromJson(json['parent'] as Map<String, dynamic>),
      sessionType: SessionType.values.firstWhere(
        (e) => e.name == json['sessionType'],
        orElse: () => SessionType.parent,
      ),
      activeChildId: json['activeChildId'] as String?,
      token: json['token'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parent': parent.toJson(),
      'sessionType': sessionType.name,
      'activeChildId': activeChildId,
      'token': token,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserSession &&
        other.parent == parent &&
        other.sessionType == sessionType &&
        other.activeChildId == activeChildId &&
        other.token == token &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(parent, sessionType, activeChildId, token, createdAt);
  }

  @override
  String toString() {
    return 'UserSession(type: $sessionType, parent: ${parent.name}, activeChild: ${activeChild?.name})';
  }
}
