import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/theme.dart';
import 'progress_ring.dart';

class SubjectCard extends StatelessWidget {
  final String emoji;
  final String name;
  final Color color;
  final Color colorLight;
  final double progress; // 0.0 to 1.0
  final bool isLocked;
  final VoidCallback? onTap;

  const SubjectCard({
    super.key,
    required this.emoji,
    required this.name,
    required this.color,
    required this.colorLight,
    required this.progress,
    this.isLocked = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isLocked ? Colors.grey.shade100 : Colors.white,
          borderRadius: YachayTheme.radiusLarge,
          boxShadow: isLocked
              ? []
              : [
                  BoxShadow(
                    color: color.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
          border: Border.all(
            color: isLocked
                ? Colors.grey.shade300
                : color.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Progress ring with emoji center
            Stack(
              alignment: Alignment.center,
              children: [
                ProgressRing(
                  progress: progress,
                  size: 80,
                  strokeWidth: 7,
                  color: isLocked ? Colors.grey : color,
                ),
                if (isLocked)
                  Icon(Icons.lock_rounded,
                      size: 30, color: Colors.grey.shade400)
                else
                  Text(emoji,
                      style: const TextStyle(fontSize: 34)),
              ],
            ),
            const SizedBox(height: 14),
            // Subject name
            Text(
              name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isLocked ? Colors.grey : YachayTheme.textDark,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            // Level indicator
            if (!isLocked)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  progress >= 1.0
                      ? '¡Completo! ⭐'
                      : '${(progress * 100).round()}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1);
  }
}
