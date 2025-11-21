import 'package:flutter/material.dart';

/// Education content screen displaying information for each mandala section
class EducationContentScreen extends StatelessWidget {
  final String sectionId;
  final String title;
  final String subtitle;
  final String content;
  final String? imagePath;

  const EducationContentScreen({
    super.key,
    required this.sectionId,
    required this.title,
    required this.subtitle,
    required this.content,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1CA7EC), // UNICEF Blue
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // TODO: Implement drawer/menu
          },
        ),
        elevation: 2,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              // Subtitle
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF9C27B0), // Purple color from screenshot
                ),
              ),

              const SizedBox(height: 16),

              // Content heading
              Text(
                content,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF9C27B0), // Purple color from screenshot
                ),
              ),

              const SizedBox(height: 32),

              // Image
              if (imagePath != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Image.asset(
                    imagePath!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 32),

              // Placeholder for additional content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9C27B0).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Content will be displayed here...\n\n'
                    'This is a placeholder for educational content about child rights and protection.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// Factory constructors for each section
  factory EducationContentScreen.survival() {
    return const EducationContentScreen(
      sectionId: 'survival',
      title: 'Survival and Development',
      subtitle: 'Health and Education',
      content: 'Im healthy, I play',
      imagePath: 'assets/images/survival_content.png',
    );
  }

  factory EducationContentScreen.nonDiscrimination() {
    return const EducationContentScreen(
      sectionId: 'non-discrimination',
      title: 'Non Discrimination',
      subtitle: 'Equality and Inclusion',
      content: 'Everyone is equal',
      imagePath: 'assets/images/non_discrimination_content.png',
    );
  }

  factory EducationContentScreen.bestInterest() {
    return const EducationContentScreen(
      sectionId: 'best-interest',
      title: 'Best interest of the child',
      subtitle: 'Happiness and Wellbeing',
      content: 'I\'m happy',
      imagePath: 'assets/images/best_interest_content.png',
    );
  }

  factory EducationContentScreen.respectViews() {
    return const EducationContentScreen(
      sectionId: 'respect-views',
      title: 'Respect Views of the child',
      subtitle: 'Child Participation',
      content: 'My voice matters',
      imagePath: 'assets/images/respect_views_content.png',
    );
  }
}
