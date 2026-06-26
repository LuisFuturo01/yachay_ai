import '../data/mock_math_data.dart';
import '../data/mock_science_data.dart';
import '../data/mock_social_data.dart';
import '../data/mock_aymara_data.dart';
import '../models/lesson.dart';

/// Service abstraction layer for the AI tutor.
/// Currently uses mock data; will be replaced by Gemini API calls via Cloud Run.

class TutorService {
  TutorService._();
  static final TutorService instance = TutorService._();

  // ─── Get Lesson Data ───

  Lesson getLesson(String subjectId, int level) {
    switch (subjectId) {
      case 'math':
        return MockMathData.getLesson(level);
      case 'science':
        return MockScienceData.getLesson(level);
      case 'social':
        return MockSocialData.getLesson(level);
      default:
        return MockMathData.getLesson(level);
    }
  }

  AymaraLesson getAymaraLesson(int level) {
    return MockAymaraData.getLesson(level);
  }

  // ─── Get Total Levels ───

  int getTotalLevels(String subjectId) {
    switch (subjectId) {
      case 'math':
        return MockMathData.totalLevels;
      case 'science':
        return MockScienceData.totalLevels;
      case 'social':
        return MockSocialData.totalLevels;
      case 'aymara':
        return MockAymaraData.totalLevels;
      default:
        return 5;
    }
  }

  // ─── Evaluate Answer (Mock — will be Gemini API) ───

  Future<TutorResponse> evaluateAnswer({
    required String subjectId,
    required int level,
    required int questionIndex,
    required String userAnswer,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    final lesson = getLesson(subjectId, level);
    if (questionIndex >= lesson.questions.length) {
      return TutorResponse(
        isCorrect: false,
        message: '¡Ya completaste todas las preguntas de esta lección!',
        type: ResponseType.lessonComplete,
      );
    }

    final question = lesson.questions[questionIndex];
    final isCorrect = _normalizeAnswer(userAnswer) == _normalizeAnswer(question.correctAnswer);

    if (isCorrect) {
      return TutorResponse(
        isCorrect: true,
        message: '🎉 ¡Excelente! ${question.explanation}',
        type: ResponseType.correct,
      );
    } else {
      // Socratic method: give hints instead of the answer
      return TutorResponse(
        isCorrect: false,
        message: '🤔 ${question.hints.first}',
        type: ResponseType.hint,
        hintsRemaining: question.hints.length - 1,
      );
    }
  }

  // ─── Get Additional Hint ───

  String getHint(String subjectId, int level, int questionIndex, int hintIndex) {
    final lesson = getLesson(subjectId, level);
    if (questionIndex >= lesson.questions.length) return 'No hay más pistas.';
    
    final hints = lesson.questions[questionIndex].hints;
    if (hintIndex >= hints.length) {
      return '💡 Pista final: La respuesta correcta es "${lesson.questions[questionIndex].correctAnswer}"';
    }
    return '💡 ${hints[hintIndex]}';
  }

  // ─── Evaluate Aymara Pronunciation (Mock — will be Gemini multimodal) ───

  Future<AymaraPronunciationResult> evaluatePronunciation({
    required int level,
    required int wordIndex,
  }) async {
    // Simulate API/Gemini processing delay
    await Future.delayed(const Duration(seconds: 1));

    final lesson = MockAymaraData.getLesson(level);
    if (wordIndex >= lesson.words.length) {
      return AymaraPronunciationResult(
        precision: 0,
        feedback: '¡Ya practicaste todas las palabras!',
        isGood: true,
      );
    }

    // Mock: return random-ish results based on word index
    final precisions = [85, 72, 90, 65, 78, 88, 95, 60, 80, 70];
    final precision = precisions[wordIndex % precisions.length];
    
    return AymaraPronunciationResult(
      precision: precision,
      feedback: precision >= 80
          ? '¡Muy bien! Tu pronunciación es excelente.'
          : precision >= 60
              ? '¡Buen intento! Intenta marcar más la sílaba fuerte.'
              : 'Sigue practicando. Escucha de nuevo y repite más lento.',
      isGood: precision >= 70,
    );
  }

  // ─── Helpers ───

  String _normalizeAnswer(String answer) {
    return answer.trim().toLowerCase().replaceAll(RegExp(r'[^\w\sáéíóúñü]'), '');
  }
}

// ─── Response Models ───

enum ResponseType { correct, hint, incorrect, lessonComplete }

class TutorResponse {
  final bool isCorrect;
  final String message;
  final ResponseType type;
  final int hintsRemaining;

  const TutorResponse({
    required this.isCorrect,
    required this.message,
    required this.type,
    this.hintsRemaining = 0,
  });
}

class AymaraPronunciationResult {
  final int precision;
  final String feedback;
  final bool isGood;

  const AymaraPronunciationResult({
    required this.precision,
    required this.feedback,
    required this.isGood,
  });
}
