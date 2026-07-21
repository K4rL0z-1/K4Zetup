# Documentación de Módulos - K4zetup

## Visión General

K4zetup organiza las instalaciones en módulos categorizados. Cada módulo contiene scripts y listas de paquetes para una funcionalidad específica.

## Módulo 01: Apps (`01-apps`)

### Propósito

Instalación de aplicaciones base del sistema y software a través de Flatpak.

### Estructura

```
01-apps/
├── scripts/
│   ├── 01-system-packages.sh
│   └── 02-flatpak-apps.sh
├── system-packages.txt
└── flatpak-apps.txt
```

### Scripts

#### `01-system-packages.sh`

- **Función**: Instala paquetes del sistema usando apt
- **Método**: `sudo apt install -y`
- **Archivos dependientes**: `system-packages.txt`
- **Paquetes por defecto**:
  - `curl` - Cliente HTTP
  - `git` - Sistema de control de versiones
  - `fastfetch` - Información del sistema
  - `wget` - Descargador de archivos
  - `blueman` - Gestor Bluetooth
  - `vlc` - Reproductor multimedia

#### `02-flatpak-apps.sh`

- **Función**: Instala aplicaciones Flatpak
- **Método**: `flatpak install -y flathub`
- **Pre-requisitos**: Instala Flatpak automáticamente si no existe
- **Archivos dependientes**: `flatpak-apps.txt`
- **Apps por defecto**:
  - `org.vinegarhq.Sober` - Emulador de Roblox
  - `com.discordapp.Discord` - Cliente de Discord

### Personalización

**Agregar paquetes apt:**

```bash
echo "nuevo-paquete" >> modules/01-apps/system-packages.txt
```

**Agregar apps Flatpak:**

```bash
echo "com.app.id" >> modules/01-apps/flatpak-apps.txt
```

**Formato de archivos:**

```
# Un paquete por línea
paquete-1
paquete-2

# Comentarios con #
# paquete-comentado
```

---

## Módulo 02: Dev (`02-dev`)

### Propósito

Herramientas de desarrollo: editor de código, extensiones y entornos de ejecución.

### Estructura

```
02-dev/
├── scripts/
│   ├── 01-vscode-extensions.sh
│   ├── 02-vscode.sh
│   └── 03-nodejs.sh
└── vscode-extensions.txt
```

### Scripts

#### `01-vscode-extensions.sh`

- **Función**: Instala extensiones de VSCode
- **Método**: `code --install-extension`
- **Pre-requisitos**: VSCode debe estar instalado
- **Archivos dependientes**: `vscode-extensions.txt`
- **Extensiones por defecto**:
  - `vscodevim.vim` - Vim para VSCode
  - `teabyii.ayu` - Tema Ayu
  - `ritwickdey.LiveServer` - Servidor local
  - `esbenp.prettier-vscode` - Formateador de código
  - `PKief.material-icon-theme` - Iconos Material
  - `miguelsolorio.fluent-icons` - Iconos Fluent
  - `formulahendry.auto-rename-tag` - Renombrado automático de tags
  - `formulahendry.auto-close-tag` - Cierre automático de tags
  - `formulahendry.auto-complete-tag` - Autocompletado de tags
  - `xabikos.JavaScriptSnippets` - Snippets de JavaScript
  - `DavidAnson.vscode-markdownlint` - Markdown linting and style checking
  - `yzhang.markdown-all-in-one` - Markdown all in one kit

#### `02-vscode.sh`

- **Función**: Instala Visual Studio Code
- **Método**: Descarga `.deb` directa de Microsoft
- **Pre-requisitos**: `curl`
- **URL de descarga**: `https://go.microsoft.com/fwlink/?LinkID=760868`
- **Proceso**:
  1. Descarga paquete a `/tmp/vscode.deb`
  2. Instala con `apt`
  3. Elimina archivo temporal

#### `03-nodejs.sh`

- **Función**: Instala Node.js mediante nvm
- **Método**: nvm (Node Version Manager)
- **Pre-requisitos**: `curl`
- **Versión por defecto**: Node.js 24
- **Proceso**:
  1. Instala nvm v0.40.6
  2. Carga nvm en el shell actual
  3. Instala Node.js 24

### Personalización

**Agregar extensiones VSCode:**

```bash
echo "autor.nombre-extension" >> modules/02-dev/vscode-extensions.txt
```

**Cambiar versión de Node.js:**
Editar el script `03-nodejs.sh` y cambiar la línea:

```bash
nvm install 24  # Cambiar 24 por la versión deseada
```

---

## Módulo 03: AI (`03-ai`)

### Propósito

Herramientas de inteligencia artificial y productividad asistida.

### Estructura

```
03-ai/
└── scripts/
    └── opencode.sh
```

### Scripts

#### `opencode.sh`

- **Función**: Instala Opencode (herramienta CLI de IA)
- **Método**: Script de instalación oficial
- **Pre-requisitos**: `curl`
- **URL de instalación**: `https://opencode.ai/install`
- **Detección**: Verifica si ya está instalado (busca "opencode" en `~/.bashrc`)

### Personalización

Para agregar nuevas herramientas de IA:

1. Crear script en `modules/03-ai/scripts/`
2. Seguir patrón existente
3. El script aparecerá automáticamente

---

## Módulo 04: Gaming (`04-gaming`)

### Propósito

Software relacionado con videojuegos y entretenimiento.

### Estructura

```
04-gaming/
└── scripts/
    └── 01-steam.sh
```

### Scripts

#### `01-steam.sh`

- **Función**: Instala Steam (plataforma de juegos)
- **Método**: Descarga `.deb` directa de Valve
- **Pre-requisitos**: `curl`
- **URL de descarga**: `https://cdn.akamai.steamstatic.com/client/installer/steam.deb`
- **Proceso**:
  1. Descarga paquete a `/tmp/steam.deb`
  2. Instala con `apt`
  3. Elimina archivo temporal

### Personalización

Para agregar más software de gaming:

1. Crear script en `modules/04-gaming/scripts/`
2. Ejemplo: Lutris, Heroic Launcher, etc.

---

## Módulo 05: Extra (`05-extra`)

### Propósito

Módulo reservado para instalaciones adicionales personalizadas.

### Estructura Actual

```
05-extra/
└── (vacío - listo para uso)
```

### Uso Futuro

Este módulo está diseñado para:

- Herramientas específicas del usuario
- Configuraciones personalizadas
- Scripts de mantenimiento
- Cualquier funcionalidad adicional

---

## Crear un Nuevo Módulo

### Paso 1: Estructura de Directorios

```bash
mkdir -p modules/XX-nuevo-modulo/scripts
```

Donde `XX` es el número de orden (06, 07, etc.)

### Paso 2: Crear Scripts

```bash
cat > modules/XX-nuevo-modulo/scripts/01-mi-script.sh << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

# Tu código aquí
echo "Instalando..."
EOF

chmod +x modules/XX-nuevo-modulo/scripts/01-mi-script.sh
```

### Paso 3: Crear Listas de Paquetes (Opcional)

```bash
cat > modules/XX-nuevo-modulo/mis-paquetes.txt << 'EOF'
paquete-1
paquete-2
EOF
```

### Paso 4: Actualizar `install.sh`

Agregar al archivo `install.sh`:

```bash
# Variable del módulo
NUEVO_MODULE="$MODULES_DIR/XX-nuevo-modulo"

# En la sección de mapfile
mapfile -t nuevoScripts < <(ls_scripts "XX-nuevo-modulo" | gum choose --no-limit --header "Nuevo Module:")

# En la sección de ejecución
execute_scripts "$NUEVO_MODULE" "${nuevoScripts[@]}"
```

---

## Convenciones de Nomenclatura

| Elemento          | Formato             | Ejemplo                             |
| ----------------- | ------------------- | ----------------------------------- |
| Directorio módulo | `XX-descripcion`    | `01-apps`, `02-dev`                 |
| Script            | `XX-descripcion.sh` | `01-system-packages.sh`             |
| Lista de paquetes | `nombre.txt`        | `system-packages.txt`               |
| Función bash      | `nombre_funcion()`  | `clean_list()`, `execute_scripts()` |

---

## Patrones Comunes de Scripts

### Patrón: Instalación con apt

```bash
#!/usr/bin/env bash
set -euo pipefail

clean_list() {
    grep -vE '^\s*#|^\s*$' "$1" 2>/dev/null || true
}

mapfile -t pkgs < <(clean_list "$MODULES_DIR/modulo/archivo.txt")
if [ ${#pkgs[@]} -gt 0 ]; then
    gum spin --spinner dot --title "Instalando..." -- \
    sudo apt install -y -qq "${pkgs[@]}"
fi
```

### Patrón: Descarga e instalación de .deb

```bash
#!/usr/bin/env bash
set -euo pipefail

if ! command -v app &> /dev/null; then
    tmpfile="/tmp/app.deb"

    if ! command -v curl &> /dev/null; then
        sudo apt install -y -qq curl
    fi

    curl -fsSL -o "$tmpfile" "https://url/descarga.deb"
    sudo apt install -y -qq "$tmpfile"
    rm -f "$tmpfile"
fi
```

### Patrón: Instalación con verificación previa

```bash
#!/usr/bin/env bash
set -euo pipefail

if ! command -v app &> /dev/null; then
    # Instalar dependencias si es necesario
    if ! command -v dependencia &> /dev/null; then
        sudo apt install -y -qq dependencia
    fi

    # Instalar aplicación
    gum spin --spinner dot --title "Instalando..." -- \
    comando-de-instalacion
fi
```
