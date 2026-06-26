class Achievement {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final int requiredPoints;
  final String? subjectId; // null = global achievement

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.requiredPoints,
    this.subjectId,
  });
}
