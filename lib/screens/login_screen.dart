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

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));

    final username = _usernameController.text.trim().toLowerCase();
    final password = _passwordController.text.trim();

    if (username == 'estudiante' && password == '1234') {
      await ProgressService.instance.loadProfile();
      if (mounted) {
        setState(() => _isLoading = false);
        if (ProgressService.instance.hasProfile) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          Navigator.pushReplacementNamed(context, '/avatar');
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = '🔑 ¡Ups! Credenciales incorrectas.\nIntenta con estudiante / 1234 o toca Crear Cuenta.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
            top: 40,
            left: -30,
            child: const Text('☁️', style: TextStyle(fontSize: 60))
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .slideX(begin: 0, end: 0.1, duration: 8.seconds, curve: Curves.easeInOut)
                .fadeIn(duration: 1.seconds),
          ),
          Positioned(
            top: 120,
            right: -25,
            child: const Text('☁️', style: TextStyle(fontSize: 50))
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .slideX(begin: 0, end: -0.08, duration: 6.seconds, curve: Curves.easeInOut)
                .fadeIn(duration: 1.seconds),
          ),

          // ─── Main Content ───
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Mascot Icon (Logo)
                    Image.asset(
                      'web/favicon.png',
                      height: 100,
                      fit: BoxFit.contain,
                    ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.06, 1.06),
                      duration: 1.seconds,
                      curve: Curves.easeInOut,
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Yachay AI',
                      style: GoogleFonts.outfit(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: YachayTheme.textDark,
                        letterSpacing: -0.5,
                      ),
                    ),

                    Text(
                      'Aventura Educativa Inteligente 🚀',
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: YachayTheme.primaryPurple,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Login Card
                    Container(
                      width: size.width > 400 ? 380 : double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
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
                              'Ingresar al Aula',
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: YachayTheme.textDark,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 14),

                            // Error message
                            if (_errorMessage != null)
                              Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: YachayTheme.errorPinkLight,
                                  borderRadius: YachayTheme.radiusSmall,
                                  border: Border.all(color: YachayTheme.errorPink.withValues(alpha: 0.25)),
                                ),
                                child: Text(
                                  _errorMessage!,
                                  style: GoogleFonts.nunito(
                                    color: YachayTheme.errorPink,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ).animate().shake(),

                            // Username
                            TextFormField(
                              controller: _usernameController,
                              style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                hintText: 'Usuario o Nombre',
                                labelText: 'Usuario',
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                prefixIcon: const Icon(Icons.person_rounded, size: 20, color: YachayTheme.primaryPurple),
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
                            const SizedBox(height: 12),

                            // Password
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                hintText: 'Contraseña',
                                labelText: 'Contraseña',
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                prefixIcon: const Icon(Icons.lock_rounded, size: 20, color: YachayTheme.primaryPurple),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                    color: YachayTheme.textMedium,
                                    size: 20,
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
                            const SizedBox(height: 20),

                            // Log In Button (3D style)
                            GestureDetector(
                              onTap: _isLoading ? null : _login,
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: YachayTheme.primaryGradient,
                                  borderRadius: YachayTheme.radiusMedium,
                                  boxShadow: YachayTheme.getButton3DShadow(YachayTheme.primaryPurpleDark),
                                ),
                                child: Center(
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '¡Entrar a Jugar!',
                                                style: GoogleFonts.nunito(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              const Text('⭐', style: TextStyle(fontSize: 16)),
                                            ],
                                          ),
                                        ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Create Account button (3D Outline style)
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/avatar');
                              },
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: YachayTheme.radiusMedium,
                                  border: Border.all(color: YachayTheme.primaryPurple, width: 2),
                                  boxShadow: YachayTheme.getButton3DShadow(YachayTheme.surfacePurple),
                                ),
                                child: Center(
                                  child: Text(
                                    'Crear Cuenta 🎭',
                                    style: GoogleFonts.nunito(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: YachayTheme.primaryPurple,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Testing Tip (Responsive scale)
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '🔑 Cuenta Demo: estudiante / 1234',
                                style: GoogleFonts.nunito(
                                  fontSize: 13,
                                  color: YachayTheme.textMedium,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.1),

                    const SizedBox(height: 20),
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
