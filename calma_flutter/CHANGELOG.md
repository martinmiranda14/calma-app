# Changelog - Calma App

## [2026-01-21] - Nuevo Botón de Ejercicios de Respiración

### Cambios Realizados

#### 1. Nueva Funcionalidad en `lib/screens/home_screen.dart`

##### Función `_startBreathingExercise()` (líneas 68-78)
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

**Propósito**:
- Permite a los usuarios acceder a ejercicios de respiración sin registrar un episodio de pánico
- No modifica estadísticas ni crea registros en el almacenamiento local
- Útil para práctica preventiva y ejercicios de relajación rutinarios

##### Nuevo Botón UI (líneas 259-296)
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
          const Icon(
            Icons.air,
            color: Colors.white,
            size: 28,
          ),
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

**Características del Diseño**:
- **Color**: Azul (`Colors.blue.shade400`) - diferente al rojo del botón de pánico
- **Forma**: Botón redondeado con `borderRadius` de 30
- **Icono**: `Icons.air` (icono de aire) para representar respiración
- **Efecto visual**: Sombra suave con opacidad 0.3
- **Tamaño**: Padding horizontal 32px, vertical 16px
- **Texto**: "Ejercicios de Respiración" en blanco, negrita, tamaño 18
- **Ubicación**: Debajo del botón SOS principal con separación de 32px
- **Visibilidad condicional**: Solo se muestra cuando `!_isInPanicMode` (no hay episodio activo)

#### 2. Configuración del Proyecto

##### Soporte para Web
- Se habilitó soporte para Flutter Web mediante `flutter config --enable-web`
- Se agregó la plataforma web al proyecto con `flutter create --platforms=web .`

##### Soporte para macOS Desktop
- Se habilitó soporte para macOS mediante `flutter config --enable-macos-desktop`
- Se agregó la plataforma macOS al proyecto con `flutter create --platforms=macos .`

##### Modificación temporal en `pubspec.yaml`
Se comentaron temporalmente los assets de audio para permitir la ejecución sin archivos de audio:
```yaml
# assets:
#   - assets/audio/432hz.wav
#   - assets/audio/528hz.wav
```

**Nota**: Los archivos de audio deben ser agregados posteriormente para habilitar la funcionalidad completa de sonidos calmantes durante los ejercicios.

### Diferencias entre Botón SOS y Botón de Respiración

| Característica | Botón SOS | Botón de Respiración |
|---|---|---|
| **Color** | Rojo → Verde (al activar) | Azul |
| **Forma** | Circular (200x200px) | Redondeado horizontal |
| **Texto** | "SOS" / "TERMINAR" | "Ejercicios de Respiración" |
| **Icono** | Ninguno | Icono de aire |
| **Función** | Registra episodio de pánico | No registra datos |
| **Estadísticas** | Guarda duración y datos | No afecta estadísticas |
| **Estado** | Cambia de modo pánico | Sin cambio de estado |
| **Visibilidad** | Siempre visible | Solo cuando no hay pánico activo |

### Flujo de Usuario

#### Flujo con Botón SOS (existente):
1. Usuario presiona "SOS" → Inicia episodio de pánico
2. Se registra hora de inicio y se genera ID de episodio
3. Navega a `BreathingExerciseScreen`
4. Usuario completa ejercicios
5. Presiona "TERMINAR" → Guarda episodio con duración y estadísticas
6. Actualiza contadores (total y semanal)

#### Flujo con Botón de Respiración (nuevo):
1. Usuario presiona "Ejercicios de Respiración"
2. Navega directamente a `BreathingExerciseScreen`
3. Usuario realiza ejercicios sin presión
4. Al finalizar, regresa a pantalla principal
5. **No se registran datos ni estadísticas**

### Casos de Uso

**Botón SOS**:
- Durante un ataque de pánico o ansiedad severa
- Necesidad de tracking y seguimiento médico
- Requiere documentar el episodio para análisis posterior

**Botón de Respiración**:
- Práctica preventiva diaria
- Relajación antes de dormir
- Ejercicios de mindfulness sin crisis
- Aprender técnicas sin presión de registro

### Archivos Modificados

1. `/lib/screens/home_screen.dart`
   - Agregada función `_startBreathingExercise()`
   - Agregado widget de botón de respiración
   - Ajustado espaciado entre elementos

2. `/pubspec.yaml`
   - Comentados temporalmente assets de audio

### Próximos Pasos Sugeridos

1. **Agregar archivos de audio**:
   - Crear directorio `assets/audio/`
   - Agregar archivos `432hz.wav` y `528hz.wav`
   - Descomentar líneas en `pubspec.yaml`

2. **Posibles mejoras**:
   - Agregar contador de sesiones de práctica (sin pánico)
   - Permitir seleccionar tipo de ejercicio antes de entrar
   - Agregar recordatorios para práctica diaria
   - Implementar streak (días consecutivos de práctica)

3. **Testing**:
   - Probar en dispositivos iOS/Android reales
   - Verificar que audio funcione correctamente en todas plataformas
   - Validar que el botón no aparece durante modo pánico

### Tecnologías Utilizadas

- **Framework**: Flutter 3.38.7
- **Lenguaje**: Dart
- **Plataformas**: Web, macOS (configuradas), iOS y Android (pendientes)
- **Dependencias**:
  - `just_audio`: ^0.9.36 (para sonidos calmantes)
  - `shared_preferences`: ^2.2.2 (almacenamiento local)
  - `cupertino_icons`: ^1.0.8 (iconos iOS)

### Compatibilidad

- ✅ Flutter Web (probado en localhost:8888)
- ✅ macOS Desktop (configurado, requiere Xcode completo)
- ⚠️ iOS (requiere Xcode y simulador)
- ⚠️ Android (requiere Android Studio y SDK)

---

**Desarrollado por**: Claude Code
**Fecha**: 21 de enero de 2026
