import 'package:flutter/foundation.dart';

import '../auth/age_group.dart';

/// The 4 C's of online safety
enum SafetyCategory {
  content('Content', 'Inappropriate or harmful content online', 'block'),
  conduct('Conduct', 'Online behavior and cyberbullying', 'people'),
  contact('Contact', 'Strangers and online predators', 'person_off'),
  contract('Contract', 'Privacy, scams, and data protection', 'security');

  final String title;
  final String description;
  final String icon;

  const SafetyCategory(this.title, this.description, this.icon);
}

/// Online safety topic model
@immutable
class SafetyTopic {
  final String id;
  final SafetyCategory category;
  final String title;
  final String description;
  final String content; // Markdown content
  final List<AgeGroup> targetAgeGroups;
  final List<SafetyTip> tips;
  final int order;

  const SafetyTopic({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.content,
    required this.targetAgeGroups,
    this.tips = const [],
    required this.order,
  });

  /// Whether this topic is relevant for a specific age group
  bool isRelevantFor(AgeGroup ageGroup) => targetAgeGroups.contains(ageGroup);

  SafetyTopic copyWith({
    String? id,
    SafetyCategory? category,
    String? title,
    String? description,
    String? content,
    List<AgeGroup>? targetAgeGroups,
    List<SafetyTip>? tips,
    int? order,
  }) {
    return SafetyTopic(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      targetAgeGroups: targetAgeGroups ?? this.targetAgeGroups,
      tips: tips ?? this.tips,
      order: order ?? this.order,
    );
  }

  factory SafetyTopic.fromJson(Map<String, dynamic> json) {
    return SafetyTopic(
      id: json['id'] as String,
      category: SafetyCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => SafetyCategory.content,
      ),
      title: json['title'] as String,
      description: json['description'] as String,
      content: json['content'] as String,
      targetAgeGroups: (json['targetAgeGroups'] as List<dynamic>)
          .map((e) => AgeGroup.values.firstWhere(
                (ag) => ag.name == e,
                orElse: () => AgeGroup.child,
              ))
          .toList(),
      tips: (json['tips'] as List<dynamic>?)
              ?.map((t) => SafetyTip.fromJson(t as Map<String, dynamic>))
              .toList() ??
          [],
      order: json['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.name,
      'title': title,
      'description': description,
      'content': content,
      'targetAgeGroups': targetAgeGroups.map((e) => e.name).toList(),
      'tips': tips.map((t) => t.toJson()).toList(),
      'order': order,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SafetyTopic && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'SafetyTopic($id: $title, category: ${category.name})';
}

/// Quick safety tip
@immutable
class SafetyTip {
  final String id;
  final String title;
  final String content;
  final SafetyCategory? category;
  final bool forParents; // vs for children
  final List<AgeGroup> targetAgeGroups;

  const SafetyTip({
    required this.id,
    required this.title,
    required this.content,
    this.category,
    this.forParents = true,
    this.targetAgeGroups = const [],
  });

  factory SafetyTip.fromJson(Map<String, dynamic> json) {
    return SafetyTip(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      category: json['category'] != null
          ? SafetyCategory.values.firstWhere(
              (e) => e.name == json['category'],
              orElse: () => SafetyCategory.content,
            )
          : null,
      forParents: json['forParents'] as bool? ?? true,
      targetAgeGroups: (json['targetAgeGroups'] as List<dynamic>?)
              ?.map((e) => AgeGroup.values.firstWhere(
                    (ag) => ag.name == e,
                    orElse: () => AgeGroup.child,
                  ))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category?.name,
      'forParents': forParents,
      'targetAgeGroups': targetAgeGroups.map((e) => e.name).toList(),
    };
  }

  @override
  String toString() => 'SafetyTip($id: $title)';
}

/// Safety concern report
@immutable
class SafetyConcern {
  final String id;
  final SafetyCategory category;
  final String description;
  final String? childName;
  final String? contactPhone;
  final bool isUrgent;
  final DateTime createdAt;

  const SafetyConcern({
    required this.id,
    required this.category,
    required this.description,
    this.childName,
    this.contactPhone,
    this.isUrgent = false,
    required this.createdAt,
  });

  factory SafetyConcern.create({
    required SafetyCategory category,
    required String description,
    String? childName,
    String? contactPhone,
    bool isUrgent = false,
  }) {
    return SafetyConcern(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: category,
      description: description,
      childName: childName,
      contactPhone: contactPhone,
      isUrgent: isUrgent,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.name,
      'description': description,
      'childName': childName,
      'contactPhone': contactPhone,
      'isUrgent': isUrgent,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() =>
      'SafetyConcern($id: ${category.name}, urgent: $isUrgent)';
}
