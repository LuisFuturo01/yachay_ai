import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/theme.dart';
import '../models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final String? tutorEmoji;

  const ChatBubble({
    super.key,
    required this.message,
    this.tutorEmoji,
  });

  Color get _bubbleColor {
    if (message.isUser) return YachayTheme.primaryPurple;
    switch (message.type) {
      case MessageType.correct:
        return YachayTheme.successGreen;
      case MessageType.incorrect:
        return YachayTheme.errorPink;
      case MessageType.hint:
        return YachayTheme.secondaryGold;
      case MessageType.system:
        return Colors.grey.shade600;
      case MessageType.thinking:
        return Colors.grey.shade400;
      default:
        return Colors.white;
    }
  }

  Color get _textColor {
    if (message.isUser) return Colors.white;
    switch (message.type) {
      case MessageType.correct:
      case MessageType.incorrect:
      case MessageType.system:
        return Colors.white;
      case MessageType.hint:
        return YachayTheme.textDark;
      case MessageType.thinking:
        return Colors.white;
      default:
        return YachayTheme.textDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Tutor avatar
          if (!message.isUser && tutorEmoji != null) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: YachayTheme.surfacePurple,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(tutorEmoji!, style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Bubble
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: message.isUser
                      ? const Radius.circular(20)
                      : const Radius.circular(4),
                  bottomRight: message.isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: _bubbleColor.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: message.type == MessageType.thinking
                  ? _ThinkingDots()
                  : Text(
                      message.text,
                      style: TextStyle(
                        fontSize: 15,
                        color: _textColor,
                        height: 1.4,
                      ),
                    ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(
          begin: message.isUser ? 0.1 : -0.1,
          end: 0,
          duration: 300.ms,
          curve: Curves.easeOut,
        );
  }
}

class _ThinkingDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            shape: BoxShape.circle,
          ),
        ).animate(
          onPlay: (c) => c.repeat(),
        ).fadeIn(
          delay: (index * 200).ms,
          duration: 400.ms,
        ).then().fadeOut(
          duration: 400.ms,
        );
      }),
    );
  }
}
