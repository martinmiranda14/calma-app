import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  // Rutas locales de archivos de audio
  // Tonos puros generados científicamente a frecuencias de sanación
  static const Map<String, String> _audioAssets = {
    '432Hz': 'assets/audio/432hz.wav', // Frecuencia natural (calmante)
    '528Hz': 'assets/audio/528hz.wav', // Frecuencia del amor (sanación)
  };

  Future<void> playCalmingSound({String frequency = '432Hz'}) async {
    // NO bloquear - ejecutar en segundo plano
    _playCalmingSoundAsync(frequency);
  }

  Future<void> _playCalmingSoundAsync(String frequency) async {
    if (_isPlaying) {
      await stop();
    }

    try {
      print('Intentando reproducir audio: $frequency');

      // Cargar audio desde assets
      final assetPath = _audioAssets[frequency] ?? _audioAssets['432Hz']!;

      await _audioPlayer.setAsset(assetPath);
      await _audioPlayer.setVolume(0.3); // Volumen moderado (30%)
      await _audioPlayer.setLoopMode(LoopMode.one); // Loop continuo

      await _audioPlayer.play();
      _isPlaying = true;

      print('Audio iniciado correctamente: $assetPath');
    } catch (e) {
      print('Error playing audio: $e');
      print('Esto es normal en navegadores - requieren interacción del usuario primero');
      // Si falla, continúa sin audio (silencioso)
      _isPlaying = false;
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _isPlaying = false;
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }

  Future<void> setVolume(double volume) async {
    try {
      await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
    } catch (e) {
      print('Error setting volume: $e');
    }
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }

  bool get isPlaying => _isPlaying;
}
