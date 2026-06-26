import '../models/achievement.dart';

/// Mock achievements data.
/// Replace with API response when backend is ready.

class MockAchievements {
  MockAchievements._();

  static const List<Achievement> achievements = [
    // ─── Global Achievements ───
    Achievement(
      id: 'first_steps',
      title: 'Primeros Pasos',
      description: '¡Completaste tu primera lección!',
      emoji: '👶',
      requiredPoints: 0,
    ),
    Achievement(
      id: 'explorer',
      title: 'Explorador',
      description: 'Alcanzaste 100 puntos.',
      emoji: '🧭',
      requiredPoints: 100,
    ),
    Achievement(
      id: 'scholar',
      title: 'Estudioso',
      description: 'Alcanzaste 300 puntos.',
      emoji: '📖',
      requiredPoints: 300,
    ),
    Achievement(
      id: 'genius',
      title: 'Genio',
      description: 'Alcanzaste 500 puntos.',
      emoji: '🧠',
      requiredPoints: 500,
    ),
    Achievement(
      id: 'legend',
      title: 'Leyenda',
      description: 'Alcanzaste 1000 puntos.',
      emoji: '🏆',
      requiredPoints: 1000,
    ),

    // ─── Math Achievements ───
    Achievement(
      id: 'math_beginner',
      title: 'Sumador Novato',
      description: 'Completaste el nivel 1 de Matemáticas.',
      emoji: '➕',
      requiredPoints: 0,
      subjectId: 'math',
    ),
    Achievement(
      id: 'math_master',
      title: 'Maestro de Números',
      description: 'Completaste todos los niveles de Matemáticas.',
      emoji: '🧮',
      requiredPoints: 0,
      subjectId: 'math',
    ),

    // ─── Science Achievements ───
    Achievement(
      id: 'science_beginner',
      title: 'Pequeño Científico',
      description: 'Completaste el nivel 1 de Ciencias.',
      emoji: '🔬',
      requiredPoints: 0,
      subjectId: 'science',
    ),
    Achievement(
      id: 'science_master',
      title: 'Doctor en Ciencias',
      description: 'Completaste todos los niveles de Ciencias.',
      emoji: '🧪',
      requiredPoints: 0,
      subjectId: 'science',
    ),

    // ─── Social Achievements ───
    Achievement(
      id: 'social_beginner',
      title: 'Ciudadano Curioso',
      description: 'Completaste el nivel 1 de Sociales.',
      emoji: '🌎',
      requiredPoints: 0,
      subjectId: 'social',
    ),
    Achievement(
      id: 'social_master',
      title: 'Historiador',
      description: 'Completaste todos los niveles de Sociales.',
      emoji: '📜',
      requiredPoints: 0,
      subjectId: 'social',
    ),

    // ─── Aymara Achievements ───
    Achievement(
      id: 'aymara_beginner',
      title: 'Aprendiz de Aymara',
      description: 'Completaste el nivel 1 de Aymara.',
      emoji: '🗣️',
      requiredPoints: 0,
      subjectId: 'aymara',
    ),
    Achievement(
      id: 'aymara_master',
      title: 'Jilata (Hermano Mayor)',
      description: 'Completaste todos los niveles de Aymara.',
      emoji: '🎓',
      requiredPoints: 0,
      subjectId: 'aymara',
    ),

    // ─── Streak / Special ───
    Achievement(
      id: 'perfect_lesson',
      title: 'Perfeccionista',
      description: '¡Completaste una lección sin errores!',
      emoji: '💯',
      requiredPoints: 0,
    ),
    Achievement(
      id: 'all_subjects',
      title: 'Todólogo',
      description: 'Completaste al menos un nivel en todas las materias.',
      emoji: '🌟',
      requiredPoints: 0,
    ),
  ];

  static Achievement? getById(String id) {
    try {
      return achievements.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<Achievement> getGlobalAchievements() {
    return achievements.where((a) => a.subjectId == null).toList();
  }

  static List<Achievement> getBySubject(String subjectId) {
    return achievements.where((a) => a.subjectId == subjectId).toList();
  }
}
