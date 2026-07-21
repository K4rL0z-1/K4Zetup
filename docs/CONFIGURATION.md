# Archivos de Configuración - K4zetup

## Visión General

K4zetup utiliza archivos de texto para definir qué paquetes y extensiones instalar. Estos archivos son fácilmente editables para personalizar la instalación.

---

## Archivos de Configuración

### 1. `system-packages.txt`

**Ubicación**: `modules/01-apps/system-packages.txt`

**Propósito**: Define los paquetes del sistema a instalar con apt.

**Contenido Actual**:
```
curl
git
fastfetch
wget
blueman
vlc
```

**Formato**:
- Un paquete por línea
- Líneas vacías se ignoran
- Comentarios con `#` al inicio de línea

**Agregar un Paquete**:
```bash
echo "nuevo-paquete" >> modules/01-apps/system-packages.txt
```

**Ejemplo con Comentarios**:
```
# Herramientas de red
curl
wget

# Sistema
git
fastfetch

# Multimedia
vlc

# Bluetooth
blueman

# editor
nano
```

---

### 2. `flatpak-apps.txt`

**Ubicación**: `modules/01-apps/flatpak-apps.txt`

**Propósito**: Define las aplicaciones Flatpak a instalar desde Flathub.

**Contenido Actual**:
```
org.vinegarhq.Sober
com.discordapp.Discord
```

**Formato**:
- Un ID de aplicación por línea
- IDs en formato reverse domain (ej: `com.empresa.App`)
- Líneas vacías y comentarios se ignoran

**Agregar una App**:
```bash
echo "com.empresa.app" >> modules/01-apps/flatpak-apps.txt
```

**Encontrar IDs de Apps**:
```bash
# Buscar en Flathub
flatpak search "nombre-app"

# O visitar: https://flathub.org
```

**Ejemplo con Categorías**:
```
# Comunicación
com.discordapp.Discord
org.mozilla.firefox

# Desarrollo
com.visualstudio.code
io.dbeaver.DBeaverCommunity

# Multimedia
com.spotify.Client
org.videolan.VLC

# Juegos
com.valvesoftware.Steam
```

---

### 3. `vscode-extensions.txt`

**Ubicación**: `modules/02-dev/vscode-extensions.txt`

**Propósito**: Define las extensiones de Visual Studio Code a instalar.

**Contenido Actual**:
```
vscodevim.vim
teabyii.ayu
ritwickdey.LiveServer
esbenp.prettier-vscode
PKief.material-icon-theme
miguelsolorio.fluent-icons
formulahendry.auto-rename-tag
formulahendry.auto-close-tag
formulahendry.auto-complete-tag
xabikos.JavaScriptSnippets
```

**Formato**:
- Un ID de extensión por línea
- Formato: `autor.nombre-extension`
- Se obtiene desde VSCode Marketplace

**Agregar una Extensión**:
```bash
echo "autor.extension" >> modules/02-dev/vscode-extensions.txt
```

**Encontrar IDs de Extensiones**:
1. Buscar en https://marketplace.visualstudio.com/
2. Copiar el ID de la extensión
3. O usar VSCode: `code --list-extensions`

**Ejemplo con Categorías**:
```
# Productividad
vscodevim.vim
yzhang.markdown-all-in-one

# Temas
teabyii.ayu
PKief.material-icon-theme

# Linting y Formateo
esbenp.prettier-vscode
dbaeumer.vscode-eslint

# HTML/CSS
ritwickdey.LiveServer
formulahendry.auto-close-tag

# JavaScript
xabikos.JavaScriptSnippets
dsznajder.es7-react-js-snippets

# Python
ms-python.python
ms-python.vscode-pylance

# Git
eamodio.gitlens
```

---

## Crear Nuevos Archivos de Configuración

### Para un Nuevo Módulo

1. Crear archivo de texto en el directorio del módulo:
```bash
touch modules/XX-modulo/nueva-config.txt
```

2. Agregar contenido (un elemento por línea):
```bash
cat > modules/XX-modulo/nueva-config.txt << 'EOF'
elemento-1
elemento-2
# comentario
elemento-3
EOF
```

3. Actualizar el script del módulo para leer el archivo:
```bash
mapfile -t items < <(clean_list "$MODULES_DIR/XX-modulo/nueva-config.txt")
```

---

## Sintaxis de Archivos de Texto

### Formato General

```bash
# Esto es un comentario
# Las líneas vacías se ignoran

# Elemento 1
elemento-1

# Elemento 2
elemento-2

  # Comentario con indentación (también se ignora)
  elemento-3
```

### Reglas

| Regla | Ejemplo |
|-------|---------|
| Un elemento por línea | `curl` |
| Comentarios con `#` | `# Esto es un comentario` |
| Líneas vacías se ignoran | (línea en blanco) |
| Espacios al inicio/final se ignoran | `  curl  ` → `curl` |
| No usar comas ni separadores | ❌ `curl, git, wget` |

### Función `clean_list()`

La función que procesa estos archivos:

```bash
clean_list() {
    grep -vE '^\s*#|^\s*$' "$1" 2>/dev/null || true
}
```

**Explicación**:
- `^\s*#`: Excluye líneas que empiezan con # (opcionalmente con espacios)
- `^\s*$`: Excluye líneas vacías
- `2>/dev/null`: Suprime errores si el archivo no existe
- `|| true`: Evita error si grep no encuentra nada

---

## Configuración de Scripts

### Variables Editables en Scripts

Algunos valores pueden editarse directamente en los scripts:

#### Versión de Node.js (`03-nodejs.sh`)

```bash
nvm install 24  # Cambiar 24 por la versión deseada
```

#### URL de Descarga

```bash
# VSCode (02-vscode.sh)
"https://go.microsoft.com/fwlink/?LinkID=760868"

# Steam (01-steam.sh)
"https://cdn.akamai.steamstatic.com/client/installer/steam.deb"
```

#### Versión de nvm (`03-nodejs.sh`)

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh | bash
# Cambiar v0.40.6 por la versión deseada
```

---

## Ejemplo: Configuración Completa Personalizada

### Archivo `system-packages.txt`

```bash
# ============================================
# Paquetes del Sistema - K4zetup
# ============================================

# Herramientas de red
curl
wget
openssh-client

# Sistema
git
fastfetch
htop
tree

# Multimedia
vlc
mpv

# Bluetooth
blueman

# Compresión
zip
unzip
p7zip-full

# Otros
neofetch
cmatrix
```

### Archivo `flatpak-apps.txt`

```bash
# ============================================
# Apps Flatpak - K4zetup
# ============================================

# Navegadores
org.mozilla.firefox
com.brave.Browser

# Comunicación
com.discordapp.Discord
com.slack.Slack
org.telegram.desktop

# Desarrollo
com.visualstudio.code
io.dbeaver.DBeaverCommunity

# Multimedia
com.spotify.Client
com.obsproject.Studio

# Productividad
com.todoist.Todoist
org.notion.desktop

# Juegos
com.valvesoftware.Steam
com.heroicgameslauncher.hgl
```

### Archivo `vscode-extensions.txt`

```bash
# ============================================
# Extensiones VSCode - K4zetup
# ============================================

# Productividad
vscodevim.vim
yzhang.markdown-all-in-one

# Temas
teabyii.ayu
PKief.material-icon-theme
miguelsolorio.fluent-icons

# Formateo
esbenp.prettier-vscode
editorconfig.editorconfig

# HTML/CSS
ritwickdey.LiveServer
formulahendry.auto-close-tag
formulahendry.auto-rename-tag

# JavaScript/TypeScript
xabikos.JavaScriptSnippets
dsznajder.es7-react-js-snippets
bradlc.vscode-tailwindcss

# Python
ms-python.python
ms-python.vscode-pylance

# Git
eamodio.gitlens

# Docker
ms-azuretools.vscode-docker
```

---

## Solución de Problemas

### Problema: Archivo no se lee

**Verificar**:
```bash
# Comprobar que el archivo existe
ls -la modules/01-apps/system-packages.txt

# Comprobar contenido
cat modules/01-apps/system-packages.txt
```

**Solución**:
- Verificar ruta correcta en el script
- Asegurar que no hay errores de permisos

### Problema: Paquete no se instala

**Verificar**:
```bash
# Probar instalación manual
sudo apt install nombre-paquete

# Buscar paquete exacto
apt search nombre-paquete
```

**Solución**:
- Usar nombre exacto del paquete
- Verificar que el paquete existe en los repositorios

### Problema: App Flatpak no se encuentra

**Verificar**:
```bash
# Buscar app
flatpak search "nombre"

# Verificar ID exacto en Flathub
```

**Solución**:
- Usar ID completo (ej: `com.discordapp.Discord`)
- Verificar en https://flathub.org

### Problema: Extensión VSCode no existe

**Verificar**:
```bash
# Listar extensiones instaladas
code --list-extensions

# Buscar en marketplace
```

**Solución**:
- Usar formato exacto: `autor.nombre`
- Buscar en https://marketplace.visualstudio.com/

---

## Mejores Prácticas

1. **Usar comentarios**: Documentar qué hace cada paquete
2. **Organizar por categorías**: Facilita mantenimiento
3. **Probar cambios**: Ejecutar scripts individualmente antes de integrar
4. **Respaldar**: Guardar copia de archivos personalizados
5. **Nombrar descriptivamente**: Usar nombres claros en comentarios
