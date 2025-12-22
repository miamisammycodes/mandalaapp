import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../providers/locale_provider.dart';
import '../../widgets/shared/app_button.dart';

/// Language selection screen
/// Shown on first app launch before authentication
class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends ConsumerState<LanguageSelectionScreen> {
  Locale? _selectedLocale;

  @override
  void initState() {
    super.initState();
    _selectedLocale = ref.read(localeProvider);
  }

  Future<void> _onContinue() async {
    if (_selectedLocale != null) {
      await ref.read(localeProvider.notifier).setLocale(_selectedLocale!);
      if (mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.spaceXl),
          child: Column(
            children: [
              const Spacer(),
              // Logo
              Image.asset(
                'assets/images/logo.png',
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
              SizedBox(height: AppDimensions.spaceXl),

              // Title
              Text(
                'Welcome',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
              ),
              SizedBox(height: AppDimensions.spaceSm),
              Text(
                'Select your preferred language',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textMedium,
                    ),
              ),
              SizedBox(height: AppDimensions.spaceXl * 2),

              // Language Options
              _LanguageOption(
                locale: AppLocales.english,
                title: 'English',
                subtitle: 'Continue in English',
                isSelected: _selectedLocale?.languageCode == 'en',
                onTap: () {
                  setState(() {
                    _selectedLocale = AppLocales.english;
                  });
                },
              ),
              SizedBox(height: AppDimensions.spaceMd),
              _LanguageOption(
                locale: AppLocales.dzongkha,
                title: 'རྫོང་ཁ',
                subtitle: 'Dzongkha',
                isSelected: _selectedLocale?.languageCode == 'dz',
                onTap: () {
                  setState(() {
                    _selectedLocale = AppLocales.dzongkha;
                  });
                },
              ),

              const Spacer(),

              // Continue Button
              AppButton(
                text: 'Continue',
                onPressed: _selectedLocale != null ? _onContinue : null,
                width: double.infinity,
              ),
              SizedBox(height: AppDimensions.spaceLg),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final Locale locale;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.locale,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(AppDimensions.spaceLg),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.unicefBlue.withValues(alpha: 0.1) : AppColors.cardWhite,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(
            color: isSelected ? AppColors.unicefBlue : AppColors.surfaceGray,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.unicefBlue.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.unicefBlue
                    : AppColors.surfaceGray,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  locale.languageCode.toUpperCase(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textMedium,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            SizedBox(width: AppDimensions.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMedium,
                        ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.unicefBlue,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
