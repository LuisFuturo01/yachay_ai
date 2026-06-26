enum MessageType {
  normal,
  correct,
  incorrect,
  hint,
  system,
  thinking,
}

class ChatMessage {
  final String text;
  final bool isUser;
  final MessageType type;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.type = MessageType.normal,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}
