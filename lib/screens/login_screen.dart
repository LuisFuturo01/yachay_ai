import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../services/progress_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _autocomplete(String role) {
    setState(() {
      _errorMessage = null;
      if (role == 'student') {
        _usernameController.text = 'estudiante';
        _passwordController.text = '1234';
      } else {
        _usernameController.text = 'docente';
        _passwordController.text = '1234';
      }
    });
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));

    final username = _usernameController.text.trim().toLowerCase();
    final password = _passwordController.text.trim();

    if (username == 'estudiante' && password == '1234') {
      // Logged in as student
      await ProgressService.instance.loadProfile();
      if (mounted) {
        setState(() => _isLoading = false);
        if (ProgressService.instance.hasProfile) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          Navigator.pushReplacementNamed(context, '/avatar');
        }
      }
    } else if (username == 'docente' && password == '1234') {
      // Logged in as teacher
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pushReplacementNamed(context, '/teacher');
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = '🔑 ¡Ups! Credenciales incorrectas.\nIntenta con estudiante/1234 o docente/1234';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ─── Playful Background Gradient ───
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: YachayTheme.playfulBackgroundGradient,
            ),
          ),

          // ─── Floating Decorative Objects ───
          Positioned(
            top: 60,
            left: -40,
            child: const Text('☁️', style: TextStyle(fontSize: 80))
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .slideX(begin: 0, end: 0.15, duration: 8.seconds, curve: Curves.easeInOut)
                .fadeIn(duration: 1.seconds),
          ),
          Positioned(
            top: 150,
            right: -30,
            child: const Text('☁️', style: TextStyle(fontSize: 60))
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .slideX(begin: 0, end: -0.12, duration: 6.seconds, curve: Curves.easeInOut)
                .fadeIn(duration: 1.seconds),
          ),
          Positioned(
            bottom: 80,
            left: 20,
            child: const Text('✨', style: TextStyle(fontSize: 32))
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.3, 1.3), duration: 2.seconds)
                .rotate(begin: 0, end: 0.2, duration: 3.seconds),
          ),
          Positioned(
            bottom: 120,
            right: 40,
            child: const Text('🎈', style: TextStyle(fontSize: 48))
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .slideY(begin: 0, end: -0.2, duration: 4.seconds, curve: Curves.easeInOut),
          ),

          // ─── Main Content ───
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Mascot/Logo Icon
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: YachayTheme.mathGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: YachayTheme.primaryPurple.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('🧠', style: TextStyle(fontSize: 50)),
                      ),
                    ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.08, 1.08),
                      duration: 1.seconds,
                      curve: Curves.easeInOut,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Yachay AI',
                      style: GoogleFonts.outfit(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: YachayTheme.textDark,
                        letterSpacing: -0.5,
                      ),
                    ),

                    Text(
                      'Aventura Educativa Inteligente 🚀',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: YachayTheme.primaryPurple,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Login Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: YachayTheme.radiusLarge,
                        border: Border.all(
                          color: YachayTheme.primaryPurple.withValues(alpha: 0.15),
                          width: 3,
                        ),
                        boxShadow: YachayTheme.softShadow,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Iniciar Sesión',
                              style: GoogleFonts.outfit(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: YachayTheme.textDark,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),

                            // Error message
                            if (_errorMessage != null)
                              Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: YachayTheme.errorPinkLight,
                                  borderRadius: YachayTheme.radiusSmall,
                                  border: Border.all(color: YachayTheme.errorPink.withValues(alpha: 0.3)),
                                ),
                                child: Text(
                                  _errorMessage!,
                                  style: GoogleFonts.nunito(
                                    color: YachayTheme.errorPink,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ).animate().shake(),

                            // Username
                            TextFormField(
                              controller: _usernameController,
                              style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                hintText: 'Ingresa tu usuario',
                                labelText: 'Usuario',
                                prefixIcon: const Icon(Icons.person_rounded, color: YachayTheme.primaryPurple),
                                border: OutlineInputBorder(
                                  borderRadius: YachayTheme.radiusSmall,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Por favor ingresa tu usuario';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Password
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                hintText: 'Ingresa tu contraseña',
                                labelText: 'Contraseña',
                                prefixIcon: const Icon(Icons.lock_rounded, color: YachayTheme.primaryPurple),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                    color: YachayTheme.textMedium,
                                  ),
                                  onPressed: () {
                                    setState(() => _obscurePassword = !_obscurePassword);
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: YachayTheme.radiusSmall,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu contraseña';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // Log In Button (3D styling)
                            GestureDetector(
                              onTap: _isLoading ? null : _login,
                              child: Container(
                                height: 54,
                                decoration: BoxDecoration(
                                  gradient: YachayTheme.primaryGradient,
                                  borderRadius: YachayTheme.radiusMedium,
                                  boxShadow: YachayTheme.getButton3DShadow(YachayTheme.primaryPurpleDark),
                                ),
                                child: Center(
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 3,
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '¡Entrar a Jugar!',
                                              style: GoogleFonts.nunito(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Text('⭐', style: TextStyle(fontSize: 18)),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

                    const SizedBox(height: 24),

                    // Demo shortcuts text
                    Text(
                      'Accesos rápidos para evaluación:',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: YachayTheme.textMedium,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Shortcuts row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _autocomplete('student'),
                          icon: const Text('👧'),
                          label: Text(
                            'Estudiante',
                            style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: YachayTheme.surfacePurple,
                            foregroundColor: YachayTheme.primaryPurple,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: YachayTheme.radiusSmall,
                              side: const BorderSide(color: YachayTheme.primaryPurpleLight, width: 1.5),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () => _autocomplete('teacher'),
                          icon: const Text('👩‍🏫'),
                          label: Text(
                            'Docente',
                            style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: YachayTheme.surfaceGold,
                            foregroundColor: YachayTheme.warningOrange,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: YachayTheme.radiusSmall,
                              side: const BorderSide(color: YachayTheme.secondaryGold, width: 1.5),
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 400.ms),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
