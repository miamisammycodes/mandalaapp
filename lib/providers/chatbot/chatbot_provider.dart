import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/chatbot_service.dart';
import '../../models/chatbot/chat_message.dart';

/// Provider for the ChatbotService
final chatbotServiceProvider = Provider<ChatbotService>((ref) {
  return ChatbotService();
});

/// Provider for the list of chat messages
final chatbotMessagesProvider =
    StateNotifierProvider<ChatbotMessagesNotifier, List<ChatMessage>>((ref) {
  final service = ref.watch(chatbotServiceProvider);
  return ChatbotMessagesNotifier(service);
});

/// Provider for tracking if the bot is currently typing
final isBotTypingProvider = StateProvider<bool>((ref) => false);

/// Provider for suggested questions
final suggestedQuestionsProvider = Provider<List<String>>((ref) {
  final service = ref.watch(chatbotServiceProvider);
  return service.getSuggestedQuestions();
});

/// StateNotifier for managing chat messages
class ChatbotMessagesNotifier extends StateNotifier<List<ChatMessage>> {
  final ChatbotService _service;

  ChatbotMessagesNotifier(this._service) : super([]);

  /// Initialize the chat with a welcome message
  void initializeChat() {
    if (state.isEmpty) {
      final welcomeMessage = ChatMessage.bot(
        content: _service.getWelcomeMessage(),
      );
      state = [welcomeMessage];
    }
  }

  /// Add a user message and get a bot response
  Future<void> sendMessage(String content, WidgetRef ref) async {
    if (content.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage.user(content: content.trim());
    state = [...state, userMessage];

    // Set typing indicator
    ref.read(isBotTypingProvider.notifier).state = true;

    try {
      // Get bot response
      final response = await _service.generateResponse(content);
      final botMessage = ChatMessage.bot(content: response);

      // Add bot message
      state = [...state, botMessage];
    } finally {
      // Clear typing indicator
      ref.read(isBotTypingProvider.notifier).state = false;
    }
  }

  /// Clear all messages and reset chat
  void clearChat() {
    state = [];
  }
}
