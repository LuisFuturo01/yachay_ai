import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../models/lesson.dart';
import '../services/tutor_service.dart';
import '../widgets/animated_tutor_avatar.dart';

class TutorChatScreen extends StatefulWidget {
  final String subjectId;
  final String subjectName;
  final String subjectEmoji;
  final Color subjectColor;
  final int level;

  const TutorChatScreen({
    super.key,
    required this.subjectId,
    required this.subjectName,
    required this.subjectEmoji,
    required this.subjectColor,
    required this.level,
  });

  @override
  State<TutorChatScreen> createState() => _TutorChatScreenState();
}

class _TutorChatScreenState extends State<TutorChatScreen> {
  final TutorService _tutor = TutorService.instance;
  late Lesson _lesson;

  int _currentQuestionIndex = 0;
  int _currentHintIndex = 0;
  int _correctAnswers = 0;
  int _totalAttemptsForQuestion = 0;
  TutorState _tutorState = TutorState.idle;

  // Selection states
  int? _selectedOptionIndex;
  bool _checked = false;

  // Particle explosion trigger
  bool _triggerExplosion = false;

  @override
  void initState() {
    super.initState();
    _lesson = _tutor.getLesson(widget.subjectId, widget.level);
  }

  void _onOptionTap(int index) {
    if (_checked) return; // Cannot change selection once checked
    setState(() {
      _selectedOptionIndex = index;
    });
  }

  void _checkAnswer() {
    if (_selectedOptionIndex == null || _checked) return;

    final question = _lesson.questions[_currentQuestionIndex];
    final selectedAnswer = question.options![_selectedOptionIndex!];
    final isCorrect = selectedAnswer == question.correctAnswer;

    setState(() {
      _checked = true;
      _totalAttemptsForQuestion++;
    });

    if (isCorrect) {
      setState(() {
        _tutorState = TutorState.happy;
        _correctAnswers++;
        _triggerExplosion = true;
      });
      // Reset explosion state after a short delay
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) setState(() => _triggerExplosion = false);
      });
    } else {
      setState(() {
        _currentHintIndex++;
        _tutorState = TutorState.thinking;
      });
    }
  }

  void _continueNext() {
    final question = _lesson.questions[_currentQuestionIndex];
    final selectedAnswer = question.options![_selectedOptionIndex!];
    final isCorrect = selectedAnswer == question.correctAnswer;

    if (isCorrect || _currentHintIndex >= 3) {
      // Move to next question
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = null;
        _checked = false;
        _currentHintIndex = 0;
        _totalAttemptsForQuestion = 0;
        _tutorState = TutorState.idle;
      });

      if (_currentQuestionIndex >= _lesson.questions.length) {
        _onLessonComplete();
      }
    } else {
      // Let them try again
      setState(() {
        _checked = false;
        _selectedOptionIndex = null;
        _tutorState = TutorState.idle;
      });
    }
  }

  void _onLessonComplete() {
    setState(() {
      _tutorState = TutorState.celebrating;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/victory',
          arguments: {
            'subjectId': widget.subjectId,
            'subjectName': widget.subjectName,
            'subjectEmoji': widget.subjectEmoji,
            'level': widget.level,
            'correctAnswers': _correctAnswers,
            'totalQuestions': _lesson.questions.length,
            'pointsEarned': _lesson.pointsReward,
          },
        );
      }
    });
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: YachayTheme.radiusMedium),
        backgroundColor: Colors.white,
        title: Text(
          '¿Quieres salir? 😢',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: YachayTheme.textDark),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'Tu progreso en esta lección se perderá si sales ahora.',
          style: GoogleFonts.nunito(color: YachayTheme.textMedium),
          textAlign: TextAlign.center,
        ),
        actionsPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: YachayTheme.primaryPurple,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: YachayTheme.radiusSmall,
                  ),
                  elevation: 2,
                ),
                child: Text(
                  'Seguir Jugando 🎮',
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Exit lesson
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'Salir de la lección',
                  style: GoogleFonts.nunito(
                    color: YachayTheme.errorPink,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuestionIndex >= _lesson.questions.length) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: YachayTheme.playfulBackgroundGradient),
          child: const Center(
            child: CircularProgressIndicator(color: YachayTheme.primaryPurple),
          ),
        ),
      );
    }

    final question = _lesson.questions[_currentQuestionIndex];
    final progress = _currentQuestionIndex / _lesson.questions.length;
    final themeColor = widget.subjectColor;

    // Evaluate response parameters
    final isCorrect = _checked && question.options![_selectedOptionIndex!] == question.correctAnswer;
    final isTryAgain = _checked && !isCorrect && _currentHintIndex < 3;
    final isFailFinal = _checked && !isCorrect && _currentHintIndex >= 3;

    return Scaffold(
      body: Stack(
        children: [
          // ─── Playful Background ───
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: YachayTheme.playfulBackgroundGradient,
            ),
          ),

          // Drifting Cloud deco
          Positioned(
            top: 100,
            right: -20,
            child: const Text('☁️', style: TextStyle(fontSize: 60))
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .slideX(begin: 0, end: -0.1, duration: 7.seconds),
          ),

          // ─── Main Content ───
          SafeArea(
            child: Column(
              children: [
                // ─── Top Bar ───
                _buildHeader(progress, themeColor),

                // ─── Quiz Area ───
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 10),

                        // Tutor Helper Banner
                        _buildTutorBanner(question),

                        const SizedBox(height: 16),

                        // Question Bubble Card
                        _buildQuestionCard(question, themeColor),

                        const SizedBox(height: 24),

                        // Options Grid/List
                        _buildOptions(question, themeColor),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // ─── Bottom Actions Bar ───
                _buildBottomBar(themeColor, isCorrect, isTryAgain, isFailFinal, question),
              ],
            ),
          ),

          // ─── Confetti Explosion Overlay ───
          if (_triggerExplosion) _buildParticleExplosion(),
        ],
      ),
    );
  }

  Widget _buildHeader(double progress, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Exit 'X' Button
          GestureDetector(
            onTap: _showExitConfirmation,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: YachayTheme.textLight.withValues(alpha: 0.3), width: 2),
                boxShadow: YachayTheme.cardShadow,
              ),
              child: const Icon(Icons.close_rounded, size: 24, color: YachayTheme.textDark),
            ),
          ),
          const SizedBox(width: 14),

          // Progress Bar
          Expanded(
            child: Stack(
              children: [
                // Background track
                Container(
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: YachayTheme.textLight.withValues(alpha: 0.2), width: 1.5),
                  ),
                ),
                // Fill
                AnimatedFractionallySizedBox(
                  widthFactor: progress.clamp(0.05, 1.0),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  child: Container(
                    height: 18,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color.withValues(alpha: 0.7), color],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Level Indicator text
          Text(
            '${_currentQuestionIndex + 1}/${_lesson.questions.length}',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorBanner(Question question) {
    String tutorSpeech = '¡Hola! Ayúdame a resolver esta pregunta.';
    if (_tutorState == TutorState.happy) {
      tutorSpeech = '¡Fantástico! ¡Respuesta correcta! 🌟';
    } else if (_tutorState == TutorState.thinking) {
      if (question.hints.isNotEmpty) {
        final hintIdx = (_currentHintIndex - 1).clamp(0, question.hints.length - 1);
        tutorSpeech = '💡 Pista de Yachay: ${question.hints[hintIdx]}';
      } else {
        tutorSpeech = '¡Inténtalo otra vez! Yo sé que puedes.';
      }
    }

    return Row(
      children: [
        AnimatedTutorAvatar(
          emoji: widget.subjectEmoji,
          state: _tutorState,
          size: 54,
        ).animate().scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
          duration: 500.ms,
          curve: Curves.elasticOut,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: const Radius.circular(20),
                bottomLeft: const Radius.circular(20),
                bottomRight: const Radius.circular(20),
              ),
              border: Border.all(
                color: YachayTheme.primaryPurple.withValues(alpha: 0.15),
                width: 2,
              ),
              boxShadow: YachayTheme.cardShadow,
            ),
            child: Text(
              tutorSpeech,
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: YachayTheme.textDark,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(Question question, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: YachayTheme.radiusLarge,
        border: Border.all(color: color.withValues(alpha: 0.25), width: 3),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          if (question.imageEmoji != null) ...[
            Text(
              question.imageEmoji!,
              style: const TextStyle(fontSize: 54),
            ).animate().scale(begin: const Offset(0.7, 0.7), duration: 500.ms, curve: Curves.elasticOut),
            const SizedBox(height: 12),
          ],
          Text(
            question.question,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: YachayTheme.textDark,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildOptions(Question question, Color themeColor) {
    if (question.options == null || question.options!.isEmpty) {
      return const SizedBox();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.2,
      ),
      itemCount: question.options!.length,
      itemBuilder: (context, index) {
        final option = question.options![index];
        final isSelected = _selectedOptionIndex == index;
        final letters = ['A', 'B', 'C', 'D'];

        return GestureDetector(
          onTap: () => _onOptionTap(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? themeColor.withValues(alpha: 0.15) : Colors.white,
              borderRadius: YachayTheme.radiusMedium,
              border: Border.all(
                color: isSelected ? themeColor : YachayTheme.textLight.withValues(alpha: 0.3),
                width: isSelected ? 3 : 2,
              ),
              boxShadow: isSelected
                  ? [BoxShadow(color: themeColor.withValues(alpha: 0.2), blurRadius: 10)]
                  : YachayTheme.getButton3DShadow(Colors.grey.shade300),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Option label card (A, B, C, D)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? themeColor : YachayTheme.surfacePurple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    letters[index],
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : YachayTheme.primaryPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  option,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: YachayTheme.textDark,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ).animate(delay: (index * 100).ms).fadeIn().scale(begin: const Offset(0.9, 0.9));
      },
    );
  }

  Widget _buildBottomBar(
    Color themeColor,
    bool isCorrect,
    bool isTryAgain,
    bool isFailFinal,
    Question question,
  ) {
    final hasSelection = _selectedOptionIndex != null;

    // Normal Check Button Container
    if (!_checked) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: YachayTheme.textLight.withValues(alpha: 0.15), width: 2),
          ),
        ),
        child: GestureDetector(
          onTap: hasSelection ? _checkAnswer : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 50,
            decoration: BoxDecoration(
              color: hasSelection ? themeColor : Colors.grey.shade300,
              borderRadius: YachayTheme.radiusMedium,
              boxShadow: hasSelection
                  ? YachayTheme.getButton3DShadow(themeColor.withValues(alpha: 0.7))
                  : [],
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'COMPROBAR',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: hasSelection ? Colors.white : Colors.grey.shade500,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Colors according to state
    Color feedbackBg = YachayTheme.successGreenLight;
    Color feedbackBorder = YachayTheme.successGreen;
    Color feedbackText = YachayTheme.successGreen;
    String feedbackTitle = '¡Excelente! 🎉';
    String feedbackDesc = question.explanation;
    String buttonText = 'CONTINUAR';

    if (isTryAgain) {
      feedbackBg = YachayTheme.surfaceGold;
      feedbackBorder = YachayTheme.secondaryGold;
      feedbackText = YachayTheme.accentTerracotta;
      feedbackTitle = '¡Casi! 💡 Pista';
      feedbackDesc = question.hints[(_currentHintIndex - 1).clamp(0, question.hints.length - 1)];
      buttonText = 'INTENTAR DE NUEVO';
    } else if (isFailFinal) {
      feedbackBg = YachayTheme.errorPinkLight;
      feedbackBorder = YachayTheme.errorPink;
      feedbackText = YachayTheme.errorPink;
      feedbackTitle = '¡Incorrecto! 😢';
      feedbackDesc = 'La respuesta correcta es: ${question.correctAnswer}.\n\n${question.explanation}';
      buttonText = 'CONTINUAR';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: feedbackBg,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        border: Border.all(color: feedbackBorder.withValues(alpha: 0.4), width: 3),
        boxShadow: [
          BoxShadow(
            color: feedbackBorder.withValues(alpha: 0.1),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                isCorrect
                    ? Icons.check_circle_rounded
                    : isTryAgain
                        ? Icons.lightbulb_rounded
                        : Icons.cancel_rounded,
                color: feedbackBorder,
                size: 28,
              ),
              const SizedBox(width: 10),
              Text(
                feedbackTitle,
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: feedbackText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            feedbackDesc,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: YachayTheme.textDark,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _continueNext,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: feedbackBorder,
                borderRadius: YachayTheme.radiusMedium,
                boxShadow: YachayTheme.getButton3DShadow(
                  feedbackBorder.withValues(alpha: 0.6),
                ),
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    buttonText,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 0.5, end: 0, duration: 250.ms, curve: Curves.easeOut);
  }

  // ─── Simple Particle Explosion Emitter ───
  Widget _buildParticleExplosion() {
    return Stack(
      children: List.generate(24, (index) {
        final double angle = (index * 15) * 3.14159 / 180;
        final double dist = 100.0 + (index % 3) * 40.0;
        final double dx = dist * 1.5 * (angle == 0 ? 1 : angle > 3.14159 ? -1 : 1); 
        // We can just randomize offsets using flutter_animate translations
        return Align(
          alignment: Alignment.center,
          child: const Text('⭐', style: TextStyle(fontSize: 24))
              .animate()
              .scale(begin: const Offset(0.1, 0.1), end: const Offset(1.5, 1.5), duration: 800.ms)
              .custom(
                builder: (context, val, child) {
                  return Transform.translate(
                    offset: Offset(dx * val, -dist * val + (100 * val * val)),
                    child: child,
                  );
                },
                duration: 1000.ms,
              )
              .fadeOut(duration: 800.ms),
        );
      }),
    );
  }
}
