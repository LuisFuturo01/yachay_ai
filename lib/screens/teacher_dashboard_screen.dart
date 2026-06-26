import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../widgets/progress_ring.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  int _currentTab = 0;

  // Mock Students Data (simulating BigQuery analytics feedback)
  final List<Map<String, dynamic>> _students = [
    {
      'name': 'Liam Mamani',
      'avatar': '🦊',
      'points': 450,
      'accuracy': 92,
      'mathProgress': 0.8,
      'scienceProgress': 0.6,
      'socialProgress': 0.4,
      'aymaraProgress': 0.9,
    },
    {
      'name': 'Sofía Flores',
      'avatar': '🦙',
      'points': 380,
      'accuracy': 87,
      'mathProgress': 0.6,
      'scienceProgress': 0.4,
      'socialProgress': 0.2,
      'aymaraProgress': 0.8,
    },
    {
      'name': 'Mateo Choque',
      'avatar': '🦅',
      'points': 290,
      'accuracy': 78,
      'mathProgress': 0.4,
      'scienceProgress': 0.2,
      'socialProgress': 0.6,
      'aymaraProgress': 0.5,
    },
    {
      'name': 'Camila Quispe',
      'avatar': '🦔',
      'points': 520,
      'accuracy': 95,
      'mathProgress': 1.0,
      'scienceProgress': 0.8,
      'socialProgress': 0.8,
      'aymaraProgress': 1.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: YachayTheme.playfulBackgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ─── Custom Top Bar ───
              _buildTopBar(),

              // ─── Main Content ───
              Expanded(
                child: _buildTabContent(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        border: Border(
          bottom: BorderSide(
            color: YachayTheme.primaryPurple.withValues(alpha: 0.1),
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              gradient: YachayTheme.teacherGradient,
              shape: BoxShape.circle,
            ),
            child: const Text('👩‍🏫', style: TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Panel del Docente',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: YachayTheme.textDark,
                  ),
                ),
                Text(
                  'Aula 3° Primaria — Tutoría IA 🎓',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: YachayTheme.primaryPurple,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: YachayTheme.errorPink),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: YachayTheme.primaryPurple.withValues(alpha: 0.1),
            width: 2,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentTab,
        selectedItemColor: YachayTheme.primaryPurple,
        unselectedItemColor: YachayTheme.textLight,
        selectedLabelStyle: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 13),
        unselectedLabelStyle: GoogleFonts.nunito(fontSize: 13),
        onTap: (idx) => setState(() => _currentTab = idx),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_rounded),
            label: 'Estudiantes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_rounded),
            label: 'Creador IA',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum_rounded),
            label: 'Asistente IA',
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_currentTab) {
      case 0:
        return _buildStudentsTab();
      case 1:
        return _buildGeneratorTab();
      case 2:
        return _buildAssistantTab();
      default:
        return const SizedBox();
    }
  }

  // ─── Tab 1: Students Analytics ───
  Widget _buildStudentsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _students.length,
      itemBuilder: (context, index) {
        final student = _students[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: YachayTheme.radiusMedium,
            border: Border.all(
              color: YachayTheme.primaryPurple.withValues(alpha: 0.15),
              width: 2,
            ),
            boxShadow: YachayTheme.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header of student card
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: YachayTheme.surfacePurple,
                      shape: BoxShape.circle,
                      border: Border.all(color: YachayTheme.primaryPurpleLight, width: 2),
                    ),
                    child: Center(
                      child: Text(student['avatar'] as String, style: const TextStyle(fontSize: 26)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student['name'] as String,
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: YachayTheme.textDark,
                          ),
                        ),
                        Text(
                          '⭐ ${student['points']} pts  |  🎯 Precisión Promedio: ${student['accuracy']}%',
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: YachayTheme.textMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ProgressRing(
                    progress: (student['accuracy'] as int) / 100,
                    size: 40,
                    strokeWidth: 4,
                    color: YachayTheme.successGreen,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Avance por materia:',
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: YachayTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),

              // Progress bars
              Row(
                children: [
                  _buildMiniProgress(
                    '🧮 Mat',
                    student['mathProgress'] as double,
                    YachayTheme.mathColor,
                  ),
                  const SizedBox(width: 8),
                  _buildMiniProgress(
                    '🔬 Cie',
                    student['scienceProgress'] as double,
                    YachayTheme.scienceColor,
                  ),
                  const SizedBox(width: 8),
                  _buildMiniProgress(
                    '🌍 Soc',
                    student['socialProgress'] as double,
                    YachayTheme.socialColor,
                  ),
                  const SizedBox(width: 8),
                  _buildMiniProgress(
                    '🗣️ Aym',
                    student['aymaraProgress'] as double,
                    YachayTheme.aymaraColor,
                  ),
                ],
              ),
            ],
          ),
        ).animate(delay: (index * 100).ms).fadeIn(duration: 400.ms).slideY(begin: 0.1);
      },
    );
  }

  Widget _buildMiniProgress(String label, double value, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.bold, color: YachayTheme.textMedium),
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: color.withValues(alpha: 0.1),
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Tab 2: Activity Generator with IA ───
  String _selectedCourse = '3ro Primaria';
  String _selectedSubject = 'science';
  final _themeController = TextEditingController();
  bool _isGenerating = false;
  Map<String, dynamic>? _generatedQuiz;

  Widget _buildGeneratorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: YachayTheme.teacherGradient,
              borderRadius: YachayTheme.radiusMedium,
              boxShadow: YachayTheme.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('✨', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 8),
                    Text(
                      'Creador de Clases con IA',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Ingresa los parámetros y Gemini generará lecciones educativas adaptadas al contexto boliviano de tus alumnos.',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ).animate().scale(duration: 400.ms, curve: Curves.easeOut),

          const SizedBox(height: 20),

          // Course and Subject selectors
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: YachayTheme.radiusSmall,
                    border: Border.all(color: YachayTheme.primaryPurple.withValues(alpha: 0.2), width: 2),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCourse,
                      style: GoogleFonts.nunito(color: YachayTheme.textDark, fontWeight: FontWeight.bold),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCourse = val);
                      },
                      items: ['1ro Primaria', '2do Primaria', '3ro Primaria', '4to Primaria', '5to Primaria']
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: YachayTheme.radiusSmall,
                    border: Border.all(color: YachayTheme.primaryPurple.withValues(alpha: 0.2), width: 2),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedSubject,
                      style: GoogleFonts.nunito(color: YachayTheme.textDark, fontWeight: FontWeight.bold),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedSubject = val);
                      },
                      items: const [
                        DropdownMenuItem(value: 'math', child: Text('🧮 Matemática')),
                        DropdownMenuItem(value: 'science', child: Text('🔬 Ciencias')),
                        DropdownMenuItem(value: 'social', child: Text('🌍 Sociales')),
                        DropdownMenuItem(value: 'aymara', child: Text('🗣️ Aymara')),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Topic Search
          TextField(
            controller: _themeController,
            style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: 'Ej. Fauna del Altiplano, Divisiones con restas...',
              labelText: 'Tema de la Lección',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: YachayTheme.radiusSmall,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Generate button
          GestureDetector(
            onTap: _isGenerating ? null : _generateLesson,
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                gradient: YachayTheme.mathGradient,
                borderRadius: YachayTheme.radiusMedium,
                boxShadow: YachayTheme.getButton3DShadow(YachayTheme.primaryPurpleDark),
              ),
              child: Center(
                child: _isGenerating
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('✨', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 8),
                          Text(
                            'Generar Actividad con IA',
                            style: GoogleFonts.nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Generated Result
          if (_generatedQuiz != null) ...[
            Text(
              'Lección Generada Exitosamente! 🎉',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: YachayTheme.textDark,
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: YachayTheme.radiusMedium,
                border: Border.all(color: YachayTheme.successGreen.withValues(alpha: 0.3), width: 3),
                boxShadow: YachayTheme.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _generatedQuiz!['emoji'] as String,
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _generatedQuiz!['title'] as String,
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: YachayTheme.textDark,
                              ),
                            ),
                            Text(
                              _generatedQuiz!['description'] as String,
                              style: GoogleFonts.nunito(
                                fontSize: 13,
                                color: YachayTheme.textMedium,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),

                  // Display questions
                  ...(_generatedQuiz!['questions'] as List<Map<String, dynamic>>).asMap().entries.map((entry) {
                    final qIdx = entry.key;
                    final q = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pregunta ${qIdx + 1}: ${q['question']}',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: YachayTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 6),
                          ...List.generate((q['options'] as List).length, (oIdx) {
                            final isCorrect = q['options'][oIdx] == q['correctAnswer'];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isCorrect ? YachayTheme.successGreenLight : Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isCorrect ? YachayTheme.successGreen : Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isCorrect ? Icons.check_circle_rounded : Icons.radio_button_off_rounded,
                                    size: 16,
                                    color: isCorrect ? YachayTheme.successGreen : Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    q['options'][oIdx] as String,
                                    style: GoogleFonts.nunito(
                                      fontSize: 13,
                                      fontWeight: isCorrect ? FontWeight.bold : FontWeight.normal,
                                      color: isCorrect ? YachayTheme.successGreen : YachayTheme.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: 4),
                          Text(
                            '💡 Pista: ${q['hint']}',
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              color: YachayTheme.warningOrange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 8),
                  // Assign Button
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Lección asignada exitosamente al Aula de 3° Primaria! 📖⭐'),
                          backgroundColor: YachayTheme.successGreen,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: YachayTheme.successGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(
                      'Asignar a mi Aula',
                      style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ).animate().slideY(begin: 0.2, duration: 400.ms),
          ],
        ],
      ),
    );
  }

  Future<void> _generateLesson() async {
    final topic = _themeController.text.trim();
    if (topic.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingresa el tema de la lección.'),
          backgroundColor: YachayTheme.errorPink,
        ),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
      _generatedQuiz = null;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isGenerating = false;
      _generatedQuiz = {
        'title': 'Lección IA: $topic',
        'description': 'Creado dinámicamente con Gemini 1.5 en base al contexto local',
        'emoji': _selectedSubject == 'math'
            ? '🧮'
            : _selectedSubject == 'science'
                ? '🔬'
                : _selectedSubject == 'social'
                    ? '🌍'
                    : '🗣️',
        'questions': [
          {
            'question': '¿Qué animal del altiplano se relaciona con el tema de $topic?',
            'options': ['La Llama Andina', 'El León Africano', 'El Tucán Amazónico', 'El Oso Polar'],
            'correctAnswer': 'La Llama Andina',
            'hint': 'Es un camélido andino doméstico con pelaje abundante.',
          },
          {
            'question': 'Si aplicamos $topic en la comunidad, ¿qué valor andino promovemos?',
            'options': ['Ayni (Trabajo Recíproco)', 'Individualismo', 'Competencia Desleal', 'Apatía Social'],
            'correctAnswer': 'Ayni (Trabajo Recíproco)',
            'hint': 'Significa ayuda mutua: "hoy por ti, mañana por mí".',
          }
        ],
      };
    });
  }

  // ─── Tab 3: Teacher Assistant Chat ───
  final List<Map<String, dynamic>> _chatHistory = [
    {
      'isUser': false,
      'text': '¡Hola! Soy Yachay, tu asistente docente inteligente. 🤖✨\n\n¿En qué puedo ayudarte hoy? Puedo planificar clases, redactar preguntas, inventar juegos dinámicos o sugerir traducciones al aymara.'
    }
  ];
  final _chatInputController = TextEditingController();

  Widget _buildAssistantTab() {
    return Column(
      children: [
        // Presets suggestions
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildChatPreset('💡 Plan de Clase sobre Plantas'),
              const SizedBox(width: 8),
              _buildChatPreset('📊 Crear Rúbrica de Matemática'),
              const SizedBox(width: 8),
              _buildChatPreset('🗣️ Actividad de Vocabulario Aymara'),
            ],
          ),
        ),

        // Chat Bubble area
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _chatHistory.length,
            itemBuilder: (context, index) {
              final msg = _chatHistory[index];
              final isUser = msg['isUser'] as bool;
              return Align(
                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                  decoration: BoxDecoration(
                    color: isUser ? YachayTheme.primaryPurple : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: isUser ? const Radius.circular(20) : const Radius.circular(4),
                      bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(20),
                    ),
                    boxShadow: YachayTheme.cardShadow,
                    border: Border.all(
                      color: isUser ? Colors.transparent : YachayTheme.primaryPurple.withValues(alpha: 0.15),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    msg['text'] as String,
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isUser ? Colors.white : YachayTheme.textDark,
                      height: 1.4,
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1);
            },
          ),
        ),

        // Chat Input field
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: YachayTheme.backgroundCream,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TextField(
                    controller: _chatInputController,
                    style: GoogleFonts.nunito(fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Pregúntame algo...',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      hintStyle: GoogleFonts.nunito(color: YachayTheme.textLight, fontSize: 15),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _sendChatMessage,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    gradient: YachayTheme.teacherGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatPreset(String title) {
    return GestureDetector(
      onTap: () {
        _chatInputController.text = title;
        _sendChatMessage();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: YachayTheme.primaryPurple.withValues(alpha: 0.15), width: 1.5),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: YachayTheme.primaryPurple,
            ),
          ),
        ),
      ),
    );
  }

  void _sendChatMessage() {
    final txt = _chatInputController.text.trim();
    if (txt.isEmpty) return;

    setState(() {
      _chatHistory.add({'isUser': true, 'text': txt});
      _chatInputController.clear();
    });

    // Mock Response
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        String answer = '';
        if (txt.contains('Plan de Clase')) {
          answer = '📋 **Planificación Didáctica: Las Plantas Alimenticias de Bolivia**\n\n'
              '**1. Objetivos:** Clasificar las plantas de la región según su utilidad alimenticia (papa, quinua, oca).\n\n'
              '**2. Inicio (15m):** Presentación del quirquincho Yachay con dibujos de tubérculos locales. Diálogo sobre lo que desayunan.\n\n'
              '**3. Desarrollo (25m):** Trabajo grupal para identificar qué plantas crecen bajo tierra y cuáles en tallo.\n\n'
              '**4. Cierre (10m):** Simular juego de mercado en clase.';
        } else if (txt.contains('Rúbrica')) {
          answer = '📊 **Rúbrica de Evaluación: Sumas y Restas Contextualizadas (3ro Primaria)**\n\n'
              '- **Excelente (3 pts):** Resuelve correctamente los problemas del mercado de abasto aplicando cálculo mental.\n'
              '- **Aceptable (2 pts):** Resuelve con apoyo gráfico (dibujando monedas o llamitas).\n'
              '- **En Desarrollo (1 pt):** Requiere acompañamiento constante en sumas simples.';
        } else if (txt.contains('Aymara')) {
          answer = '🗣️ **Actividad Vocabulario Aymara: Los Animales (Uywanaka)**\n\n'
              'Organiza un juego de tarjetas de memoria:\n'
              '- **Qawra** (Llama)\n'
              '- **K\'usillo** (Mono)\n'
              '- **Pankatata** (Quirquincho)\n\n'
              'El niño debe pronunciar la palabra y hacer el sonido del animal. ¡Fácil y lúdico!';
        } else {
          answer = 'Entendido, colega. Aquí tienes una sugerencia pedagógica adaptada a tu aula para "$txt":\n\n'
              'Podríamos implementar un juego de roles o utilizar un cuestionario dinámico con Yachay AI para evaluar a los estudiantes. ¿Te gustaría que elabore las preguntas específicas? 📝';
        }
        _chatHistory.add({'isUser': false, 'text': answer});
      });
    });
  }
}
