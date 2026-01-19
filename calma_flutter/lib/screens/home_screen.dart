import 'package:flutter/material.dart';
import 'breathing_exercise_screen.dart';
import '../services/local_storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isInPanicMode = false;
  DateTime? _episodeStartTime;
  String? _currentEpisodeId;
  int _totalEpisodes = 0;
  int _weeklyEpisodes = 0;
  final LocalStorageService _storage = LocalStorageService();

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    final totalCount = await _storage.getEpisodeCount();
    final weeklyCount = await _storage.getWeeklyEpisodeCount();

    setState(() {
      _totalEpisodes = totalCount;
      _weeklyEpisodes = weeklyCount;
    });

    print('[HomeScreen] Estadísticas cargadas: $_totalEpisodes total, $_weeklyEpisodes esta semana');
  }

  void _togglePanicMode() async {
    if (!_isInPanicMode) {
      // Iniciar modo pánico y ejercicio de respiración
      final episodeId = DateTime.now().millisecondsSinceEpoch.toString();

      setState(() {
        _isInPanicMode = true;
        _episodeStartTime = DateTime.now();
        _currentEpisodeId = episodeId;
      });

      print('[HomeScreen] Episodio iniciado: $episodeId');

      // Navegar a la pantalla de ejercicios de respiración
      final completed = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BreathingExerciseScreen(),
        ),
      );

      // Cuando regresa de los ejercicios
      if (completed == true) {
        await _finishEpisode();
      }
    } else {
      await _finishEpisode();
    }
  }

  Future<void> _finishEpisode() async {
    if (_episodeStartTime == null || _currentEpisodeId == null) {
      print('[HomeScreen] Error: No hay episodio activo para finalizar');
      return;
    }

    final endTime = DateTime.now();
    final durationSeconds = endTime.difference(_episodeStartTime!).inSeconds;

    // Crear y guardar el episodio
    final episode = PanicEpisode(
      id: _currentEpisodeId!,
      startTime: _episodeStartTime!,
      endTime: endTime,
      durationSeconds: durationSeconds,
      intensityLevel: 1, // Por ahora siempre es nivel 1
    );

    await _storage.saveEpisode(episode);

    print('[HomeScreen] Episodio finalizado: ${episode.id}');
    print('[HomeScreen] Duración: $durationSeconds segundos');

    setState(() {
      _isInPanicMode = false;
      _episodeStartTime = null;
      _currentEpisodeId = null;
    });

    // Recargar estadísticas
    await _loadStatistics();

    // Mostrar mensaje de confirmación
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Episodio guardado. Duración: ${_formatDuration(durationSeconds)}'),
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    if (minutes > 0) {
      return '$minutes min $remainingSeconds seg';
    } else {
      return '$seconds seg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calma'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Estadísticas en la parte superior
            if (_totalEpisodes > 0)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [
                            Text(
                              '$_totalEpisodes',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo.shade700,
                                  ),
                            ),
                            Text(
                              'Total',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 32),
                        Column(
                          children: [
                            Text(
                              '$_weeklyEpisodes',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange.shade700,
                                  ),
                            ),
                            Text(
                              'Esta semana',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            const Spacer(),

            // Título
            Text(
              _isInPanicMode ? 'Respira profundo' : 'Estoy aquí para ti',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 32),

            // Mensaje de ayuda
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _isInPanicMode
                    ? 'Vas a estar bien. Respira conmigo.'
                    : '¿Sientes ansiedad? Presiona el botón para comenzar',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 48),

            // Botón de pánico
            GestureDetector(
              onTap: _togglePanicMode,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isInPanicMode
                      ? Colors.green.shade400
                      : Colors.red.shade400,
                  boxShadow: [
                    BoxShadow(
                      color: (_isInPanicMode
                              ? Colors.green.shade400
                              : Colors.red.shade400)
                          .withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _isInPanicMode ? 'TERMINAR' : 'SOS',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),

            // Instrucciones
            if (_isInPanicMode)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Presiona "TERMINAR" cuando te sientas mejor',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
              ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
