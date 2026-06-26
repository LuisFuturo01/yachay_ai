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
}
