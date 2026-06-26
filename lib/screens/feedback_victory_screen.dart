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
      body: Stack(
        children: [
          // ─── Playful Sky Gradient ───
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF5B21B6),
                  YachayTheme.primaryPurple,
                  Color(0xFF0EA5E9),
                ],
              ),
            ),
          ),

          // ─── Confetti Rain ───
          _ConfettiRain(),

          // ─── Content ───
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // ─── Trophy Emoji ───
                  Text(
                    '🏆',
                    style: const TextStyle(fontSize: 80),
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .slideY(begin: 0, end: -0.1, duration: 1.5.seconds, curve: Curves.easeInOut)
                      .animate()
                      .scale(
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
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),

                  const SizedBox(height: 8),

                  Text(
                    '${widget.subjectEmoji} ${widget.subjectName} — Nivel ${widget.level + 1}',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ).animate().fadeIn(delay: 500.ms),

                  const SizedBox(height: 28),

                  // ─── Stars ───
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      final isEarned = index < _stars;
                      Widget starIcon = Icon(
                        isEarned ? Icons.star_rounded : Icons.star_border_rounded,
                        color: isEarned ? YachayTheme.secondaryGold : Colors.white.withValues(alpha: 0.3),
                        size: index == 1 ? 64 : 50,
                      );

                      if (isEarned) {
                        starIcon = starIcon
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .scale(begin: const Offset(1, 1), end: const Offset(1.15, 1.15), duration: 1.seconds);
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: starIcon,
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
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: YachayTheme.radiusLarge,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
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

                  // ─── Action Buttons (3D style) ───
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false,
                      );
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: YachayTheme.secondaryGold,
                        borderRadius: YachayTheme.radiusMedium,
                        boxShadow: YachayTheme.getButton3DShadow(
                          const Color(0xFFC2410C),
                        ),
                      ),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Volver al mapa',
                                style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: YachayTheme.textDark,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('🗺️', style: TextStyle(fontSize: 18)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 1200.ms).slideY(begin: 0.2),

                  const SizedBox(height: 14),

                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: YachayTheme.radiusMedium,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
                      ),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Siguiente nivel ▶',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 1400.ms).slideY(begin: 0.2),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
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
            fontWeight: FontWeight.bold,
            color: Colors.white.withValues(alpha: 0.95),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: isHighlight ? 24 : 18,
            fontWeight: FontWeight.bold,
            color: isHighlight ? YachayTheme.secondaryGold : Colors.white,
          ),
        ),
      ],
    );
  }
}

// ─── Looping Confetti Falling Rain Widget ───
class _ConfettiRain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.redAccent,
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.yellowAccent,
      Colors.pinkAccent,
      Colors.orangeAccent,
      Colors.purpleAccent
    ];
    final size = MediaQuery.of(context).size;

    return Stack(
      children: List.generate(35, (index) {
        final randomColor = colors[index % colors.length];
        final double left = (index * (size.width / 35)) % size.width;
        final double sizeVal = 6.0 + (index % 3) * 4.0;
        final isCircle = index % 2 == 0;
        final duration = 3.seconds + ((index % 4) * 600).ms;
        final delay = ((index % 5) * 400).ms;

        return Positioned(
          top: -20,
          left: left,
          child: Container(
            width: sizeVal,
            height: sizeVal,
            decoration: BoxDecoration(
              color: randomColor,
              shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .slideY(
                begin: 0,
                end: size.height / sizeVal + 4,
                duration: duration,
                delay: delay,
                curve: Curves.linear,
              )
              .rotate(
                begin: 0,
                end: 4.0 + (index % 3),
                duration: duration,
                delay: delay,
                curve: Curves.linear,
              ),
        );
      }),
    );
  }
}
