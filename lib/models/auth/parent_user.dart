import 'package:flutter/foundation.dart';

import 'child_profile.dart';

/// Parent user model
/// Represents a parent account with phone authentication
@immutable
class ParentUser {
  final String id;
  final String phoneNumber;
  final String name;
  final String? avatar;
  final List<ChildProfile> children;
  final DateTime createdAt;

  const ParentUser({
    required this.id,
    required this.phoneNumber,
    required this.name,
    this.avatar,
    this.children = const [],
    required this.createdAt,
  });

  /// Whether parent has any children profiles
  bool get hasChildren => children.isNotEmpty;

  /// Whether parent has any expecting children (pregnancy)
  bool get hasExpecting => children.any((c) => c.isExpecting);

  /// Get child by ID
  ChildProfile? getChild(String childId) {
    try {
      return children.firstWhere((c) => c.id == childId);
    } catch (_) {
      return null;
    }
  }

  ParentUser copyWith({
    String? id,
    String? phoneNumber,
    String? name,
    String? avatar,
    List<ChildProfile>? children,
    DateTime? createdAt,
  }) {
    return ParentUser(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      children: children ?? this.children,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Add a child to the parent's profile
  ParentUser addChild(ChildProfile child) {
    return copyWith(children: [...children, child]);
  }

  /// Remove a child from the parent's profile
  ParentUser removeChild(String childId) {
    return copyWith(
      children: children.where((c) => c.id != childId).toList(),
    );
  }

  /// Update a child in the parent's profile
  ParentUser updateChild(ChildProfile updatedChild) {
    return copyWith(
      children: children.map((c) {
        return c.id == updatedChild.id ? updatedChild : c;
      }).toList(),
    );
  }

  factory ParentUser.fromJson(Map<String, dynamic> json) {
    return ParentUser(
      id: json['id'] as String,
      phoneNumber: json['phoneNumber'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      children: (json['children'] as List<dynamic>?)
              ?.map((c) => ChildProfile.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'name': name,
      'avatar': avatar,
      'children': children.map((c) => c.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ParentUser &&
        other.id == id &&
        other.phoneNumber == phoneNumber &&
        other.name == name &&
        other.avatar == avatar &&
        listEquals(other.children, children) &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      phoneNumber,
      name,
      avatar,
      Object.hashAll(children),
      createdAt,
    );
  }

  @override
  String toString() {
    return 'ParentUser(id: $id, name: $name, phone: $phoneNumber, children: ${children.length})';
  }
}
