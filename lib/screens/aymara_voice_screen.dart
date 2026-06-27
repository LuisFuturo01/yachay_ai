import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../data/mock_aymara_data.dart';
import '../services/tutor_service.dart';
import '../services/voice_service.dart';
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
  bool _isFlipped = false;
  String? _recordedFilePath;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _lesson = MockAymaraData.getLesson(widget.level);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _initVoice();
  }

  Future<void> _initVoice() async {
    await VoiceService.instance.initialize();
    
    // Listen to audio player completion to update UI state instantly
    VoiceService.instance.setOnComplete(() {
      if (mounted) {
        setState(() {});
      }
    });

    // Speak the first word after a short delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _speakCurrentWord();
    });
  }

  Future<void> _speakCurrentWord() async {
    // Use the phonetic ttsHint for correct pronunciation,
    // fall back to the raw word if no hint is set.
    final textToSpeak = _currentWord.ttsHint ?? _currentWord.word;
    await VoiceService.instance.hablar(textToSpeak);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    // Cancel any ongoing recording when leaving the screen
    if (_isRecording) {
      VoiceService.instance.cancelarGrabacion();
    }
    super.dispose();
  }

  AymaraWord get _currentWord => _lesson.words[_currentWordIndex];

  Future<void> _startRecording() async {
    // Stop any TTS or playback that might be playing
    await VoiceService.instance.pararDeHablar();
    await VoiceService.instance.detenerReproduccion();

    setState(() {
      _isRecording = true;
      _showResult = false;
      _recordedFilePath = null;
      _isVerified = false;
    });
    _pulseController.repeat(reverse: true);

    // Start real microphone recording
    final started = await VoiceService.instance.empezarAGrabar();
    if (!started) {
      if (mounted) {
        _pulseController.stop();
        _pulseController.reset();
        setState(() => _isRecording = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '🎙️ No se pudo acceder al micrófono. Verifica los permisos.',
              style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
            ),
            backgroundColor: YachayTheme.warningOrange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    // Record for 3 seconds then stop
    await Future.delayed(const Duration(seconds: 3));

    // Stop recording and get path
    final audioPath = await VoiceService.instance.terminarDeGrabar();
    debugPrint('🎧 Audio grabado en: $audioPath');

    if (!mounted) return;

    _pulseController.stop();
    _pulseController.reset();

    setState(() {
      _isRecording = false;
      _recordedFilePath = audioPath;
    });

    if (audioPath != null) {
      await VoiceService.instance.prepararAudio(audioPath);
      if (mounted) setState(() {});
    }
  }

  Future<void> _toggleUserAudio() async {
    if (_recordedFilePath == null) return;

    if (VoiceService.instance.isPlayingAudio) {
      await VoiceService.instance.detenerReproduccion();
      setState(() {});
    } else {
      setState(() {});
      await VoiceService.instance.reproducirAudio(_recordedFilePath!);
    }
  }

  Future<void> _verifyPronunciation() async {
    if (_recordedFilePath == null) return;

    setState(() {
      _isVerified = true;
    });

    // TODO: When backend API is ready (Dev 3/4), send _recordedFilePath
    // to the pronunciation evaluation endpoint instead of mock.
    // Example: final result = await ApiService.evaluatePronunciation(_recordedFilePath!, _currentWord.word);

    // For now, use mock pronunciation result
    final result = await TutorService.instance.evaluatePronunciation(
      level: widget.level,
      wordIndex: _currentWordIndex,
    );

    if (!mounted) return;

    setState(() {
      _showResult = true;
      _precision = result.precision;
      _feedback = result.feedback;
      _isGood = result.isGood;
    });
  }

  void _nextWord() {
    setState(() {
      _wordsCompleted++;
      _isFlipped = false; // Reset card flip
      _recordedFilePath = null;
      _isVerified = false;
      if (_currentWordIndex < _lesson.words.length - 1) {
        _currentWordIndex++;
        _showResult = false;
        // Speak the next word automatically
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) _speakCurrentWord();
        });
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
                      if (_recordedFilePath == null)
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

                      // ─── Playback & Verify Actions ───
                      if (_recordedFilePath != null && !_isVerified) ...[
                        _buildPlaybackCard(),
                        const SizedBox(height: 24),
                      ],

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
    return GestureDetector(
      onTap: () => setState(() => _isFlipped = !_isFlipped),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: _isFlipped ? 180 : 0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        builder: (context, val, child) {
          final isBack = val >= 90;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // perspective
              ..rotateY(val * 3.14159265 / 180),
            child: isBack
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(3.14159265),
                    child: _buildCardBack(),
                  )
                : _buildCardFront(),
          );
        },
      ),
    );
  }

  Widget _buildCardFront() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: YachayTheme.radiusLarge,
        boxShadow: [
          BoxShadow(
            color: YachayTheme.aymaraColor.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: YachayTheme.aymaraColor.withValues(alpha: 0.25),
          width: 3,
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
              fontSize: 38,
              fontWeight: FontWeight.w800,
              color: YachayTheme.aymaraColor,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: YachayTheme.surfaceGold,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.touch_app_rounded, size: 16, color: YachayTheme.warningOrange),
                const SizedBox(width: 6),
                Text(
                  'Ver traducción',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: YachayTheme.warningOrange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: YachayTheme.aymaraGradient,
        borderRadius: YachayTheme.radiusLarge,
        boxShadow: [
          BoxShadow(
            color: YachayTheme.aymaraColor.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.4),
          width: 3,
        ),
      ),
      child: Column(
        children: [
          Text(
            _currentWord.translation,
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _currentWord.context,
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Aymara 🔁 Español',
              style: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPronunciationGuide() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: YachayTheme.surfaceGold,
        borderRadius: YachayTheme.radiusSmall,
        border: Border.all(color: YachayTheme.secondaryGold.withValues(alpha: 0.4), width: 1.5),
      ),
      child: Row(
        children: [
          const Text('📖', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Pronunciación: ${_currentWord.pronunciationGuide}',
              style: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: YachayTheme.textDark,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Listen button — speak the word via TTS
          Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _isRecording ? null : _speakCurrentWord,
              highlightColor: Colors.black.withValues(alpha: 0.15),
              splashColor: Colors.black.withValues(alpha: 0.1),
              child: Ink(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: YachayTheme.aymaraColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: YachayTheme.aymaraColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.volume_up_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildMicButton() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Wave 1
            if (_isRecording)
              Container(
                width: 120 + (_pulseController.value * 50),
                height: 120 + (_pulseController.value * 50),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: YachayTheme.errorPink.withValues(alpha: 0.15 * (1.0 - _pulseController.value)),
                ),
              ),
            // Wave 2
            if (_isRecording)
              Container(
                width: 120 + (((_pulseController.value + 0.5) % 1.0) * 50),
                height: 120 + (((_pulseController.value + 0.5) % 1.0) * 50),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: YachayTheme.errorPink.withValues(alpha: 0.15 * (1.0 - ((_pulseController.value + 0.5) % 1.0))),
                ),
              ),
            // Main circular mic button with 3D press shadow and visual tap response
            Material(
              color: Colors.transparent,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _isRecording ? null : _startRecording,
                highlightColor: Colors.black.withValues(alpha: 0.15),
                splashColor: Colors.black.withValues(alpha: 0.1),
                child: Ink(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: _isRecording
                          ? [YachayTheme.errorPink, const Color(0xFFFF6B8A)]
                          : [YachayTheme.aymaraColor, const Color(0xFFF59E0B)],
                    ),
                    boxShadow: YachayTheme.getButton3DShadow(
                      _isRecording ? const Color(0xFFB91C1C) : const Color(0xFFC2410C),
                    ),
                  ),
                  child: Icon(
                    _isRecording ? Icons.mic_rounded : Icons.mic_none_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ).animate().scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          duration: 600.ms,
          curve: Curves.elasticOut,
        );
  }

  Widget _buildPlaybackCard() {
    final isPlaying = VoiceService.instance.isPlayingAudio;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: YachayTheme.radiusMedium,
        border: Border.all(
          color: YachayTheme.primaryPurple.withValues(alpha: 0.15),
          width: 2.5,
        ),
        boxShadow: YachayTheme.cardShadow,
      ),
      child: Column(
        children: [
          Text(
            '¡Grabación lista! 🎙️✨',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: YachayTheme.textDark,
            ),
          ),
          const SizedBox(height: 14),

          // Playback control
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: _toggleUserAudio,
              highlightColor: Colors.black.withValues(alpha: 0.15),
              splashColor: Colors.black.withValues(alpha: 0.1),
              child: Ink(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isPlaying ? YachayTheme.errorPink : YachayTheme.primaryPurple,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: YachayTheme.getButton3DShadow(
                    isPlaying ? const Color(0xFFB91C1C) : YachayTheme.primaryPurpleDark,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isPlaying ? 'Detener audio' : 'Escuchar mi grabación 🎧',
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).animate(target: isPlaying ? 1 : 0).scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05)),

          const SizedBox(height: 24),

          // Actions: Send or retry
          Row(
            children: [
              // Retry Button
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: YachayTheme.radiusMedium,
                    onTap: _startRecording,
                    highlightColor: Colors.black.withValues(alpha: 0.08),
                    splashColor: Colors.black.withValues(alpha: 0.05),
                    child: Ink(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: YachayTheme.radiusMedium,
                        border: Border.all(color: YachayTheme.primaryPurple, width: 2),
                        boxShadow: YachayTheme.getButton3DShadow(YachayTheme.surfacePurple),
                      ),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Grabar de nuevo 🔄',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: YachayTheme.primaryPurple,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Verify Button
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: YachayTheme.radiusMedium,
                    onTap: _verifyPronunciation,
                    highlightColor: Colors.black.withValues(alpha: 0.15),
                    splashColor: Colors.black.withValues(alpha: 0.1),
                    child: Ink(
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: YachayTheme.primaryGradient,
                        borderRadius: YachayTheme.radiusMedium,
                        boxShadow: YachayTheme.getButton3DShadow(YachayTheme.primaryPurpleDark),
                      ),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Verificar voz 🚀',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
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
