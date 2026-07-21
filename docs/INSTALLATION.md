# Guía de Instalación - K4zetup

## Requisitos del Sistema

### Sistema Operativo

- **Recomendado**: Ubuntu 20.04 LTS o superior
- **Soportado**: Debian 11+, Linux Mint, Pop!_OS, y otras derivadas
- **Arquitectura**: amd64 (x86_64)

### Dependencias del Sistema

| Paquete | Versión Mínima | Propósito |
|---------|----------------|-----------|
| `bash` | 4.0+ | Intérprete de comandos |
| `sudo` | Cualquiera | Ejecución con privilegios |
| `gum` | Cualquiera | Interfaz de usuario |

### Instalar Gum (Requisito Previo)

Gum es necesario para la interfaz interactiva. Instalarlo antes de usar K4zetup:

```bash
# Opción 1: Desde repositorios (si disponible)
sudo apt install gum

# Opción 2: Instalación manual
echo "deb [trusted=yes] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo apt update && sudo apt install gum
```

## Instalación de K4zetup

### Opción 1: Clonar Repositorio (Recomendado)

```bash
# Clonar el repositorio
git clone <url-del-repositorio> K4zetup

# Navegar al directorio
cd K4zetup

# Dar permisos de ejecución
chmod +x install.sh

# Ejecutar el instalador
./install.sh
```

### Opción 2: Descarga Directa

```bash
# Descargar y extraer
wget <url-del-zip> -O K4zetup.zip
unzip K4zetup.zip
cd K4zetup

# Dar permisos y ejecutar
chmod +x install.sh
./install.sh
```

## Flujo de Instalación

### Paso 1: Verificación de Permisos

El instalador solicitará permisos sudo al iniciar. Se verificará que el usuario tiene acceso sudo.

### Paso 2: Selección de Módulos

Se presentará una interfaz visual con Gum donde podrás seleccionar:

```
┌─────────────────────────────────────────┐
│  K4zetup                                │
│  ═══════                                │
│                                         │
│  Apps Module:                           │
│  [X] 01-system-packages.sh             │
│  [X] 02-flatpak-apps.sh               │
│                                         │
│  Dev Module:                            │
│  [X] 01-vscode-extensions.sh          │
│  [X] 02-vscode.sh                     │
│  [X] 03-nodejs.sh                     │
│                                         │
│  AI Module:                             │
│  [X] opencode.sh                       │
│                                         │
│  Gaming Module:                         │
│  [X] 01-steam.sh                      │
│                                         │
│  ¿Confirmar instalación? [s/N]         │
└─────────────────────────────────────────┘
```

### Paso 3: Confirmación

Responder `s` o `Sí` para proceder con la instalación, o `n` para cancelar.

### Paso 4: Ejecución

Los scripts se ejecutarán en orden secuencial con indicadores de progreso:

```
⠋ Synchronizing Repositories - (01-system-packages.sh)...
⠙ Installing Packages - (01-system-packages.sh)...
⠹ Installing Vscode Extensions: vscodevim.vim - (01-vscode-extensions.sh)...
⠸ Installing NodeJS - (03-nodejs.sh)...
⠼ Installing Opencode - (opencode.sh)...
```

### Paso 5: Finalización

Al completar, se mostrará un mensaje de éxito y se recomendará reiniciar el sistema.

## Personalización

### Editar Listas de Paquetes

Antes de ejecutar, puedes editar los archivos de texto para personalizar qué se instala:

```bash
# Paquetes del sistema
nano modules/01-apps/system-packages.txt

# Apps Flatpak
nano modules/01-apps/flatpak-apps.txt

# Extensiones VSCode
nano modules/02-dev/vscode-extensions.txt
```

**Formato de los archivos de texto:**

```
# Comentarios (se ignoran)
nombre-paquete-1
nombre-paquete-2

# Líneas vacías (se ignoran)
nombre-paquete-3
```

### Agregar Nuevos Scripts

1. Crear script en el módulo correspondiente
2. Usar formato de nombre: `XX-descripcion.sh`
3. Seguir el patrón existente (ver `SCRIPTS.md`)
4. El script aparecerá automáticamente en la interfaz

## Solución de Problemas

### Problema: "gum: command not found"

**Solución**: Instalar Gum primero:

```bash
echo "deb [trusted=yes] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo apt update && sudo apt install gum
```

### Problema: "Permission denied"

**Solución**: Dar permisos de ejecución:

```bash
chmod +x install.sh
chmod +x modules/*/scripts/*.sh
```

### Problema: "sudo: a password is required"

**Solución**: Verificar que el usuario está en el grupo sudo:

```bash
sudo usermod -aG sudo $USER
# Cerrar sesión y volver a entrar
```

### Problema: Scripts no se ejecutan

**Solución**: Verificar que bash está instalado y es la versión correcta:

```bash
bash --version
# Debe ser 4.0 o superior
```

## Desinstalación

K4zetup no realiza desinstalación automática. Para desinstalar:

1. **Paquetes apt**: `sudo apt remove [paquete]`
2. **Apps Flatpak**: `flatpak uninstall [app-id]`
3. **VSCode**: `sudo apt remove code`
4. **Extensiones VSCode**: Desinstalar desde la interfaz de VSCode

## Notas Importantes

- **Recomendación**: Reiniciar el sistema después de la instalación completa
- **Backup**: Se recomienda respaldar datos importantes antes de ejecutar
- **Conexión**: Se requiere conexión a internet para descargar paquetes
- **Tiempo**: La instalación completa puede tomar varios minutos dependiendo de la conexión
