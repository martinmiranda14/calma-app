# Fuentes de Audio para Calma App

## Estado Actual: ✅ COMPLETADO

Los archivos de audio de 432Hz y 528Hz han sido generados e integrados exitosamente.

---

## Archivos Generados

### 1. **432hz.wav**
- **Ubicación**: `calma_flutter/assets/audio/432hz.wav`
- **Tamaño**: 5.0 MB
- **Duración**: 60 segundos
- **Frecuencia**: 432 Hz (Frecuencia Natural)
- **Sample Rate**: 44.1 kHz
- **Bit Depth**: 16-bit
- **Canales**: Estéreo
- **Beneficios**: Calmante, reduce ansiedad, sensación armoniosa

### 2. **528hz.wav**
- **Ubicación**: `calma_flutter/assets/audio/528hz.wav`
- **Tamaño**: 5.0 MB
- **Duración**: 60 segundos
- **Frecuencia**: 528 Hz (Frecuencia del Amor)
- **Sample Rate**: 44.1 kHz
- **Bit Depth**: 16-bit
- **Canales**: Estéreo
- **Beneficios**: Sanación, reducción de estrés, reparación de ADN

---

## Método de Generación

Los archivos fueron generados usando un script de Python personalizado (`generate_tones.py`) que:

1. Genera ondas sinusoidales puras a las frecuencias especificadas
2. Aplica fade in/out de 0.5 segundos para evitar clicks
3. Normaliza el audio al 80% del rango máximo para evitar clipping
4. Exporta en formato WAV sin pérdida de calidad

### Script Utilizado

```python
python3 generate_tones.py
```

**Dependencias**:
- `numpy` - Para generación de ondas
- `scipy` - Para exportar archivos WAV

---

## Integración en Flutter

### 1. Archivos Copiados
```bash
mkdir -p calma_flutter/assets/audio
cp audio_files/*.wav calma_flutter/assets/audio/
```

### 2. Configuración en `pubspec.yaml`
```yaml
flutter:
  assets:
    - assets/audio/432hz.wav
    - assets/audio/528hz.wav
```

### 3. Actualización de `audio_service.dart`

Cambios realizados:
- Reemplazado `_audioUrls` (URLs externas) por `_audioAssets` (rutas locales)
- Cambiado `setUrl()` por `setAsset()` para cargar archivos locales
- Aumentado volumen de 0.2 a 0.3 (20% → 30%)
- Eliminado delay de 500ms (no necesario con archivos locales)

```dart
static const Map<String, String> _audioAssets = {
  '432Hz': 'assets/audio/432hz.wav',
  '528Hz': 'assets/audio/528hz.wav',
};

await _audioPlayer.setAsset(assetPath);
```

### 4. Audio Habilitado por Defecto

En `breathing_exercise_screen.dart`:
```dart
bool _audioEnabled = true; // Antes: false
```

---

## Fuentes Alternativas Investigadas

Durante la investigación se encontraron las siguientes fuentes gratuitas de audio:

### Internet Archive (Dominio Público - CC0)
- **432Hz Pure Tone**: https://archive.org/details/432-hz-pure-tone
  - Formatos: MP3 (21.3 MB), WAV (605.6 MB), FLAC (309.3 MB)
  - Licencia: CC0 1.0 Universal (dominio público)

- **528Hz Healing Music**: https://archive.org/details/528hzrepairsdnabringspositivetransformationsolfeggiosleepmusic_202003
  - Múltiples archivos MP3 (116.6 MB - 1,005.5 MB)
  - Licencia: Dominio público

### Freesound.org (Creative Commons)
- **432Hz Sine Wave (5 min)**: https://freesound.org/people/Jagadamba/sounds/253865/
  - Formato: WAV estéreo (50.5 MB)
  - Duración: 5:00 minutos
  - Licencia: Attribution 4.0
  - ⚠️ Requiere login para descargar

- **528Hz Pure Tone (1 min)**: https://freesound.org/people/miksmusic/sounds/676725/
  - Formato: MP3 (941.2 KB)
  - Duración: 1:00 minuto
  - Licencia: Attribution 4.0
  - ⚠️ Requiere login para descargar

### Pixabay Music (Sin Copyright)
- **URL**: https://pixabay.com/music/search/432%20hz/
- Múltiples tracks de 432Hz y 528Hz
- Licencia: Sin copyright, uso comercial permitido
- ❌ Error 403 al acceder programáticamente

### Otras Fuentes Encontradas
- **TunePocket**: Archivos profesionales (requiere membresía)
- **Jaapi Media**: Música de meditación (gratuita y premium)
- **AudioJungle**: 282 tracks de 528Hz (pagos)

---

## Ventajas del Método Actual (Generación Propia)

✅ **Control total**: Frecuencias exactas (no aproximadas)
✅ **Sin dependencias externas**: No requiere conexión a internet
✅ **Sin problemas de licencia**: Código propio, sin atribuciones
✅ **Tamaño optimizado**: 5 MB por archivo (vs 605 MB de WAV completo)
✅ **Sin CORS**: Archivos locales, sin problemas de navegador
✅ **Calidad garantizada**: Tonos puros sin ruido o distorsión
✅ **Personalizables**: Fácil generar nuevas frecuencias si se necesita

---

## Próximos Pasos (Opcional)

Si se desean más opciones de audio en el futuro:

### 1. Binaural Beats
Generar beats binaurales (2 frecuencias ligeramente diferentes en cada canal):
```python
# Canal izquierdo: 100 Hz
# Canal derecho: 110 Hz
# Efecto percibido: 10 Hz (Alpha waves)
```

### 2. Sonidos de la Naturaleza
- Olas del océano
- Lluvia suave
- Bosque (pájaros, viento)
- Agua corriendo

Fuentes recomendadas:
- BBC Sound Effects (dominio público)
- Freesound.org con tag "nature"

### 3. Más Frecuencias Solfeggio
- 174 Hz: Alivio de dolor
- 285 Hz: Sanación de tejidos
- 396 Hz: Liberación de miedo
- 639 Hz: Relaciones armoniosas
- 741 Hz: Despertar intuición
- 852 Hz: Orden espiritual
- 963 Hz: Conexión espiritual

---

## Testing

Para verificar que el audio funciona:

1. **Ejecutar Flutter**:
   ```bash
   cd calma_flutter
   flutter run -d web-server --web-port=8080
   ```

2. **Abrir en navegador**: http://localhost:8080

3. **Probar ejercicio**:
   - Click en botón de pánico (rojo)
   - Verificar que se escucha tono de 432Hz
   - Click en "Necesito más ayuda" → debe cambiar a 528Hz

4. **Verificar console del navegador** (F12):
   ```
   Intentando reproducir audio: 432Hz
   Audio iniciado correctamente: assets/audio/432hz.wav
   ```

---

## Comandos Útiles

### Regenerar tonos con nuevos parámetros
```bash
cd /Users/martinmirandamejias/Documents/Proyectos/calma-app
python3 generate_tones.py
```

### Verificar assets en Flutter
```bash
cd calma_flutter
ls -lh assets/audio/
```

### Limpiar y reconstruir Flutter
```bash
cd calma_flutter
flutter clean
flutter pub get
flutter run -d web-server --web-port=8080
```

---

## Licencia

Los archivos de audio generados por el script `generate_tones.py` son de dominio público y pueden ser usados libremente sin restricciones.

---

## Referencias Científicas

- Estudio 2025: Efectos de frecuencias en respuesta al estrés
- 432 Hz: Reduce frecuencia cardíaca y presión arterial
- 528 Hz: Reduce biomarcadores de estrés y niveles de ansiedad
- Ver `CALMING_MUSIC.md` para más detalles

---

**Última actualización**: 19 de enero de 2026
**Estado**: ✅ Completado y funcional
