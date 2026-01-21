# Despliegue en Vercel - Aplicación Calma

**Fecha**: 19 de enero de 2026
**URL de producción**: https://web-eight-pi-96.vercel.app/

---

## Resumen

La aplicación Calma fue desplegada exitosamente en Vercel usando Vercel CLI. La aplicación Flutter web está completamente funcional con todas sus características.

---

## Requisitos Previos

- Cuenta en Vercel (https://vercel.com)
- Vercel CLI instalado globalmente
- Flutter SDK instalado (versión 3.38.7)
- Archivos de audio en `calma_flutter/assets/audio/`
  - 432hz.wav (5MB)
  - 528hz.wav (5MB)

---

## Proceso de Despliegue

### 1. Instalación de Vercel CLI

```bash
npm install -g vercel
```

Versión instalada: `50.4.5`

### 2. Autenticación en Vercel

```bash
vercel login
```

Este comando abre el navegador para iniciar sesión con tu cuenta de Vercel (puede usar GitHub, GitLab, Bitbucket o email).

### 3. Preparación de los Archivos de Audio

Los archivos de audio fueron extraídos desde la rama `gh-pages` del repositorio:

```bash
cd calma_flutter
mkdir -p assets/audio

# Extraer archivos de audio desde gh-pages
git show gh-pages:assets/assets/audio/432hz.wav > assets/audio/432hz.wav
git show gh-pages:assets/assets/audio/528hz.wav > assets/audio/528hz.wav
```

### 4. Build de Flutter para Web

```bash
cd calma_flutter
flutter build web --release
```

**Importante**: El build se hace SIN el flag `--base-href` porque Vercel sirve desde la raíz.

Resultado del build:
- Ubicación: `calma_flutter/build/web`
- Tiempo: ~21 segundos
- Optimizaciones automáticas:
  - MaterialIcons-Regular.otf: reducido 99.5% (de 1.6MB a 8KB)
  - CupertinoIcons.ttf: reducido 99.4% (de 257KB a 1.5KB)

### 5. Despliegue a Vercel

```bash
cd build/web
vercel --prod --yes
```

**Detalles del despliegue**:
- Proyecto Vercel: `martin-mirandas-projects/web`
- Región: Washington, D.C., USA (East) – iad1
- Configuración de máquina: 2 cores, 8 GB RAM
- Archivos desplegados: 36 archivos
- Tiempo de build: ~8-10 segundos

**URLs generadas**:
- URL de producción: https://web-eight-pi-96.vercel.app
- URL de inspección: https://web-emzgoem4d-martin-mirandas-projects.vercel.app

---

## Estructura de Archivos Desplegados

```
build/web/
├── index.html                    # Página principal
├── main.dart.js                  # Código Dart compilado
├── flutter.js                    # Bootstrap de Flutter
├── flutter_service_worker.js     # Service Worker para PWA
├── manifest.json                 # Manifiesto de PWA
├── version.json                  # Información de versión
├── assets/
│   ├── AssetManifest.bin         # Manifiesto de assets
│   ├── AssetManifest.bin.json    # Manifiesto JSON
│   ├── FontManifest.json         # Fuentes
│   ├── NOTICES                   # Licencias
│   ├── assets/
│   │   └── audio/
│   │       ├── 432hz.wav         # 5MB
│   │       └── 528hz.wav         # 5MB
│   ├── fonts/
│   │   └── MaterialIcons-Regular.otf
│   ├── packages/
│   │   └── cupertino_icons/
│   │       └── CupertinoIcons.ttf
│   └── shaders/
│       ├── ink_sparkle.frag
│       └── stretch_effect.frag
├── canvaskit/                    # Motor de renderizado
├── icons/                        # Iconos de la app
└── vercel.json                   # Configuración de Vercel (opcional)

```

---

## Configuración de Vercel

### Archivo vercel.json (Opcional)

Se creó un archivo `vercel.json` en `build/web/` con la siguiente configuración:

```json
{
  "version": 2,
  "builds": [
    {
      "src": "**/*",
      "use": "@vercel/static"
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "/$1"
    }
  ]
}
```

**Nota**: Este archivo es opcional. Vercel detecta automáticamente archivos estáticos.

---

## Verificación del Despliegue

### 1. Verificar que la Aplicación Carga

Accede a: https://web-eight-pi-96.vercel.app/

Debes ver:
- ✅ AppBar con título "Calma"
- ✅ Mensaje "Estoy aquí para ti"
- ✅ Instrucción "¿Sientes ansiedad? Presiona el botón para comenzar"
- ✅ Botón circular rojo grande "SOS"
- ✅ Diseño responsive y limpio

### 2. Probar Funcionalidad

**Test del Botón SOS**:
1. Click en el botón "SOS"
2. Debe cambiar a modo pánico
3. Navegación automática a ejercicios de respiración

**Test de Ejercicios de Respiración**:
1. Debe mostrar animación de respiración
2. Audio de 432Hz debe reproducirse (si el navegador lo permite)
3. Contadores de ciclos deben actualizarse
4. Opciones "Ya me siento calmado" y "Necesito más ayuda"

**Test de Almacenamiento Local**:
1. Completar un ejercicio
2. Ver mensaje de confirmación verde
3. Verificar que aparece tarjeta de estadísticas
4. Cerrar y reabrir la página
5. Las estadísticas deben persistir

### 3. Verificar Logs en Vercel

```bash
# Ver logs del último despliegue
vercel inspect web-emzgoem4d-martin-mirandas-projects.vercel.app --logs

# Redesplegar si es necesario
vercel redeploy web-emzgoem4d-martin-mirandas-projects.vercel.app
```

---

## Problemas Comunes y Soluciones

### Problema 1: Página en Blanco o Solo Muestra "calma_flutter"

**Causa**: Los archivos de JavaScript de Flutter no se cargaron correctamente.

**Solución**:
1. Verificar que el build se hizo correctamente
2. Asegurarse de que NO se usó `--base-href` en el build
3. Redesplegar desde el directorio `build/web`

```bash
cd calma_flutter/build/web
rm -rf .vercel
vercel --prod --yes
```

### Problema 2: Audio No Se Reproduce

**Causa**: Política de autoplay del navegador.

**Solución**:
- Los navegadores modernos bloquean audio automático
- El usuario debe interactuar primero (click en botón SOS)
- La app ya maneja esto correctamente

**Nota en consola**:
```
The AudioContext was not allowed to start. It must be resumed (or created)
after a user gesture on the page.
```

### Problema 3: Archivos de Audio Faltantes

**Causa**: Los archivos .wav están en .gitignore y no se suben a Git.

**Solución**:
```bash
# Extraer desde gh-pages
git show gh-pages:assets/assets/audio/432hz.wav > calma_flutter/assets/audio/432hz.wav
git show gh-pages:assets/assets/audio/528hz.wav > calma_flutter/assets/audio/528hz.wav

# Reconstruir
cd calma_flutter
flutter build web --release
```

### Problema 4: Vercel CLI No Sube Todos los Archivos

**Causa**: Vercel tiene límites de tamaño y cantidad de archivos en deploys directos.

**Solución**:
- Usar integración de GitHub en lugar de Vercel CLI
- O asegurarse de desplegar desde el directorio correcto `build/web`

---

## Actualización de la Aplicación

### Proceso de Actualización

1. **Hacer cambios en el código**:
   ```bash
   cd /Users/martinmirandamejias/Documents/Proyectos/calma-app/calma_flutter
   # Editar archivos...
   ```

2. **Reconstruir la aplicación**:
   ```bash
   flutter build web --release
   ```

3. **Redesplegar a Vercel**:
   ```bash
   cd build/web
   vercel --prod --yes
   ```

4. **Verificar cambios**:
   - Visitar https://web-eight-pi-96.vercel.app/
   - Hacer hard refresh (Ctrl+Shift+R o Cmd+Shift+R)
   - Verificar que los cambios aparecen

### Rollback a Versión Anterior

Si un despliegue tiene problemas:

```bash
# Listar despliegues
vercel ls

# Ver detalles de un despliegue específico
vercel inspect <deployment-url>

# Promover un despliegue anterior a producción
vercel promote <deployment-url>
```

---

## Integración con GitHub (Alternativa Recomendada)

Para futuros despliegues, se recomienda usar la integración de Vercel con GitHub:

### 1. Crear vercel.json en la raíz del proyecto

```json
{
  "buildCommand": "cd calma_flutter && flutter build web --release",
  "outputDirectory": "calma_flutter/build/web",
  "installCommand": "flutter --version",
  "framework": null
}
```

### 2. Conectar Repositorio en Vercel

1. Ir a https://vercel.com/dashboard
2. Click en "Import Project"
3. Seleccionar "Import Git Repository"
4. Elegir `martinmiranda14/calma-app`
5. Configurar:
   - Framework Preset: Other
   - Build Command: `cd calma_flutter && flutter build web --release`
   - Output Directory: `calma_flutter/build/web`
   - Install Command: `flutter pub get`

### 3. Despliegues Automáticos

Con esta configuración:
- Cada push a `main` despliega automáticamente
- Pull requests crean preview deployments
- Rollbacks son más fáciles

---

## Comandos Útiles de Vercel CLI

```bash
# Ver lista de proyectos
vercel projects ls

# Ver lista de despliegues
vercel ls

# Ver logs de un despliegue
vercel logs <deployment-url>

# Inspeccionar despliegue
vercel inspect <deployment-url> --logs

# Redesplegar
vercel redeploy <deployment-url>

# Promover a producción
vercel promote <deployment-url>

# Remover proyecto
vercel remove <project-name>

# Ver aliases
vercel alias ls

# Listar dominios
vercel domains ls

# Ver información del equipo
vercel teams ls
```

---

## Configuraciones Avanzadas

### Variables de Entorno

Si necesitas agregar variables de entorno:

```bash
# Agregar variable
vercel env add API_KEY

# Listar variables
vercel env ls

# Remover variable
vercel env rm API_KEY
```

### Dominios Personalizados

Para usar un dominio personalizado:

```bash
# Agregar dominio
vercel domains add tudominio.com

# Ver configuración de DNS
vercel domains inspect tudominio.com

# Remover dominio
vercel domains rm tudominio.com
```

### Headers Personalizados

Agregar en `vercel.json`:

```json
{
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        },
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        },
        {
          "key": "X-XSS-Protection",
          "value": "1; mode=block"
        }
      ]
    }
  ]
}
```

---

## Monitoreo y Analytics

### Ver Métricas en Vercel Dashboard

1. Ir a https://vercel.com/dashboard
2. Seleccionar proyecto "web"
3. Ver Analytics:
   - Visitantes
   - Tiempo de carga
   - Errores
   - Regiones de usuarios

### Logs en Tiempo Real

```bash
# Ver logs en tiempo real
vercel logs <project-name> --follow

# Filtrar logs por tipo
vercel logs <project-name> --output  # Solo build logs
vercel logs <project-name> --until 1h  # Últimas hora
```

---

## Costo y Límites

### Plan Hobby (Gratis)

- ✅ Despliegues ilimitados
- ✅ Ancho de banda: 100GB/mes
- ✅ Invocaciones serverless: 100GB-hrs
- ✅ Dominios personalizados
- ✅ SSL automático
- ✅ Preview deployments

**Límites**:
- 100GB de ancho de banda
- 100GB-hrs de ejecución serverless
- Sin soporte comercial

Para esta aplicación (Calma):
- Cada visita consume ~10MB (archivos iniciales + audio)
- Con 100GB puedes tener ~10,000 visitas/mes
- Más que suficiente para uso personal o testing

---

## Troubleshooting

### Error: "Too many files"

Si Vercel rechaza el despliegue por muchos archivos:

```bash
# Limpiar archivos innecesarios
flutter clean

# Reconstruir
flutter build web --release

# Desplegar solo build/web
cd build/web
vercel --prod --yes
```

### Error: "Build failed"

Ver logs completos:

```bash
vercel inspect <deployment-url> --logs
```

### Aplicación Lenta

Optimizaciones:

1. **Habilitar compresión**:
   ```json
   {
     "headers": [
       {
         "source": "/(.*)",
         "headers": [
           {
             "key": "Cache-Control",
             "value": "public, max-age=31536000, immutable"
           }
         ]
       }
     ]
   }
   ```

2. **Build con optimizaciones**:
   ```bash
   flutter build web --release --no-tree-shake-icons
   ```

---

## Backup y Recuperación

### Backup del Build

```bash
# Crear backup del build actual
cd calma_flutter
tar -czf calma-build-$(date +%Y%m%d).tar.gz build/web

# Restaurar desde backup
tar -xzf calma-build-20260119.tar.gz
```

### Recuperación desde Vercel

Si pierdes el build local:

1. Descargar desde Vercel:
   ```bash
   vercel download <deployment-url>
   ```

2. O usar el repositorio de Git si está actualizado

---

## Checklist de Despliegue

- [ ] Flutter SDK instalado y actualizado
- [ ] Archivos de audio presentes en `assets/audio/`
- [ ] Build exitoso sin errores
- [ ] Vercel CLI instalado
- [ ] Autenticado en Vercel
- [ ] Despliegue exitoso
- [ ] Aplicación carga correctamente
- [ ] Botón SOS funciona
- [ ] Ejercicios de respiración funcionan
- [ ] Audio se reproduce
- [ ] Almacenamiento local funciona
- [ ] Estadísticas persisten
- [ ] Probado en múltiples navegadores

---

## URLs de Referencia

- **Aplicación**: https://web-eight-pi-96.vercel.app/
- **Dashboard de Vercel**: https://vercel.com/dashboard
- **Documentación de Vercel**: https://vercel.com/docs
- **Repositorio de GitHub**: https://github.com/martinmiranda14/calma-app
- **Flutter Web Docs**: https://docs.flutter.dev/platform-integration/web

---

## Contacto y Soporte

- **Vercel Support**: https://vercel.com/support
- **Flutter Community**: https://flutter.dev/community
- **GitHub Issues**: https://github.com/martinmiranda14/calma-app/issues

---

## Changelog

### v1.0 - 19 de enero de 2026
- ✅ Despliegue inicial en Vercel
- ✅ Migración a almacenamiento local
- ✅ Integración de audio terapéutico
- ✅ Sistema de ejercicios de respiración
- ✅ Sistema adaptativo de intensidad

---

**Última actualización**: 19 de enero de 2026
**Autor**: Claude Code Assistant
**Estado**: ✅ Producción - Funcionando correctamente
