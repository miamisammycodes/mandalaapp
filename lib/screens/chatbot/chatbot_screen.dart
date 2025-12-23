import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../providers/chatbot/chatbot_provider.dart';
import '../../widgets/chatbot/chat_input_field.dart';
import '../../widgets/chatbot/chat_message_bubble.dart';
import '../../widgets/chatbot/chat_suggestions.dart';
import '../../widgets/chatbot/typing_indicator.dart';
import '../../widgets/chatbot/voice_input_button.dart';
import '../../widgets/shared/app_scaffold.dart';

/// Chatbot screen with chat interface
class ChatbotScreen extends ConsumerStatefulWidget {
  const ChatbotScreen({super.key});

  @override
  ConsumerState<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends ConsumerState<ChatbotScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Initialize chat with welcome message after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatbotMessagesProvider.notifier).initializeChat();
    });

    // Listen to text changes to update send button state
    _messageController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String content) {
    if (content.trim().isEmpty) return;

    _messageController.clear();
    ref.read(chatbotMessagesProvider.notifier).sendMessage(content, ref);

    // Scroll to bottom after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatbotMessagesProvider);
    final isTyping = ref.watch(isBotTypingProvider);
    final suggestions = ref.watch(suggestedQuestionsProvider);

    // Scroll to bottom when messages change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (messages.isNotEmpty) {
        _scrollToBottom();
      }
    });

    return AppScaffold(
      title: 'Chat Support',
      actions: [
        // Clear chat button
        if (messages.length > 1)
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Start new chat',
            onPressed: () => _showClearChatDialog(),
          ),
      ],
      body: Column(
        children: [
          // Info banner
          _buildInfoBanner(),

          // Messages list
          Expanded(
            child: messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.spaceMd,
                    ),
                    itemCount: messages.length + (isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == messages.length && isTyping) {
                        return const TypingIndicator();
                      }
                      return ChatMessageBubble(message: messages[index]);
                    },
                  ),
          ),

          // Suggestions (show when not typing and has few messages)
          if (!isTyping && messages.length <= 2)
            ChatSuggestions(
              suggestions: suggestions,
              onSuggestionTap: _sendMessage,
            ),

          // Input area
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Voice button
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 8),
                    child: const VoiceInputButton(),
                  ),
                  // Text input
                  Expanded(
                    child: ChatInputField(
                      controller: _messageController,
                      onSend: () => _sendMessage(_messageController.text),
                      isEnabled: !isTyping,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.spaceMd),
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.pastelPurple.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: AppColors.pastelPurple.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.pastelPurple.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: AppColors.pastelPurple,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Assistant (Preview)',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'This is a demo chatbot. Full AI capabilities coming soon!',
                  style: TextStyle(
                    color: AppColors.textMedium,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.unicefBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 48,
              color: AppColors.unicefBlue,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Start a conversation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ask me about child protection,\nonline safety, or parenting tips!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textMedium,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showClearChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Start new chat?'),
        content: const Text(
          'This will clear the current conversation and start fresh.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(chatbotMessagesProvider.notifier).clearChat();
              ref.read(chatbotMessagesProvider.notifier).initializeChat();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
