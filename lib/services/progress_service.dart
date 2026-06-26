import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

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
  }

  Future<void> createProfile(String name, String avatarId) async {
    final profile = UserProfile(name: name, avatarId: avatarId);
    await saveProfile(profile);
  }

  // ─── Progress Updates ───

  Future<void> completeLevel(String subjectId, int pointsEarned) async {
    if (_currentProfile == null) return;
    _currentProfile!.advanceLevel(subjectId);
    _currentProfile!.addPoints(pointsEarned);
    await saveProfile(_currentProfile!);
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
}
