import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

/// Service for Text-to-Speech (TTS) and microphone recording/playback.
/// Uses flutter_tts for speaking words aloud, the record package
/// for capturing audio from the device microphone, and audioplayers
/// to play back the captured voice for verification.

class VoiceService {
  // ─── Singleton ───
  VoiceService._();
  static final VoiceService instance = VoiceService._();

  final FlutterTts _tts = FlutterTts();
  AudioRecorder? _recorder;
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  bool _ttsInitialized = false;
  bool _audioPlayerInitialized = false;
  bool _isRecording = false;
  bool _isSpeaking = false;
  bool _isPlayingAudio = false;

  bool get isRecording => _isRecording;
  bool get isSpeaking => _isSpeaking;
  bool get isPlayingAudio => _isPlayingAudio;

  // ─── INICIALIZACIÓN ───

  /// Call once during app startup or before first use.
  Future<void> initialize() async {
    await _initTts();
    _recorder = AudioRecorder();
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    if (_audioPlayerInitialized) return;
    
    // Listen to player state changes
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlayingAudio = state == PlayerState.playing;
    });
    
    _audioPlayerInitialized = true;
  }

  /// Register a callback to be invoked when audio playback finishes.
  void setOnComplete(VoidCallback callback) {
    _initAudioPlayer();
    _audioPlayer.onPlayerComplete.listen((_) => callback());
  }

  Future<void> _initTts() async {
    if (_ttsInitialized) return;

    // Configure TTS for kid-friendly Aymara/Spanish reading
    await _tts.setLanguage('es-ES');
    await _tts.setSpeechRate(0.45); // Slow for children
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.1); // Slightly higher pitch (friendlier)

    // Callbacks to track speaking state
    _tts.setStartHandler(() {
      _isSpeaking = true;
    });
    _tts.setCompletionHandler(() {
      _isSpeaking = false;
    });
    _tts.setCancelHandler(() {
      _isSpeaking = false;
    });
    _tts.setErrorHandler((msg) {
      _isSpeaking = false;
      debugPrint('❌ TTS Error: $msg');
    });

    _ttsInitialized = true;
  }

  // ─── PARTE 1: HACER QUE HABLE (Text-to-Speech) ───

  /// Speak the given [text] out loud using TTS.
  /// Optionally override [language] (default: 'es-ES').
  Future<void> hablar(String texto, {String? language}) async {
    await _initTts();

    // Force language set every time to prevent resets on some browsers/emulators
    final targetLanguage = language ?? 'es-ES';
    await _tts.setLanguage(targetLanguage);
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.1);

    await _tts.speak(texto);
  }

  /// Stop any ongoing speech.
  Future<void> pararDeHablar() async {
    await _tts.stop();
    _isSpeaking = false;
  }

  // ─── PARTE 2: HACER QUE ESCUCHE (Microphone Recording) ───

  /// Start recording from the microphone.
  /// Returns `true` if recording started successfully, `false` otherwise.
  Future<bool> empezarAGrabar() async {
    _recorder ??= AudioRecorder();

    // Check microphone permission
    final hasPermission = await _recorder!.hasPermission();
    if (!hasPermission) {
      debugPrint('❌ No se otorgó permiso al micrófono.');
      return false;
    }

    try {
      // Configure recording: AAC LC format (extremely compatible on Android, iOS, and Web)
      const config = RecordConfig(
        encoder: AudioEncoder.aacLc,
        sampleRate: 16000,
        numChannels: 1,
        bitRate: 128000,
      );

      String recordPath = '';
      if (!kIsWeb) {
        final tempDir = await getTemporaryDirectory();
        // Enforce a specific .m4a extension and use timestamp to prevent audioplayer caching bugs
        recordPath = '${tempDir.path}/yachay_voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      }

      // Start recording
      await _recorder!.start(config, path: recordPath);
      _isRecording = true;
      debugPrint('🔴 Micrófono abierto... ¡Habla ahora! Archivo en: $recordPath');
      return true;
    } catch (e) {
      debugPrint('❌ Error al iniciar grabación: $e');
      _isRecording = false;
      return false;
    }
  }

  /// Stop recording and return the file path of the recorded audio.
  /// Returns `null` if recording failed or wasn't started.
  Future<String?> terminarDeGrabar() async {
    if (_recorder == null || !_isRecording) {
      debugPrint('⚠️ No hay grabación activa para detener.');
      return null;
    }

    try {
      final path = await _recorder!.stop();
      _isRecording = false;
      debugPrint('⬛ Grabación terminada. Archivo en: $path');
      return path;
    } catch (e) {
      debugPrint('❌ Error al detener grabación: $e');
      _isRecording = false;
      return null;
    }
  }

  /// Cancel current recording without saving.
  Future<void> cancelarGrabacion() async {
    if (_recorder != null && _isRecording) {
      await _recorder!.cancel();
      _isRecording = false;
      debugPrint('🚫 Grabación cancelada.');
    }
  }

  // ─── PARTE 3: REPRODUCIR LA GRABACIÓN (Audio Playback) ───

  /// Pre-load the recorded audio file path to make it play instantly
  Future<void> prepararAudio(String path) async {
    _initAudioPlayer();
    try {
      if (kIsWeb) {
        await _audioPlayer.setSource(UrlSource(path));
      } else {
        String cleanPath = path;
        if (cleanPath.startsWith('file://')) {
          cleanPath = cleanPath.substring(7);
        } else if (cleanPath.startsWith('file:/')) {
          cleanPath = cleanPath.substring(6);
        }
        await _audioPlayer.setSource(DeviceFileSource(cleanPath));
      }
      debugPrint('🎵 Audio pre-cargado para reproducción instantánea: $path');
    } catch (e) {
      debugPrint('❌ Error al pre-cargar audio: $e');
    }
  }

  /// Play the recorded audio file from the given [path].
  Future<void> reproducirAudio(String path) async {
    _initAudioPlayer();
    try {
      // Stop any ongoing speech or playback first
      await pararDeHablar();
      await detenerReproduccion();

      if (kIsWeb) {
        await _audioPlayer.play(UrlSource(path));
      } else {
        // Strip 'file://' or 'file:/' scheme prefix if present (common on Android/iOS paths)
        String cleanPath = path;
        if (cleanPath.startsWith('file://')) {
          cleanPath = cleanPath.substring(7);
        } else if (cleanPath.startsWith('file:/')) {
          cleanPath = cleanPath.substring(6);
        }
        await _audioPlayer.play(DeviceFileSource(cleanPath));
      }
      debugPrint('▶️ Reproduciendo grabación: $path');
    } catch (e) {
      debugPrint('❌ Error al reproducir audio: $e');
    }
  }

  /// Stop current audio playback.
  Future<void> detenerReproduccion() async {
    await _audioPlayer.stop();
    _isPlayingAudio = false;
  }

  // ─── LIMPIEZA ───

  /// Dispose resources. Call when the app shuts down.
  Future<void> dispose() async {
    await pararDeHablar();
    await detenerReproduccion();
    if (_isRecording) {
      await cancelarGrabacion();
    }
    _recorder?.dispose();
    _recorder = null;
    _audioPlayer.dispose();
  }
}