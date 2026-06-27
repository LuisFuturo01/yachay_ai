import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Service to interact directly with the Google Cloud Firestore NoSQL REST API.
/// This duplicates the database logic from database.py in Dart.
class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  static const String _projectId = 'yachay-ai-core';
  static const String _baseUrl = 'https://firestore.googleapis.com/v1/projects/$_projectId/databases/(default)/documents';

  /// Helper to convert a primitive Dart value into a Firestore REST typed value
  Map<String, dynamic> _toFirestoreValue(dynamic val) {
    if (val is String) {
      return {'stringValue': val};
    } else if (val is int) {
      return {'integerValue': val.toString()};
    } else if (val is bool) {
      return {'booleanValue': val};
    } else if (val is List) {
      return {
        'arrayValue': {
          'values': val.map((item) => _toFirestoreValue(item)).toList()
        }
      };
    } else if (val is DateTime) {
      return {'timestampValue': val.toUtc().toIso8601String()};
    }
    return {'nullValue': null};
  }

  /// Helper to convert a flat Dart Map to a Firestore REST Document fields map
  Map<String, dynamic> _toFirestoreFields(Map<String, dynamic> data) {
    final fields = <String, dynamic>{};
    data.forEach((key, value) {
      fields[key] = _toFirestoreValue(value);
    });
    return {'fields': fields};
  }

  /// Duplicates database.py -> crear_perfil_usuario
  Future<bool> crearPerfilUsuario({
    required String uid,
    required String name,
    required String avatarId,
    int totalPoints = 0,
    List<String> achievements = const [],
  }) async {
    final url = Uri.parse('$_baseUrl/users/$uid');
    
    final bodyData = _toFirestoreFields({
      'uid': uid,
      'name': name,
      'avatarId': avatarId,
      'totalPoints': totalPoints,
      'achievements': achievements,
      'createdAt': DateTime.now(),
      'lastActive': DateTime.now(),
    });

    try {
      // PATCH creates the document if it does not exist, and merges if it does
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        debugPrint('🔥 Perfil creado/sincronizado en Firestore para: $uid');
        return true;
      } else {
        debugPrint('❌ Error Firestore crearPerfilUsuario: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error de red Firestore crearPerfilUsuario: $e');
      return false;
    }
  }

  /// Duplicates database.py -> obtener_o_crear_usuario
  Future<Map<String, dynamic>> obtenerOCrearUsuario({
    required String uid,
    required String name,
    required String avatarId,
  }) async {
    final url = Uri.parse('$_baseUrl/users/$uid');

    try {
      // 1. Check if user document exists in Firestore NoSQL
      final getResponse = await http.get(url);

      if (getResponse.statusCode == 200) {
        // Document exists! Update lastActive field (equivalent to db.update in database.py)
        final patchBody = _toFirestoreFields({
          'lastActive': DateTime.now(),
        });
        
        await http.patch(
          Uri.parse('$url?updateMask.fieldPaths=lastActive'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(patchBody),
        );

        // Parse and return existing user data
        final docData = jsonDecode(getResponse.body) as Map<String, dynamic>;
        final fields = docData['fields'] as Map<String, dynamic>? ?? {};
        
        final existingName = fields['name']?['stringValue'] as String? ?? name;
        final existingAvatarId = fields['avatarId']?['stringValue'] as String? ?? avatarId;
        
        // Parse points (integers in Firestore REST are string representations inside integerValue)
        final pointsStr = fields['totalPoints']?['integerValue'] as String? ?? '0';
        final existingPoints = int.tryParse(pointsStr) ?? 0;
        
        // Parse achievements list
        final achievementsList = <String>[];
        final achievementsArray = fields['achievements']?['arrayValue']?['values'] as List?;
        if (achievementsArray != null) {
          for (final item in achievementsArray) {
            final val = item['stringValue'] as String?;
            if (val != null) achievementsList.add(val);
          }
        }

        // Parse subject progress (from subcollection/local fallback if needed)
        // For simplicity in login, we return the parsed profile details
        debugPrint('🔥 Sesión iniciada para usuario existente: $uid');
        return {
          'estado': 'sesion_iniciada',
          'name': existingName,
          'avatarId': existingAvatarId,
          'totalPoints': existingPoints,
          'achievements': achievementsList,
        };
      } else if (getResponse.statusCode == 404) {
        // Document does not exist! Create initial profile (equivalent to ref.set in database.py)
        final createBody = _toFirestoreFields({
          'uid': uid,
          'name': name,
          'avatarId': avatarId,
          'totalPoints': 0,
          'achievements': <String>[],
          'createdAt': DateTime.now(),
          'lastActive': DateTime.now(),
        });

        final createResponse = await http.patch(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(createBody),
        );

        if (createResponse.statusCode == 200) {
          debugPrint('🔥 Nuevo usuario creado en Firestore: $uid');
          return {'estado': 'creado'};
        }
      }
      
      debugPrint('❌ Error Firestore obtenerOCrearUsuario: ${getResponse.statusCode}');
      return {'estado': 'error'};
    } catch (e) {
      debugPrint('❌ Exception in obtenerOCrearUsuario: $e');
      return {'estado': 'error'};
    }
  }

  /// Duplicates database.py -> actualizar_progreso_materia
  Future<bool> actualizarProgresoMateria({
    required String userId,
    required String subjectId,
    required int currentLevel,
    required int maxLevelReached,
    required int completedLessonsCount,
  }) async {
    final url = Uri.parse('$_baseUrl/users/$userId/progress/$subjectId');
    
    final bodyData = _toFirestoreFields({
      'currentLevel': currentLevel,
      'maxLevelReached': maxLevelReached,
      'completedLessonsCount': completedLessonsCount,
      'lastUpdated': DateTime.now(),
    });

    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        debugPrint('🔥 Progreso ($subjectId) sincronizado en Firestore para: $userId');
        return true;
      } else {
        debugPrint('❌ Error Firestore actualizarProgresoMateria: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error de red Firestore actualizarProgresoMateria: $e');
      return false;
    }
  }

  /// Duplicates database.py -> registrar_sesion_juego
  Future<bool> registrarSesionJuego({
    required String userId,
    required String sessionId,
    required String subjectId,
    required int level,
    required String status,
    required int correctAnswers,
    required int totalQuestions,
    required int pointsEarned,
  }) async {
    final url = Uri.parse('$_baseUrl/users/$userId/sessions/$sessionId');
    
    final bodyData = _toFirestoreFields({
      'subjectId': subjectId,
      'level': level,
      'status': status,
      'correctAnswers': correctAnswers,
      'totalQuestions': totalQuestions,
      'pointsEarned': pointsEarned,
      'startedAt': DateTime.now(),
      'completedAt': DateTime.now(),
    });

    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        debugPrint('🔥 Sesión ($sessionId) registrada en Firestore para: $userId');
        return true;
      } else {
        debugPrint('❌ Error Firestore registrarSesionJuego: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error de red Firestore registrarSesionJuego: $e');
      return false;
    }
  }

  /// Duplicates database.py -> guardar_mensaje_chat
  Future<bool> guardarMensajeChat({
    required String userId,
    required String sessionId,
    required String text,
    required bool isUser,
    required String type,
    String? audioPath,
  }) async {
    final url = Uri.parse('$_baseUrl/users/$userId/sessions/$sessionId/chats');
    
    final bodyData = _toFirestoreFields({
      'text': text,
      'isUser': isUser,
      'type': type,
      'audioPath': audioPath ?? '',
      'timestamp': DateTime.now(),
    });

    try {
      // POST automatically generates a document ID inside the chats subcollection
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        debugPrint('🔥 Mensaje de chat guardado en Firestore. Emisor: ${isUser ? "Usuario" : "Tutor"}');
        return true;
      } else {
        debugPrint('❌ Error Firestore guardarMensajeChat: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error de red Firestore guardarMensajeChat: $e');
      return false;
    }
  }
}
