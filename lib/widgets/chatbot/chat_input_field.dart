import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

/// Chat input field with send button
class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isEnabled;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceSm,
        vertical: AppDimensions.spaceSm,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          // Text field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceGray,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: controller,
                enabled: isEnabled,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 4,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: isEnabled ? 'Type a message...' : 'Please wait...',
                  hintStyle: TextStyle(color: AppColors.textLight),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onSubmitted: isEnabled ? (_) => _handleSend() : null,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Send button
          Material(
            color: isEnabled && controller.text.trim().isNotEmpty
                ? AppColors.unicefBlue
                : AppColors.textLight.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              onTap: isEnabled ? _handleSend : null,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                child: Icon(
                  Icons.send_rounded,
                  color: isEnabled ? Colors.white : AppColors.textLight,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSend() {
    if (controller.text.trim().isNotEmpty) {
      onSend();
    }
  }
}
