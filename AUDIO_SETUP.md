# Configuración de Audio para Calma App

## Estado Actual

El sistema de audio está **implementado** pero requiere archivos de audio locales para funcionar correctamente en Flutter Web.

## Problema

`just_audio` en Flutter Web tiene limitaciones:
- No todas las URLs externas funcionan por CORS
- Los navegadores bloquean algunos reproductores automáticos
- Es mejor usar archivos locales en los assets

## Solución Recomendada

### Opción 1: Agregar Archivos de Audio Locales (Recomendada)

1. **Descargar/Generar tonos:**
   - Ir a: https://onlinetonegenerator.com/
   - Configurar 432 Hz, formato sine wave
   - Duración: 60 segundos
   - Descargar como MP3
   - Repetir para 528 Hz

2. **Agregar archivos al proyecto:**
   ```bash
   mkdir -p lib/assets/audio
   # Copiar archivos descargados
   cp ~/Downloads/432hz.mp3 lib/assets/audio/
   cp ~/Downloads/528hz.mp3 lib/assets/audio/
   ```

3. **Actualizar pubspec.yaml:**
   ```yaml
   flutter:
     assets:
       - assets/audio/432hz.mp3
       - assets/audio/528hz.mp3
   ```

4. **Actualizar audio_service.dart:**
   ```dart
   static const Map<String, String> _audioUrls = {
     '432Hz': 'assets/audio/432hz.mp3',
     '528Hz': 'assets/audio/528hz.mp3',
   };

   Future<void> playCalmingSound({String frequency = '432Hz'}) async {
     if (_isPlaying) {
       await stop();
     }

     try {
       final assetPath = _audioUrls[frequency] ?? _audioUrls['432Hz']!;
       await _audioPlayer.setAsset(assetPath); // Usar setAsset en lugar de setUrl
       await _audioPlayer.setVolume(0.3);
       await _audioPlayer.setLoopMode(LoopMode.one);
       await _audioPlayer.play();
       _isPlaying = true;
     } catch (e) {
       print('Error playing audio: $e');
     }
   }
   ```

### Opción 2: Generar Tonos con Python (Rápido)

```python
import numpy as np
from scipy.io.wavfile import write

def generate_tone(frequency, duration=60, sample_rate=44100):
    """Genera un tono puro de frecuencia específica"""
    t = np.linspace(0, duration, int(sample_rate * duration))

    # Generar onda sinusoidal
    wave = np.sin(2 * np.pi * frequency * t)

    # Aplicar fade in/out para evitar clicks
    fade_duration = int(sample_rate * 0.5)  # 0.5 segundos
    fade_in = np.linspace(0, 1, fade_duration)
    fade_out = np.linspace(1, 0, fade_duration)

    wave[:fade_duration] *= fade_in
    wave[-fade_duration:] *= fade_out

    # Normalizar a rango de 16-bit
    wave = np.int16(wave * 32767)

    return wave

# Generar tonos
print("Generando tono 432 Hz...")
tone_432 = generate_tone(432)
write('432hz.wav', 44100, tone_432)

print("Generando tono 528 Hz...")
tone_528 = generate_tone(528)
write('528hz.wav', 44100, tone_528)

print("Archivos generados exitosamente!")
```

**Para ejecutar:**
```bash
pip install numpy scipy
python generate_tones.py
```

### Opción 3: Usar Audacity (GUI, Más Fácil)

1. Abrir Audacity (gratuito)
2. Generate → Tone...
3. Configurar:
   - Waveform: Sine
   - Frequency: 432
   - Amplitude: 0.5
   - Duration: 60 seconds
4. File → Export → Export as MP3
5. Repetir para 528 Hz

### Opción 4: Desactivar Audio Temporalmente

Si prefieres continuar sin audio por ahora:

```dart
// En breathing_exercise_screen.dart
bool _audioEnabled = false; // Cambiar de true a false
```

O simplemente usar el botón de volumen en la app para silenciar.

## Archivos de Audio Recomendados

### Características ideales:
- **Formato**: MP3 o OGG (mejor compresión)
- **Duración**: 60 segundos (se hace loop)
- **Bitrate**: 128 kbps (balance calidad/tamaño)
- **Sample Rate**: 44.1 kHz
- **Tamaño**: ~1-2 MB por archivo

### Fuentes Alternativas (Licencia Libre):
1. **Freesound.org** (Creative Commons)
   - Buscar: "432hz tone" o "528hz healing"

2. **YouTube Audio Library** (gratuito)
   - Filtrar por "Ambient" o "Meditation"

3. **Incompetech** (Kevin MacLeod - CC BY)
   - Música ambient gratuita

## Configuración Actual

El código está preparado para recibir archivos de audio. Solo necesitas:
1. Agregar los archivos MP3/WAV
2. Actualizar las rutas en `audio_service.dart`
3. Hot restart de Flutter

## Testing

Para verificar que el audio funciona:

```dart
// Agregar en breathing_exercise_screen.dart initState()
print('Audio service initialized');

// En playCalmingSound()
print('Playing audio: $frequency');
print('Is playing: $_isPlaying');
```

Revisar console del navegador (F12 → Console) para ver logs.

## Troubleshooting

### "Audio no se reproduce"
- ✅ Verificar que archivos estén en `assets/audio/`
- ✅ Verificar `pubspec.yaml` tiene configuración correcta
- ✅ Hacer `flutter pub get` después de cambios
- ✅ Hot restart (R) no hot reload (r)

### "Permission denied"
- Los navegadores modernos bloquean autoplay
- El usuario debe interactuar primero (click en botón)
- Nuestra app ya maneja esto correctamente

### "CORS error"
- Solo ocurre con URLs externas
- Solución: usar assets locales

## Próximos Pasos

1. Generar/descargar archivos de audio
2. Agregarlos al proyecto
3. Actualizar `audio_service.dart` para usar assets
4. Testar en navegador

¿Necesitas ayuda con algún paso específico?
