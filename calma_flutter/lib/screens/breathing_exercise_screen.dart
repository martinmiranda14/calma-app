import 'package:flutter/material.dart';
import 'dart:async';
import '../services/audio_service.dart';

class BreathingExerciseScreen extends StatefulWidget {
  const BreathingExerciseScreen({super.key});

  @override
  State<BreathingExerciseScreen> createState() => _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  Timer? _timer;
  final AudioService _audioService = AudioService();

  // Estados de respiración
  String _currentPhase = 'Prepárate';
  int _countdown = 3;
  bool _isExercising = false;
  int _cycleCount = 0;
  int _totalCycles = 4;
  bool _audioEnabled = true; // Audio habilitado - se ejecuta en segundo plano sin bloquear
  int _intensityLevel = 1; // 1 = normal, 2 = alto, 3 = severo

  // Técnica seleccionada (4-7-8)
  String _technique = '4-7-8';

  // Duraciones para 4-7-8 (ajustables según intensidad)
  int _inhaleSeconds = 4;
  int _holdSeconds = 7;
  int _exhaleSeconds = 8;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _startCountdown();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    _audioService.stop();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
        _startBreathingExercise();
      }
    });
  }

  void _startBreathingExercise() async {
    print('[DEBUG] Iniciando ejercicio de respiración');
    setState(() {
      _isExercising = true;
      _cycleCount = 0;
    });

    // Iniciar audio si está habilitado
    // En web, esto funciona porque el usuario ya interactuó (presionó el botón)
    if (_audioEnabled) {
      print('[DEBUG] Iniciando audio 432Hz');
      try {
        await _audioService.playCalmingSound(frequency: '432Hz');
        print('[DEBUG] Audio iniciado exitosamente');
      } catch (e) {
        print('[DEBUG] Error al iniciar audio: $e');
        // Continuar sin audio si falla
      }
    }

    print('[DEBUG] Llamando a _startBreathingCycle');
    _startBreathingCycle();
  }

  void _startBreathingCycle() {
    print('[DEBUG] _startBreathingCycle - ciclo $_cycleCount de $_totalCycles');
    if (_cycleCount >= _totalCycles) {
      print('[DEBUG] Ciclos completados, finalizando ejercicio');
      _finishExercise();
      return;
    }

    setState(() {
      _cycleCount++;
    });

    print('[DEBUG] Iniciando fase de inhalación');
    // Fase 1: Inhalar (4 segundos)
    _startPhase('Inhala profundamente', _inhaleSeconds, () {
      _animationController.duration = Duration(seconds: _inhaleSeconds);
      _animationController.forward(from: 0.0);
    }, () {
      // Fase 2: Retener (7 segundos)
      _startPhase('Retén la respiración', _holdSeconds, () {
        // Mantener el círculo grande
      }, () {
        // Fase 3: Exhalar (8 segundos)
        _startPhase('Exhala lentamente', _exhaleSeconds, () {
          _animationController.duration = Duration(seconds: _exhaleSeconds);
          _animationController.reverse();
        }, () {
          // Siguiente ciclo
          _startBreathingCycle();
        });
      });
    });
  }

  void _startPhase(String phase, int duration, VoidCallback onStart, VoidCallback onComplete) {
    print('[DEBUG] _startPhase: $phase - duración: $duration segundos');
    setState(() {
      _currentPhase = phase;
      _countdown = duration;
    });

    print('[DEBUG] Ejecutando callback onStart');
    onStart();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
        onComplete();
      }
    });
  }

  void _finishExercise() {
    setState(() {
      _currentPhase = '¡Completado!';
      _isExercising = false;
    });

    _animationController.stop();
    _animationController.value = 0.0;
  }

  void _stopExercise() async {
    _timer?.cancel();
    await _audioService.stop();
    Navigator.pop(context, true); // Retorna true indicando que completó el ejercicio
  }

  void _toggleAudio() {
    setState(() {
      _audioEnabled = !_audioEnabled;
    });

    if (_audioEnabled && _isExercising) {
      _audioService.playCalmingSound(frequency: '432Hz');
    } else {
      _audioService.stop();
    }
  }

  void _increaseIntensity() {
    setState(() {
      _intensityLevel++;

      // Ajustar el ejercicio según intensidad
      if (_intensityLevel == 2) {
        // Nivel alto: Cambiar a Box Breathing (más simple)
        _technique = 'Box 4-4-4-4';
        _inhaleSeconds = 4;
        _holdSeconds = 4;
        _exhaleSeconds = 4;
        _totalCycles = 6; // Más ciclos
      } else if (_intensityLevel >= 3) {
        // Nivel severo: Respiración más lenta y profunda
        _technique = '5-5-5';
        _inhaleSeconds = 5;
        _holdSeconds = 5;
        _exhaleSeconds = 5;
        _totalCycles = 8; // Aún más ciclos
      }

      // Reiniciar el ejercicio con las nuevas configuraciones
      _cycleCount = 0;
      _isExercising = true;
    });

    // Cambiar a frecuencia 528Hz para crisis más severas
    if (_audioEnabled) {
      _audioService.stop();
      _audioService.playCalmingSound(frequency: '528Hz');
    }

    _startBreathingCycle();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _stopExercise,
        ),
        title: Text(
          'Respiración $_technique',
          style: TextStyle(color: Colors.indigo.shade900),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _audioEnabled ? Icons.volume_up : Icons.volume_off,
              color: Colors.indigo.shade700,
            ),
            onPressed: _toggleAudio,
            tooltip: _audioEnabled ? 'Silenciar audio' : 'Activar audio',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Contador de ciclos
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _isExercising
                    ? 'Ciclo $_cycleCount de $_totalCycles'
                    : 'Preparándose...',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.indigo.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Espacio flexible para centrar el círculo
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Círculo animado de respiración
                    AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return Container(
                          width: 150 * _scaleAnimation.value,
                          height: 150 * _scaleAnimation.value,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.blue.shade300.withOpacity(0.8),
                                Colors.purple.shade300.withOpacity(0.6),
                                Colors.indigo.shade200.withOpacity(0.4),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.indigo.shade200.withOpacity(0.5),
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '$_countdown',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 48),

                    // Instrucción de fase
                    Text(
                      _currentPhase,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade900,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Descripción de la fase
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        _getPhaseDescription(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.indigo.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Botones para terminar o repetir con más intensidad (solo cuando termina)
            if (!_isExercising && _cycleCount >= _totalCycles)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    // Ícono de éxito
                    Icon(
                      Icons.check_circle,
                      size: 64,
                      color: Colors.green.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '¡Excelente trabajo!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Has completado el ejercicio de respiración',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.indigo.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '¿Cómo te sientes?',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.indigo.shade800,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Botón: Ya me siento calmado
                    ElevatedButton(
                      onPressed: _stopExercise,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade400,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Ya me siento calmado',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Botón: Necesito más ayuda
                    OutlinedButton.icon(
                      onPressed: _increaseIntensity,
                      icon: const Icon(Icons.refresh),
                      label: Text(
                        _intensityLevel == 1
                          ? 'Necesito más ayuda'
                          : 'Aún necesito ayuda',
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange.shade700,
                        side: BorderSide(color: Colors.orange.shade400, width: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),

                    // Indicador de nivel de intensidad
                    if (_intensityLevel > 1) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Colors.orange.shade700,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _intensityLevel == 2
                                ? 'Ejercicio ajustado: Box Breathing'
                                : 'Ejercicio ajustado: Respiración profunda',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getPhaseDescription() {
    if (_currentPhase.contains('Inhala')) {
      return 'Respira por la nariz profunda y lentamente';
    } else if (_currentPhase.contains('Retén')) {
      return 'Mantén el aire en tus pulmones';
    } else if (_currentPhase.contains('Exhala')) {
      return 'Suelta el aire lentamente por la boca';
    } else if (_currentPhase.contains('Completado')) {
      return '¿Cómo te sientes ahora?';
    }
    return 'Encuentra un lugar cómodo y relájate';
  }
}
