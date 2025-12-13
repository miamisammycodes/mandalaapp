import 'package:flutter/foundation.dart';

import '../auth/age_group.dart';

/// ICAP Chapter model
/// Represents a chapter of educational content
@immutable
class IcapChapter {
  final String id;
  final int chapterNumber;
  final String title;
  final String description;
  final String? youtubeVideoId;
  final String icon;
  final List<AgeGroup> ageGroups; // Which age groups can see this
  final List<ChapterTopic> topics;
  final int order;

  const IcapChapter({
    required this.id,
    required this.chapterNumber,
    required this.title,
    required this.description,
    this.youtubeVideoId,
    required this.icon,
    required this.ageGroups,
    this.topics = const [],
    required this.order,
  });

  /// Whether this chapter is available for a specific age group
  bool isAvailableFor(AgeGroup ageGroup) => ageGroups.contains(ageGroup);

  /// Whether this chapter is for all ages (like overview, cross-cutting)
  bool get isForAllAges => ageGroups.length >= 4;

  IcapChapter copyWith({
    String? id,
    int? chapterNumber,
    String? title,
    String? description,
    String? youtubeVideoId,
    String? icon,
    List<AgeGroup>? ageGroups,
    List<ChapterTopic>? topics,
    int? order,
  }) {
    return IcapChapter(
      id: id ?? this.id,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      youtubeVideoId: youtubeVideoId ?? this.youtubeVideoId,
      icon: icon ?? this.icon,
      ageGroups: ageGroups ?? this.ageGroups,
      topics: topics ?? this.topics,
      order: order ?? this.order,
    );
  }

  factory IcapChapter.fromJson(Map<String, dynamic> json) {
    return IcapChapter(
      id: json['id'] as String,
      chapterNumber: json['chapterNumber'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      youtubeVideoId: json['youtubeVideoId'] as String?,
      icon: json['icon'] as String,
      ageGroups: (json['ageGroups'] as List<dynamic>)
          .map((e) => AgeGroup.values.firstWhere(
                (ag) => ag.name == e,
                orElse: () => AgeGroup.child,
              ))
          .toList(),
      topics: (json['topics'] as List<dynamic>?)
              ?.map((t) => ChapterTopic.fromJson(t as Map<String, dynamic>))
              .toList() ??
          [],
      order: json['order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapterNumber': chapterNumber,
      'title': title,
      'description': description,
      'youtubeVideoId': youtubeVideoId,
      'icon': icon,
      'ageGroups': ageGroups.map((e) => e.name).toList(),
      'topics': topics.map((t) => t.toJson()).toList(),
      'order': order,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IcapChapter &&
        other.id == id &&
        other.chapterNumber == chapterNumber;
  }

  @override
  int get hashCode => Object.hash(id, chapterNumber);

  @override
  String toString() =>
      'IcapChapter($chapterNumber: $title, topics: ${topics.length})';
}

/// Topic within a chapter
@immutable
class ChapterTopic {
  final String id;
  final String title;
  final String? icon;
  final String contentFile; // Markdown file name
  final int order;

  const ChapterTopic({
    required this.id,
    required this.title,
    this.icon,
    required this.contentFile,
    required this.order,
  });

  factory ChapterTopic.fromJson(Map<String, dynamic> json) {
    return ChapterTopic(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String?,
      contentFile: json['file'] as String? ?? json['contentFile'] as String,
      order: json['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
      'contentFile': contentFile,
      'order': order,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChapterTopic && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ChapterTopic($id: $title)';
}
