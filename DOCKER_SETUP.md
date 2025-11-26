# Configuración de Docker Hub con GitHub Actions

## ✅ Workflow Creado

Se ha creado el archivo [`.github/workflows/docker.yml`](file:///home/fernando/2ndoAño/laravel-ci-cd/laravel-ci-demo/.github/workflows/docker.yml) que automáticamente:

- 🔨 Construye la imagen Docker
- 📤 Sube la imagen a Docker Hub
- 🏷️ Etiqueta con `latest`, hash del commit y versiones semánticas

## 📋 Pasos para Configurar

### 1. Crear Token de Acceso en Docker Hub

1. Ve a [Docker Hub](https://hub.docker.com)
2. Login con tu cuenta
3. Click en tu avatar (arriba derecha) → **Account Settings**
4. Ve a **Security** → **New Access Token**
5. Nombre del token: `github-actions`
6. Permisos: **Read, Write, Delete**
7. Click **Generate** y **COPIA EL TOKEN** (solo se muestra una vez)

### 2. Agregar Secrets en GitHub

1. Ve a tu repositorio: `https://github.com/FerdisJ/ci-cd-demo-laravel`
2. Click en **Settings** (pestaña superior)
3. En el menú lateral: **Secrets and variables** → **Actions**
4. Click en **New repository secret**

Agrega estos dos secrets:

#### Secret 1: DOCKERHUB_USERNAME
- **Name:** `DOCKERHUB_USERNAME`
- **Secret:** Tu username de Docker Hub (ej: `ferdisj`)

#### Secret 2: DOCKERHUB_TOKEN
- **Name:** `DOCKERHUB_TOKEN`
- **Secret:** El token que copiaste en el paso 1

### 3. Hacer Commit y Push

```bash
# Agregar los nuevos archivos
git add Dockerfile .dockerignore docker/ .github/workflows/docker.yml

# Commit
git commit -m "Add Docker support and automated build workflow"

# Push a main
git push origin main
```

### 4. Verificar el Workflow

1. Ve a la pestaña **Actions** en tu repositorio GitHub
2. Deberías ver el workflow "Build and Push Docker Image" ejecutándose
3. Una vez completado, ve a Docker Hub: `https://hub.docker.com/r/TU_USERNAME/laravel-ci-demo`

## 🎯 Cómo Funciona

El workflow se ejecuta automáticamente cuando:

- ✅ Haces `push` a la rama `main`
- ✅ Creas un tag con formato `v*` (ej: `v1.0.0`)
- ✅ Lo ejecutas manualmente desde Actions

### Tags Generados

La imagen se etiquetará automáticamente con:

- `latest` - Última versión de main
- `sha-abc1234` - Hash corto del commit
- `v1.0.0` - Si creas un tag semántico
- `main` - Nombre de la rama

## 🚀 Usar la Imagen

Una vez publicada, puedes usar tu imagen:

```bash
# Descargar la imagen
docker pull TU_USERNAME/laravel-ci-demo:latest

# Ejecutar el contenedor
docker run -d -p 8080:80 \
  -e APP_KEY=base64:TU_APP_KEY_AQUI \
  -e DB_CONNECTION=sqlite \
  TU_USERNAME/laravel-ci-demo:latest

# Acceder a la aplicación
open http://localhost:8080
```

## 📝 Crear Releases con Tags

Para crear versiones específicas:

```bash
# Crear un tag
git tag -a v1.0.0 -m "Primera versión estable"

# Subir el tag
git push origin v1.0.0
```

Esto disparará el workflow y creará una imagen con tag `v1.0.0` en Docker Hub.

## 🔍 Troubleshooting

### Error: "unauthorized: authentication required"
- Verifica que los secrets `DOCKERHUB_USERNAME` y `DOCKERHUB_TOKEN` estén correctamente configurados
- Asegúrate de usar un **Access Token**, no tu password

### Error: "denied: requested access to the resource is denied"
- El token debe tener permisos de **Write**
- Verifica que el username sea correcto

### La imagen no aparece en Docker Hub
- Verifica que el workflow haya completado exitosamente en la pestaña Actions
- Revisa los logs del paso "Build and push Docker image"
