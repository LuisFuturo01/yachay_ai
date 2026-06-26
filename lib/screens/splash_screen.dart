import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../services/progress_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    _checkProfile();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _showButton = true);
    });
  }

  Future<void> _checkProfile() async {
    await ProgressService.instance.loadProfile();
  }

  void _navigateNext() {
    if (ProgressService.instance.hasProfile) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: YachayTheme.splashGradient),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // ─── Logo Icon ───
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 3,
                  ),
                ),
                child: const Center(
                  child: Text('🦙', style: TextStyle(fontSize: 60)),
                ),
              )
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1, 1),
                    curve: Curves.elasticOut,
                    duration: 1000.ms,
                  ),

              const SizedBox(height: 28),

              // ─── Title ───
              Text(
                'Yachay AI',
                style: GoogleFonts.outfit(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -1,
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 600.ms).slideY(
                    begin: 0.3,
                    end: 0,
                    delay: 300.ms,
                  ),

              const SizedBox(height: 8),

              // ─── Subtitle ───
              Text(
                '¡Aprende jugando! 🎮',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ).animate().fadeIn(delay: 600.ms, duration: 600.ms),

              const SizedBox(height: 8),
              Text(
                'Educación inteligente para niños bolivianos',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ).animate().fadeIn(delay: 800.ms),

              const Spacer(flex: 2),

              // ─── Return User Greeting ───
              if (ProgressService.instance.hasProfile)
                Text(
                  '¡Hola de nuevo, ${ProgressService.instance.currentProfile!.name}! 👋',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ).animate().fadeIn(delay: 1000.ms),

              const SizedBox(height: 20),

              // ─── CTA Button ───
              if (_showButton)
                ElevatedButton(
                  onPressed: _navigateNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: YachayTheme.secondaryGold,
                    foregroundColor: YachayTheme.textDark,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 8,
                    shadowColor:
                        YachayTheme.secondaryGold.withValues(alpha: 0.4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        ProgressService.instance.hasProfile
                            ? '¡Continuar!'
                            : '¡Vamos a jugar!',
                        style: GoogleFonts.nunito(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('🚀', style: TextStyle(fontSize: 22)),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.3, end: 0)
                    .then()
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.05, 1.05),
                      duration: 1500.ms,
                    ),

              const Spacer(),

              // ─── Footer ───
              Text(
                'Build with AI La Paz 2026',
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
