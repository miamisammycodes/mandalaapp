import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Voice input button with "Coming Soon" badge
class VoiceInputButton extends StatelessWidget {
  const VoiceInputButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main button
        Material(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            onTap: () => _showComingSoonDialog(context),
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              child: Icon(
                Icons.mic_rounded,
                color: AppColors.textMedium,
                size: 24,
              ),
            ),
          ),
        ),
        // Coming Soon badge
        Positioned(
          top: -4,
          right: -4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.pastelPurple,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Soon',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.pastelPurple.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.mic_rounded,
                color: AppColors.pastelPurple,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Voice Input'),
          ],
        ),
        content: const Text(
          'Voice input is coming soon! You\'ll be able to speak your questions and get helpful responses.\n\nFor now, please type your message in the text field.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }
}
