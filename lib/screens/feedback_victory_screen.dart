import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../services/progress_service.dart';

class FeedbackVictoryScreen extends StatefulWidget {
  final String subjectId;
  final String subjectName;
  final String subjectEmoji;
  final int level;
  final int correctAnswers;
  final int totalQuestions;
  final int pointsEarned;

  const FeedbackVictoryScreen({
    super.key,
    required this.subjectId,
    required this.subjectName,
    required this.subjectEmoji,
    required this.level,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.pointsEarned,
  });

  @override
  State<FeedbackVictoryScreen> createState() => _FeedbackVictoryScreenState();
}

class _FeedbackVictoryScreenState extends State<FeedbackVictoryScreen> {
  int _displayedPoints = 0;
  bool _savedProgress = false;

  @override
  void initState() {
    super.initState();
    _saveProgressAndAnimate();
  }

  Future<void> _saveProgressAndAnimate() async {
    // Save progress
    await ProgressService.instance.completeLevel(
      widget.subjectId,
      widget.pointsEarned,
    );

    // Check for achievements
    if (widget.correctAnswers == widget.totalQuestions) {
      await ProgressService.instance.unlockAchievement('perfect_lesson');
    }
    if (widget.level == 0) {
      await ProgressService.instance
          .unlockAchievement('${widget.subjectId}_beginner');
    }
    final totalPoints = ProgressService.instance.getTotalPoints();
    if (totalPoints >= 100) {
      await ProgressService.instance.unlockAchievement('explorer');
    }
    if (totalPoints >= 300) {
      await ProgressService.instance.unlockAchievement('scholar');
    }

    setState(() => _savedProgress = true);

    // Animate points counter
    _animatePoints();
  }

  void _animatePoints() {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      final target = widget.pointsEarned;
      const steps = 20;
      final increment = (target / steps).ceil();

      for (int i = 0; i <= steps; i++) {
        Future.delayed(Duration(milliseconds: i * 50), () {
          if (mounted) {
            setState(() {
              _displayedPoints = (increment * i).clamp(0, target);
            });
          }
        });
      }
    });
  }

  int get _stars {
    final ratio = widget.correctAnswers / widget.totalQuestions;
    if (ratio >= 0.9) return 3;
    if (ratio >= 0.6) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              YachayTheme.primaryPurple,
              YachayTheme.primaryPurpleLight,
              YachayTheme.primaryPurple.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // ─── Trophy Emoji ───
                Text(
                  '🏆',
                  style: const TextStyle(fontSize: 72),
                ).animate().scale(
                      begin: const Offset(0, 0),
                      end: const Offset(1, 1),
                      duration: 800.ms,
                      curve: Curves.elasticOut,
                    ),

                const SizedBox(height: 16),

                // ─── Title ───
                Text(
                  '¡Lección Completada!',
                  style: GoogleFonts.outfit(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),

                const SizedBox(height: 8),

                Text(
                  '${widget.subjectEmoji} ${widget.subjectName} — Nivel ${widget.level + 1}',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ).animate().fadeIn(delay: 500.ms),

                const SizedBox(height: 28),

                // ─── Stars ───
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    final isEarned = index < _stars;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        isEarned
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: isEarned
                            ? YachayTheme.secondaryGold
                            : Colors.white.withValues(alpha: 0.3),
                        size: index == 1 ? 56 : 44,
                      ),
                    ).animate(delay: (600 + index * 200).ms).scale(
                          begin: const Offset(0, 0),
                          end: const Offset(1, 1),
                          curve: Curves.elasticOut,
                          duration: 600.ms,
                        );
                  }),
                ),

                const SizedBox(height: 32),

                // ─── Stats Card ───
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: YachayTheme.radiusLarge,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildStatRow(
                        '✅ Respuestas correctas',
                        '${widget.correctAnswers}/${widget.totalQuestions}',
                      ),
                      const SizedBox(height: 16),
                      Divider(
                        color: Colors.white.withValues(alpha: 0.15),
                        height: 1,
                      ),
                      const SizedBox(height: 16),
                      _buildStatRow(
                        '⭐ Puntos ganados',
                        '+$_displayedPoints',
                        isHighlight: true,
                      ),
                      const SizedBox(height: 16),
                      Divider(
                        color: Colors.white.withValues(alpha: 0.15),
                        height: 1,
                      ),
                      const SizedBox(height: 16),
                      _buildStatRow(
                        '🏅 Puntos totales',
                        '${ProgressService.instance.getTotalPoints()}',
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.1),

                const SizedBox(height: 32),

                // ─── Action Buttons ───
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: YachayTheme.secondaryGold,
                      foregroundColor: YachayTheme.textDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                      shadowColor:
                          YachayTheme.secondaryGold.withValues(alpha: 0.4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Volver al mapa',
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('🗺️', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 1200.ms).slideY(begin: 0.2),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigate to next level
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side:
                          BorderSide(color: Colors.white.withValues(alpha: 0.5), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Siguiente nivel ▶',
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 1400.ms).slideY(begin: 0.2),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 15,
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: isHighlight ? 22 : 18,
            fontWeight: FontWeight.bold,
            color: isHighlight ? YachayTheme.secondaryGold : Colors.white,
          ),
        ),
      ],
    );
  }
}
