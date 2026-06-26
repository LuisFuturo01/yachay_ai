import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../models/chat_message.dart';
import '../services/tutor_service.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/animated_tutor_avatar.dart';
import '../widgets/feedback_overlay.dart';

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
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final TutorService _tutor = TutorService.instance;

  int _currentQuestionIndex = 0;
  int _currentHintIndex = 0;
  int _correctAnswers = 0;
  int _totalAttempts = 0;
  bool _isProcessing = false;
  bool _showFeedback = false;
  bool _feedbackIsCorrect = false;
  String _feedbackMessage = '';
  TutorState _tutorState = TutorState.idle;

  @override
  void initState() {
    super.initState();
    _loadFirstQuestion();
  }

  void _loadFirstQuestion() {
    final lesson = _tutor.getLesson(widget.subjectId, widget.level);
    _messages.add(ChatMessage(
      text: '¡Hola! Soy Yachay, tu tutor de ${widget.subjectName}. 😊\n\n'
          'Hoy vamos a practicar: "${lesson.title}" ${lesson.emoji}\n\n'
          '¡Hay ${lesson.questions.length} preguntas! ¿Estás listo?',
      isUser: false,
      type: MessageType.normal,
    ));

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _askCurrentQuestion();
    });
  }

  void _askCurrentQuestion() {
    final lesson = _tutor.getLesson(widget.subjectId, widget.level);
    if (_currentQuestionIndex >= lesson.questions.length) {
      _onLessonComplete();
      return;
    }

    final question = lesson.questions[_currentQuestionIndex];
    setState(() {
      _messages.add(ChatMessage(
        text: '📝 Pregunta ${_currentQuestionIndex + 1}:\n\n${question.question}',
        isUser: false,
        type: MessageType.normal,
      ));

      // Show options if available
      if (question.options != null && question.options!.isNotEmpty) {
        final optionsText =
            question.options!.asMap().entries.map((e) {
              final letters = ['A', 'B', 'C', 'D'];
              return '${letters[e.key]}) ${e.value}';
            }).join('\n');
        _messages.add(ChatMessage(
          text: optionsText,
          isUser: false,
          type: MessageType.system,
        ));
      }

      _currentHintIndex = 0;
      _tutorState = TutorState.idle;
    });
    _scrollToBottom();
  }

  Future<void> _sendAnswer() async {
    final answer = _controller.text.trim();
    if (answer.isEmpty || _isProcessing) return;

    setState(() {
      _messages.add(ChatMessage(
        text: answer,
        isUser: true,
      ));
      _controller.clear();
      _isProcessing = true;
      _totalAttempts++;
      _tutorState = TutorState.thinking;

      // Show thinking indicator
      _messages.add(ChatMessage(
        text: '',
        isUser: false,
        type: MessageType.thinking,
      ));
    });
    _scrollToBottom();

    // Evaluate with tutor service
    final response = await _tutor.evaluateAnswer(
      subjectId: widget.subjectId,
      level: widget.level,
      questionIndex: _currentQuestionIndex,
      userAnswer: _resolveAnswer(answer),
    );

    if (!mounted) return;

    setState(() {
      // Remove thinking indicator
      _messages.removeWhere((m) => m.type == MessageType.thinking);

      if (response.isCorrect) {
        _messages.add(ChatMessage(
          text: response.message,
          isUser: false,
          type: MessageType.correct,
        ));
        _tutorState = TutorState.happy;
        _correctAnswers++;
        _currentQuestionIndex++;
        _isProcessing = false;

        // Show feedback overlay
        _feedbackIsCorrect = true;
        _feedbackMessage = response.message;
        _showFeedback = true;
      } else {
        _currentHintIndex++;
        _messages.add(ChatMessage(
          text: response.message,
          isUser: false,
          type: MessageType.hint,
        ));
        _tutorState = TutorState.thinking;
        _isProcessing = false;

        // If too many attempts, give the answer
        if (_currentHintIndex >= 3) {
          final lesson = _tutor.getLesson(widget.subjectId, widget.level);
          final correctAnswer =
              lesson.questions[_currentQuestionIndex].correctAnswer;
          _messages.add(ChatMessage(
            text: '💡 La respuesta correcta es: $correctAnswer\n\n'
                '${lesson.questions[_currentQuestionIndex].explanation}\n\n'
                '¡No te preocupes, lo harás mejor la próxima vez!',
            isUser: false,
            type: MessageType.incorrect,
          ));
          _currentQuestionIndex++;

          _feedbackIsCorrect = false;
          _feedbackMessage = '¡Sigue practicando! La próxima vez lo lograrás.';
          _showFeedback = true;
        }
      }
    });
    _scrollToBottom();
  }

  String _resolveAnswer(String answer) {
    // Map letter options to actual answers
    final lesson = _tutor.getLesson(widget.subjectId, widget.level);
    if (_currentQuestionIndex >= lesson.questions.length) return answer;

    final question = lesson.questions[_currentQuestionIndex];
    if (question.options == null || question.options!.isEmpty) return answer;

    final upperAnswer = answer.toUpperCase().trim();
    final letterMap = {'A': 0, 'B': 1, 'C': 2, 'D': 3};

    if (letterMap.containsKey(upperAnswer)) {
      final idx = letterMap[upperAnswer]!;
      if (idx < question.options!.length) {
        return question.options![idx];
      }
    }
    return answer;
  }

  void _onLessonComplete() {
    setState(() {
      _tutorState = TutorState.celebrating;
      _messages.add(ChatMessage(
        text: '🎉🎉🎉\n\n¡FELICIDADES! ¡Completaste la lección!\n\n'
            'Respuestas correctas: $_correctAnswers/${_tutor.getLesson(widget.subjectId, widget.level).questions.length}\n\n'
            '¡Eres increíble! 🌟',
        isUser: false,
        type: MessageType.correct,
      ));
    });
    _scrollToBottom();

    // Navigate to victory screen
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final lesson = _tutor.getLesson(widget.subjectId, widget.level);
        Navigator.pushReplacementNamed(
          context,
          '/victory',
          arguments: {
            'subjectId': widget.subjectId,
            'subjectName': widget.subjectName,
            'subjectEmoji': widget.subjectEmoji,
            'level': widget.level,
            'correctAnswers': _correctAnswers,
            'totalQuestions': lesson.questions.length,
            'pointsEarned': lesson.pointsReward,
          },
        );
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _dismissFeedback() {
    setState(() {
      _showFeedback = false;
      if (_feedbackIsCorrect) {
        // Load next question
        _askCurrentQuestion();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lesson = _tutor.getLesson(widget.subjectId, widget.level);
    final progress = _currentQuestionIndex / lesson.questions.length;

    return Scaffold(
      body: Stack(
        children: [
          // Main content
          Container(
            decoration:
                const BoxDecoration(gradient: YachayTheme.backgroundGradient),
            child: SafeArea(
              child: Column(
                children: [
                  // ─── App Bar ───
                  _buildAppBar(lesson.title, progress),

                  // ─── Chat Messages ───
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return ChatBubble(
                          message: _messages[index],
                          tutorEmoji: widget.subjectEmoji,
                        );
                      },
                    ),
                  ),

                  // ─── Input Area ───
                  _buildInputArea(),
                ],
              ),
            ),
          ),

          // Feedback overlay
          if (_showFeedback)
            FeedbackOverlay(
              isCorrect: _feedbackIsCorrect,
              message: _feedbackMessage,
              onDismiss: _dismissFeedback,
            ),
        ],
      ),
    );
  }

  Widget _buildAppBar(String lessonTitle, double progress) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Back button
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

          const SizedBox(width: 12),

          // Lesson info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.subjectEmoji} ${widget.subjectName}',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: YachayTheme.textMedium,
                  ),
                ),
                Text(
                  lessonTitle,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: YachayTheme.textDark,
                  ),
                ),
              ],
            ),
          ),

          // Tutor avatar
          AnimatedTutorAvatar(
            emoji: widget.subjectEmoji,
            state: _tutorState,
            size: 44,
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Text field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: YachayTheme.backgroundCream,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _controller,
                enabled: !_isProcessing,
                style: GoogleFonts.nunito(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Escribe tu respuesta...',
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  hintStyle: GoogleFonts.nunito(
                    color: YachayTheme.textLight,
                    fontSize: 16,
                  ),
                ),
                onSubmitted: (_) => _sendAnswer(),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Send button
          GestureDetector(
            onTap: _sendAnswer,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: _controller.text.isNotEmpty
                    ? YachayTheme.primaryGradient
                    : null,
                color: _controller.text.isEmpty
                    ? YachayTheme.surfacePurple
                    : null,
                shape: BoxShape.circle,
                boxShadow: _controller.text.isNotEmpty
                    ? [
                        BoxShadow(
                          color:
                              YachayTheme.primaryPurple.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              child: Icon(
                Icons.send_rounded,
                color: _controller.text.isNotEmpty
                    ? Colors.white
                    : YachayTheme.textLight,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 0.5, duration: 300.ms);
  }
}
