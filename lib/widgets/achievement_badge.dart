import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/theme.dart';
import '../models/achievement.dart';

class AchievementBadge extends StatelessWidget {
  final Achievement achievement;
  final bool isUnlocked;
  final double size;

  const AchievementBadge({
    super.key,
    required this.achievement,
    this.isUnlocked = false,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isUnlocked ? Colors.white : Colors.grey.shade200,
            border: Border.all(
              color: isUnlocked
                  ? YachayTheme.secondaryGold
                  : Colors.grey.shade300,
              width: 3,
            ),
            boxShadow: isUnlocked
                ? [
                    BoxShadow(
                      color: YachayTheme.secondaryGold.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: isUnlocked
                ? Text(
                    achievement.emoji,
                    style: TextStyle(fontSize: size * 0.45),
                  )
                : Icon(
                    Icons.lock_rounded,
                    size: size * 0.35,
                    color: Colors.grey.shade400,
                  ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: size + 20,
          child: Text(
            achievement.title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isUnlocked ? YachayTheme.textDark : YachayTheme.textLight,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ).animate().fadeIn().scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          duration: 400.ms,
        );
  }
}
