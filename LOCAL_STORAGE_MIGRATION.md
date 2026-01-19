# Migración a Almacenamiento Local - Calma App

**Fecha**: 19 de enero de 2026

---

## Resumen del Cambio

La aplicación Calma ha sido migrada de un modelo cliente-servidor (Flutter + API REST) a una aplicación completamente local que almacena todos los datos en el dispositivo del usuario.

---

## Motivación

El usuario solicitó explícitamente que la aplicación solo almacene datos localmente y no tenga API:

> "quiero que solo almacene datos localmente y que no tenga api"

### Ventajas del Almacenamiento Local:

1. **Privacidad Total**: Los datos de episodios de ansiedad nunca salen del dispositivo
2. **Sin Latencia**: No hay esperas de red, respuesta instantánea
3. **Funciona Offline**: La aplicación funciona sin conexión a internet
4. **Simplicidad**: No requiere mantener un servidor backend
5. **Costo Cero**: No hay costos de hosting o infraestructura
6. **Datos Sensibles**: Información de salud mental permanece privada

---

## Cambios Implementados

### 1. Nueva Dependencia: `shared_preferences`

**Archivo**: `pubspec.yaml`

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  just_audio: ^0.9.36
  shared_preferences: ^2.2.2  # Nueva dependencia
```

**Qué hace**: `shared_preferences` es un plugin de Flutter que permite guardar datos clave-valor de forma persistente en el dispositivo.

---

### 2. Nuevo Servicio: `LocalStorageService`

**Archivo**: `lib/services/local_storage_service.dart` (NUEVO)

Este servicio maneja todo el almacenamiento y recuperación de episodios de pánico.

#### Clase `PanicEpisode`

```dart
class PanicEpisode {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final int? durationSeconds;
  final int intensityLevel;
}
```

**Atributos**:
- `id`: Identificador único del episodio (timestamp en milisegundos)
- `startTime`: Momento en que comenzó el episodio
- `endTime`: Momento en que terminó el episodio (opcional)
- `durationSeconds`: Duración del episodio en segundos
- `intensityLevel`: Nivel de intensidad (1, 2 o 3)

#### Métodos Principales

| Método | Descripción | Uso |
|--------|-------------|-----|
| `saveEpisode()` | Guarda un episodio de pánico | Cuando el usuario completa ejercicio |
| `getEpisodes()` | Obtiene todos los episodios | Para historial completo |
| `getRecentEpisodes()` | Episodios de últimos 7 días | Para estadísticas semanales |
| `getEpisodeCount()` | Cuenta total de episodios | Para dashboard |
| `getWeeklyEpisodeCount()` | Episodios de esta semana | Para tendencias |
| `getAverageDuration()` | Duración promedio | Para análisis |
| `clearAllEpisodes()` | Borra todos los datos | Para reset o testing |
| `exportData()` | Exporta como JSON | Para backup |
| `importData()` | Importa desde JSON | Para restaurar backup |

#### Ejemplo de Uso

```dart
final storage = LocalStorageService();

// Guardar un episodio
final episode = PanicEpisode(
  id: DateTime.now().millisecondsSinceEpoch.toString(),
  startTime: startTime,
  endTime: DateTime.now(),
  durationSeconds: 120,
  intensityLevel: 1,
);
await storage.saveEpisode(episode);

// Obtener estadísticas
final totalCount = await storage.getEpisodeCount();
final weeklyCount = await storage.getWeeklyEpisodeCount();
```

---

### 3. Actualización del `HomeScreen`

**Archivo**: `lib/screens/home_screen.dart`

#### Nuevos Campos de Estado

```dart
String? _currentEpisodeId;
int _totalEpisodes = 0;
int _weeklyEpisodes = 0;
final LocalStorageService _storage = LocalStorageService();
```

#### Flujo de Guardado de Episodios

**Antes** (sin almacenamiento):
```dart
void _finishEpisode() {
  setState(() {
    _isInPanicMode = false;
    _episodeStartTime = null;
  });
  // Aquí más adelante guardaremos el episodio en el backend
}
```

**Después** (con almacenamiento local):
```dart
Future<void> _finishEpisode() async {
  final endTime = DateTime.now();
  final durationSeconds = endTime.difference(_episodeStartTime!).inSeconds;

  // Crear y guardar el episodio
  final episode = PanicEpisode(
    id: _currentEpisodeId!,
    startTime: _episodeStartTime!,
    endTime: endTime,
    durationSeconds: durationSeconds,
    intensityLevel: 1,
  );

  await _storage.saveEpisode(episode);

  // Recargar estadísticas
  await _loadStatistics();

  // Mostrar confirmación
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Episodio guardado. Duración: ${_formatDuration(durationSeconds)}'),
      backgroundColor: Colors.green.shade600,
    ),
  );
}
```

#### Nueva UI: Tarjeta de Estadísticas

Ahora la pantalla principal muestra:

```dart
// Estadísticas en la parte superior
if (_totalEpisodes > 0)
  Card(
    child: Row(
      children: [
        Column(
          children: [
            Text('$_totalEpisodes'),  // Total de episodios
            Text('Total'),
          ],
        ),
        Column(
          children: [
            Text('$_weeklyEpisodes'),  // Episodios esta semana
            Text('Esta semana'),
          ],
        ),
      ],
    ),
  ),
```

**Logs de Debug**:
```dart
print('[HomeScreen] Episodio iniciado: $episodeId');
print('[HomeScreen] Episodio finalizado: ${episode.id}');
print('[HomeScreen] Duración: $durationSeconds segundos');
print('[HomeScreen] Estadísticas cargadas: $_totalEpisodes total, $_weeklyEpisodes esta semana');
```

---

## Verificación de la Migración

### Backend API - Status: ✅ NO HAY REFERENCIAS

Búsqueda realizada en `lib/`:
```bash
grep -r "http://localhost:3001\|http.*api\|fetch.*http" lib/
```

**Resultado**: No se encontraron archivos con referencias a APIs externas.

### Dependencias HTTP - Status: ✅ NINGUNA

**pubspec.yaml** solo contiene:
- `just_audio`: Para reproducción de audio (archivos locales)
- `shared_preferences`: Para almacenamiento local
- `cupertino_icons`: Iconos de iOS

**NO hay**:
- `http` package
- `dio` package
- `retrofit` package
- Ningún otro cliente HTTP

---

## Cómo Funciona el Almacenamiento

### Formato de Datos

Los episodios se guardan en formato JSON en SharedPreferences:

```json
[
  {
    "id": "1737287640000",
    "startTime": "2026-01-19T12:00:40.000Z",
    "endTime": "2026-01-19T12:03:20.000Z",
    "durationSeconds": 160,
    "intensityLevel": 1
  },
  {
    "id": "1737288000000",
    "startTime": "2026-01-19T12:06:40.000Z",
    "endTime": "2026-01-19T12:09:10.000Z",
    "durationSeconds": 150,
    "intensityLevel": 2
  }
]
```

### Ubicación de los Datos

Los datos se almacenan en:

- **Web (Chrome/Firefox/Safari)**: `localStorage` del navegador
- **Android**: `SharedPreferences` (archivo XML en `/data/data/com.example.calma_flutter/shared_prefs/`)
- **iOS**: `NSUserDefaults` (plist file)
- **Windows**: Registro de Windows
- **macOS**: `NSUserDefaults`
- **Linux**: Archivo en `~/.config/`

### Persistencia

- Los datos **persisten** entre sesiones
- Los datos **sobreviven** reinicios de la aplicación
- Los datos **NO se sincronizan** entre dispositivos (solo local)
- Los datos **permanecen** aunque la app se cierre completamente

---

## Testing

### Test 1: Guardar un Episodio

**Pasos**:
1. Abrir http://localhost:8080
2. Click en botón "SOS"
3. Completar ejercicio de respiración
4. Click en "Ya me siento calmado"

**Resultado Esperado**:
- Mensaje verde: "Episodio guardado. Duración: X min Y seg"
- Tarjeta de estadísticas aparece mostrando "1 Total, 1 Esta semana"
- Log en consola: `[LocalStorage] Episodio guardado: [id]`

### Test 2: Persistencia de Datos

**Pasos**:
1. Guardar 2-3 episodios
2. Cerrar el navegador completamente
3. Reabrir http://localhost:8080

**Resultado Esperado**:
- Las estadísticas se cargan automáticamente
- La tarjeta muestra el total correcto de episodios
- Log en consola: `[HomeScreen] Estadísticas cargadas: X total, Y esta semana`

### Test 3: Ver Datos en Browser DevTools

**Pasos**:
1. Abrir F12 (DevTools)
2. Ir a pestaña "Application" (Chrome) o "Storage" (Firefox)
3. Expandir "Local Storage"
4. Click en http://localhost:8080
5. Buscar clave: `flutter.panic_episodes`

**Resultado Esperado**:
- Ver array JSON con todos los episodios guardados

### Test 4: Limpiar Datos

**Desde Código**:
```dart
final storage = LocalStorageService();
await storage.clearAllEpisodes();
```

**Desde Browser**:
1. F12 → Application → Local Storage
2. Right-click en http://localhost:8080
3. "Clear"
4. Recargar página

---

## Logs de Debug

Para monitorear el funcionamiento del almacenamiento local:

```
[HomeScreen] Estadísticas cargadas: 0 total, 0 esta semana
[HomeScreen] Episodio iniciado: 1737287640000
[DEBUG] Iniciando ejercicio de respiración
[DEBUG] Iniciando audio 432Hz
[DEBUG] _startBreathingCycle - ciclo 1 de 4
[HomeScreen] Episodio finalizado: 1737287640000
[HomeScreen] Duración: 160 segundos
[LocalStorage] Episodio guardado: 1737287640000
[LocalStorage] Total episodios: 1
[HomeScreen] Estadísticas cargadas: 1 total, 1 esta semana
```

---

## Limitaciones y Consideraciones

### 1. Límite de Almacenamiento

**Web (LocalStorage)**:
- Límite típico: 5-10 MB
- Calma App: ~1 KB por episodio
- **Capacidad estimada**: ~5000-10000 episodios

**Móvil (SharedPreferences)**:
- Sin límite estricto (depende del espacio disponible)
- **Capacidad práctica**: Ilimitada para este uso

### 2. Sin Sincronización Multi-Dispositivo

- Si el usuario usa la app en múltiples dispositivos, cada uno tendrá su propio historial
- **Solución futura**: Implementar export/import de datos

### 3. Respaldo de Datos

Los datos solo existen en el dispositivo local.

**Recomendaciones**:
- Implementar función de exportar datos
- Permitir al usuario descargar un JSON con todo su historial
- Opción de importar datos desde backup

**Ya implementado**:
```dart
// Exportar datos
final jsonBackup = await storage.exportData();
// Usuario puede guardar este string

// Restaurar datos
await storage.importData(jsonBackup);
```

### 4. Privacidad y GDPR

**Ventajas**:
- ✅ Cumple GDPR automáticamente (datos no salen del dispositivo)
- ✅ No requiere políticas de privacidad complejas
- ✅ No requiere términos de servicio para manejo de datos
- ✅ Usuario tiene control total de sus datos

**Usuario puede**:
- Ver sus datos: DevTools → Application → Local Storage
- Borrar sus datos: Limpiar datos del navegador/app
- Exportar sus datos: Función `exportData()`

---

## Backend NestJS - Status: DEPRECADO

### Estado del Backend

El backend en `calma-backend/` **ya no es necesario** pero se mantiene en el repositorio por si en el futuro se desea:

1. Implementar sincronización en la nube
2. Agregar funcionalidades de análisis de datos
3. Compartir datos con profesionales de salud mental
4. Hacer backup automático en servidor

### Para Detener el Backend

```bash
# Si está corriendo en background
lsof -ti:3001 | xargs kill -9

# O simplemente no iniciarlo
```

El backend no afecta el funcionamiento de la app Flutter.

---

## Migración de Datos Existentes

Si en el futuro hay usuarios con datos en el backend antiguo:

### Paso 1: Exportar desde Backend

```bash
# Endpoint ficticio (si se implementara)
GET http://localhost:3001/panic-episodes/export
```

### Paso 2: Importar a Local Storage

```dart
final storage = LocalStorageService();
await storage.importData(jsonBackupFromBackend);
```

---

## Próximas Mejoras Sugeridas

### 1. Pantalla de Historial

Mostrar lista de todos los episodios con:
- Fecha y hora
- Duración
- Nivel de intensidad
- Gráficos de tendencias

### 2. Función de Export/Import

Agregar botones en la UI:
- "Exportar mis datos" → Descarga JSON
- "Importar datos" → Sube JSON

### 3. Estadísticas Avanzadas

- Promedio de episodios por semana
- Día/hora más frecuentes
- Tendencias (mejorando/empeorando)
- Duración promedio

### 4. Recordatorios

Usar `shared_preferences` para:
- Recordar última vez que practicó
- Sugerencias de práctica preventiva

---

## Archivos Modificados

| Archivo | Tipo de Cambio | Líneas |
|---------|----------------|--------|
| `pubspec.yaml` | Agregada dependencia | 42 |
| `lib/services/local_storage_service.dart` | **NUEVO** | 1-185 |
| `lib/screens/home_screen.dart` | Actualizado | 1-267 |

**Total de líneas nuevas**: ~185 líneas
**Total de líneas modificadas**: ~150 líneas

---

## Conclusión

✅ **Migración Completada**

La aplicación Calma ahora:
1. **Almacena datos localmente** usando `shared_preferences`
2. **No requiere API backend** para funcionar
3. **Muestra estadísticas** de episodios en tiempo real
4. **Persiste datos** entre sesiones
5. **Protege la privacidad** del usuario (datos nunca salen del dispositivo)

**Estado Final**: Producción Ready

La app está lista para uso sin dependencias externas.

---

**Última actualización**: 19 de enero de 2026
**Autor**: Claude Code Assistant
