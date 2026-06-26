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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: YachayTheme.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // ─── Title ───
                Text(
                  '¿Cómo te llamas? 😊',
                  style: GoogleFonts.outfit(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: YachayTheme.textDark,
                  ),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2),

                const SizedBox(height: 8),
                Text(
                  'Escribe tu nombre para comenzar',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
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
                      fillColor: Colors.white,
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

                const SizedBox(height: 36),

                // ─── Continue Button ───
                AnimatedOpacity(
                  opacity: _isValid ? 1.0 : 0.4,
                  duration: const Duration(milliseconds: 300),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isValid && !_isLoading ? _createProfile : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: YachayTheme.primaryPurple,
                        disabledBackgroundColor:
                            YachayTheme.primaryPurple.withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: _isValid ? 6 : 0,
                        shadowColor:
                            YachayTheme.primaryPurple.withValues(alpha: 0.3),
                      ),
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
                                  '¡Listo, vamos!',
                                  style: GoogleFonts.nunito(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text('🎉',
                                    style: TextStyle(fontSize: 22)),
                              ],
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
