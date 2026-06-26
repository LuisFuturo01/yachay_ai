import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../services/progress_service.dart';
import '../widgets/avatar_selector.dart';

class AvatarSelectionScreen extends StatefulWidget {
  const AvatarSelectionScreen({super.key});

  @override
  State<AvatarSelectionScreen> createState() => _AvatarSelectionScreenState();
}

class _AvatarSelectionScreenState extends State<AvatarSelectionScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedAvatarId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final profile = ProgressService.instance.currentProfile;
    if (profile != null) {
      _nameController.text = profile.name;
      _selectedAvatarId = profile.avatarId;
    }
  }

  bool get _isValid =>
      _nameController.text.trim().isNotEmpty && _selectedAvatarId != null;

  Future<void> _createProfile() async {
    if (!_isValid) return;
    setState(() => _isLoading = true);

    await ProgressService.instance.createProfile(
      _nameController.text.trim(),
      _selectedAvatarId!,
    );

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ─── Playful Background ───
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: YachayTheme.playfulBackgroundGradient,
            ),
          ),

          // Floating clouds decoration
          Positioned(
            top: 50,
            left: -30,
            child: const Text('☁️', style: TextStyle(fontSize: 60))
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .slideX(begin: 0, end: 0.12, duration: 6.seconds),
          ),
          Positioned(
            top: 180,
            right: -20,
            child: const Text('☁️', style: TextStyle(fontSize: 50))
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .slideX(begin: 0, end: -0.1, duration: 8.seconds),
          ),

          // ─── Content ───
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),

                  // ─── Title ───
                  Text(
                    '¿Cómo te llamas? 😊',
                    style: GoogleFonts.outfit(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: YachayTheme.textDark,
                    ),
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2),

                  const SizedBox(height: 8),
                  Text(
                    'Escribe tu nombre para comenzar la aventura',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: YachayTheme.textMedium,
                    ),
                  ).animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: 24),

                  // ─── Name Input ───
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: YachayTheme.radiusMedium,
                      boxShadow: YachayTheme.cardShadow,
                    ),
                    child: TextField(
                      controller: _nameController,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: YachayTheme.textDark,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Tu nombre aquí...',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text('✏️', style: TextStyle(fontSize: 20)),
                        ),
                        prefixIconConstraints: const BoxConstraints(minWidth: 50),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.9),
                        border: OutlineInputBorder(
                          borderRadius: YachayTheme.radiusMedium,
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: YachayTheme.radiusMedium,
                          borderSide: const BorderSide(
                            color: YachayTheme.primaryPurple,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),

                  const SizedBox(height: 36),

                  // ─── Avatar Selection Title ───
                  Text(
                    'Elige tu compañero de aventura 🐾',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: YachayTheme.textDark,
                    ),
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: 20),

                  // ─── Avatar Grid ───
                  AvatarSelector(
                    selectedId: _selectedAvatarId,
                    onSelected: (id) {
                      setState(() => _selectedAvatarId = id);
                    },
                  ),

                  // Mascot Speech Bubble
                  if (_selectedAvatarId != null) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: YachayTheme.radiusMedium,
                        border: Border.all(
                          color: YachayTheme.primaryPurple.withValues(alpha: 0.2),
                          width: 2,
                        ),
                        boxShadow: YachayTheme.softShadow,
                      ),
                      child: Text(
                        '¡Hola, ${_nameController.text.trim().isEmpty ? "amiguito" : _nameController.text.trim()}! Soy tu compañero ideal. ¡Viajemos juntos por Bolivia! ⛰️🎒✨',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: YachayTheme.primaryPurple,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ).animate().scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1.0, 1.0),
                      duration: 400.ms,
                      curve: Curves.easeOutBack,
                    ),
                  ],

                  const SizedBox(height: 36),

                  // ─── Continue Button (3D style) ───
                  AnimatedOpacity(
                    opacity: _isValid ? 1.0 : 0.4,
                    duration: const Duration(milliseconds: 300),
                    child: GestureDetector(
                      onTap: _isValid && !_isLoading ? _createProfile : null,
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _isValid ? YachayTheme.primaryPurple : Colors.grey.shade400,
                          borderRadius: YachayTheme.radiusMedium,
                          boxShadow: _isValid
                              ? YachayTheme.getButton3DShadow(YachayTheme.primaryPurpleDark)
                              : [],
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
                                        '¡Listo, vamos!',
                                        style: GoogleFonts.nunito(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text('🚀', style: TextStyle(fontSize: 18)),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
