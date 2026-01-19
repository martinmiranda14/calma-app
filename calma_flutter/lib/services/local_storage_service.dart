import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PanicEpisode {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final int? durationSeconds;
  final int intensityLevel;

  PanicEpisode({
    required this.id,
    required this.startTime,
    this.endTime,
    this.durationSeconds,
    this.intensityLevel = 1,
  });

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'durationSeconds': durationSeconds,
      'intensityLevel': intensityLevel,
    };
  }

  // Crear desde JSON
  factory PanicEpisode.fromJson(Map<String, dynamic> json) {
    return PanicEpisode(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null,
      durationSeconds: json['durationSeconds'] as int?,
      intensityLevel: json['intensityLevel'] as int? ?? 1,
    );
  }
}

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  static const String _episodesKey = 'panic_episodes';
  SharedPreferences? _prefs;

  // Inicializar SharedPreferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Guardar un episodio de pánico
  Future<void> saveEpisode(PanicEpisode episode) async {
    await init();

    // Obtener episodios existentes
    final episodes = await getEpisodes();

    // Agregar el nuevo episodio
    episodes.add(episode);

    // Convertir a JSON y guardar
    final episodesJson = episodes.map((e) => e.toJson()).toList();
    final encodedData = json.encode(episodesJson);

    await _prefs!.setString(_episodesKey, encodedData);

    print('[LocalStorage] Episodio guardado: ${episode.id}');
    print('[LocalStorage] Total episodios: ${episodes.length}');
  }

  // Obtener todos los episodios
  Future<List<PanicEpisode>> getEpisodes() async {
    await init();

    final encodedData = _prefs!.getString(_episodesKey);

    if (encodedData == null || encodedData.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> episodesJson = json.decode(encodedData) as List<dynamic>;
      return episodesJson
          .map((e) => PanicEpisode.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('[LocalStorage] Error al cargar episodios: $e');
      return [];
    }
  }

  // Obtener episodios recientes (últimos 7 días)
  Future<List<PanicEpisode>> getRecentEpisodes({int days = 7}) async {
    final allEpisodes = await getEpisodes();
    final cutoffDate = DateTime.now().subtract(Duration(days: days));

    return allEpisodes
        .where((episode) => episode.startTime.isAfter(cutoffDate))
        .toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime)); // Más recientes primero
  }

  // Obtener el último episodio
  Future<PanicEpisode?> getLastEpisode() async {
    final episodes = await getEpisodes();

    if (episodes.isEmpty) {
      return null;
    }

    episodes.sort((a, b) => b.startTime.compareTo(a.startTime));
    return episodes.first;
  }

  // Contar episodios totales
  Future<int> getEpisodeCount() async {
    final episodes = await getEpisodes();
    return episodes.length;
  }

  // Contar episodios de la última semana
  Future<int> getWeeklyEpisodeCount() async {
    final recentEpisodes = await getRecentEpisodes(days: 7);
    return recentEpisodes.length;
  }

  // Obtener duración promedio de episodios
  Future<double?> getAverageDuration() async {
    final episodes = await getEpisodes();

    final episodesWithDuration = episodes
        .where((e) => e.durationSeconds != null)
        .toList();

    if (episodesWithDuration.isEmpty) {
      return null;
    }

    final totalSeconds = episodesWithDuration
        .map((e) => e.durationSeconds!)
        .reduce((a, b) => a + b);

    return totalSeconds / episodesWithDuration.length;
  }

  // Limpiar todos los episodios (útil para testing o reset)
  Future<void> clearAllEpisodes() async {
    await init();
    await _prefs!.remove(_episodesKey);
    print('[LocalStorage] Todos los episodios han sido eliminados');
  }

  // Exportar datos como JSON (útil para respaldo)
  Future<String> exportData() async {
    final episodes = await getEpisodes();
    final episodesJson = episodes.map((e) => e.toJson()).toList();
    return json.encode(episodesJson);
  }

  // Importar datos desde JSON (útil para restaurar respaldo)
  Future<void> importData(String jsonData) async {
    await init();

    try {
      final List<dynamic> episodesJson = json.decode(jsonData) as List<dynamic>;
      final episodes = episodesJson
          .map((e) => PanicEpisode.fromJson(e as Map<String, dynamic>))
          .toList();

      // Guardar episodios importados
      final encodedData = json.encode(episodesJson);
      await _prefs!.setString(_episodesKey, encodedData);

      print('[LocalStorage] Datos importados: ${episodes.length} episodios');
    } catch (e) {
      print('[LocalStorage] Error al importar datos: $e');
      throw Exception('Error al importar datos: $e');
    }
  }
}
