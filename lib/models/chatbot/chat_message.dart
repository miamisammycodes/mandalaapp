/// Model representing a chat message in the chatbot conversation
class ChatMessage {
  final String id;
  final String content;
  final bool isUserMessage;
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.isUserMessage,
    required this.timestamp,
  });

  /// Factory constructor for creating a user message
  factory ChatMessage.user({
    required String content,
    String? id,
  }) {
    return ChatMessage(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUserMessage: true,
      timestamp: DateTime.now(),
    );
  }

  /// Factory constructor for creating a bot message
  factory ChatMessage.bot({
    required String content,
    String? id,
  }) {
    return ChatMessage(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUserMessage: false,
      timestamp: DateTime.now(),
    );
  }

  /// Create a copy with modified fields
  ChatMessage copyWith({
    String? id,
    String? content,
    bool? isUserMessage,
    DateTime? timestamp,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      isUserMessage: isUserMessage ?? this.isUserMessage,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMessage && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
