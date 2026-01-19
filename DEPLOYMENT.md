# Guía de Deployment - Calma App

## GitHub Pages - Deployment Automático

La aplicación Calma está configurada para desplegarse automáticamente en GitHub Pages cada vez que se hace push a la rama `main`.

---

## Configuración Actual

### GitHub Actions Workflow

**Archivo**: `.github/workflows/deploy.yml`

Este workflow:
1. Se ejecuta automáticamente en cada push a `main`
2. Instala Flutter 3.38.7
3. Construye la aplicación para producción web
4. Despliega el build a la rama `gh-pages`

### URL de la Aplicación

Una vez que el workflow se ejecute por primera vez (lo cual sucederá automáticamente), la aplicación estará disponible en:

**https://martinmiranda14.github.io/calma-app/**

---

## Habilitar GitHub Pages (Paso Manual Único)

Después de que el workflow se ejecute por primera vez y cree la rama `gh-pages`, debes habilitar GitHub Pages manualmente:

### Opción 1: Desde la Web (Recomendado)

1. Ve a https://github.com/martinmiranda14/calma-app
2. Click en **Settings** (Configuración)
3. En el menú lateral, click en **Pages**
4. En **Source**, selecciona:
   - Branch: `gh-pages`
   - Folder: `/` (root)
5. Click en **Save**
6. Espera unos minutos y la app estará disponible en: https://martinmiranda14.github.io/calma-app/

### Opción 2: Desde la Terminal

```bash
# Después de que el workflow cree la rama gh-pages
gh api repos/martinmiranda14/calma-app/pages -X POST \
  --raw-field 'source[branch]=gh-pages' \
  --raw-field 'source[path]=/'
```

---

## Verificar el Deployment

### 1. Ver el Estado del Workflow

```bash
# Ver workflows
gh workflow list

# Ver runs del workflow de deployment
gh run list --workflow=deploy.yml

# Ver detalles de la última ejecución
gh run view
```

O visita: https://github.com/martinmiranda14/calma-app/actions

### 2. Verificar la Rama gh-pages

```bash
# Ver todas las ramas
git branch -a

# Debería aparecer: remotes/origin/gh-pages
```

### 3. Acceder a la Aplicación

Una vez habilitado GitHub Pages, la app estará en:
https://martinmiranda14.github.io/calma-app/

---

## Proceso de Deployment Automático

Cada vez que hagas `git push origin main`:

```
1. Push a main
   ↓
2. GitHub Actions se activa automáticamente
   ↓
3. Instala Flutter
   ↓
4. Ejecuta: flutter build web --release
   ↓
5. Despliega el build/ a gh-pages
   ↓
6. GitHub Pages actualiza la app
   ↓
7. App disponible en https://martinmiranda14.github.io/calma-app/
```

**Tiempo estimado**: 2-3 minutos desde el push hasta que la app se actualiza.

---

## Build Local para Testing

Si quieres probar el build de producción localmente antes de hacer push:

```bash
cd calma_flutter

# Build para producción
flutter build web --release --base-href "/calma-app/"

# Servir el build localmente
python3 -m http.server 8000 --directory build/web

# O con PHP
php -S localhost:8000 -t build/web

# Abre: http://localhost:8000
```

---

## Actualizar la Aplicación

Para actualizar la app en producción:

```bash
# 1. Hacer cambios en el código
vim calma_flutter/lib/screens/home_screen.dart

# 2. Commit y push
git add .
git commit -m "Update: descripción de los cambios"
git push origin main

# 3. El deployment se ejecuta automáticamente
# Monitorea el progreso en: https://github.com/martinmiranda14/calma-app/actions
```

---

## Troubleshooting

### El workflow falla

1. **Ver logs del workflow**:
   ```bash
   gh run view --log
   ```

2. **Errores comunes**:
   - **Flutter version**: Asegúrate de que el workflow usa Flutter 3.38.7
   - **Dependencies**: Verifica que `pubspec.yaml` tenga todas las dependencias
   - **Build errors**: Asegúrate de que `flutter build web` funciona localmente

### La app no se ve bien en GitHub Pages

1. **Verifica base-href**: Debe ser `/calma-app/` (con slashes al inicio y final)
2. **Cache del navegador**: Haz hard refresh (Ctrl+Shift+R o Cmd+Shift+R)
3. **Espera propagación**: GitHub Pages puede tardar 1-2 minutos en actualizar

### Los archivos de audio no se cargan

**Problema**: Los archivos `.wav` son grandes (5MB cada uno) y pueden causar lentitud.

**Solución temporal**: Los archivos ya están en el gitignore, pero si necesitas incluirlos:

```bash
# Eliminar archivos de audio del gitignore
sed -i '' '/\*.wav/d' .gitignore

# Agregar archivos de audio
git add calma_flutter/assets/audio/*.wav
git commit -m "Add audio files"
git push origin main
```

**Solución permanente**: Convertir WAV a MP3:

```bash
# Instalar ffmpeg
brew install ffmpeg  # macOS
# sudo apt install ffmpeg  # Linux

# Convertir archivos
cd calma_flutter/assets/audio/
ffmpeg -i 432hz.wav -b:a 128k 432hz.mp3
ffmpeg -i 528hz.wav -b:a 128k 528hz.mp3

# Actualizar código para usar .mp3 en lugar de .wav
```

---

## Alternativas a GitHub Pages

Si GitHub Pages no funciona para tu caso, aquí hay alternativas:

### 1. Netlify (Recomendado)

**Ventajas**: Build automático, dominios custom gratis, CDN global

```bash
# Instalar Netlify CLI
npm install -g netlify-cli

# Deploy
cd calma_flutter
flutter build web --release
netlify deploy --prod --dir=build/web
```

**O conectar con GitHub**: https://app.netlify.com/start

### 2. Vercel

**Ventajas**: Deploy automático desde GitHub, muy rápido

```bash
# Instalar Vercel CLI
npm install -g vercel

# Deploy
cd calma_flutter
flutter build web --release
vercel --prod
```

**O conectar con GitHub**: https://vercel.com/new

### 3. Firebase Hosting

**Ventajas**: Integración con otros servicios de Firebase

```bash
# Instalar Firebase CLI
npm install -g firebase-tools

# Login y configurar
firebase login
firebase init hosting

# Deploy
cd calma_flutter
flutter build web --release
firebase deploy --only hosting
```

### 4. GitHub Releases (Solo archivos estáticos)

```bash
# Crear release con los archivos del build
cd calma_flutter
flutter build web --release
cd build/web
zip -r ../../calma-app-web.zip .
cd ../..

# Subir a GitHub Releases
gh release create v1.0.0 calma-app-web.zip \
  --title "Calma App v1.0.0" \
  --notes "Primera versión de Calma App"
```

---

## Monitoreo y Analytics

### Agregar Google Analytics (Opcional)

1. Crear propiedad en Google Analytics
2. Obtener el ID de medición (G-XXXXXXXXXX)
3. Agregar a `calma_flutter/web/index.html`:

```html
<head>
  <!-- Google Analytics -->
  <script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
  <script>
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
    gtag('config', 'G-XXXXXXXXXX');
  </script>
</head>
```

### Plausible Analytics (Alternativa privada)

```html
<head>
  <script defer data-domain="martinmiranda14.github.io" src="https://plausible.io/js/script.js"></script>
</head>
```

---

## Dominio Personalizado (Opcional)

Si quieres usar un dominio custom como `calma-app.com`:

1. **Compra un dominio** (Namecheap, Google Domains, etc.)

2. **Configura DNS**:
   ```
   Type: CNAME
   Name: www
   Value: martinmiranda14.github.io

   Type: A
   Name: @
   Value: 185.199.108.153
   Value: 185.199.109.153
   Value: 185.199.110.153
   Value: 185.199.111.153
   ```

3. **Agrega el dominio en GitHub**:
   - Settings → Pages → Custom domain
   - Ingresa: `calma-app.com`
   - Espera verificación DNS

4. **Actualiza base-href**:
   ```yaml
   # .github/workflows/deploy.yml
   flutter build web --release --base-href "/"
   ```

---

## Métricas de Deployment

### Tamaño del Build

```bash
cd calma_flutter
flutter build web --release
du -sh build/web
```

**Tamaño típico**: ~5-10 MB (sin archivos de audio grandes)

### Optimizaciones de Build

```bash
# Build optimizado con web renderers
flutter build web --release --web-renderer canvaskit

# Build con tree-shaking agresivo
flutter build web --release --tree-shake-icons

# Build con obfuscación (para proteger código)
flutter build web --release --obfuscate --split-debug-info=debug-info/
```

---

## Próximos Pasos

1. ✅ **Espera 2-3 minutos** para que el workflow se ejecute
2. ✅ **Ve a Settings → Pages** y habilita GitHub Pages con rama `gh-pages`
3. ✅ **Accede a** https://martinmiranda14.github.io/calma-app/
4. ✅ **Comparte el link** con otros para probar la app

---

**Última actualización**: 19 de enero de 2026
**Autor**: Claude Code Assistant
