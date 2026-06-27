class Question {
  final String question;
  final List<String>? options; // null for open-ended questions
  final String correctAnswer;
  final List<String> hints;
  final String explanation;
  final String? imageEmoji; // visual emoji hint for kids

  const Question({
    required this.question,
    this.options,
    required this.correctAnswer,
    required this.hints,
    required this.explanation,
    this.imageEmoji,
  });

  factory Question.fromGeminiJson(Map<String, dynamic> json) {
    final contenido = json['contenido'] as Map<String, dynamic>? ?? json;
    
    // Extract options
    List<String>? optionsList;
    if (contenido['opciones'] != null) {
      optionsList = List<String>.from(contenido['opciones'] as List);
    }
    
    // Extract hints
    List<String> hintsList = [];
    if (contenido['pistas'] != null) {
      hintsList = List<String>.from(contenido['pistas'] as List);
    } else if (contenido['pista'] != null) {
      hintsList = [contenido['pista'] as String];
    }

    return Question(
      question: contenido['enunciado'] as String? ?? contenido['pregunta'] as String? ?? '',
      options: optionsList,
      correctAnswer: (contenido['respuesta_correcta'] ?? contenido['correcto'] ?? '').toString(),
      hints: hintsList,
      explanation: contenido['explicacion'] as String? ?? '',
      imageEmoji: contenido['emoji'] as String? ?? json['metadata']?['emoji'] as String?,
    );
  }
}

class Lesson {
  final String id;
  final String subjectId;
  final int level; // 0-based
  final String title;
  final String description;
  final String emoji;
  final List<Question> questions;
  final int pointsReward;

  const Lesson({
    required this.id,
    required this.subjectId,
    required this.level,
    required this.title,
    required this.description,
    required this.emoji,
    required this.questions,
    this.pointsReward = 50,
  });

  factory Lesson.fromGeminiJson(Map<String, dynamic> json, String subjectId, int level) {
    final questionsList = <Question>[];
    
    if (json['preguntas'] != null) {
      final list = json['preguntas'] as List;
      for (final item in list) {
        if (item is Map<String, dynamic>) {
          questionsList.add(Question.fromGeminiJson(item));
        }
      }
    } else {
      // Fallback: single question parsed from the root/contenido
      questionsList.add(Question.fromGeminiJson(json));
    }

    return Lesson(
      id: '${subjectId}_${level}_dynamic',
      subjectId: subjectId,
      level: level,
      title: json['titulo'] as String? ?? 'Lección Dinámica',
      description: json['mensaje'] as String? ?? '¡Vamos a practicar!',
      emoji: json['metadata']?['emoji'] as String? ?? '✨',
      questions: questionsList,
      pointsReward: (json['metadata']?['puntos'] as num?)?.toInt() ?? 50,
    );
  }
}
