import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../data/mock_avatars.dart';
import '../models/subject.dart';
import '../services/progress_service.dart';
import '../services/tutor_service.dart';
import '../widgets/subject_card.dart';

class HomeMapScreen extends StatefulWidget {
  const HomeMapScreen({super.key});

  @override
  State<HomeMapScreen> createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends State<HomeMapScreen> {
  int _currentNavIndex = 0;

  static const List<Subject> _subjects = [
    Subject(
      id: 'math',
      name: 'Matemáticas',
      emoji: '🧮',
      icon: Icons.calculate_rounded,
      color: YachayTheme.mathColor,
      colorLight: Color(0xFFEDE9FE),
      description: 'Sumas, restas, multiplicación y más',
      totalLevels: 5,
    ),
    Subject(
      id: 'science',
      name: 'Ciencias Naturales',
      emoji: '🔬',
      icon: Icons.science_rounded,
      color: YachayTheme.scienceColor,
      colorLight: Color(0xFFD1FAE5),
      description: 'Animales, plantas y el cuerpo humano',
      totalLevels: 5,
    ),
    Subject(
      id: 'social',
      name: 'Ciencias Sociales',
      emoji: '🌍',
      icon: Icons.public_rounded,
      color: YachayTheme.socialColor,
      colorLight: Color(0xFFFCE7F3),
      description: 'Bolivia, culturas y geografía',
      totalLevels: 5,
    ),
    Subject(
      id: 'aymara',
      name: 'Idioma Aymara',
      emoji: '🗣️',
      icon: Icons.record_voice_over_rounded,
      color: YachayTheme.aymaraColor,
      colorLight: Color(0xFFFED7AA),
      description: 'Aprende a hablar Aymara',
      totalLevels: 5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final profile = ProgressService.instance.currentProfile;
    final avatar = profile != null
        ? MockAvatars.getById(profile.avatarId)
        : MockAvatars.avatars.first;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: YachayTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // ─── Top Bar ───
              _buildTopBar(profile, avatar),

              // ─── Content ───
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        '¿Qué quieres aprender hoy?',
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: YachayTheme.textDark,
                        ),
                      ).animate().fadeIn().slideX(begin: -0.1),

                      const SizedBox(height: 6),
                      Text(
                        'Elige una materia para comenzar 📚',
                        style: GoogleFonts.nunito(
                          fontSize: 15,
                          color: YachayTheme.textMedium,
                        ),
                      ).animate().fadeIn(delay: 100.ms),

                      const SizedBox(height: 20),

                      // ─── Subject Grid ───
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: _subjects.length,
                        itemBuilder: (context, index) {
                          final subject = _subjects[index];
                          final currentLevel = ProgressService.instance
                              .getSubjectProgress(subject.id);
                          final totalLevels =
                              TutorService.instance.getTotalLevels(subject.id);
                          final progress = currentLevel / totalLevels;

                          return SubjectCard(
                            emoji: subject.emoji,
                            name: subject.name,
                            color: subject.color,
                            colorLight: subject.colorLight,
                            progress: progress,
                            isLocked: false, // All subjects unlocked
                            onTap: () => _navigateToSubject(subject, currentLevel),
                          ).animate(delay: (index * 120).ms);
                        },
                      ),

                      const SizedBox(height: 24),

                      // ─── Daily Tip Card ───
                      _buildTipCard(),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTopBar(dynamic profile, AvatarData avatar) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Avatar
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: YachayTheme.surfacePurple,
                shape: BoxShape.circle,
                border: Border.all(
                  color: YachayTheme.primaryPurple.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(avatar.emoji, style: const TextStyle(fontSize: 26)),
              ),
            ),
          ).animate().fadeIn().scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                duration: 400.ms,
              ),

          const SizedBox(width: 12),

          // Name & greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Hola, ${profile?.name ?? 'Estudiante'}! 👋',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: YachayTheme.textDark,
                  ),
                ),
                Text(
                  '¡Sigue aprendiendo!',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    color: YachayTheme.textMedium,
                  ),
                ),
              ],
            ),
          ),

          // Points badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: YachayTheme.goldGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: YachayTheme.secondaryGold.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('⭐', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 4),
                Text(
                  '${ProgressService.instance.getTotalPoints()}',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.2),
        ],
      ),
    );
  }

  Widget _buildTipCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            YachayTheme.primaryPurple.withValues(alpha: 0.08),
            YachayTheme.secondaryGold.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: YachayTheme.radiusMedium,
        border: Border.all(
          color: YachayTheme.primaryPurple.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          const Text('💡', style: TextStyle(fontSize: 32)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¿Sabías que...?',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: YachayTheme.primaryPurple,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bolivia tiene 36 lenguas originarias. ¡El aymara es una de las más habladas!',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    color: YachayTheme.textMedium,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1);
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() => _currentNavIndex = index);
          if (index == 1) {
            Navigator.pushNamed(context, '/profile');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map_rounded),
            activeIcon: Icon(Icons.map_rounded),
            label: 'Aprender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_rounded),
            activeIcon: Icon(Icons.emoji_events_rounded),
            label: 'Logros',
          ),
        ],
      ),
    );
  }

  void _navigateToSubject(Subject subject, int currentLevel) {
    if (subject.id == 'aymara') {
      Navigator.pushNamed(
        context,
        '/aymara',
        arguments: {'level': currentLevel},
      );
    } else {
      Navigator.pushNamed(
        context,
        '/tutor',
        arguments: {
          'subjectId': subject.id,
          'subjectName': subject.name,
          'subjectEmoji': subject.emoji,
          'subjectColor': subject.color.value,
          'level': currentLevel,
        },
      );
    }
  }
}
