import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../data/mock_math_data.dart';
import '../data/mock_science_data.dart';
import '../data/mock_social_data.dart';
import '../data/mock_aymara_data.dart';
import '../models/lesson.dart';
import '../models/yachay_response.dart';
import 'firestore_service.dart';
import 'progress_service.dart';

/// Service abstraction layer for the AI tutor.
/// Performs direct calls to Gemini 1.5 Flash using the Prompt Library.
class TutorService {
  TutorService._();
  static final TutorService instance = TutorService._();

  static String? lastApiError;

  // Gemini API Key fallback from environment configuration
  static const String _geminiApiKey = '';

  // Cache of dynamically generated lessons
  final Map<String, Lesson> _dynamicLessons = {};
  
  // Cache of dynamically generated Aymara lessons
  final Map<int, AymaraLesson> _dynamicAymaraLessons = {};

  // Resolve API Key dynamically from environment
  String get _apiKey {
    try {
      final key = dotenv.env['GEMINI_API_KEY'];
      if (key != null && key.isNotEmpty) return key;
    } catch (_) {}
    return _geminiApiKey;
  }

  // ─── Get Lesson Data ───

  Lesson getLesson(String subjectId, int level) {
    switch (subjectId) {
      case 'math':
        return MockMathData.getLesson(level);
      case 'science':
        return MockScienceData.getLesson(level);
      case 'social':
        return MockSocialData.getLesson(level);
      default:
        return MockMathData.getLesson(level);
    }
  }

  AymaraLesson getAymaraLesson(int level) {
    return MockAymaraData.getLesson(level);
  }

  // ─── Dynamic Lesson Generation with Gemini ───

  Future<Lesson> generateLesson(String subjectId, int level) async {
    final cacheKey = '${subjectId}_$level';
    if (_dynamicLessons.containsKey(cacheKey)) {
      return _dynamicLessons[cacheKey]!;
    }

    final fallbackLesson = getLesson(subjectId, level);

    try {
      final int age = 6 + level;
      final String grade = '${level + 1}ro de Primaria';
      final String theme = fallbackLesson.title;

      final systemPrompt = await _loadPrompt('Prompt_Library/01_System_Prompt/01_System_Prompt.md');
      
      String subjectPrompt = '';
      String jsonPrompt = '';

      if (subjectId == 'math') {
        subjectPrompt = await _loadPrompt('Prompt_Library/02_Matematica/MAT-01_Generacion_Ejercicios.md');
        jsonPrompt = await _loadPrompt('Prompt_Library/06_JSON/JSON-01_Matematica.md');
      } else if (subjectId == 'science') {
        subjectPrompt = await _loadPrompt('Prompt_Library/04_Ciencias_Naturales/NAT-01_Generacion_Ejercicios.md');
        jsonPrompt = await _loadPrompt('Prompt_Library/06_JSON/JSON-03_Ciencias_Naturales.md');
      } else if (subjectId == 'social') {
        subjectPrompt = await _loadPrompt('Prompt_Library/05_Cs_Sociales/SOC-01_Generacion_Ejercicios.md');
        jsonPrompt = await _loadPrompt('Prompt_Library/06_JSON/JSON-04_Ciencias_Sociales.md');
      }

      final instruccionCompleta = """
$systemPrompt

REGLAS DE TAREA ESPECÍFICAS:
$subjectPrompt

REGLAS DE FORMATO JSON:
$jsonPrompt

ADVERTENCIA IMPORTANTE PARA GENERACIÓN DE SESIÓN COMPLETA:
Debes generar una lección completa que consta de exactamente 3 preguntas diferentes basadas en el tema especificado.
Debes responder con un único objeto JSON que contenga los siguientes campos en la raíz:
{
  "tipo": "ejercicio",
  "titulo": "Título de la Lección (adecuado para niños)",
  "mensaje": "Mensaje motivador de bienvenida de Yachay para el niño",
  "preguntas": [
    {
      "enunciado": "Enunciado amigable de la Pregunta 1 con contexto boliviano.",
      "opciones": ["Opción A", "Opción B", "Opción C", "Opción D"],
      "respuesta_correcta": "La opción correcta exacta (debe coincidir textualmente con una de las opciones)",
      "pistas": [
        "Pista 1 amigable...",
        "Pista 2 progresiva..."
      ],
      "explicacion": "Breve explicación de por qué es la correcta."
    },
    {
      "enunciado": "Enunciado amigable de la Pregunta 2 con contexto boliviano.",
      "opciones": ["Opción A", "Opción B", "Opción C", "Opción D"],
      "respuesta_correcta": "La opción correcta exacta (debe coincidir textualmente con una de las opciones)",
      "pistas": [
        "Pista 1 amigable...",
        "Pista 2 progresiva..."
      ],
      "explicacion": "Breve explicación de por qué es la correcta."
    },
    {
      "enunciado": "Enunciado amigable de la Pregunta 3 con contexto boliviano.",
      "opciones": ["Opción A", "Opción B", "Opción C", "Opción D"],
      "respuesta_correcta": "La opción correcta exacta (debe coincidir textualmente con una de las opciones)",
      "pistas": [
        "Pista 1 amigable...",
        "Pista 2 progresiva..."
      ],
      "explicacion": "Breve explicación de por qué es la correcta."
    }
  ],
  "metadata": {
    "tema": "$theme",
    "nivel": "${level < 2 ? 'Básico' : (level < 4 ? 'Intermedio' : 'Avanzado')}",
    "emoji": "${fallbackLesson.emoji}",
    "puntos": ${fallbackLesson.pointsReward}
  }
}
Responde únicamente con el JSON crudo, sin markdown, bloques de código, ni texto adicional.
""";

      final promptText = jsonEncode({
        'edad': '$age años',
        'grado': grade,
        'materia': subjectId == 'math' ? 'Matemática' : (subjectId == 'science' ? 'Ciencias Naturales' : 'Ciencias Sociales'),
        'tema': theme,
        'nivel': level < 2 ? 'Básico' : (level < 4 ? 'Intermedio' : 'Avanzado'),
      });

      final responseMap = await _callGemini(
        instruction: instruccionCompleta,
        prompt: promptText,
      );

      if (responseMap != null && responseMap.containsKey('preguntas')) {
        final lesson = Lesson.fromGeminiJson(responseMap, subjectId, level);
        _dynamicLessons[cacheKey] = lesson;
        debugPrint('🎉 Dynamic lesson successfully generated for $cacheKey!');
        return lesson;
      } else {
        debugPrint('⚠️ Response from Gemini was not in standard list format, trying fallback.');
      }
    } catch (e) {
      debugPrint('❌ Error generating dynamic lesson: $e');
    }

    // Fallback to static mock lesson
    return fallbackLesson;
  }

  Future<AymaraLesson> generateAymaraLesson(int level) async {
    if (_dynamicAymaraLessons.containsKey(level)) {
      return _dynamicAymaraLessons[level]!;
    }

    final fallbackLesson = MockAymaraData.getLesson(level);

    try {
      final String category = fallbackLesson.title.split('(').last.replaceAll(')', '');
      final String levelName = level < 2 ? 'Básico' : (level < 4 ? 'Intermedio' : 'Avanzado');
      
      final systemPrompt = await _loadPrompt('Prompt_Library/01_System_Prompt/01_System_Prompt.md');
      final aymaraPrompt = await _loadPrompt('Prompt_Library/03_Aymara/AYM-01_Generacion_Audios.md');
      final jsonPrompt = await _loadPrompt('Prompt_Library/06_JSON/JSON-02_Aymara.md');

      final instruccionCompleta = """
$systemPrompt

REGLAS DE TAREA ESPECÍFICAS:
$aymaraPrompt

REGLAS DE FORMATO JSON:
$jsonPrompt

ADVERTENCIA IMPORTANTE PARA GENERACIÓN DE SESIÓN COMPLETA:
Debes generar una lección completa de Aymara que consta de exactamente 4 palabras/frases diferentes de la categoría solicitada.
Debes responder con un único objeto JSON que contenga los siguientes campos en la raíz:
{
  "titulo": "Título de la lección de Aymara",
  "mensaje": "Mensaje de bienvenida",
  "palabras": [
    {
      "palabra": "Palabra o frase en Aymara (ej. Kamisaki)",
      "significado": "Significado en Español (ej. ¿Cómo estás?)",
      "guia_pronunciacion": "Guía silábica de pronunciación (ej. ka-mi-SA-ki)",
      "contexto": "Breve explicación de cuándo se usa",
      "emoji": "Emoji descriptivo",
      "texto_audio": "Texto exacto en Aymara simplificado para que la síntesis de voz (TTS) española lo lea lo más cercano posible al Aymara real (ej. kamisaki)"
    },
    {
      "palabra": "Segunda palabra o frase en Aymara",
      "significado": "Significado en Español",
      "guia_pronunciacion": "Guía silábica de pronunciación",
      "contexto": "Breve explicación de cuándo se usa",
      "emoji": "Emoji descriptivo",
      "texto_audio": "Texto exacto para síntesis de voz"
    },
    {
      "palabra": "Tercera palabra o frase en Aymara",
      "significado": "Significado en Español",
      "guia_pronunciacion": "Guía silábica de pronunciación",
      "contexto": "Breve explicación de cuándo se usa",
      "emoji": "Emoji descriptivo",
      "texto_audio": "Texto exacto para síntesis de voz"
    },
    {
      "palabra": "Cuarta palabra o frase en Aymara",
      "significado": "Significado en Español",
      "guia_pronunciacion": "Guía silábica de pronunciación",
      "contexto": "Breve explicación de cuándo se usa",
      "emoji": "Emoji descriptivo",
      "texto_audio": "Texto exacto para síntesis de voz"
    }
  ],
  "metadata": {
    "categoria": "$category",
    "nivel": "$levelName",
    "emoji": "${fallbackLesson.emoji}",
    "puntos": ${fallbackLesson.pointsReward}
  }
}
Responde únicamente con el JSON crudo, sin markdown, bloques de código, ni texto adicional.
""";

      final promptText = jsonEncode({
        'edad': '${6 + level} años',
        'nivel': levelName,
        'categoria': category,
      });

      final responseMap = await _callGemini(
        instruction: instruccionCompleta,
        prompt: promptText,
      );

      if (responseMap != null && responseMap.containsKey('palabras')) {
        final lesson = AymaraLesson.fromGeminiJson(responseMap, level);
        _dynamicAymaraLessons[level] = lesson;
        debugPrint('🎉 Dynamic Aymara lesson successfully generated for level $level!');
        return lesson;
      } else {
        debugPrint('⚠️ Response from Gemini was not in standard Aymara list format, trying fallback.');
      }
    } catch (e) {
      debugPrint('❌ Error generating dynamic Aymara lesson: $e');
    }

    // Fallback to static mock lesson
    return fallbackLesson;
  }

  // ─── Get Total Levels ───

  int getTotalLevels(String subjectId) {
    switch (subjectId) {
      case 'math':
        return MockMathData.totalLevels;
      case 'science':
        return MockScienceData.totalLevels;
      case 'social':
        return MockSocialData.totalLevels;
      case 'aymara':
        return MockAymaraData.totalLevels;
      default:
        return 5;
    }
  }

  // ─── Prompt Loader Helper ───

  Future<String> _loadPrompt(String path) async {
    try {
      return await rootBundle.loadString(path);
    } catch (e) {
      debugPrint('⚠️ Warning: Failed to load prompt asset at $path: $e');
      return '';
    }
  }

  // ─── Gemini API REST Call Helper ───

  Future<Map<String, dynamic>?> _callGemini({
    required String instruction,
    required String prompt,
  }) async {
    // List of models to try in case of model-not-found or regional restrictions
    final models = [
      'gemini-3.5-flash',
      'gemini-2.0-flash',
      'gemini-2.0-flash-lite',
      'gemini-1.5-flash',
      'gemini-2.5-flash-preview-05-20',
    ];

    for (final model in models) {
      final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$_apiKey');
      
      final payload = {
        'system_instruction': {
          'parts': [{'text': instruction}]
        },
        'contents': [
          {
            'parts': [{'text': prompt}]
          }
        ],
        'generationConfig': {
          'temperature': 0.3,
          'responseMimeType': 'application/json'
        }
      };

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        );

        if (response.statusCode == 200) {
          lastApiError = null; // Clear errors
          final decoded = jsonDecode(response.body) as Map<String, dynamic>;
          
          final candidates = decoded['candidates'] as List?;
          if (candidates != null && candidates.isNotEmpty) {
            final content = candidates[0]['content'] as Map?;
            if (content != null) {
              final parts = content['parts'] as List?;
              if (parts != null && parts.isNotEmpty) {
                final text = parts[0]['text'] as String?;
                if (text != null) {
                  debugPrint('🎉 Exitoso con el modelo: $model');
                  return jsonDecode(text.trim()) as Map<String, dynamic>;
                }
              }
            }
          }
        } else {
          lastApiError = 'HTTP ${response.statusCode}: ${response.body}';
          debugPrint('⚠️ Intento fallido con modelo $model: $lastApiError');
          
          // If it is a model not found or method not supported error, try the next model in the list
          if (response.body.contains('not found') || response.body.contains('not supported')) {
            continue;
          }
          // If it is an authentication or quota error, stop retrying
          return null;
        }
      } catch (e) {
        lastApiError = 'Excepción de red: $e';
        debugPrint('❌ Exception in Gemini API call for model $model: $e');
        return null;
      }
    }
    return null;
  }

  // ─── Evaluate Answer (Real Gemini REST Call) ───

  Future<TutorResponse> evaluateAnswer({
    required String subjectId,
    required int level,
    required int questionIndex,
    required String userAnswer,
  }) async {
    // 1. Load prompts asynchronously from the local asset bundle
    final systemPrompt = await _loadPrompt('Prompt_Library/01_System_Prompt/01_System_Prompt.md');
    
    String subjectPrompt = '';
    String jsonPrompt = '';

    if (subjectId == 'math') {
      subjectPrompt = await _loadPrompt('Prompt_Library/02_Matematica/MAT-02_Correccion_Inteligente.md');
      jsonPrompt = await _loadPrompt('Prompt_Library/06_JSON/JSON-01_Matematica.md');
    } else if (subjectId == 'science') {
      subjectPrompt = await _loadPrompt('Prompt_Library/04_Ciencias_Naturales/NAT-02_Correccion_Inteligente.md');
      jsonPrompt = await _loadPrompt('Prompt_Library/06_JSON/JSON-03_Ciencias_Naturales.md');
    } else if (subjectId == 'social') {
      subjectPrompt = await _loadPrompt('Prompt_Library/05_Cs_Sociales/SOC-02_Correccion_Inteligente.md');
      jsonPrompt = await _loadPrompt('Prompt_Library/06_JSON/JSON-04_Ciencias_Sociales.md');
    }

    final instruccionCompleta = """
--- IDENTIDAD Y REGLAS MAESTRAS ---
$systemPrompt
--- REGLAS ESPECÍFICAS DE LA TAREA ---
$subjectPrompt
--- ESTRUCTURA DE RESPUESTA OBLIGATORIA ---
$jsonPrompt
""";

    final lesson = _dynamicLessons['${subjectId}_$level'] ?? getLesson(subjectId, level);
    final questionText = lesson.questions[questionIndex].question;
    final expectedAnswer = lesson.questions[questionIndex].correctAnswer;

    final profile = ProgressService.instance.currentProfile;
    final preguntaArmada = jsonEncode({
      'userId': profile?.uid ?? 'estudiante_demo',
      'sessionId': 'sess_${subjectId}_L$level',
      'mensaje': 'Ejercicio: $questionText. Respuesta del estudiante: $userAnswer. (Respuesta esperada: $expectedAnswer)',
      'materia': subjectId,
      'nivel': 'Nivel ${level + 1}',
    });

    // 2. Query Gemini
    final responseMap = await _callGemini(
      instruction: instruccionCompleta,
      prompt: preguntaArmada,
    );

    if (responseMap == null) {
      return const TutorResponse(
        isCorrect: false,
        message: 'Yachay no puede responder en este momento. Conexión a internet lenta, ¡inténtalo de nuevo! 🦙',
        type: ResponseType.hint,
      );
    }

    // 3. Process, Save to Firestore and return feedback
    try {
      final parsedResponse = YachayResponse.fromJson(responseMap);
      final content = parsedResponse.contenido;
      
      final correctoVal = content['correcto'];
      final bool isAnswerCorrect = (correctoVal == true || correctoVal.toString().toLowerCase() == 'true');

      // Sync chat message history to Firestore under the current student profile
      final profile = ProgressService.instance.currentProfile;
      if (profile != null) {
        final sessionId = 'sess_${subjectId}_L$level';
        
        // Log user answer
        FirestoreService.instance.guardarMensajeChat(
          userId: profile.uid,
          sessionId: sessionId,
          text: userAnswer,
          isUser: true,
          type: 'normal',
        );

        // Log tutor response
        FirestoreService.instance.guardarMensajeChat(
          userId: profile.uid,
          sessionId: sessionId,
          text: parsedResponse.mensaje,
          isUser: false,
          type: isAnswerCorrect ? 'correct' : 'hint',
        );
      }

      return TutorResponse(
        isCorrect: isAnswerCorrect,
        message: parsedResponse.mensaje,
        type: isAnswerCorrect ? ResponseType.correct : ResponseType.hint,
        hintsRemaining: isAnswerCorrect ? 0 : 1,
      );

    } catch (e) {
      debugPrint('❌ Error parsing Socratic JSON response: $e');
      return const TutorResponse(
        isCorrect: false,
        message: 'Conexión a internet lenta, ¡inténtalo de nuevo! 🦙',
        type: ResponseType.hint,
      );
    }
  }

  // ─── Get Additional Hint ───

  String getHint(String subjectId, int level, int questionIndex, int hintIndex) {
    final lesson = _dynamicLessons['${subjectId}_$level'] ?? getLesson(subjectId, level);
    if (questionIndex >= lesson.questions.length) return 'No hay más pistas.';
    
    final hints = lesson.questions[questionIndex].hints;
    if (hintIndex >= hints.length) {
      return '💡 Pista final: La respuesta correcta es "${lesson.questions[questionIndex].correctAnswer}"';
    }
    return '💡 ${hints[hintIndex]}';
  }

  // ─── Audio Transcription Helper (Fast Gemini Call) ───

  Future<String> _transcribeAudio(String audioPath, String targetWord) async {
    try {
      final file = File(audioPath);
      
      // Wait up to 500ms for the OS to finish flushing the WAV file to disk
      int attempts = 0;
      while (attempts < 5 && (!await file.exists() || await file.length() == 0)) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }

      if (!await file.exists()) {
        debugPrint('⚠️ Audio file for transcription does not exist at $audioPath');
        return '';
      }

      final bytes = await file.readAsBytes();
      final fileLength = bytes.length;
      debugPrint('🎙️ Reading audio file for transcription: $audioPath ($fileLength bytes)');

      if (fileLength == 0) {
        debugPrint('⚠️ Audio file is empty (0 bytes)');
        return '';
      }

      final base64Audio = base64Encode(bytes);

      // List of models to try in case of model-not-found or regional restrictions
      final models = [
        'gemini-3.5-flash',
        'gemini-2.0-flash',
        'gemini-2.0-flash-lite',
        'gemini-2.5-flash-preview-05-20',
      ];

      for (final model in models) {
        final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$_apiKey');
        
        final payload = {
          'contents': [
            {
              'parts': [
                {
                  'text': 'You are a precise speech-to-text transcriber for children speaking Aymara. The child is trying to pronounce the target word "$targetWord". Listen to the audio and transcribe what they actually pronounced exactly as they said it. Do not correct their pronunciation or spelling. Do not add any punctuation, conversational text, notes, greetings, explanations or markdown formatting. Output only the plain transcribed words. If the audio is silent or unintelligible, reply with the word "$targetWord".'
                },
                {
                  'inlineData': {
                    'mimeType': 'audio/wav',
                    'data': base64Audio
                  }
                }
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.1,
          }
        };

        try {
          final response = await http.post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          );

          debugPrint('🎙️ Gemini STT Response Status ($model): ${response.statusCode}');
          debugPrint('🎙️ Gemini STT Response Body ($model): ${response.body}');

          if (response.statusCode == 200) {
            final decoded = jsonDecode(response.body) as Map<String, dynamic>;
            final candidates = decoded['candidates'] as List?;
            if (candidates != null && candidates.isNotEmpty) {
              final content = candidates[0]['content'] as Map?;
              if (content != null) {
                final parts = content['parts'] as List?;
                if (parts != null && parts.isNotEmpty) {
                  final text = parts[0]['text'] as String?;
                  if (text != null) {
                    final transcription = text.trim();
                    debugPrint('🎙️ Gemini Audio Transcription (WAV) for "$targetWord": "$transcription"');
                    return transcription;
                  }
                }
              }
            }
          } else {
            debugPrint('⚠️ Transcription failed with model $model: HTTP ${response.statusCode}');
          }
        } catch (e) {
          debugPrint('❌ Network error during transcription with model $model: $e');
        }
      }
    } catch (e) {
      debugPrint('❌ Exception in _transcribeAudio: $e');
    }
    return '';
  }

  // ─── Evaluate Aymara Pronunciation (Text-Only Gemini REST Call) ───

  Future<AymaraPronunciationResult> evaluatePronunciation({
    required int level,
    required int wordIndex,
    String? audioPath,
  }) async {
    final lesson = _dynamicAymaraLessons[level] ?? getAymaraLesson(level);
    final targetWord = lesson.words[wordIndex].word;
    final pronunciationGuide = lesson.words[wordIndex].pronunciationGuide;

    // 1. Transcribe the audio file if path is provided (converting audio to text inside .dart)
    String transcribedText = '';
    if (audioPath != null) {
      transcribedText = await _transcribeAudio(audioPath, targetWord);
    }

    // If transcription returned nothing or failed, report immediately
    if (transcribedText.trim().isEmpty) {
      return const AymaraPronunciationResult(
        precision: 0,
        feedback: 'No pudimos escuchar con claridad tu pronunciación. Asegúrate de estar en un lugar silencioso, hablar claro y volver a intentar. 🎤',
        isGood: false,
      );
    }

    // 2. Load Prompts
    final systemPrompt = await _loadPrompt('Prompt_Library/01_System_Prompt/01_System_Prompt.md');
    final aymaraPrompt = await _loadPrompt('Prompt_Library/03_Aymara/AYM-02_Evaluacion_Fonetica.md');
    final jsonPrompt = await _loadPrompt('Prompt_Library/06_JSON/JSON-02_Aymara.md');

    final instruccionCompleta = """
--- IDENTIDAD Y REGLAS MAESTRAS ---
$systemPrompt
--- REGLAS ESPECÍFICAS DE LA TAREA ---
$aymaraPrompt
--- ESTRUCTURA DE RESPUESTA OBLIGATORIA ---
$jsonPrompt
""";
    
    final profile = ProgressService.instance.currentProfile;
    final promptText = jsonEncode({
      'userId': profile?.uid ?? 'estudiante_demo',
      'sessionId': 'sess_aymara_L$level',
      'mensaje': 'Palabra objetivo en Aymara: $targetWord. Guía de pronunciación: $pronunciationGuide. El niño pronunció: "$transcribedText". Evalúa si la pronunciación es correcta.',
      'materia': 'aymara',
      'nivel': 'Nivel ${level + 1}',
    });

    // 3. Query Gemini (text only, no audio)
    final responseMap = await _callGemini(
      instruction: instruccionCompleta,
      prompt: promptText,
    );

    if (responseMap == null) {
      return const AymaraPronunciationResult(
        precision: 50,
        feedback: 'Conexión a internet lenta, ¡inténtalo de nuevo! 🦙',
        isGood: false,
      );
    }

    // 4. Parse response and log
    try {
      final parsedResponse = YachayResponse.fromJson(responseMap);
      final content = parsedResponse.contenido;
      
      final precisionVal = content['precision_porcentaje'];
      final int precision = (precisionVal is num) ? precisionVal.toInt() : 0;
      final isGood = precision >= 70;
      
      final transcription = content['transcripcion_detectada'] as String? ?? '';
      final observations = content['observaciones_foneticas'] as String? ?? '';

      // Sync chat message history to Firestore
      final profile = ProgressService.instance.currentProfile;
      if (profile != null) {
        final sessionId = 'sess_aymara_L$level';
        
        // Log user audio reference
        FirestoreService.instance.guardarMensajeChat(
          userId: profile.uid,
          sessionId: sessionId,
          text: '[Grabación de voz: $targetWord]',
          isUser: true,
          type: 'normal',
          audioPath: audioPath,
        );

        // Log tutor pronunciation feedback
        FirestoreService.instance.guardarMensajeChat(
          userId: profile.uid,
          sessionId: sessionId,
          text: '${parsedResponse.mensaje} Transcripción detectada: "$transcription". $observations',
          isUser: false,
          type: isGood ? 'correct' : 'hint',
        );
      }

      return AymaraPronunciationResult(
        precision: precision,
        feedback: '${parsedResponse.mensaje} Transcripción: "$transcription". $observations',
        isGood: isGood,
      );

    } catch (e) {
      debugPrint('❌ Error parsing Aymara Socratic response: $e');
      return const AymaraPronunciationResult(
        precision: 60,
        feedback: 'Conexión a internet lenta, ¡inténtalo de nuevo! 🦙',
        isGood: false,
      );
    }
  }

  // ─── Helpers ───

  String _normalizeAnswer(String answer) {
    return answer.trim().toLowerCase().replaceAll(RegExp(r'[^\w\sáéíóúñü]'), '');
  }
}

// ─── Response Models ───

enum ResponseType { correct, hint, incorrect, lessonComplete }

class TutorResponse {
  final bool isCorrect;
  final String message;
  final ResponseType type;
  final int hintsRemaining;

  const TutorResponse({
    required this.isCorrect,
    required this.message,
    required this.type,
    this.hintsRemaining = 0,
  });
}

class AymaraPronunciationResult {
  final int precision;
  final String feedback;
  final bool isGood;

  const AymaraPronunciationResult({
    required this.precision,
    required this.feedback,
    required this.isGood,
  });
}
