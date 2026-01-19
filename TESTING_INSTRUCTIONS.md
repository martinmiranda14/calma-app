# Instrucciones de Testing - Calma App

## Cambio Realizado

**Problema reportado**: La animación se quedaba pegada en "Prepárate" con el número 1 cuando se iniciaba el audio.

**Causa**: La función `_startBreathingExercise()` tenía un `await` que bloqueaba la ejecución hasta que el audio terminara de cargar.

**Solución**: Eliminé el `await` para que el audio se cargue en paralelo sin bloquear la animación.

---

## Cómo Probar el Fix

### 1. Recargar la aplicación

La aplicación está corriendo en: http://localhost:8080

**Opción A**: Refrescar el navegador (F5 o Cmd+R)

**Opción B**: En la terminal de Flutter, presionar `r` para hot reload

### 2. Secuencia de Testing

1. **Abrir** http://localhost:8080 en el navegador
2. **Click** en el botón rojo "¡NECESITO CALMARME!"
3. **Observar** la secuencia esperada:
   - Pantalla de "Prepárate" con countdown: 3, 2, 1
   - **Después del 1**, debe cambiar automáticamente a:
     - "Inhala profundamente" con countdown: 4, 3, 2, 1
     - Círculo debe expandirse (animación de inhalar)
   - Luego "Retén la respiración" (7 segundos)
   - Luego "Exhala lentamente" (8 segundos, círculo se contrae)
   - Se repite 4 veces

### 3. Verificar Audio

- El audio de 432Hz debe comenzar a reproducirse automáticamente
- **Nota**: Algunos navegadores pueden bloquear autoplay de audio
  - Si el audio no se escucha, verifica en la consola del navegador (F12)
  - Puede requerir interacción del usuario primero

### 4. Ver Logs de Debug

Para verificar qué está pasando internamente:

1. **Abrir DevTools del navegador**: F12 (Chrome/Edge) o Cmd+Option+I (Mac)
2. **Ir a la pestaña Console**
3. **Click** en el botón de pánico
4. **Buscar logs** que empiezan con `[DEBUG]`:

Logs esperados:
```
[DEBUG] Iniciando ejercicio de respiración
[DEBUG] Iniciando audio 432Hz
[DEBUG] Llamando a _startBreathingCycle
[DEBUG] _startBreathingCycle - ciclo 0 de 4
[DEBUG] Iniciando fase de inhalación
[DEBUG] _startPhase: Inhala profundamente - duración: 4 segundos
[DEBUG] Ejecutando callback onStart
```

### 5. Probar Botón "Necesito más ayuda"

Durante el ejercicio:

1. **Click** en "Necesito más ayuda" (botón naranja)
2. **Verificar** que:
   - Cambia la técnica de respiración (a Box Breathing o 5-5-5)
   - El audio cambia a 528Hz
   - La animación continúa sin problemas

---

## Problemas Conocidos y Soluciones

### Problema: Audio no se escucha

**Posibles causas**:
1. Navegador bloquea autoplay
2. Archivos de audio no se cargaron correctamente
3. Volumen del sistema está bajo

**Verificación**:
- Abrir F12 → Console
- Buscar mensajes de error de audio
- Verificar que los archivos están en `assets/audio/`:
  ```bash
  ls -lh calma_flutter/assets/audio/
  ```

**Solución temporal**:
- Desactivar el audio con el botón de volumen (esquina superior derecha)
- O cambiar `_audioEnabled = true;` a `false` en línea 24 de `breathing_exercise_screen.dart`

### Problema: Animación aún se queda pegada

**Verificación**:
1. Ver logs de debug en consola
2. Identificar en qué punto se detiene

**Si se detiene en "Prepárate"**:
- Verificar que el countdown inicial esté funcionando
- Revisar si hay errores en consola

**Si se detiene al cambiar a "Inhala"**:
- El problema puede ser con el `AnimationController`
- Verificar que no hay excepciones

### Problema: Los botones no responden

**Causa posible**: Conflicto de timers

**Solución**:
- Hacer hot restart en lugar de hot reload: presionar `R` (mayúscula) en terminal de Flutter

---

## Comandos Útiles

### Hot Reload (aplicar cambios rápido)
En la terminal de Flutter, presionar: `r`

### Hot Restart (reinicio completo)
En la terminal de Flutter, presionar: `R`

### Limpiar y reconstruir
```bash
cd calma_flutter
flutter clean
flutter pub get
flutter run -d web-server --web-port=8080
```

### Ver logs detallados
Los `print()` en el código de Dart aparecerán en:
- Terminal de Flutter (stdout)
- Consola del navegador (F12 → Console)

---

## Resultados Esperados

### ✅ Comportamiento Correcto

- Countdown inicial: 3 → 2 → 1
- Transición inmediata a "Inhala profundamente"
- Círculo se expande suavemente
- Audio comienza a reproducirse (432Hz)
- Countdown de inhalación: 4 → 3 → 2 → 1
- Transición a "Retén la respiración"
- Transición a "Exhala lentamente"
- Círculo se contrae
- Se repite el ciclo 4 veces
- Botones responden correctamente

### ❌ Comportamiento Incorrecto (BUG)

- Se queda en "Prepárate" con número 1
- No pasa a la fase de inhalación
- Animación no se inicia
- Pantalla congelada

---

## Reporte de Bugs

Si encuentras un bug:

1. **Abrir F12 → Console**
2. **Copiar todos los logs** (especialmente los que empiezan con `[DEBUG]` o errores en rojo)
3. **Describir**:
   - Qué estabas haciendo
   - Qué esperabas que pasara
   - Qué pasó en realidad
   - Screenshots si es posible

4. **Información del navegador**:
   - Navegador y versión (ej: Chrome 121)
   - Sistema operativo

---

## Próximos Tests

Una vez que el ejercicio de respiración funcione correctamente:

1. **Test de integración completa**:
   - Click en botón de pánico
   - Completar ejercicio entero
   - Verificar que regresa a pantalla principal
   - Verificar que registra el episodio

2. **Test de audio**:
   - Verificar que 432Hz suena correctamente
   - Cambiar a 528Hz y verificar el cambio
   - Silenciar y des-silenciar

3. **Test de intensidad**:
   - Nivel 1: Técnica 4-7-8
   - Nivel 2: Box Breathing 4-4-4-4
   - Nivel 3: Respiración 5-5-5

---

**Última actualización**: 19 de enero de 2026
**Autor**: Claude Code Assistant
