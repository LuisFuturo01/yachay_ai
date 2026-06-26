import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../data/mock_avatars.dart';
import '../data/mock_achievements.dart';
import '../services/progress_service.dart';
import '../services/tutor_service.dart';
import '../widgets/achievement_badge.dart';
import '../widgets/progress_ring.dart';

class ProfileAchievementsScreen extends StatelessWidget {
  const ProfileAchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = ProgressService.instance.currentProfile;
    if (profile == null) {
      return const Scaffold(body: Center(child: Text('No hay perfil')));
    }

    final avatar = MockAvatars.getById(profile.avatarId);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: YachayTheme.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 8),

                // ─── Top Bar ───
                Row(
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
                        child:
                            const Icon(Icons.arrow_back_rounded, size: 20),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Mi Perfil',
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: YachayTheme.textDark,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 40),
                  ],
                ),

                const SizedBox(height: 24),

                // ─── Profile Card ───
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: YachayTheme.primaryGradient,
                    borderRadius: YachayTheme.radiusLarge,
                    boxShadow: [
                      BoxShadow(
                        color:
                            YachayTheme.primaryPurple.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.5),
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Text(avatar.emoji,
                              style: const TextStyle(fontSize: 42)),
                        ),
                      ).animate().scale(
                            begin: const Offset(0.8, 0.8),
                            end: const Offset(1, 1),
                            duration: 500.ms,
                            curve: Curves.elasticOut,
                          ),

                      const SizedBox(height: 12),
                      Text(
                        profile.name,
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        avatar.description,
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Points
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: YachayTheme.goldGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('⭐',
                                style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 8),
                            Text(
                              '${profile.totalPoints} puntos',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: -0.1),

                const SizedBox(height: 28),

                // ─── Subject Progress ───
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '📊 Progreso por materia',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: YachayTheme.textDark,
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 16),

                _buildProgressList(profile),

                const SizedBox(height: 28),

                // ─── Achievements ───
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '🏅 Mis Logros',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: YachayTheme.textDark,
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms),

                const SizedBox(height: 16),

                _buildAchievementsGrid(profile),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressList(dynamic profile) {
    final subjects = [
      {
        'id': 'math',
        'name': 'Matemáticas',
        'emoji': '🧮',
        'color': YachayTheme.mathColor
      },
      {
        'id': 'science',
        'name': 'Ciencias Naturales',
        'emoji': '🔬',
        'color': YachayTheme.scienceColor
      },
      {
        'id': 'social',
        'name': 'Ciencias Sociales',
        'emoji': '🌍',
        'color': YachayTheme.socialColor
      },
      {
        'id': 'aymara',
        'name': 'Idioma Aymara',
        'emoji': '🗣️',
        'color': YachayTheme.aymaraColor
      },
    ];

    return Column(
      children: subjects.asMap().entries.map((entry) {
        final index = entry.key;
        final subject = entry.value;
        final subjectId = subject['id'] as String;
        final progress = ProgressService.instance.getSubjectProgress(subjectId);
        final total =
            TutorService.instance.getTotalLevels(subjectId);
        final ratio = progress / total;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: YachayTheme.radiusMedium,
            boxShadow: YachayTheme.cardShadow,
          ),
          child: Row(
            children: [
              Text(subject['emoji'] as String,
                  style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject['name'] as String,
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: YachayTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: ratio,
                        minHeight: 8,
                        backgroundColor:
                            (subject['color'] as Color).withValues(alpha: 0.1),
                        color: subject['color'] as Color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              ProgressRing(
                progress: ratio,
                size: 48,
                strokeWidth: 5,
                color: subject['color'] as Color,
              ),
            ],
          ),
        ).animate(delay: (300 + index * 100).ms).fadeIn().slideX(begin: 0.1);
      }).toList(),
    );
  }

  Widget _buildAchievementsGrid(dynamic profile) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: MockAchievements.achievements.length,
      itemBuilder: (context, index) {
        final achievement = MockAchievements.achievements[index];
        final isUnlocked =
            ProgressService.instance.hasAchievement(achievement.id);
        return AchievementBadge(
          achievement: achievement,
          isUnlocked: isUnlocked,
          size: 60,
        );
      },
    );
  }
}
