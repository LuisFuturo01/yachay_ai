import 'dart:convert';

class UserProfile {
  final String name;
  final String avatarId;
  final Map<String, int> subjectProgress; // subject key -> current level (0-based)
  final List<String> achievements;
  int totalPoints;

  UserProfile({
    required this.name,
    required this.avatarId,
    Map<String, int>? subjectProgress,
    List<String>? achievements,
    this.totalPoints = 0,
  })  : subjectProgress = subjectProgress ?? {
          'math': 0,
          'science': 0,
          'social': 0,
          'aymara': 0,
        },
        achievements = achievements ?? [];

  int getProgress(String subjectId) => subjectProgress[subjectId] ?? 0;

  void advanceLevel(String subjectId) {
    subjectProgress[subjectId] = (subjectProgress[subjectId] ?? 0) + 1;
  }

  void addPoints(int points) {
    totalPoints += points;
  }

  void unlockAchievement(String achievementId) {
    if (!achievements.contains(achievementId)) {
      achievements.add(achievementId);
    }
  }

  // ─── Serialization (for SharedPreferences / future Firebase) ───
  Map<String, dynamic> toJson() => {
    'name': name,
    'avatarId': avatarId,
    'subjectProgress': subjectProgress,
    'achievements': achievements,
    'totalPoints': totalPoints,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    name: json['name'] as String,
    avatarId: json['avatarId'] as String,
    subjectProgress: Map<String, int>.from(json['subjectProgress'] as Map),
    achievements: List<String>.from(json['achievements'] as List),
    totalPoints: json['totalPoints'] as int,
  );

  String toJsonString() => jsonEncode(toJson());

  factory UserProfile.fromJsonString(String jsonString) =>
      UserProfile.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
}
