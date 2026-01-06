import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/auth/age_group.dart';
import '../../models/events/event.dart';

/// Provider for all events
final eventsProvider = Provider<List<Event>>((ref) {
  return _mockEvents;
});

/// Provider for upcoming events (future events)
final upcomingEventsProvider = Provider<List<Event>>((ref) {
  final events = ref.watch(eventsProvider);
  final now = DateTime.now();
  return events
      .where((e) => e.eventDate.isAfter(now) || e.isToday)
      .toList()
    ..sort((a, b) => a.eventDate.compareTo(b.eventDate));
});

/// Provider for past events
final pastEventsProvider = Provider<List<Event>>((ref) {
  final events = ref.watch(eventsProvider);
  final now = DateTime.now();
  return events.where((e) => e.eventDate.isBefore(now) && !e.isToday).toList()
    ..sort((a, b) => b.eventDate.compareTo(a.eventDate)); // Most recent first
});

/// Provider for featured events
final featuredEventsProvider = Provider<List<Event>>((ref) {
  final events = ref.watch(upcomingEventsProvider);
  return events.where((e) => e.isFeatured).toList();
});

/// Provider for events by category
final eventsByCategoryProvider =
    Provider.family<List<Event>, EventCategory?>((ref, category) {
  final events = ref.watch(upcomingEventsProvider);
  if (category == null) return events;
  return events.where((e) => e.category == category).toList();
});

/// Provider for a single event by ID
final eventByIdProvider = Provider.family<Event?, String>((ref, id) {
  final events = ref.watch(eventsProvider);
  try {
    return events.firstWhere((e) => e.id == id);
  } catch (_) {
    return null;
  }
});

/// Provider for events filtered by audience
final eventsByAudienceProvider =
    Provider.family<List<Event>, EventAudience?>((ref, audience) {
  final events = ref.watch(upcomingEventsProvider);
  if (audience == null) return events;
  return events.where((e) => e.isForAudience(audience)).toList();
});

/// State notifier for event filters
class EventFilterState {
  final EventCategory? category;
  final EventAudience? audience;
  final bool showPast;

  const EventFilterState({
    this.category,
    this.audience,
    this.showPast = false,
  });

  EventFilterState copyWith({
    EventCategory? category,
    EventAudience? audience,
    bool? showPast,
    bool clearCategory = false,
    bool clearAudience = false,
  }) {
    return EventFilterState(
      category: clearCategory ? null : (category ?? this.category),
      audience: clearAudience ? null : (audience ?? this.audience),
      showPast: showPast ?? this.showPast,
    );
  }
}

class EventFilterNotifier extends StateNotifier<EventFilterState> {
  EventFilterNotifier() : super(const EventFilterState());

  void setCategory(EventCategory? category) {
    state = state.copyWith(category: category, clearCategory: category == null);
  }

  void setAudience(EventAudience? audience) {
    state = state.copyWith(audience: audience, clearAudience: audience == null);
  }

  void toggleShowPast() {
    state = state.copyWith(showPast: !state.showPast);
  }

  void clearFilters() {
    state = const EventFilterState();
  }
}

final eventFilterProvider =
    StateNotifierProvider<EventFilterNotifier, EventFilterState>((ref) {
  return EventFilterNotifier();
});

/// Provider for filtered events based on current filter state
final filteredEventsProvider = Provider<List<Event>>((ref) {
  final filterState = ref.watch(eventFilterProvider);
  final baseEvents = filterState.showPast
      ? ref.watch(pastEventsProvider)
      : ref.watch(upcomingEventsProvider);

  var filtered = baseEvents;

  if (filterState.category != null) {
    filtered = filtered.where((e) => e.category == filterState.category).toList();
  }

  if (filterState.audience != null) {
    filtered = filtered.where((e) => e.isForAudience(filterState.audience!)).toList();
  }

  return filtered;
});

// Mock agencies
const _unicef = EventAgency(
  id: 'unicef',
  name: 'UNICEF Bhutan',
);

const _ncwc = EventAgency(
  id: 'ncwc',
  name: 'National Commission for Women and Children',
);

const _mohHealth = EventAgency(
  id: 'moh',
  name: 'Ministry of Health',
);

const _moe = EventAgency(
  id: 'moe',
  name: 'Ministry of Education',
);

// Mock events data
final _mockEvents = [
  // Upcoming events
  Event(
    id: 'event-1',
    title: 'Child Care Awareness Workshop',
    description:
        'Join us for a comprehensive workshop on understanding child rights and protection mechanisms in Bhutan. Learn about the legal framework, reporting procedures, and support services available for children.\n\nThis workshop is ideal for parents, educators, and community leaders who want to better understand how to protect children in their communities.',
    eventDate: DateTime.now().add(const Duration(days: 3)),
    startTime: '09:00',
    endTime: '16:00',
    location: 'Thimphu Conference Center, Norzin Lam',
    agency: _unicef,
    category: EventCategory.workshop,
    targetAudience: [EventAudience.parents, EventAudience.educators],
    isFeatured: true,
    registrationUrl: 'https://example.com/register',
    imageUrl: 'https://images.unsplash.com/photo-1577896851231-70ef18881754?w=800',
    createdAt: DateTime.now().subtract(const Duration(days: 7)),
  ),
  Event(
    id: 'event-2',
    title: 'Positive Parenting Seminar',
    description:
        'Discover effective positive parenting techniques that strengthen the bond between you and your child. Topics include positive discipline, effective communication, and building emotional resilience in children.\n\nLight refreshments will be provided.',
    eventDate: DateTime.now().add(const Duration(days: 7)),
    startTime: '14:00',
    endTime: '17:00',
    location: 'Royal University of Bhutan, Paro',
    agency: _ncwc,
    category: EventCategory.seminar,
    targetAudience: [EventAudience.parents],
    isFeatured: true,
    imageUrl: 'https://images.unsplash.com/photo-1491013516836-7db643ee125a?w=800',
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
  ),
  Event(
    id: 'event-3',
    title: 'Online Safety for Children',
    description:
        'A special session designed for children aged 10-17 to learn about staying safe online. Interactive activities will cover topics like protecting personal information, recognizing online threats, and responsible social media use.',
    eventDate: DateTime.now().add(const Duration(days: 10)),
    startTime: '10:00',
    endTime: '12:00',
    location: 'Virtual Event',
    isVirtual: true,
    virtualLink: 'https://zoom.us/example',
    agency: _unicef,
    category: EventCategory.training,
    targetAudience: [EventAudience.children],
    targetAgeGroups: [AgeGroup.child, AgeGroup.teen],
    imageUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
  Event(
    id: 'event-4',
    title: 'Community Health Camp',
    description:
        'Free health check-ups for children including vision screening, dental check-ups, and general health assessments. Nutritional counseling will also be available for parents.\n\nPlease bring your child\'s health card.',
    eventDate: DateTime.now().add(const Duration(days: 14)),
    startTime: '08:00',
    endTime: '15:00',
    location: 'Punakha District Hospital',
    agency: _mohHealth,
    category: EventCategory.health,
    targetAudience: [EventAudience.families],
    isFeatured: true,
    imageUrl: 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=800',
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
  ),
  Event(
    id: 'event-5',
    title: 'Early Childhood Development Training',
    description:
        'Training program for educators and caregivers on early childhood development best practices. Learn about age-appropriate activities, developmental milestones, and creating nurturing environments for young children.',
    eventDate: DateTime.now().add(const Duration(days: 21)),
    startTime: '09:00',
    endTime: '17:00',
    location: 'Teacher Training College, Paro',
    agency: _moe,
    category: EventCategory.training,
    targetAudience: [EventAudience.educators],
    registrationUrl: 'https://example.com/ecd-training',
    imageUrl: 'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=800',
    createdAt: DateTime.now().subtract(const Duration(days: 14)),
  ),
  Event(
    id: 'event-6',
    title: 'Family Fun Day',
    description:
        'A day of fun activities for the whole family! Games, art activities, storytelling, and educational exhibits on child development and safety. Food stalls and entertainment for all ages.',
    eventDate: DateTime.now().add(const Duration(days: 28)),
    startTime: '10:00',
    endTime: '18:00',
    location: 'Changlimithang Stadium, Thimphu',
    agency: _unicef,
    category: EventCategory.community,
    targetAudience: [EventAudience.all],
    isFeatured: true,
    imageUrl: 'https://images.unsplash.com/photo-1472162072942-cd5147eb3902?w=800',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  Event(
    id: 'event-7',
    title: 'Adolescent Mental Health Awareness',
    description:
        'Understanding mental health challenges in teenagers and how to provide support. For parents and educators of adolescents.\n\nTopics include: recognizing signs of stress and anxiety, communication strategies, and available support resources.',
    eventDate: DateTime.now().add(const Duration(days: 5)),
    startTime: '13:00',
    endTime: '16:00',
    location: 'Jigme Dorji Wangchuck National Referral Hospital',
    agency: _mohHealth,
    category: EventCategory.awareness,
    targetAudience: [EventAudience.parents, EventAudience.educators],
    imageUrl: 'https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?w=800',
    createdAt: DateTime.now().subtract(const Duration(days: 4)),
  ),

  // Past events
  Event(
    id: 'event-past-1',
    title: 'Child Rights Day Celebration',
    description:
        'Annual celebration of Child Rights Day with activities, performances, and awareness campaigns across the country.',
    eventDate: DateTime.now().subtract(const Duration(days: 30)),
    startTime: '09:00',
    endTime: '17:00',
    location: 'Clock Tower Square, Thimphu',
    agency: _ncwc,
    category: EventCategory.awareness,
    targetAudience: [EventAudience.all],
    isFeatured: false,
    createdAt: DateTime.now().subtract(const Duration(days: 45)),
  ),
  Event(
    id: 'event-past-2',
    title: 'Parent-Teacher Conference on Child Safety',
    description:
        'Conference bringing together parents and teachers to discuss child safety measures in schools and at home.',
    eventDate: DateTime.now().subtract(const Duration(days: 14)),
    startTime: '14:00',
    endTime: '17:00',
    location: 'Yangchenphug Higher Secondary School',
    agency: _moe,
    category: EventCategory.seminar,
    targetAudience: [EventAudience.parents, EventAudience.educators],
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
  ),
  Event(
    id: 'event-past-3',
    title: 'Nutrition Workshop for Parents',
    description:
        'Learn about proper nutrition for children at different ages. Practical tips on meal planning and healthy eating habits.',
    eventDate: DateTime.now().subtract(const Duration(days: 7)),
    startTime: '10:00',
    endTime: '13:00',
    location: 'Bajo Health Center, Wangdue',
    agency: _mohHealth,
    category: EventCategory.workshop,
    targetAudience: [EventAudience.parents],
    createdAt: DateTime.now().subtract(const Duration(days: 21)),
  ),
];
