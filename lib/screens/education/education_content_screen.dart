import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../widgets/shared/app_scaffold.dart';

/// Education content screen displaying information for each mandala section
class EducationContentScreen extends StatelessWidget {
  final String sectionId;
  final String title;
  final String subtitle;
  final String description;
  final Color accentColor;
  final List<String> keyPoints;
  final String detailedContent;

  const EducationContentScreen({
    super.key,
    required this.sectionId,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.accentColor,
    required this.keyPoints,
    required this.detailedContent,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: title,
      showBackButton: true,
      onBackPressed: () {
        // Use pop for proper back animation (left to right)
        // If can't pop, navigate to home
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          context.go('/');
        }
      },
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero section with gradient
            _buildHeroSection(context),

            // Key points
            _buildKeyPointsSection(context),

            // Detailed content
            _buildContentSection(context),

            SizedBox(height: AppDimensions.spaceLg),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            accentColor.withValues(alpha: 0.3),
            accentColor.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: AppDimensions.spaceLg),

          // Section icon with child-friendly design
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.4),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accentColor.withValues(alpha: 0.3),
                    accentColor.withValues(alpha: 0.1),
                  ],
                ),
              ),
              child: Center(
                child: _buildSectionIllustration(),
              ),
            ),
          ),

          SizedBox(height: AppDimensions.spaceLg),

          // Subtitle
          Text(
            subtitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: AppDimensions.spaceSm),

          // Description tagline
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.spaceLg),
            child: Text(
              description,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: AppDimensions.spaceLg),
        ],
      ),
    );
  }

  Widget _buildKeyPointsSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Principles',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
          ),
          SizedBox(height: AppDimensions.spaceMd),

          // Key points as cards
          ...keyPoints.asMap().entries.map((entry) {
            final index = entry.key;
            final point = entry.value;
            return _buildKeyPointCard(context, index + 1, point);
          }),
        ],
      ),
    );
  }

  Widget _buildKeyPointCard(BuildContext context, int number, String point) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.spaceMd),
      padding: EdgeInsets.all(AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$number',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(width: AppDimensions.spaceMd),
          Expanded(
            child: Text(
              point,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMedium,
                    height: 1.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Learn More',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
          ),
          SizedBox(height: AppDimensions.spaceMd),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppDimensions.spaceMd),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              detailedContent,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMedium,
                    height: 1.6,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build a child-friendly illustration for each section
  Widget _buildSectionIllustration() {
    switch (sectionId) {
      case 'survival':
        // Health & Education - Kids playing/learning
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.favorite, size: 56, color: accentColor),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.favorite, size: 20, color: Colors.red[300]),
              ),
            ),
          ],
        );
      case 'non-discrimination':
        // Equality - Multiple children together
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.boy, size: 40, color: accentColor),
            Icon(Icons.girl, size: 40, color: accentColor.withValues(alpha: 0.7)),
            Icon(Icons.accessibility_new, size: 32, color: accentColor.withValues(alpha: 0.5)),
          ],
        );
      case 'best-interest':
        // Happiness - Happy child with heart
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.emoji_emotions, size: 56, color: accentColor),
            Positioned(
              bottom: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, size: 16, color: Colors.amber),
                  Icon(Icons.star, size: 20, color: Colors.amber),
                  Icon(Icons.star, size: 16, color: Colors.amber),
                ],
              ),
            ),
          ],
        );
      case 'respect-views':
        // Participation - Child speaking
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.record_voice_over, size: 56, color: accentColor),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.mic, size: 18, color: accentColor),
              ),
            ),
          ],
        );
      default:
        return Icon(Icons.circle, size: 56, color: accentColor);
    }
  }

  /// Factory constructors for each section
  factory EducationContentScreen.survival() {
    return const EducationContentScreen(
      sectionId: 'survival',
      title: 'Survival and Development',
      subtitle: 'Health and Education',
      description: '"I\'m healthy, I learn and play"',
      accentColor: Color(0xFFE57373), // Soft red
      keyPoints: [
        'Every child has the inherent right to life, and governments must ensure child survival and development.',
        'Children have the right to the best health care possible, clean water, nutritious food, and a clean environment.',
        'Every child has the right to education that develops their personality, talents, and abilities to the fullest.',
        'Children have the right to rest, play, and participate in cultural and artistic activities.',
      ],
      detailedContent:
          'The right to survival and development is one of the four guiding principles of the UN Convention on the Rights of the Child. '
          'It emphasizes that every child has the right to life and that governments must do everything they can to ensure children survive and develop healthily.\n\n'
          'This includes providing access to healthcare, nutrition, education, and safe living conditions. '
          'Children need nurturing environments where they can grow physically, mentally, emotionally, and socially.',
    );
  }

  factory EducationContentScreen.nonDiscrimination() {
    return const EducationContentScreen(
      sectionId: 'non-discrimination',
      title: 'Non-Discrimination',
      subtitle: 'Equality and Inclusion',
      description: '"Everyone is equal, I belong"',
      accentColor: Color(0xFFFFD54F), // Soft yellow
      keyPoints: [
        'All children have equal rights regardless of race, color, sex, language, religion, or any other status.',
        'No child should be discriminated against or treated unfairly for any reason.',
        'Children with disabilities have the right to special care and support to live full lives.',
        'Every child deserves the same opportunities to reach their full potential.',
      ],
      detailedContent:
          'The principle of non-discrimination ensures that all rights apply to all children without exception. '
          'No child should face discrimination based on their own or their parent\'s race, color, sex, language, religion, opinions, origins, wealth, birth status, or abilities.\n\n'
          'This principle requires governments to identify children who might need extra measures to enjoy their rights. '
          'It means creating inclusive environments where every child feels valued and has equal opportunities.',
    );
  }

  factory EducationContentScreen.bestInterest() {
    return const EducationContentScreen(
      sectionId: 'best-interest',
      title: 'Best Interest of the Child',
      subtitle: 'Happiness and Wellbeing',
      description: '"I\'m happy, my needs come first"',
      accentColor: Color(0xFF9575CD), // Soft purple
      keyPoints: [
        'When adults make decisions affecting children, the child\'s best interests must be the primary consideration.',
        'Children\'s physical, emotional, and educational needs should guide all decisions about their lives.',
        'Protection from harm and ensuring child wellbeing is the responsibility of both families and governments.',
        'Every child deserves to live in conditions that support their happiness and healthy development.',
      ],
      detailedContent:
          'The best interests of the child must be a primary consideration in all actions concerning children. '
          'This applies to actions by courts, administrative authorities, legislative bodies, and public or private institutions.\n\n'
          'When making decisions about a child, adults must consider what is best for that child\'s wellbeing, safety, and development. '
          'This includes decisions about education, healthcare, family matters, and social services.',
    );
  }

  factory EducationContentScreen.respectViews() {
    return const EducationContentScreen(
      sectionId: 'respect-views',
      title: 'Respect for the Views of the Child',
      subtitle: 'Child Participation',
      description: '"My voice matters, I am heard"',
      accentColor: Color(0xFF81C784), // Soft green
      keyPoints: [
        'Every child has the right to express their views, feelings, and wishes in all matters affecting them.',
        'Children\'s opinions should be given due weight according to their age and maturity.',
        'Children have the right to be heard in any legal or administrative proceedings affecting them.',
        'Participation helps children develop confidence, skills, and a sense of responsibility.',
      ],
      detailedContent:
          'Children have the right to give their opinions freely on matters that affect them. '
          'Adults should listen and take children\'s views seriously, giving them appropriate weight based on the child\'s age and maturity.\n\n'
          'This doesn\'t mean children get to make all decisions, but that their perspectives are valued and considered. '
          'Meaningful participation helps children develop critical thinking, communication skills, and prepares them for active citizenship.',
    );
  }
}
