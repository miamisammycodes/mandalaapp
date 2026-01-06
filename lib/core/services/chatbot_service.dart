import 'dart:math';

/// Service for handling chatbot demo responses
class ChatbotService {
  // Singleton pattern
  static final ChatbotService _instance = ChatbotService._internal();
  factory ChatbotService() => _instance;
  ChatbotService._internal();

  final Random _random = Random();

  /// Get the welcome message when chat starts
  String getWelcomeMessage() {
    return "Hello! I'm the UNICEF Child Care Assistant. "
        "I can help you learn about child care, online safety, and parenting resources."
        "This feature is still being developed, but feel free to ask me anything!";
  }

  /// Get suggested questions for the user
  List<String> getSuggestedQuestions() {
    return [
      'What is child protection?',
      'How can I keep my child safe online?',
      'Tell me about ICAP',
      'What events are coming up?',
      'Emergency contacts',
    ];
  }

  /// Generate a response based on the user's message
  /// Simulates network delay for realistic chat experience
  Future<String> generateResponse(String userMessage) async {
    // Simulate thinking time (500ms - 1500ms)
    await Future.delayed(Duration(milliseconds: 500 + _random.nextInt(1000)));

    final message = userMessage.toLowerCase();

    // Check for greetings
    if (_containsAny(message, ['hello', 'hi', 'hey', 'good morning', 'good afternoon', 'good evening'])) {
      return _getRandomResponse([
        "Hello! How can I help you today?",
        "Hi there! I'm here to help with child protection information. What would you like to know?",
        "Hey! Welcome to the Child Mandala app. Feel free to ask me anything!",
      ]);
    }

    // Check for child protection keywords
    if (_containsAny(message, ['child', 'children', 'protection', 'protect', 'rights'])) {
      return "Child protection is at the heart of what we do! The Child Mandala app provides:\n\n"
          "• Age-appropriate learning content (ICAP chapters)\n"
          "• Online safety guidance\n"
          "• Resources for parents and caregivers\n"
          "• Event reporting for concerns\n\n"
          "Check out the Learning section in the app to explore more!";
    }

    // Check for ICAP/learning/education keywords
    if (_containsAny(message, ['icap', 'learning', 'education', 'chapter', 'content', 'parenting'])) {
      return "ICAP (Integrated Child and Adolescent Parenting) provides age-based guidance for parents:\n\n"
          "• Pregnancy care\n"
          "• Birth to 3 years development\n"
          "• Preschool years (3-5)\n"
          "• Primary school (6-12)\n"
          "• Adolescence (13-17)\n\n"
          "Go to Learning in the menu to explore chapters tailored to your child's age!";
    }

    // Check for online safety keywords
    if (_containsAny(message, ['safety', 'online', 'internet', 'cyber', 'digital', 'screen'])) {
      return "Online safety is crucial in today's digital world. We cover the 4 C's of online risks:\n\n"
          "• Content - Inappropriate or harmful material\n"
          "• Contact - Strangers and unsafe interactions\n"
          "• Conduct - Cyberbullying and harmful behavior\n"
          "• Contract - Privacy and data protection\n\n"
          "Visit the Online Safety section for tips and guidance!";
    }

    // Check for events keywords
    if (_containsAny(message, ['event', 'events', 'workshop', 'seminar', 'training', 'calendar'])) {
      return "We have various events organized by child protection agencies:\n\n"
          "• Parenting workshops\n"
          "• Child safety seminars\n"
          "• Community awareness campaigns\n"
          "• Training sessions\n\n"
          "Check the Events section in the app to see upcoming activities in your area!";
    }

    // Check for emergency/help keywords
    if (_containsAny(message, ['help', 'emergency', 'urgent', 'contact', 'report', 'abuse', 'danger'])) {
      return "For urgent matters or to report concerns:\n\n"
          "📞 Police Emergency: 113\n"
          "📞 Child Helpline: 1098\n"
          "📞 Women & Child Helpline: 1010\n\n"
          "You can also use the Report Event feature in the app to submit a detailed report. "
          "Your safety and your child's safety is our priority!";
    }

    // Check for thanks/goodbye
    if (_containsAny(message, ['thank', 'thanks', 'bye', 'goodbye', 'see you'])) {
      return _getRandomResponse([
        "You're welcome! Feel free to reach out anytime you need help.",
        "Happy to help! Take care and stay safe!",
        "Goodbye! Remember, protecting children is everyone's responsibility.",
      ]);
    }

    // Default response
    return _getRandomResponse([
      "I'm still learning! This chatbot feature is coming soon with more capabilities. "
          "In the meantime, explore the app's Learning, Events, and Online Safety sections for helpful information.",
      "That's a great question! While I'm still being developed, you can find lots of helpful information "
          "in the app's various sections. Try the Learning section for parenting content!",
      "I'm not quite sure about that yet, but I'm getting smarter every day! "
          "Feel free to explore the app or try asking about child protection, online safety, or upcoming events.",
    ]);
  }

  /// Check if the message contains any of the keywords
  bool _containsAny(String message, List<String> keywords) {
    return keywords.any((keyword) => message.contains(keyword));
  }

  /// Get a random response from a list
  String _getRandomResponse(List<String> responses) {
    return responses[_random.nextInt(responses.length)];
  }
}
