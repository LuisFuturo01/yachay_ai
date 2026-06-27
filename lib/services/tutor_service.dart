import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

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

  // Gemini API Key from environment configuration
  static const String _geminiApiKey = 'AQ.Ab8RN6IhJh3ZF48KzGAA6_Q-IQG46TPxiKZ7R2jQPr-dFl6X2Q';
  static const String _geminiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

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
      'gemini-1.5-flash',
      'gemini-1.5-flash-latest',
      'gemini-2.0-flash',
    ];

    for (final model in models) {
      final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$_geminiApiKey');
      
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

    final lesson = getLesson(subjectId, level);
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
      final errorDetail = lastApiError != null ? '\n\n($lastApiError)' : '';
      return TutorResponse(
        isCorrect: false,
        message: 'Yachay no pudo responder en este momento. ¡Pruébalo otra vez! 🦙$errorDetail',
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
      return TutorResponse(
        isCorrect: false,
        message: '¡Buen intento! Pero no pudimos procesar la respuesta. Inténtalo de nuevo. 😊',
        type: ResponseType.hint,
      );
    }
  }

  // ─── Get Additional Hint ───

  String getHint(String subjectId, int level, int questionIndex, int hintIndex) {
    final lesson = getLesson(subjectId, level);
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
        'gemini-1.5-flash',
        'gemini-1.5-flash-latest',
        'gemini-2.0-flash',
      ];

      for (final model in models) {
        final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$_geminiApiKey');
        
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
    final lesson = MockAymaraData.getLesson(level);
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
      final errorDetail = lastApiError != null ? '\n\n($lastApiError)' : '';
      return AymaraPronunciationResult(
        precision: 50,
        feedback: 'No pudimos evaluar tu pronunciación. ¡Inténtalo de nuevo! 🦙$errorDetail',
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
        feedback: '¡Buen intento! Pero hubo un problema al evaluar. Inténtalo otra vez. 😊',
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
