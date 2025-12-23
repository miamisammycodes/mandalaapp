import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/router/app_router.dart';
import '../../widgets/home/mandala_image_viewer.dart';
import '../../widgets/shared/app_scaffold.dart';

/// Home screen displaying the interactive Child Mandala
class MandalaHomeScreen extends StatefulWidget {
  const MandalaHomeScreen({super.key});

  @override
  State<MandalaHomeScreen> createState() => _MandalaHomeScreenState();
}

class _MandalaHomeScreenState extends State<MandalaHomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() => _currentPage = page);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<_NavButton> _getButtons(BuildContext context) {
    return [
      _NavButton(
        label: 'Learning',
        description: 'Age-appropriate parenting content',
        icon: Icons.school,
        color: const Color(0xFF7E57C2),
        onTap: () => context.pushNamed(AppRoutes.chapters),
      ),
      _NavButton(
        label: 'News',
        description: 'Latest updates and articles',
        icon: Icons.article,
        color: const Color(0xFFFF9800),
        onTap: () => context.pushNamed(AppRoutes.news),
      ),
      _NavButton(
        label: 'Events',
        description: 'Upcoming community events',
        icon: Icons.event,
        color: const Color(0xFFE91E63),
        onTap: () => context.pushNamed(AppRoutes.events),
      ),
      _NavButton(
        label: 'Online Safety',
        description: 'Keep your children safe online',
        icon: Icons.security,
        color: AppColors.unicefBlue,
        onTap: () => context.pushNamed(AppRoutes.onlineSafety),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final buttons = _getButtons(context);

    return AppScaffold(
      title: 'The Child Mandala App',
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [AppColors.unicefBlue, Color(0xFF0D8BD9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.unicefBlue.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => context.pushNamed(AppRoutes.chatbot),
          backgroundColor: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
          icon: const Icon(
            Icons.chat_rounded,
            color: Colors.white,
          ),
          label: const Text(
            'Chat',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Mandala viewer with padding
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: MandalaImageViewer(),
              ),
              const SizedBox(height: 16),
              // Horizontal carousel
              SizedBox(
                height: 160,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: buttons.length,
                  itemBuilder: (context, index) {
                    return _CarouselCard(
                      button: buttons[index],
                      isActive: index == _currentPage,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Page indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  buttons.length,
                  (index) => _PageIndicator(
                    isActive: index == _currentPage,
                    color: buttons[index].color,
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
}

class _NavButton {
  final String label;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _NavButton({
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class _CarouselCard extends StatelessWidget {
  final _NavButton button;
  final bool isActive;

  const _CarouselCard({
    required this.button,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      margin: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: isActive ? 0 : 12,
      ),
      child: GestureDetector(
        onTap: button.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            border: Border.all(
              color: isActive ? button.color : Colors.grey.shade200,
              width: isActive ? 2 : 1,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: button.color.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spaceMd),
            child: Row(
              children: [
                // Icon container
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isActive ? 70 : 60,
                  height: isActive ? 70 : 60,
                  decoration: BoxDecoration(
                    color: button.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  ),
                  child: Icon(
                    button.icon,
                    size: isActive ? 36 : 30,
                    color: button.color,
                  ),
                ),
                const SizedBox(width: AppDimensions.spaceMd),
                // Text content
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        button.label,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: button.color,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        button.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textMedium,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Arrow
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: isActive ? button.color : AppColors.textLight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final bool isActive;
  final Color color;

  const _PageIndicator({
    required this.isActive,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? color : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
