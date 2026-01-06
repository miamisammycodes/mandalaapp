import 'dart:math';

/// Dummy Data Service
///
/// Centralized service for generating realistic mock data during development.
/// This service simulates backend API responses until the real API is ready.
///
/// Features:
/// - Generates realistic mock data for all features
/// - Consistent IDs and references
/// - Varied content for better testing
/// - Easy to swap with real API later
class DummyDataService {
  // Singleton instance
  static final DummyDataService _instance = DummyDataService._internal();
  factory DummyDataService() => _instance;

  final Random _random = Random();

  // Private constructor
  DummyDataService._internal();

  // ============================================================================
  // NEWS DATA
  // ============================================================================

  /// Generate a list of news articles
  List<Map<String, dynamic>> generateNewsList(int count, {String? category}) {
    return List.generate(count, (index) {
      final id = 'news_${_random.nextInt(10000)}';
      final categories = ['Health', 'Education', 'Protection', 'Advocacy', 'Emergency'];
      final selectedCategory = category ?? categories[_random.nextInt(categories.length)];

      return {
        'id': id,
        'title': _getNewsTitle(selectedCategory),
        'excerpt': _getNewsExcerpt(selectedCategory),
        'content': _getNewsContent(selectedCategory),
        'image': 'https://picsum.photos/seed/$id/800/600',
        'author': _getRandomName(),
        'authorAvatar': 'https://i.pravatar.cc/150?u=$id',
        'category': selectedCategory,
        'tags': _getRandomTags(),
        'likeCount': _random.nextInt(500),
        'isLikedByUser': _random.nextBool(),
        'publishedAt': _getRandomDate().toIso8601String(),
        'readTime': '${_random.nextInt(10) + 3} min read',
      };
    });
  }

  /// Generate news article detail
  Map<String, dynamic> generateNewsDetail(String id) {
    final categories = ['Health', 'Education', 'Protection', 'Advocacy', 'Emergency'];
    final category = categories[_random.nextInt(categories.length)];

    return {
      'id': id,
      'title': _getNewsTitle(category),
      'excerpt': _getNewsExcerpt(category),
      'content': _getNewsContent(category),
      'image': 'https://picsum.photos/seed/$id/800/600',
      'author': _getRandomName(),
      'authorAvatar': 'https://i.pravatar.cc/150?u=$id',
      'category': category,
      'tags': _getRandomTags(),
      'likeCount': _random.nextInt(500),
      'isLikedByUser': _random.nextBool(),
      'publishedAt': _getRandomDate().toIso8601String(),
      'readTime': '${_random.nextInt(10) + 3} min read',
    };
  }

  // ============================================================================
  // EDUCATION DATA
  // ============================================================================

  /// Generate education categories (4 main mandala sections)
  List<Map<String, dynamic>> generateCategories() {
    return [
      {
        'id': 'survival',
        'name': 'Survival and Development',
        'slug': 'survival',
        'description': 'Every child has the right to life, survival and development',
        'icon': 'heart',
        'color': '#FFB3BA', // Pastel pink
        'order': 1,
        'hasSubcategories': true,
        'subcategories': [
          {'id': 'health', 'name': 'Health', 'categoryId': 'survival'},
          {'id': 'nutrition', 'name': 'Nutrition', 'categoryId': 'survival'},
          {'id': 'water', 'name': 'Water & Sanitation', 'categoryId': 'survival'},
          {'id': 'shelter', 'name': 'Shelter', 'categoryId': 'survival'},
          {'id': 'education', 'name': 'Education', 'categoryId': 'survival'},
        ],
      },
      {
        'id': 'non-discrimination',
        'name': 'Non-Discrimination',
        'slug': 'non-discrimination',
        'description': 'All children have equal rights without discrimination',
        'icon': 'people',
        'color': '#FFFFBA', // Pastel yellow
        'order': 2,
        'hasSubcategories': false,
      },
      {
        'id': 'best-interest',
        'name': 'Best Interest of the Child',
        'slug': 'best-interest',
        'description': 'The best interests of children must be the primary concern',
        'icon': 'star',
        'color': '#BAE1FF', // Pastel blue
        'order': 3,
        'hasSubcategories': false,
      },
      {
        'id': 'respect-views',
        'name': 'Respect for the Views of the Child',
        'slug': 'respect-views',
        'description': 'Every child has the right to express views freely',
        'icon': 'chat',
        'color': '#BAFFC9', // Pastel green
        'order': 4,
        'hasSubcategories': false,
      },
    ];
  }

  /// Generate content list for a category
  List<Map<String, dynamic>> generateContentList(
    String categoryId, {
    String? subcategoryId,
    int count = 10,
  }) {
    return List.generate(count, (index) {
      final id = '${categoryId}_content_$index';

      return {
        'id': id,
        'title': _getContentTitle(categoryId),
        'excerpt': _getContentExcerpt(categoryId),
        'content': _getContentBody(categoryId),
        'image': 'https://picsum.photos/seed/$id/800/600',
        'categoryId': categoryId,
        'subcategoryId': subcategoryId,
        'tags': _getRandomTags(),
        'author': 'UNICEF',
        'readTime': '${_random.nextInt(15) + 5} min read',
        'createdAt': _getRandomDate().toIso8601String(),
      };
    });
  }

  // ============================================================================
  // FEEDBACK DATA
  // ============================================================================

  /// Generate feedback list
  List<Map<String, dynamic>> generateFeedbackList({int count = 20}) {
    final categories = ['General', 'Bug Report', 'Feature Request', 'Complaint', 'Praise'];
    final statuses = ['pending', 'in_review', 'responded', 'closed'];

    return List.generate(count, (index) {
      final id = 'feedback_$index';
      final status = statuses[_random.nextInt(statuses.length)];

      return {
        'id': id,
        'userId': 'user_${_random.nextInt(100)}',
        'category': categories[_random.nextInt(categories.length)],
        'subject': _getFeedbackSubject(),
        'message': _getFeedbackMessage(),
        'email': 'user${_random.nextInt(100)}@example.com',
        'status': status,
        'response': status == 'responded' ? _getFeedbackResponse() : null,
        'createdAt': _getRandomDate().toIso8601String(),
      };
    });
  }

  // ============================================================================
  // USER DATA
  // ============================================================================

  /// Generate user data
  Map<String, dynamic> generateUser({String? id}) {
    final userId = id ?? 'user_${_random.nextInt(10000)}';
    final name = _getRandomName();

    return {
      'id': userId,
      'email': '${name.toLowerCase().replaceAll(' ', '.')}@example.com',
      'name': name,
      'avatar': 'https://i.pravatar.cc/150?u=$userId',
      'role': 'user',
      'createdAt': _getRandomDate().toIso8601String(),
    };
  }

  /// Generate auth response
  Map<String, dynamic> generateAuthResponse({String? email}) {
    final user = generateUser();
    if (email != null) {
      user['email'] = email;
    }

    return {
      'success': true,
      'user': user,
      'token': _generateToken(),
      'refreshToken': _generateToken(),
      'expiresIn': 86400, // 24 hours
    };
  }

  // ============================================================================
  // EVENT REPORT DATA
  // ============================================================================

  /// Generate event report submission response
  Map<String, dynamic> generateEventReportResponse() {
    return {
      'success': true,
      'referenceNumber': _generateReferenceNumber(),
      'message': 'Your report has been submitted successfully. We will review it shortly.',
      'status': 'pending',
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  // ============================================================================
  // CONTACT DATA
  // ============================================================================

  /// Generate contact form submission response
  Map<String, dynamic> generateContactResponse() {
    return {
      'success': true,
      'referenceNumber': _generateReferenceNumber(),
      'message': 'Thank you for contacting us. We will respond within 24-48 hours.',
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  // ============================================================================
  // SUBSCRIPTION DATA
  // ============================================================================

  /// Generate subscription response
  Map<String, dynamic> generateSubscriptionResponse(String email) {
    return {
      'success': true,
      'message': 'Subscription successful! Please check your email to confirm.',
      'email': email,
      'status': 'pending_confirmation',
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  String _getRandomName() {
    final firstNames = ['John', 'Jane', 'Alice', 'Bob', 'Sarah', 'Michael', 'Emma', 'David', 'Sophia', 'James'];
    final lastNames = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis', 'Rodriguez', 'Martinez'];
    return '${firstNames[_random.nextInt(firstNames.length)]} ${lastNames[_random.nextInt(lastNames.length)]}';
  }

  List<String> _getRandomTags() {
    final allTags = ['children', 'rights', 'protection', 'health', 'education', 'safety', 'welfare', 'support', 'community', 'family'];
    final count = _random.nextInt(3) + 2;
    allTags.shuffle();
    return allTags.take(count).toList();
  }

  DateTime _getRandomDate() {
    final daysAgo = _random.nextInt(365);
    return DateTime.now().subtract(Duration(days: daysAgo));
  }

  String _generateToken() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(64, (index) => chars[_random.nextInt(chars.length)]).join();
  }

  String _generateReferenceNumber() {
    return 'REF${DateTime.now().millisecondsSinceEpoch}${_random.nextInt(1000)}';
  }

  // News content generators
  String _getNewsTitle(String category) {
    final titles = {
      'Health': [
        'UNICEF Launches New Health Initiative for Children',
        'Vaccination Campaign Reaches 1 Million Children',
        'New Healthcare Centers Open in Rural Areas',
      ],
      'Education': [
        'Back to School: UNICEF Supports Education Recovery',
        'New Learning Materials Distributed to Schools',
        'Digital Learning Programs Expand Across Region',
      ],
      'Protection': [
        'Child Care Services Strengthened in Communities',
        'New Policies to Combat Child Labor Announced',
        'Safe Spaces Created for Vulnerable Children',
      ],
      'Advocacy': [
        'Advocating for Children\'s Rights in Policy Decisions',
        'Youth Voices Heard in National Dialogue',
        'Campaign for Child Rights Gains Momentum',
      ],
      'Emergency': [
        'Emergency Response: UNICEF Delivers Aid to Affected Areas',
        'Children Receive Emergency Assistance After Disaster',
        'Rapid Response Teams Deployed to Crisis Zones',
      ],
    };
    final categoryTitles = titles[category] ?? ['UNICEF News Update'];
    return categoryTitles[_random.nextInt(categoryTitles.length)];
  }

  String _getNewsExcerpt(String category) {
    return 'UNICEF continues its commitment to supporting children worldwide through various programs and initiatives in $category.';
  }

  String _getNewsContent(String category) {
    return '''
<p>UNICEF is working tirelessly to ensure every child has access to their fundamental rights. Our recent initiatives in $category demonstrate our ongoing commitment to creating a better world for children.</p>

<h3>Key Achievements</h3>
<p>Over the past months, we have made significant progress in addressing critical needs of children in vulnerable situations. Our programs have reached thousands of families, providing essential support and services.</p>

<h3>Looking Forward</h3>
<p>We remain committed to expanding our reach and impact. With the support of partners and donors, we will continue to advocate for children's rights and deliver life-saving programs.</p>

<p><strong>Together, we can make a difference in the lives of children everywhere.</strong></p>
''';
  }

  // Content generators
  String _getContentTitle(String categoryId) {
    final titles = {
      'survival': [
        'Understanding Child Health and Nutrition',
        'The Importance of Clean Water and Sanitation',
        'Education: A Fundamental Right',
      ],
      'non-discrimination': [
        'Equality for All Children',
        'Breaking Down Barriers to Inclusion',
        'Every Child Deserves Equal Opportunities',
      ],
      'best-interest': [
        'Putting Children First in Decision Making',
        'What Does Best Interest Mean?',
        'Protecting Children in Legal Proceedings',
      ],
      'respect-views': [
        'Listening to Children\'s Voices',
        'The Right to Express Opinion',
        'Youth Participation in Community Decisions',
      ],
    };
    final categoryTitles = titles[categoryId] ?? ['Child Rights Information'];
    return categoryTitles[_random.nextInt(categoryTitles.length)];
  }

  String _getContentExcerpt(String categoryId) {
    return 'Learn about the fundamental rights of children and how UNICEF works to protect and promote these rights globally.';
  }

  String _getContentBody(String categoryId) {
    return '''
<p>Every child deserves to have their rights protected and fulfilled. This article explores the key aspects of child rights and what we can do to ensure every child grows up in a safe, supportive environment.</p>

<h3>What You Need to Know</h3>
<p>Understanding child rights is the first step toward creating a world where every child can thrive. These rights are universal and apply to all children, regardless of their background or circumstances.</p>

<h3>How You Can Help</h3>
<p>There are many ways you can support children's rights in your community. From raising awareness to advocating for better policies, every action counts.</p>

<p><em>Together, we can build a brighter future for all children.</em></p>
''';
  }

  // Feedback generators
  String _getFeedbackSubject() {
    final subjects = [
      'Great app experience',
      'Suggestion for improvement',
      'Issue with content loading',
      'Question about resources',
      'Thank you for your work',
    ];
    return subjects[_random.nextInt(subjects.length)];
  }

  String _getFeedbackMessage() {
    return 'I wanted to share my experience with the app and provide some feedback on how it could be improved.';
  }

  String _getFeedbackResponse() {
    return 'Thank you for your feedback. We appreciate you taking the time to share your thoughts with us. We are continuously working to improve our services.';
  }
}
