import 'package:flutter/foundation.dart';

import '../auth/age_group.dart';

/// Event category types
enum EventCategory {
  seminar('Seminar', 'school'),
  training('Training', 'fitness_center'),
  workshop('Workshop', 'build'),
  awareness('Awareness Campaign', 'campaign'),
  community('Community Event', 'groups'),
  health('Health Camp', 'health_and_safety'),
  other('Other', 'event');

  final String label;
  final String icon;

  const EventCategory(this.label, this.icon);
}

/// Target audience for events
enum EventAudience {
  parents('Parents'),
  children('Children'),
  families('Families'),
  educators('Educators'),
  healthWorkers('Health Workers'),
  community('Community'),
  all('Everyone');

  final String label;

  const EventAudience(this.label);
}

/// Agency/organization hosting the event
@immutable
class EventAgency {
  final String id;
  final String name;
  final String? logo;

  const EventAgency({
    required this.id,
    required this.name,
    this.logo,
  });

  factory EventAgency.fromJson(Map<String, dynamic> json) {
    return EventAgency(
      id: json['id'] as String,
      name: json['name'] as String,
      logo: json['logo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
    };
  }
}

/// Event model for agency-posted events
@immutable
class Event {
  final String id;
  final String title;
  final String description;
  final DateTime eventDate;
  final String? startTime; // e.g., "09:00"
  final String? endTime; // e.g., "17:00"
  final String location;
  final bool isVirtual;
  final String? virtualLink;
  final EventAgency agency;
  final EventCategory category;
  final List<EventAudience> targetAudience;
  final List<AgeGroup>? targetAgeGroups; // For child-specific events
  final String? registrationUrl;
  final String? imageUrl;
  final bool isFeatured;
  final DateTime createdAt;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.eventDate,
    this.startTime,
    this.endTime,
    required this.location,
    this.isVirtual = false,
    this.virtualLink,
    required this.agency,
    required this.category,
    required this.targetAudience,
    this.targetAgeGroups,
    this.registrationUrl,
    this.imageUrl,
    this.isFeatured = false,
    required this.createdAt,
  });

  /// Whether event is in the past
  bool get isPast => eventDate.isBefore(DateTime.now());

  /// Whether event is today
  bool get isToday {
    final now = DateTime.now();
    return eventDate.year == now.year &&
        eventDate.month == now.month &&
        eventDate.day == now.day;
  }

  /// Whether event is upcoming (within next 7 days)
  bool get isUpcoming {
    final now = DateTime.now();
    final weekFromNow = now.add(const Duration(days: 7));
    return eventDate.isAfter(now) && eventDate.isBefore(weekFromNow);
  }

  /// Formatted date string
  String get formattedDate {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${eventDate.day} ${months[eventDate.month - 1]} ${eventDate.year}';
  }

  /// Formatted time range
  String? get formattedTime {
    if (startTime == null) return null;
    if (endTime == null) return startTime;
    return '$startTime - $endTime';
  }

  /// Whether this event is relevant for a specific audience
  bool isForAudience(EventAudience audience) =>
      targetAudience.contains(EventAudience.all) ||
      targetAudience.contains(audience);

  /// Whether this event is relevant for a specific age group
  bool isForAgeGroup(AgeGroup? ageGroup) {
    if (targetAgeGroups == null || targetAgeGroups!.isEmpty) return true;
    if (ageGroup == null) return true;
    return targetAgeGroups!.contains(ageGroup);
  }

  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? eventDate,
    String? startTime,
    String? endTime,
    String? location,
    bool? isVirtual,
    String? virtualLink,
    EventAgency? agency,
    EventCategory? category,
    List<EventAudience>? targetAudience,
    List<AgeGroup>? targetAgeGroups,
    String? registrationUrl,
    String? imageUrl,
    bool? isFeatured,
    DateTime? createdAt,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      eventDate: eventDate ?? this.eventDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      isVirtual: isVirtual ?? this.isVirtual,
      virtualLink: virtualLink ?? this.virtualLink,
      agency: agency ?? this.agency,
      category: category ?? this.category,
      targetAudience: targetAudience ?? this.targetAudience,
      targetAgeGroups: targetAgeGroups ?? this.targetAgeGroups,
      registrationUrl: registrationUrl ?? this.registrationUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      isFeatured: isFeatured ?? this.isFeatured,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      location: json['location'] as String,
      isVirtual: json['isVirtual'] as bool? ?? false,
      virtualLink: json['virtualLink'] as String?,
      agency: EventAgency.fromJson(json['agency'] as Map<String, dynamic>),
      category: EventCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => EventCategory.other,
      ),
      targetAudience: (json['targetAudience'] as List<dynamic>)
          .map((e) => EventAudience.values.firstWhere(
                (a) => a.name == e,
                orElse: () => EventAudience.all,
              ))
          .toList(),
      targetAgeGroups: (json['targetAgeGroups'] as List<dynamic>?)
          ?.map((e) => AgeGroup.values.firstWhere(
                (ag) => ag.name == e,
                orElse: () => AgeGroup.child,
              ))
          .toList(),
      registrationUrl: json['registrationUrl'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isFeatured: json['isFeatured'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'eventDate': eventDate.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'isVirtual': isVirtual,
      'virtualLink': virtualLink,
      'agency': agency.toJson(),
      'category': category.name,
      'targetAudience': targetAudience.map((e) => e.name).toList(),
      'targetAgeGroups': targetAgeGroups?.map((e) => e.name).toList(),
      'registrationUrl': registrationUrl,
      'imageUrl': imageUrl,
      'isFeatured': isFeatured,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Event && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Event($id: $title, date: $formattedDate)';
}
