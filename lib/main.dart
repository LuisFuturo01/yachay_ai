import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/teacher_dashboard_screen.dart';
import 'screens/avatar_selection_screen.dart';
import 'screens/home_map_screen.dart';
import 'screens/tutor_chat_screen.dart';
import 'screens/aymara_voice_screen.dart';
import 'screens/feedback_victory_screen.dart';
import 'screens/profile_achievements_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const YachayApp());
}

class YachayApp extends StatelessWidget {
  const YachayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yachay AI',
      debugShowCheckedModeBanner: false,
      theme: YachayTheme.theme,
      initialRoute: '/',
      onGenerateRoute: _generateRoute,
    );
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _buildPageRoute(const SplashScreen(), settings);

      case '/login':
        return _buildPageRoute(const LoginScreen(), settings);

      case '/teacher':
        return _buildPageRoute(const TeacherDashboardScreen(), settings);

      case '/avatar':
        return _buildPageRoute(const AvatarSelectionScreen(), settings);

      case '/home':
        return _buildPageRoute(const HomeMapScreen(), settings);

      case '/tutor':
        final args = settings.arguments as Map<String, dynamic>;
        return _buildPageRoute(
          TutorChatScreen(
            subjectId: args['subjectId'] as String,
            subjectName: args['subjectName'] as String,
            subjectEmoji: args['subjectEmoji'] as String,
            subjectColor: Color(args['subjectColor'] as int),
            level: args['level'] as int,
          ),
          settings,
        );

      case '/aymara':
        final args = settings.arguments as Map<String, dynamic>;
        return _buildPageRoute(
          AymaraVoiceScreen(level: args['level'] as int),
          settings,
        );

      case '/victory':
        final args = settings.arguments as Map<String, dynamic>;
        return _buildPageRoute(
          FeedbackVictoryScreen(
            subjectId: args['subjectId'] as String,
            subjectName: args['subjectName'] as String,
            subjectEmoji: args['subjectEmoji'] as String,
            level: args['level'] as int,
            correctAnswers: args['correctAnswers'] as int,
            totalQuestions: args['totalQuestions'] as int,
            pointsEarned: args['pointsEarned'] as int,
          ),
          settings,
        );

      case '/profile':
        return _buildPageRoute(const ProfileAchievementsScreen(), settings);

      default:
        return _buildPageRoute(const SplashScreen(), settings);
    }
  }

  PageRouteBuilder _buildPageRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;
        final fadeAnimation =
            Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: curve),
        );
        final slideAnimation =
            Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero)
                .animate(
          CurvedAnimation(parent: animation, curve: curve),
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }
}
