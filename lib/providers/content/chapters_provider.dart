import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/content_service.dart';
import '../../models/auth/age_group.dart';
import '../../models/content/icap_chapter.dart';
import '../auth/auth_provider.dart';

/// Provider for the content service
final contentServiceProvider = Provider<ContentService>((ref) {
  return ContentService.instance;
});

/// Provider for all chapters
final allChaptersProvider = Provider<List<IcapChapter>>((ref) {
  final contentService = ref.watch(contentServiceProvider);
  return contentService.getAllChapters();
});

/// Provider for chapters filtered by active child's age group
/// Returns all chapters for parents, filtered for children
final ageFilteredChaptersProvider = Provider<List<IcapChapter>>((ref) {
  final authState = ref.watch(authStateProvider);
  final allChapters = ref.watch(allChaptersProvider);

  // If in child mode, filter by age group
  if (authState.isChildMode && authState.activeChild != null) {
    final ageGroup = authState.activeChild!.ageGroup;
    return allChapters
        .where((chapter) => chapter.isAvailableFor(ageGroup))
        .toList();
  }

  // Parent mode sees all chapters
  return allChapters;
});

/// Provider for chapters filtered by specific age group
final chaptersByAgeGroupProvider =
    Provider.family<List<IcapChapter>, AgeGroup>((ref, ageGroup) {
  final contentService = ref.watch(contentServiceProvider);
  return contentService.getChaptersForAgeGroup(ageGroup);
});

/// Provider for a single chapter by ID
final chapterByIdProvider =
    Provider.family<IcapChapter?, String>((ref, chapterId) {
  final contentService = ref.watch(contentServiceProvider);
  return contentService.getChapterById(chapterId);
});

/// Provider for topic content (async)
final topicContentProvider =
    FutureProvider.family<String, ({String chapterId, String topicId})>(
        (ref, params) async {
  final contentService = ref.watch(contentServiceProvider);
  return contentService.getTopicContent(params.chapterId, params.topicId);
});

/// Provider to check if we're in child-friendly mode
final isChildFriendlyModeProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.isChildMode;
});

/// Provider for the active child's age group (null if not in child mode)
final activeAgeGroupProvider = Provider<AgeGroup?>((ref) {
  final authState = ref.watch(authStateProvider);
  if (authState.isChildMode && authState.activeChild != null) {
    return authState.activeChild!.ageGroup;
  }
  return null;
});
