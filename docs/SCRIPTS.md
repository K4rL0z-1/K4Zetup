# Documentación de Scripts - K4zetup

## Visión General

Cada script en K4zetup sigue patrones consistentes para garantizar fiabilidad y mantenibilidad. Este documento describe el funcionamiento detallado de cada script.

---

## `install.sh` - Punto de Entrada Principal

**Ubicación**: `K4zetup/install.sh`

### Propósito
Script principal que orquesta toda la ejecución de K4zetup.

### Funcionamiento

#### 1. Configuración Inicial (Líneas 1-11)

```bash
#!/usr/bin/env bash
set -euo pipefail
```

- `set -e`: Salir si cualquier comando falla
- `set -u`: Error si se usa variable no definida
- `set -o pipefail**: Error si falla cualquier comando en un pipeline

#### 2. Gestión de Sudo (Líneas 4-11)

```bash
sudo -v || exit 1
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &
SUDO_KEEPALIVE_PID=$!
trap 'kill $SUDO_KEEPALIVE_PID 2>/dev/null' EXIT
```

**Explicación**:
- `sudo -v`: Verifica credenciales sudo
- Bucle infinito que ejecuta `sudo -n true` cada 60 segundos
- `kill -0 "$$"`: Verifica que el proceso principal sigue activo
- `trap ... EXIT`: Limpia el proceso al salir

#### 3. Variables Globales (Líneas 15-22)

```bash
export BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
export MODULES_DIR="$BASE_DIR/modules"
```

- `BASE_DIR`: Directorio raíz del proyecto (resuelve symlinks)
- `MODULES_DIR`: Directorio donde están los módulos

#### 4. Interfaz de Usuario (Líneas 26-32)

```bash
gum style --border double --margin "1" --padding "1" --border-foreground 212 "K4Zetup"

mapfile -t appsScripts < <(ls_scripts "01-apps" | gum choose --no-limit --header "Apps Module:")
mapfile -t devScripts < <(ls_scripts "02-dev" | gum choose --no-limit --header "Dev Module:")
# ... etc
```

**Explicación**:
- `gum style`: Muestra banner decorativo
- `mapfile -t`: Guarda selección del usuario en array
- `ls_scripts`: Lista scripts disponibles del módulo
- `gum choose --no-limit`: Selección múltiple sin límite

#### 5. Ejecución (Líneas 33-43)

```bash
if gum confirm; then
    execute_scripts "$APPS_MODULE" "${appsScripts[@]}"
    # ... etc
else
    clear
    gum style "Process cancelled by the user"
fi
```

**Explicación**:
- `gum confirm`: Pregunta de confirmación
- `execute_scripts`: Ejecuta scripts seleccionados
- Si se cancela, muestra mensaje y limpia pantalla

### Dependencias

- `gum` - Interfaz de usuario
- `bash` >= 4.0 - Para `mapfile`

---

## `core/utils.sh` - Funciones Utilitarias

**Ubicación**: `K4zetup/core/utils.sh`

### Propósito
Funciones base reutilizadas por todos los scripts.

### Funciones

#### `ls_scripts()`

```bash
ls_scripts() {
    ls "$MODULES_DIR"/"$1"/scripts/
}
```

**Parámetros**:
- `$1`: Nombre del directorio del módulo (ej: "01-apps")

**Retorna**: Lista de scripts disponibles en ese módulo

**Uso**:
```bash
ls_scripts "01-apps"
# Retorna: "01-system-packages.sh" "02-flatpak-apps.sh"
```

#### `execute_scripts()`

```bash
execute_scripts() {
    local module="$1"
    shift

    for scriptName in "$@"; do
        local scriptPath
        scriptPath=$(find "$module" -name "$scriptName" -print -quit)

        if [[ -n "$scriptPath" ]]; then
            bash "$scriptPath"
        fi
    done
}
```

**Parámetros**:
- `$1`: Ruta completa al directorio del módulo
- `$@`: Lista de nombres de scripts a ejecutar

**Funcionamiento**:
1. Recibe el directorio del módulo y lista de scripts
2. Para cada script, busca su ruta completa usando `find`
3. Si lo encuentra, lo ejecuta con `bash`
4. `find -print -quit`: Detiene búsqueda al primer resultado

---

## `modules/01-apps/scripts/01-system-packages.sh`

**Ubicación**: `K4zetup/modules/01-apps/scripts/01-system-packages.sh`

### Propósito
Instalar paquetes base del sistema usando apt.

### Funcionamiento

#### 1. Definición de `clean_list()`

```bash
clean_list() {
    grep -vE '^\s*#|^\s*$' "$1" 2>/dev/null || true
}
```

**Explicación**:
- `grep -v`: Invertir coincidencia (excluir)
- `^\s*#`: Líneas que empiezan con # (comentarios)
- `^\s*$`: Líneas vacías
- `2>/dev/null`: Suprime errores si archivo no existe
- `|| true`: Evita error si grep no encuentra nada

#### 2. Carga de Paquetes

```bash
mapfile -t pkgs < <(clean_list "$MODULES_DIR/01-apps/system-packages.txt")
```

- Lee archivo de texto
- Limpia comentarios y líneas vacías
- Guarda paquetes en array `pkgs`

#### 3. Instalación

```bash
if [ ${#pkgs[@]} -gt 0 ]; then
    gum spin --spinner globe --title "Synchronizing Repositories..." -- \
    sudo apt update -qq
    gum spin --spinner dot --title "Installing Packages..." -- \
    sudo env DEBIAN_FRONTEND=noninteractive apt install -y -qq "${pkgs[@]}"
fi
```

**Explicación**:
- `${#pkgs[@]}`: Número de elementos en el array
- `gum spin`: Muestra animación de carga
- `DEBIAN_FRONTEND=noninteractive`: Evita preguntas interactivas
- `-y`: Responde "sí" a todas las preguntas
- `-qq`: Modo silencioso (solo errores)

### Archivos Dependientes

- `modules/01-apps/system-packages.txt`: Lista de paquetes apt

---

## `modules/01-apps/scripts/02-flatpak-apps.sh`

**Ubicación**: `K4zetup/modules/01-apps/scripts/02-flatpak-apps.sh`

### Propósito
Instalar aplicaciones Flatpak desde Flathub.

### Funcionamiento

#### 1. Verificación de Flatpak

```bash
if ! command -v flatpak &> /dev/null; then
    echo "You don't have Flatpak installed."
    gum spin --spinner dot --title "Installing Flatpak..." -- \
    sudo env DEBIAN_FRONTEND=noninteractive apt install -y -qq flatpak gnome-software-plugin-flatpak && \
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
fi
```

**Explicación**:
- `command -v flatpak`: Verifica si Flatpak está instalado
- `&> /dev/null`: Redirige stdout y stderr a /dev/null
- Instala Flatpak y plugin de GNOME Software
- `flatpak remote-add --if-not-exists`: Agrega Flathub si no existe

#### 2. Carga y Instalación

```bash
mapfile -t pkgs < <(clean_list "$MODULES_DIR/01-apps/flatpak-apps.txt")
if [ ${#pkgs[@]} -gt 0 ]; then
    gum spin --spinner dot --title "Installing Flatpak Apps..." -- \
    flatpak install -y flathub ${pkgs[*]}
fi
```

**Explicación**:
- `${pkgs[*]}`: Expande todos los elementos del array
- `-y`: Confirma instalación automáticamente
- `flathub`: Repositorio predeterminado

### Archivos Dependientes

- `modules/01-apps/flatpak-apps.txt`: IDs de apps Flatpak

---

## `modules/02-dev/scripts/01-vscode-extensions.sh`

**Ubicación**: `K4zetup/modules/02-dev/scripts/01-vscode-extensions.sh`

### Propósito
Instalar extensiones de Visual Studio Code.

### Funcionamiento

#### 1. Verificación de VSCode

```bash
if ! command -v code &> /dev/null; then
    echo "You don't have Vscode installed. Skipping..."
else
    # ... instalar extensiones
fi
```

**Explicación**:
- Verifica si VSCode está instalado
- Si no está, muestra mensaje y omite

#### 2. Instalación de Extensiones

```bash
if [ ${#pkgs[@]} -gt 0 ]; then
    while read -r ext; do
        gum spin --spinner dot --title "Installing Vscode Extensions: "$ext"..." -- \
        code --install-extension "$ext"
    done < <(clean_list "$MODULES_DIR/02-dev/vscode-extensions.txt")
fi
```

**Explicación**:
- Lee cada extensión del archivo
- Instala una por una (no en batch)
- `code --install-extension`: Comando de VSCode para instalar
- Muestra nombre de cada extensión durante instalación

### Archivos Dependientes

- `modules/02-dev/vscode-extensions.txt`: IDs de extensiones

### Formato del Archivo de Extensiones

```
autor.nombre-extension
```

Ejemplo:
```
vscodevim.vim
teabyii.ayu
```

---

## `modules/02-dev/scripts/02-vscode.sh`

**Ubicación**: `K4zetup/modules/02-dev/scripts/02-vscode.sh`

### Propósito
Instalar Visual Studio Code desde la fuente oficial de Microsoft.

### Funcionamiento

#### 1. Verificación

```bash
if ! command -v code &> /dev/null; then
    tmpfile="/tmp/vscode.deb"
    # ... proceder con instalación
fi
```

#### 2. Instalación de curl (si necesario)

```bash
if ! command -v curl &> /dev/null; then
    gum spin --spinner dot --title "Installing Dependence: curl..." -- \
    sudo DEBIAN_FRONTEND=noninteractive apt install -y -qq curl
fi
```

#### 3. Descarga del Paquete

```bash
gum spin --spinner globe --title "Downloading VSCode Package..." -- \
curl -fsSL -o "$tmpfile" \
    "https://go.microsoft.com/fwlink/?LinkID=760868"
```

**Explicación**:
- `-f`: Falla silenciosamente en error HTTP
- `-s`: Modo silencioso
- `-S`: Muestra errores aunque esté en modo silencioso
- `-L`: Sigue redirecciones
- `-o "$tmpfile"`: Guarda en archivo temporal

#### 4. Instalación

```bash
gum spin --spinner dot --title "Installing VSCode..." -- \
sudo DEBIAN_FRONTEND=noninteractive apt install -y -qq "$tmpfile"
```

#### 5. Limpieza

```bash
gum spin --spinner dot --title "Removing VSCode From /tmp/..." -- \
rm -f "$tmpfile"
```

**Explicación**:
- `rm -f`: Elimina sin preguntar

---

## `modules/02-dev/scripts/03-nodejs.sh`

**Ubicación**: `K4zetup/modules/02-dev/scripts/03-nodejs.sh`

### Propósito
Instalar Node.js mediante nvm (Node Version Manager).

### Funcionamiento

#### 1. Verificación

```bash
if ! command -v node &> /dev/null; then
    # ... proceder con instalación
fi
```

#### 2. Instalación de nvm

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh | bash
```

**Explicación**:
- Descarga script de instalación de nvm
- `curl -o-`: Escribe a stdout (lo pipea a bash)
- `| bash`: Ejecuta el script descargado

#### 3. Carga de nvm en el Shell Actual

```bash
\. "$HOME/.nvm/nvm.sh"
```

**Explicación**:
- `\. ` (o `source`): Carga el script en el shell actual
- Necesario para usar `nvm` inmediatamente sin reiniciar

#### 4. Instalación de Node.js

```bash
nvm install 24
```

**Explicación**:
- Descarga e instala Node.js versión 24
- Configura PATH automáticamente

#### 5. Verificación

```bash
node -v  # Debería mostrar "v24.x.x"
npm -v   # Debería mostrar "x.x.x"
```

---

## `modules/03-ai/scripts/opencode.sh`

**Ubicación**: `K4zetup/modules/03-ai/scripts/opencode.sh`

### Propósito
Instalar Opencode, herramienta CLI de inteligencia artificial.

### Funcionamiento

#### 1. Verificación de Instalación

```bash
if ! grep -q "opencode" ~/.bashrc; then
    # ... proceder con instalación
fi
```

**Explicación**:
- `grep -q`: Modo silencioso (no muestra output)
- Verifica si "opencode" aparece en `.bashrc`
- Indica que ya fue instalado previamente

#### 2. Instalación de curl

```bash
if ! command -v curl &> /dev/null; then
    gum spin --spinner dot --title "Installing Dependence: curl..." -- \
    sudo DEBIAN_FRONTEND=noninteractive apt install -y -qq curl
fi
```

#### 3. Instalación de Opencode

```bash
gum spin --spinner dot --title "Installing Opencode..." -- \
curl -fsSL https://opencode.ai/install | bash
```

**Explicación**:
- Descarga script de instalación oficial
- Ejecuta directamente desde URL

---

## `modules/04-gaming/scripts/01-steam.sh`

**Ubicación**: `K4zetup/modules/04-gaming/scripts/01-steam.sh`

### Propósito
Instalar Steam, plataforma de distribución de videojuegos de Valve.

### Funcionamiento

#### 1. Verificación

```bash
if ! command -v steam &> /dev/null; then
    tmpfile="/tmp/steam.deb"
    # ... proceder con instalación
fi
```

#### 2. Instalación de curl

```bash
if ! command -v curl &> /dev/null; then
    gum spin --spinner dot --title "Installing Dependence: curl..." -- \
    sudo DEBIAN_FRONTEND=noninteractive apt install -y -qq curl
fi
```

#### 3. Descarga del Paquete

```bash
gum spin --spinner globe --title "Downloading Steam Package..." -- \
curl -fsSL -o "$tmpfile" \
    "https://cdn.akamai.steamstatic.com/client/installer/steam.deb"
```

**Explicación**:
- Usa CDN de Akamai para distribución global
- Mismo patrón que VSCode

#### 4. Instalación

```bash
gum spin --spinner dot --title "Installing Steam..." -- \
sudo DEBIAN_FRONTEND=noninteractive apt install -y -qq "$tmpfile"
```

#### 5. Limpieza

```bash
gum spin --spinner dot --title "Removing Steam From /tmp/..." -- \
rm -f "$tmpfile"
```

---

## Patrón Común de Scripts

Todos los scripts siguen este patrón base:

```bash
#!/usr/bin/env bash
set -euo pipefail

# 1. Verificar si ya está instalado
if ! command -v app &> /dev/null; then
    
    # 2. Instalar dependencias si es necesario
    if ! command -v dependencia &> /dev/null; then
        gum spin --spinner dot --title "Installing Dependence..." -- \
        sudo apt install -y -qq dependencia
    fi
    
    # 3. Instalar aplicación
    gum spin --spinner dot --title "Installing App..." -- \
    comando-de-instalacion
fi
```

### Características del Patrón

1. **Idempotencia**: No reinstala si ya existe
2. **Dependencias**: Instala prerequisites automáticamente
3. **Feedback visual**: Usa `gum spin` para mostrar progreso
4. **Modo silencioso**: `-qq` para no molestar al usuario
5. **No interactivo**: `DEBIAN_FRONTEND=noninteractive` evita preguntas
