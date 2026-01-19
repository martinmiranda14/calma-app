# Calma - Aplicación de Gestión Emocional

Una aplicación móvil y web para ayudar a las personas a gestionar ataques de ansiedad y pánico a través de ejercicios de respiración guiados y música calmante.

## 🌐 Demo en Vivo

**Prueba la aplicación aquí**: https://martinmiranda14.github.io/calma-app/

> **Nota**: Después del primer push, debes habilitar GitHub Pages manualmente en Settings → Pages. Ver [DEPLOYMENT.md](DEPLOYMENT.md) para instrucciones detalladas.

## Características

- **Botón de Pánico (SOS)**: Acceso inmediato a ejercicios de respiración
- **Ejercicios de Respiración Guiados**:
  - Técnica 4-7-8 (respiración calmante)
  - Box Breathing 4-4-4-4 (respiración equilibrada)
  - Respiración 5-5-5 (respiración profunda)
- **Sistema Adaptativo de Intensidad**: Ajusta automáticamente el ejercicio según el nivel de ansiedad
- **Audio Terapéutico**: Tonos puros de 432Hz y 528Hz para calmar
- **Registro de Episodios**: Almacenamiento local de episodios de ansiedad
- **Estadísticas**: Visualización de episodios totales y semanales
- **Privacidad Total**: Todos los datos se almacenan localmente en el dispositivo

## Tecnologías

### Frontend (Flutter)
- **Flutter 3.38.7**: Framework multiplataforma
- **Dart 3.10.7**: Lenguaje de programación
- **just_audio**: Reproducción de audio
- **shared_preferences**: Almacenamiento local

### Backend (Deprecado)
- **NestJS**: Framework Node.js (ya no es necesario)
- **TypeORM**: ORM para bases de datos (ya no es necesario)

## Estructura del Proyecto

```
calma-app/
├── calma_flutter/          # Aplicación Flutter
│   ├── lib/
│   │   ├── main.dart
│   │   ├── screens/
│   │   │   ├── home_screen.dart
│   │   │   └── breathing_exercise_screen.dart
│   │   └── services/
│   │       ├── audio_service.dart
│   │       └── local_storage_service.dart
│   ├── assets/
│   │   └── audio/
│   │       ├── 432hz.wav
│   │       └── 528hz.wav
│   └── pubspec.yaml
├── calma-backend/          # Backend NestJS (deprecado)
├── BREATHING_TECHNIQUES.md
├── CALMING_MUSIC.md
├── LOCAL_STORAGE_MIGRATION.md
└── README.md
```

## Instalación

### Prerrequisitos

- [Flutter](https://flutter.dev/docs/get-started/install) 3.38.7 o superior
- Dart 3.10.7 o superior

### Pasos

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/[tu-usuario]/calma-app.git
   cd calma-app/calma_flutter
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Ejecutar la aplicación**

   **Para Web:**
   ```bash
   flutter run -d web-server --web-port=8080
   ```

   Abre http://localhost:8080 en tu navegador

   **Para Chrome:**
   ```bash
   flutter run -d chrome
   ```

   **Para dispositivo móvil:**
   ```bash
   flutter devices  # Ver dispositivos disponibles
   flutter run      # Ejecutar en el dispositivo seleccionado
   ```

## Uso

1. **Iniciar Ejercicio**: Presiona el botón rojo "SOS" en la pantalla principal
2. **Seguir Instrucciones**: Respira siguiendo las indicaciones en pantalla
3. **Ajustar Intensidad**: Si necesitas más ayuda, presiona "Necesito más ayuda" al finalizar
4. **Finalizar**: Presiona "Ya me siento calmado" cuando te sientas mejor

## Almacenamiento de Datos

La aplicación almacena todos los datos **localmente** en tu dispositivo:

- **Web**: `localStorage` del navegador
- **Android**: `SharedPreferences`
- **iOS**: `NSUserDefaults`

**No se envía ningún dato a servidores externos.**

## Técnicas de Respiración

### 1. Técnica 4-7-8
- Inhalar: 4 segundos
- Retener: 7 segundos
- Exhalar: 8 segundos
- Ciclos: 4

### 2. Box Breathing (4-4-4-4)
- Inhalar: 4 segundos
- Retener: 4 segundos
- Exhalar: 4 segundos
- Pausa: 4 segundos
- Ciclos: 6

### 3. Respiración Profunda (5-5-5)
- Inhalar: 5 segundos
- Retener: 5 segundos
- Exhalar: 5 segundos
- Ciclos: 8

## Audio Terapéutico

- **432 Hz**: Frecuencia natural, conocida por sus propiedades calmantes
- **528 Hz**: Frecuencia de "amor", asociada con sanación y reducción de estrés

## Desarrollo

### Comandos Útiles

```bash
# Hot reload (aplicar cambios sin reiniciar)
flutter pub run build_runner build

# Limpiar build
flutter clean

# Analizar código
flutter analyze

# Ejecutar tests
flutter test

# Build para producción (Web)
flutter build web

# Build para producción (Android)
flutter build apk

# Build para producción (iOS)
flutter build ios
```

### Estructura de Código

- `lib/main.dart`: Punto de entrada de la aplicación
- `lib/screens/`: Pantallas de la aplicación
- `lib/services/`: Servicios (audio, almacenamiento)
- `assets/audio/`: Archivos de audio

## Documentación Adicional

- [BREATHING_TECHNIQUES.md](BREATHING_TECHNIQUES.md): Investigación sobre técnicas de respiración
- [CALMING_MUSIC.md](CALMING_MUSIC.md): Investigación sobre frecuencias de sanación
- [LOCAL_STORAGE_MIGRATION.md](LOCAL_STORAGE_MIGRATION.md): Detalles de la migración a almacenamiento local
- [BUG_FIX_SUMMARY.md](BUG_FIX_SUMMARY.md): Resumen de corrección de bugs
- [TESTING_INSTRUCTIONS.md](TESTING_INSTRUCTIONS.md): Instrucciones de testing

## Privacidad

Esta aplicación respeta completamente tu privacidad:

- ✅ **Todos los datos se almacenan localmente**
- ✅ **No hay seguimiento de usuarios**
- ✅ **No se envía información a servidores**
- ✅ **No requiere cuenta de usuario**
- ✅ **No requiere conexión a internet**
- ✅ **Cumple con GDPR automáticamente**

## Limitaciones Conocidas

1. **Autoplay de Audio**: Algunos navegadores bloquean la reproducción automática de audio
2. **Tamaño de Archivos**: Los archivos de audio son grandes (5MB cada uno)
3. **Sin Sincronización**: Los datos no se sincronizan entre dispositivos

## Mejoras Futuras

- [ ] Pantalla de historial de episodios
- [ ] Gráficos de tendencias
- [ ] Export/Import de datos
- [ ] Más técnicas de respiración
- [ ] Meditaciones guiadas
- [ ] Modo oscuro
- [ ] Recordatorios de práctica

## Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## Contacto

Martín Miranda - [GitHub](https://github.com/[tu-usuario])

## Agradecimientos

- Investigación de técnicas de respiración basada en estudios científicos
- Frecuencias de sanación basadas en investigación sobre terapia de sonido
- Diseño inspirado en principios de UX para aplicaciones de salud mental

---

**Nota**: Esta aplicación NO reemplaza el tratamiento profesional de salud mental. Si experimentas ataques de ansiedad o pánico frecuentes, por favor consulta a un profesional de la salud.
