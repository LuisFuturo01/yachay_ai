/// Mock Aymara language practice data.
/// Replace with API/Gemini voice analysis when backend is ready.

class AymaraWord {
  final String word;
  final String translation;
  final String pronunciationGuide;
  final String context;
  final String emoji;
  /// Phonetic hint for TTS engine — spelled so Spanish TTS reads it
  /// as close to real Aymara pronunciation as possible.
  /// Falls back to [word] if null.
  final String? ttsHint;

  const AymaraWord({
    required this.word,
    required this.translation,
    required this.pronunciationGuide,
    required this.context,
    this.emoji = '🗣️',
    this.ttsHint,
  });

  factory AymaraWord.fromGeminiJson(Map<String, dynamic> json) {
    final contenido = json['contenido'] as Map<String, dynamic>? ?? json;
    return AymaraWord(
      word: (contenido['palabra'] ?? '').toString(),
      translation: (contenido['significado'] ?? contenido['traduccion'] ?? '').toString(),
      pronunciationGuide: (contenido['guia_pronunciacion'] ?? contenido['pronunciacion'] ?? contenido['instruccion'] ?? '').toString(),
      context: (contenido['contexto'] ?? contenido['context'] ?? contenido['categoria'] ?? 'Vocabulario').toString(),
      emoji: (contenido['emoji'] ?? '🗣️').toString(),
      ttsHint: (contenido['texto_audio'] ?? contenido['tts_hint'] ?? contenido['palabra'] ?? '').toString(),
    );
  }
}

class AymaraLesson {
  final String id;
  final int level;
  final String title;
  final String description;
  final String emoji;
  final List<AymaraWord> words;
  final int pointsReward;

  const AymaraLesson({
    required this.id,
    required this.level,
    required this.title,
    required this.description,
    required this.emoji,
    required this.words,
    this.pointsReward = 50,
  });

  factory AymaraLesson.fromGeminiJson(Map<String, dynamic> json, int level) {
    final wordsList = <AymaraWord>[];
    
    if (json['palabras'] != null) {
      final list = json['palabras'] as List;
      for (final item in list) {
        if (item is Map<String, dynamic>) {
          wordsList.add(AymaraWord.fromGeminiJson(item));
        }
      }
    } else {
      // Fallback: single word parsed from root/contenido
      wordsList.add(AymaraWord.fromGeminiJson(json));
    }

    return AymaraLesson(
      id: 'aymara_${level}_dynamic',
      level: level,
      title: json['titulo'] as String? ?? 'Aymara Dinámico',
      description: json['mensaje'] as String? ?? '¡Vamos a pronunciar!',
      emoji: json['metadata']?['emoji'] as String? ?? '🗣️',
      words: wordsList,
      pointsReward: (json['metadata']?['puntos'] as num?)?.toInt() ?? 50,
    );
  }
}

class MockAymaraData {
  MockAymaraData._();

  static const List<AymaraLesson> lessons = [
    // ─── Nivel 1: Saludos ───
    AymaraLesson(
      id: 'aymara_1',
      level: 0,
      title: 'Jisk\'a Aruskipawi (Saludos)',
      description: '¡Aprende a saludar en Aymara!',
      emoji: '👋',
      pointsReward: 50,
      words: [
        AymaraWord(
          word: 'Kamisaki',
          translation: '¿Cómo estás?',
          pronunciationGuide: 'ka-mi-SA-ki',
          context: 'Se usa para saludar a alguien, como un "hola, ¿cómo estás?"',
          emoji: '👋',
          ttsHint: 'kamisaki',
        ),
        AymaraWord(
          word: 'Waliki',
          translation: 'Estoy bien',
          pronunciationGuide: 'wa-LI-ki',
          context: 'Es la respuesta cuando alguien te dice "Kamisaki"',
          emoji: '😊',
          ttsHint: 'waliki',
        ),
        AymaraWord(
          word: 'Jallalla',
          translation: '¡Viva! / ¡Que viva!',
          pronunciationGuide: 'ja-LLA-lla',
          context: 'Se usa para celebrar algo. ¡Como gritar de alegría!',
          emoji: '🎉',
          ttsHint: 'jayaya',
        ),
        AymaraWord(
          word: 'Jikisiñkama',
          translation: 'Hasta luego',
          pronunciationGuide: 'ji-ki-SI-ña-ka-ma',
          context: 'Se usa para despedirse de alguien',
          emoji: '👋',
          ttsHint: 'jikisiniakama',
        ),
      ],
    ),

    // ─── Nivel 2: Números ───
    AymaraLesson(
      id: 'aymara_2',
      level: 1,
      title: 'Jakhu (Números)',
      description: 'Cuenta del 1 al 10 en Aymara.',
      emoji: '🔢',
      pointsReward: 60,
      words: [
        AymaraWord(
          word: 'Maya',
          translation: 'Uno (1)',
          pronunciationGuide: 'MA-ya',
          context: 'El número 1. Maya es también "primero"',
          emoji: '1️⃣',
          ttsHint: 'maya',
        ),
        AymaraWord(
          word: 'Paya',
          translation: 'Dos (2)',
          pronunciationGuide: 'PA-ya',
          context: 'El número 2. Paya manos = dos manos',
          emoji: '2️⃣',
          ttsHint: 'paya',
        ),
        AymaraWord(
          word: 'Kimsa',
          translation: 'Tres (3)',
          pronunciationGuide: 'KIM-sa',
          context: 'El número 3',
          emoji: '3️⃣',
          ttsHint: 'kimsa',
        ),
        AymaraWord(
          word: 'Pusi',
          translation: 'Cuatro (4)',
          pronunciationGuide: 'PU-si',
          context: 'El número 4',
          emoji: '4️⃣',
          ttsHint: 'pusi',
        ),
        AymaraWord(
          word: 'Phisqa',
          translation: 'Cinco (5)',
          pronunciationGuide: 'PHIS-qa',
          context: 'El número 5. Como los dedos de una mano',
          emoji: '5️⃣',
          ttsHint: 'piska',
        ),
      ],
    ),

    // ─── Nivel 3: Colores ───
    AymaraLesson(
      id: 'aymara_3',
      level: 2,
      title: 'Samiri (Colores)',
      description: 'Los colores del mundo en Aymara.',
      emoji: '🌈',
      pointsReward: 80,
      words: [
        AymaraWord(
          word: 'Chupika',
          translation: 'Rojo',
          pronunciationGuide: 'chu-PI-ka',
          context: 'Rojo como la bandera de Bolivia',
          emoji: '🔴',
          ttsHint: 'chupika',
        ),
        AymaraWord(
          word: 'Qillu',
          translation: 'Amarillo',
          pronunciationGuide: 'QI-llu',
          context: 'Amarillo como el sol del altiplano',
          emoji: '🟡',
          ttsHint: 'kiyu',
        ),
        AymaraWord(
          word: 'Ch\'uxña',
          translation: 'Verde',
          pronunciationGuide: 'CHUJ-ña',
          context: 'Verde como las plantas de los Yungas',
          emoji: '🟢',
          ttsHint: 'chujnia',
        ),
        AymaraWord(
          word: 'Larama',
          translation: 'Azul',
          pronunciationGuide: 'la-RA-ma',
          context: 'Azul como el cielo de La Paz',
          emoji: '🔵',
          ttsHint: 'larama',
        ),
      ],
    ),

    // ─── Nivel 4: Animales ───
    AymaraLesson(
      id: 'aymara_4',
      level: 3,
      title: 'Uywa (Animales)',
      description: 'Nombra a los animales en Aymara.',
      emoji: '🦙',
      pointsReward: 100,
      words: [
        AymaraWord(
          word: 'Qawra',
          translation: 'Llama',
          pronunciationGuide: 'QAW-ra',
          context: 'La llama, el animal más querido del altiplano',
          emoji: '🦙',
          ttsHint: 'kaura',
        ),
        AymaraWord(
          word: 'Kunturi',
          translation: 'Cóndor',
          pronunciationGuide: 'kun-TU-ri',
          context: 'El cóndor, el ave que vuela más alto',
          emoji: '🦅',
          ttsHint: 'kunturi',
        ),
        AymaraWord(
          word: 'Anu',
          translation: 'Perro',
          pronunciationGuide: 'A-nu',
          context: 'El perro, el mejor amigo del ser humano',
          emoji: '🐕',
          ttsHint: 'anu',
        ),
        AymaraWord(
          word: 'Phisi',
          translation: 'Gato',
          pronunciationGuide: 'PHI-si',
          context: 'El gato, compañero silencioso del hogar',
          emoji: '🐈',
          ttsHint: 'pisi',
        ),
      ],
    ),

    // ─── Nivel 5: Frases básicas ───
    AymaraLesson(
      id: 'aymara_5',
      level: 4,
      title: 'Aruskipawi (Frases)',
      description: '¡Forma oraciones completas en Aymara!',
      emoji: '💬',
      pointsReward: 120,
      words: [
        AymaraWord(
          word: 'Nayax waliktwa',
          translation: 'Yo estoy bien',
          pronunciationGuide: 'NA-yaj wa-LIK-twa',
          context: 'Para decir que te sientes bien',
          emoji: '😊',
          ttsHint: 'nayaj waliktua',
        ),
        AymaraWord(
          word: 'Jumax kamisaki',
          translation: '¿Y tú cómo estás?',
          pronunciationGuide: 'JU-maj ka-mi-SA-ki',
          context: 'Para preguntar cómo está otra persona',
          emoji: '🤗',
          ttsHint: 'jumaj kamisaki',
        ),
        AymaraWord(
          word: 'Yuspajara',
          translation: 'Gracias',
          pronunciationGuide: 'yus-pa-JA-ra',
          context: 'Para agradecer a alguien',
          emoji: '🙏',
          ttsHint: 'yuspajara',
        ),
        AymaraWord(
          word: 'Janiw yatkti',
          translation: 'No sé',
          pronunciationGuide: 'JA-niw YAT-kti',
          context: 'Cuando no sabes algo. ¡Pero pronto lo aprenderás!',
          emoji: '🤔',
          ttsHint: 'janiu yatkti',
        ),
      ],
    ),
  ];

  static AymaraLesson getLesson(int level) {
    if (level < 0 || level >= lessons.length) return lessons.first;
    return lessons[level];
  }

  static int get totalLevels => lessons.length;
}
