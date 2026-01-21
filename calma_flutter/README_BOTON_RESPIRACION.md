# Botón de Ejercicios de Respiración - Guía Técnica

## Resumen

Se ha agregado un nuevo botón a la pantalla principal de la aplicación Calma que permite a los usuarios acceder directamente a ejercicios de respiración sin registrar un episodio de pánico.

## Ubicación del Código

### Archivo Principal
```
lib/screens/home_screen.dart
```

### Función de Navegación (líneas 68-78)
```dart
void _startBreathingExercise() async {
  // Navegar directamente a ejercicios sin registrar episodio de pánico
  print('[HomeScreen] Ejercicio de respiración directo iniciado');

  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const BreathingExerciseScreen(),
    ),
  );
}
```

### Widget del Botón (líneas 259-296)
```dart
// Botón de ejercicios de respiración
if (!_isInPanicMode)
  GestureDetector(
    onTap: _startBreathingExercise,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.blue.shade400,
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade400.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.air, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          const Text(
            'Ejercicios de Respiración',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  ),
```

## Especificaciones Técnicas

### Diseño Visual

| Propiedad | Valor |
|---|---|
| Color de fondo | `Colors.blue.shade400` |
| Forma | Redondeada (borderRadius: 30) |
| Padding horizontal | 32px |
| Padding vertical | 16px |
| Color de sombra | `Colors.blue.shade400` con opacidad 0.3 |
| Blur de sombra | 15px |
| Spread de sombra | 2px |
| Tamaño de icono | 28px |
| Color de icono | Blanco |
| Tamaño de texto | 18px |
| Peso de texto | Bold |
| Color de texto | Blanco |

### Comportamiento

**Condición de Visibilidad**:
```dart
if (!_isInPanicMode)
```
El botón solo aparece cuando NO hay un episodio de pánico activo.

**Acción al Presionar**:
1. Imprime log: `[HomeScreen] Ejercicio de respiración directo iniciado`
2. Navega a `BreathingExerciseScreen` usando `Navigator.push()`
3. NO modifica ninguna variable de estado
4. NO crea registros en `LocalStorageService`
5. NO actualiza estadísticas

### Diferencias con el Botón SOS

#### Variables de Estado NO Modificadas
```dart
_isInPanicMode        // Permanece en false
_episodeStartTime     // No se asigna valor
_currentEpisodeId     // No se genera ID
```

#### Funciones NO Llamadas
```dart
_finishEpisode()      // No se ejecuta
_loadStatistics()     // No se actualiza
LocalStorageService.saveEpisode()  // No se guarda nada
```

## Integración con Código Existente

### Layout en la Pantalla Principal

```
┌─────────────────────────────────┐
│         AppBar: "Calma"         │
├─────────────────────────────────┤
│                                 │
│  [Estadísticas Card]            │
│  Total: X | Esta semana: Y      │
│                                 │
│  Spacer                         │
│                                 │
│  Título: "Estoy aquí para ti"  │
│                                 │
│  Mensaje de ayuda              │
│                                 │
│  ┌─────────────┐               │
│  │   Botón    │ ← 200x200      │
│  │    SOS     │   circular     │
│  └─────────────┘   rojo/verde  │
│                                 │
│  [32px spacing]                │
│                                 │
│  ┌───────────────────────────┐ │
│  │ 🌬️ Ejercicios de         │ │ ← NUEVO
│  │    Respiración            │ │
│  └───────────────────────────┘ │
│                                 │
│  Spacer                         │
└─────────────────────────────────┘
```

### Flujo de Navegación

```
HomeScreen
    │
    ├─── [Botón SOS] ────────────► _togglePanicMode()
    │                                     │
    │                                     ├─ setState(_isInPanicMode = true)
    │                                     ├─ Genera episodeId
    │                                     ├─ Registra startTime
    │                                     ├─ Navigator.push(BreathingExerciseScreen)
    │                                     └─ Al regresar: _finishEpisode()
    │
    └─── [Botón Respiración] ────► _startBreathingExercise()
                                          │
                                          ├─ NO modifica estado
                                          ├─ Navigator.push(BreathingExerciseScreen)
                                          └─ Al regresar: nada más
```

## Pruebas y Validación

### Casos de Prueba Recomendados

1. **Visibilidad del Botón**
   - ✅ El botón aparece cuando la app inicia (modo normal)
   - ✅ El botón desaparece cuando se activa el botón SOS
   - ✅ El botón reaparece cuando termina el episodio de pánico

2. **Funcionalidad**
   - ✅ Al presionar el botón, navega a ejercicios de respiración
   - ✅ Los ejercicios funcionan normalmente
   - ✅ Al regresar, no se guardan estadísticas
   - ✅ Los contadores (Total, Esta semana) no cambian

3. **Estado de la Aplicación**
   - ✅ `_isInPanicMode` permanece en `false`
   - ✅ `_episodeStartTime` permanece en `null`
   - ✅ `_currentEpisodeId` permanece en `null`

4. **Almacenamiento Local**
   - ✅ No se crea ningún `PanicEpisode`
   - ✅ La función `saveEpisode()` no se llama
   - ✅ El conteo de episodios no aumenta

### Comandos para Ejecutar Pruebas

```bash
# Ejecutar en web
cd calma_flutter
flutter run -d web-server --web-port=8888

# Ejecutar en iOS Simulator (requiere Xcode)
flutter run -d iPhone

# Ejecutar en Android Emulator (requiere Android Studio)
flutter run -d emulator-5554

# Ejecutar todas las pruebas unitarias
flutter test
```

## Personalización

### Cambiar Color del Botón

Ubicación: `home_screen.dart` línea 267
```dart
color: Colors.blue.shade400,  // Cambiar a otro color
```

Opciones sugeridas:
- `Colors.teal.shade400` - Verde azulado
- `Colors.purple.shade400` - Morado
- `Colors.indigo.shade400` - Índigo
- `Colors.cyan.shade400` - Cian

### Cambiar Icono

Ubicación: `home_screen.dart` línea 279
```dart
const Icon(Icons.air, ...)  // Cambiar icono
```

Iconos alternativos:
- `Icons.spa` - Icono de spa/relajación
- `Icons.self_improvement` - Meditación
- `Icons.accessibility_new` - Persona en posición yoga
- `Icons.favorite` - Corazón

### Cambiar Texto

Ubicación: `home_screen.dart` línea 285
```dart
const Text('Ejercicios de Respiración', ...)
```

Textos alternativos:
- "Respirar"
- "Practicar Respiración"
- "Ejercicios Calmantes"
- "Técnicas de Relajación"

### Cambiar Posición

Para mover el botón **arriba** del botón SOS:
```dart
// Mover el bloque completo (líneas 259-296)
// antes del bloque del botón SOS (línea 222)
```

Para colocarlo **al lado** del botón SOS:
```dart
// Envolver ambos botones en un Row:
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    // Botón SOS aquí
    // Botón Respiración aquí
  ],
)
```

## Mantenimiento

### Logs para Debugging

El botón genera el siguiente log al presionarse:
```
[HomeScreen] Ejercicio de respiración directo iniciado
```

Para agregar más logs:
```dart
void _startBreathingExercise() async {
  print('[HomeScreen] Ejercicio de respiración directo iniciado');
  print('[HomeScreen] Estado actual - Modo pánico: $_isInPanicMode');

  await Navigator.push(...);

  print('[HomeScreen] Regreso de ejercicios de respiración');
}
```

### Extensibilidad Futura

Si se desea agregar tracking opcional (sin forzar registro):
```dart
void _startBreathingExercise() async {
  print('[HomeScreen] Ejercicio de respiración directo iniciado');

  // Opcional: guardar timestamp para estadísticas de uso
  final practiceStartTime = DateTime.now();

  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const BreathingExerciseScreen(),
    ),
  );

  // Opcional: calcular duración de práctica
  final duration = DateTime.now().difference(practiceStartTime);
  print('[HomeScreen] Duración de práctica: ${duration.inSeconds}s');
}
```

## Archivos Relacionados

| Archivo | Propósito |
|---|---|
| `lib/screens/home_screen.dart` | Pantalla principal con ambos botones |
| `lib/screens/breathing_exercise_screen.dart` | Pantalla de ejercicios de respiración |
| `lib/services/local_storage_service.dart` | Servicio de almacenamiento (NO usado por el nuevo botón) |
| `pubspec.yaml` | Configuración de dependencias |

## Dependencias

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  just_audio: ^0.9.36          # Para audio (opcional)
  shared_preferences: ^2.2.2   # NO usado por el nuevo botón
```

## Notas Importantes

⚠️ **NO modificar** las siguientes funciones sin entender el impacto:
- `_togglePanicMode()` - Controla el flujo del botón SOS
- `_finishEpisode()` - Guarda estadísticas de pánico
- `_loadStatistics()` - Carga contadores

✅ **Seguro modificar**:
- Estilo visual del nuevo botón
- Texto e icono del nuevo botón
- Posición del nuevo botón
- Logs dentro de `_startBreathingExercise()`

## Soporte

Para preguntas o reportar problemas:
- Revisar logs en la consola
- Verificar que Flutter esté actualizado: `flutter doctor`
- Limpiar y reconstruir: `flutter clean && flutter pub get`

---

**Versión**: 1.0
**Fecha**: 21 de enero de 2026
**Autor**: Claude Code
