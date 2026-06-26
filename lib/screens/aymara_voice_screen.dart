import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../data/mock_aymara_data.dart';
import '../services/tutor_service.dart';
import '../widgets/progress_ring.dart';

class AymaraVoiceScreen extends StatefulWidget {
  final int level;

  const AymaraVoiceScreen({super.key, required this.level});

  @override
  State<AymaraVoiceScreen> createState() => _AymaraVoiceScreenState();
}

class _AymaraVoiceScreenState extends State<AymaraVoiceScreen>
    with SingleTickerProviderStateMixin {
  late AymaraLesson _lesson;
  int _currentWordIndex = 0;
  bool _isRecording = false;
  bool _showResult = false;
  int _precision = 0;
  String _feedback = '';
  bool _isGood = false;
  int _wordsCompleted = 0;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _lesson = MockAymaraData.getLesson(widget.level);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  AymaraWord get _currentWord => _lesson.words[_currentWordIndex];

  Future<void> _startRecording() async {
    setState(() {
      _isRecording = true;
      _showResult = false;
    });
    _pulseController.repeat(reverse: true);

    // Simulate recording + processing
    await Future.delayed(const Duration(seconds: 2));

    // Get mock pronunciation result
    final result = await TutorService.instance.evaluatePronunciation(
      level: widget.level,
      wordIndex: _currentWordIndex,
    );

    if (!mounted) return;

    _pulseController.stop();
    _pulseController.reset();

    setState(() {
      _isRecording = false;
      _showResult = true;
      _precision = result.precision;
      _feedback = result.feedback;
      _isGood = result.isGood;
    });
  }

  void _nextWord() {
    setState(() {
      _wordsCompleted++;
      if (_currentWordIndex < _lesson.words.length - 1) {
        _currentWordIndex++;
        _showResult = false;
      } else {
        // Lesson complete
        Navigator.pushReplacementNamed(
          context,
          '/victory',
          arguments: {
            'subjectId': 'aymara',
            'subjectName': 'Idioma Aymara',
            'subjectEmoji': '🗣️',
            'level': widget.level,
            'correctAnswers': _wordsCompleted + 1,
            'totalQuestions': _lesson.words.length,
            'pointsEarned': _lesson.pointsReward,
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentWordIndex + 1) / _lesson.words.length;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: YachayTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // ─── Top Bar ───
              _buildTopBar(progress),

              // ─── Content ───
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // ─── Word Card ───
                      _buildWordCard(),

                      const SizedBox(height: 12),

                      // ─── Pronunciation Guide ───
                      _buildPronunciationGuide(),

                      const SizedBox(height: 32),

                      // ─── Microphone Button ───
                      _buildMicButton(),

                      const SizedBox(height: 24),

                      // ─── Recording Status ───
                      if (_isRecording)
                        Text(
                          '🎙️ Escuchando... Habla ahora',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: YachayTheme.errorPink,
                          ),
                        ).animate(
                          onPlay: (c) => c.repeat(reverse: true),
                        ).fadeIn().then().fade(
                              begin: 1,
                              end: 0.5,
                              duration: 800.ms,
                            ),

                      // ─── Result ───
                      if (_showResult) ...[
                        _buildResultCard(),
                        const SizedBox(height: 20),
                        _buildNextButton(),
                      ],

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(double progress) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: YachayTheme.cardShadow,
              ),
              child: const Icon(Icons.arrow_back_rounded, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🗣️ ${_lesson.title}',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: YachayTheme.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor:
                        YachayTheme.aymaraColor.withValues(alpha: 0.15),
                    color: YachayTheme.aymaraColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${_currentWordIndex + 1}/${_lesson.words.length}',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: YachayTheme.aymaraColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: YachayTheme.radiusLarge,
        boxShadow: [
          BoxShadow(
            color: YachayTheme.aymaraColor.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: YachayTheme.aymaraColor.withValues(alpha: 0.15),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            _currentWord.emoji,
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 12),
          Text(
            _currentWord.word,
            style: GoogleFonts.outfit(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: YachayTheme.aymaraColor,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: YachayTheme.aymaraColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _currentWord.translation,
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: YachayTheme.textDark,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _currentWord.context,
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: YachayTheme.textMedium,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn().scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
          duration: 400.ms,
        );
  }

  Widget _buildPronunciationGuide() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: YachayTheme.surfaceGold,
        borderRadius: YachayTheme.radiusSmall,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📖', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Text(
            'Pronunciación: ${_currentWord.pronunciationGuide}',
            style: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: YachayTheme.textDark,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildMicButton() {
    return GestureDetector(
      onTap: _isRecording ? null : _startRecording,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final scale = _isRecording ? 1.0 + (_pulseController.value * 0.15) : 1.0;
          return Transform.scale(
            scale: scale,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: _isRecording
                      ? [YachayTheme.errorPink, const Color(0xFFFF6B8A)]
                      : [YachayTheme.aymaraColor, const Color(0xFFF59E0B)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: (_isRecording
                            ? YachayTheme.errorPink
                            : YachayTheme.aymaraColor)
                        .withValues(alpha: 0.3 + (_pulseController.value * 0.2)),
                    blurRadius: 20 + (_pulseController.value * 15),
                    spreadRadius: _pulseController.value * 5,
                  ),
                ],
              ),
              child: Icon(
                _isRecording ? Icons.mic : Icons.mic_none_rounded,
                color: Colors.white,
                size: 50,
              ),
            ),
          );
        },
      ),
    ).animate().scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          duration: 600.ms,
          curve: Curves.elasticOut,
        );
  }

  Widget _buildResultCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: YachayTheme.radiusMedium,
        boxShadow: [
          BoxShadow(
            color: (_isGood ? YachayTheme.successGreen : YachayTheme.warningOrange)
                .withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: _isGood
              ? YachayTheme.successGreen.withValues(alpha: 0.3)
              : YachayTheme.warningOrange.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Precision ring
          ProgressRing(
            progress: _precision / 100,
            size: 90,
            strokeWidth: 8,
            color: _isGood
                ? YachayTheme.successGreen
                : YachayTheme.warningOrange,
            child: Text(
              '$_precision%',
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _isGood
                    ? YachayTheme.successGreen
                    : YachayTheme.warningOrange,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _isGood ? '¡Muy bien! 🎉' : '¡Sigue practicando! 💪',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _isGood
                  ? YachayTheme.successGreen
                  : YachayTheme.warningOrange,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _feedback,
            style: GoogleFonts.nunito(
              fontSize: 15,
              color: YachayTheme.textMedium,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2, duration: 400.ms);
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _nextWord,
        style: ElevatedButton.styleFrom(
          backgroundColor: YachayTheme.aymaraColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          _currentWordIndex < _lesson.words.length - 1
              ? 'Siguiente palabra ▶'
              : '¡Completar lección! 🎉',
          style: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }
}
