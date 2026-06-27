import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import 'firestore_service.dart';

/// Service for saving/loading user progress locally.
/// Replace SharedPreferences with Firebase when backend is ready.

class ProgressService {
  static const String _profileKey = 'user_profile';
  static ProgressService? _instance;
  UserProfile? _currentProfile;

  ProgressService._();

  static ProgressService get instance {
    _instance ??= ProgressService._();
    return _instance!;
  }

  UserProfile? get currentProfile => _currentProfile;
  bool get hasProfile => _currentProfile != null;

  // ─── Load / Save ───

  Future<UserProfile?> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_profileKey);
    if (jsonString != null) {
      _currentProfile = UserProfile.fromJsonString(jsonString);
    }
    return _currentProfile;
  }

  Future<void> saveProfile(UserProfile profile) async {
    _currentProfile = profile;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, profile.toJsonString());
    
    // Background sync to Firestore root /users/{uid}
    FirestoreService.instance.crearPerfilUsuario(
      uid: profile.uid,
      name: profile.name,
      avatarId: profile.avatarId,
      totalPoints: profile.totalPoints,
      achievements: profile.achievements,
    );
  }

  Future<void> createProfile(String name, String avatarId) async {
    final uid = 'user_${DateTime.now().millisecondsSinceEpoch}';
    final profile = UserProfile(uid: uid, name: name, avatarId: avatarId);
    await saveProfile(profile);
  }

  // ─── Progress Updates ───

  Future<void> completeLevel(String subjectId, int pointsEarned) async {
    if (_currentProfile == null) return;
    _currentProfile!.advanceLevel(subjectId);
    _currentProfile!.addPoints(pointsEarned);
    await saveProfile(_currentProfile!);

    // Sync subject level progress to Firestore subcollection /users/{uid}/progress/{subjectId}
    final currentLevel = _currentProfile!.getProgress(subjectId);
    FirestoreService.instance.actualizarProgresoMateria(
      userId: _currentProfile!.uid,
      subjectId: subjectId,
      currentLevel: currentLevel,
      maxLevelReached: currentLevel,
      completedLessonsCount: currentLevel,
    );
  }

  Future<void> addPoints(int points) async {
    if (_currentProfile == null) return;
    _currentProfile!.addPoints(points);
    await saveProfile(_currentProfile!);
  }

  Future<void> unlockAchievement(String achievementId) async {
    if (_currentProfile == null) return;
    _currentProfile!.unlockAchievement(achievementId);
    await saveProfile(_currentProfile!);
  }

  // ─── Queries ───

  int getSubjectProgress(String subjectId) {
    return _currentProfile?.getProgress(subjectId) ?? 0;
  }

  int getTotalPoints() {
    return _currentProfile?.totalPoints ?? 0;
  }

  bool hasAchievement(String achievementId) {
    return _currentProfile?.achievements.contains(achievementId) ?? false;
  }

  // ─── Reset (for debugging) ───

  Future<void> resetProfile() async {
    _currentProfile = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
  }

  /// Logs in an existing user or registers a new user under the Firestore NoSQL database.
  Future<Map<String, dynamic>> loginUser(String username) async {
    // Generate a consistent unique UID based on the lowercase username
    final cleanUsername = username.trim().replaceAll(RegExp(r'\s+'), '_').toLowerCase();
    final uid = 'usr_$cleanUsername';
    
    try {
      final result = await FirestoreService.instance.obtenerOCrearUsuario(
        uid: uid,
        name: username,
        avatarId: 'avatar_llama', // default fallback avatar
      );
      
      if (result['estado'] == 'error') {
        return {'success': false, 'message': 'No se pudo conectar con el servidor.'};
      }
      
      if (result['estado'] == 'sesion_iniciada') {
        // User exists in Firestore! Sync locally and save profile details
        final profile = UserProfile(
          uid: uid,
          name: result['name'] as String,
          avatarId: result['avatarId'] as String,
          totalPoints: result['totalPoints'] as int,
          achievements: List<String>.from(result['achievements'] as List),
        );
        
        // Save locally to SharedPreferences
        _currentProfile = profile;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_profileKey, profile.toJsonString());
        
        return {'success': true, 'isNew': false};
      } else {
        // New user created! Set temporary name locally, they will choose their avatar next
        final profile = UserProfile(uid: uid, name: username, avatarId: 'avatar_llama');
        _currentProfile = profile;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_profileKey, profile.toJsonString());
        
        return {'success': true, 'isNew': true};
      }
    } catch (e) {
      debugPrint('❌ Error in loginUser: $e');
      return {'success': false, 'message': 'Ocurrió un error inesperado: $e'};
    }
  }
}
