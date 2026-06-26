import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/theme.dart';

class FeedbackOverlay extends StatelessWidget {
  final bool isCorrect;
  final String message;
  final VoidCallback onDismiss;

  const FeedbackOverlay({
    super.key,
    required this.isCorrect,
    required this.message,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: Colors.black.withValues(alpha: 0.4),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(40),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: YachayTheme.radiusXLarge,
              boxShadow: [
                BoxShadow(
                  color: (isCorrect
                          ? YachayTheme.successGreen
                          : YachayTheme.warningOrange)
                      .withValues(alpha: 0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Emoji
                Text(
                  isCorrect ? '🎉' : '💪',
                  style: const TextStyle(fontSize: 64),
                ).animate().scale(
                      begin: const Offset(0.3, 0.3),
                      end: const Offset(1, 1),
                      duration: 500.ms,
                      curve: Curves.elasticOut,
                    ),
                const SizedBox(height: 16),

                // Title
                Text(
                  isCorrect ? '¡Excelente!' : '¡Casi lo logras!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isCorrect
                        ? YachayTheme.successGreen
                        : YachayTheme.warningOrange,
                  ),
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 12),

                // Message
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    color: YachayTheme.textMedium,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 400.ms),
                const SizedBox(height: 24),

                // Stars for correct
                if (isCorrect)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          Icons.star_rounded,
                          color: YachayTheme.secondaryGold,
                          size: 36,
                        ),
                      ).animate(delay: (300 + i * 150).ms).scale(
                            begin: const Offset(0, 0),
                            end: const Offset(1, 1),
                            curve: Curves.elasticOut,
                          );
                    }),
                  ),

                const SizedBox(height: 20),

                // Continue button
                ElevatedButton(
                  onPressed: onDismiss,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCorrect
                        ? YachayTheme.successGreen
                        : YachayTheme.warningOrange,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 36, vertical: 14),
                  ),
                  child: Text(
                    isCorrect ? 'Continuar ▶' : 'Intentar de nuevo',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
              ],
            ),
          ).animate().scale(
                begin: const Offset(0.7, 0.7),
                end: const Offset(1, 1),
                duration: 400.ms,
                curve: Curves.easeOutBack,
              ),
        ),
      ),
    );
  }
}
