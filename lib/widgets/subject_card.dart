import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final darkShade = Color.lerp(color, Colors.black, 0.25) ?? color;
    final cardGradient = isLocked
        ? LinearGradient(colors: [Colors.grey.shade300, Colors.grey.shade400])
        : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, darkShade],
          );

    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          gradient: cardGradient,
          borderRadius: YachayTheme.radiusLarge,
          border: Border.all(
            color: isLocked ? Colors.grey.shade400 : color.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: isLocked
              ? []
              : YachayTheme.getButton3DShadow(
                  Color.lerp(color, Colors.black, 0.45) ?? Colors.black,
                ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Progress ring with floating emoji center
            Stack(
              alignment: Alignment.center,
              children: [
                ProgressRing(
                  progress: progress,
                  size: 66,
                  strokeWidth: 6,
                  color: isLocked ? Colors.grey : YachayTheme.secondaryGold,
                  backgroundColor: Colors.white.withValues(alpha: 0.25),
                ),
                if (isLocked)
                  Icon(Icons.lock_rounded, size: 24, color: Colors.grey.shade600)
                else
                  Text(
                    emoji,
                    style: const TextStyle(fontSize: 28),
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .slideY(begin: 0, end: -0.15, duration: 1.5.seconds, curve: Curves.easeInOut),
              ],
            ),
            const SizedBox(height: 8),

            // Subject name
            Text(
              name,
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isLocked ? Colors.grey.shade700 : Colors.white,
                shadows: isLocked
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),

            // Level indicator badge
            if (!isLocked)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  progress >= 1.0 ? '¡Completo! ⭐' : '${(progress * 100).round()}%',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1);
  }
}
