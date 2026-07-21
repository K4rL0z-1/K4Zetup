# K4zetup

Herramienta de configuración automatizada de sistemas escrita en Bash, diseñada para distribuciones basadas en Debian/Ubuntu. Permite instalar y configurar aplicaciones, herramientas de desarrollo, software de IA, juegos y otros paquetes de forma interactiva y modular.

## Características

- **Interfaz interactiva** - Utiliza [Gum](https://github.com/charmbracelet/gum) para una experiencia visual amigable
- **Arquitectura modular** - Organización por categorías para fácil mantenimiento
- **Instalación selectiva** - El usuario elige qué módulos ejecutar
- **Soporte múltiple de paquetes** - apt, Flatpak y descargas directas (.deb)
- **Listas de paquetes editables** - Ficheros de configuración para personalizar instalaciones

## Requisitos

- Debian, Ubuntu o derivados
- `bash` 4.0+, `gum`, `sudo`

## Instalación

```bash
git clone <url-del-repositorio> K4zetup
cd K4zetup
./install.sh
```

## Estructura

```
K4zetup/
├── install.sh              # Punto de entrada
├── core/
│   └── utils.sh            # Funciones utilitarias
├── modules/
│   ├── 01-apps/            # Paquetes del sistema y Flatpak
│   ├── 02-dev/             # VSCode, extensiones, Node.js
│   ├── 03-ai/              # Herramientas de IA
│   ├── 04-gaming/          # Steam
│   └── 05-extra/           # Módulos adicionales
└── docs/                   # Documentación técnica
```

## Módulos

| Módulo | Contenido |
|--------|-----------|
| `01-apps` | curl, git, fastfetch, wget, blueman, vlc, Flatpak (Discord, Sober) |
| `02-dev` | VSCode, 10 extensiones, Node.js 24 via nvm |
| `03-ai` | Opencode |
| `04-gaming` | Steam |

## Uso

Al ejecutar `./install.sh` se presenta una interfaz visual donde seleccionas los módulos a instalar. Los scripts se ejecutan en orden secuencial con indicadores de progreso.

## Documentación

La documentación técnica detallada se encuentra en la carpeta [`docs/`](docs/):

- [Índice de documentación](docs/INDEX.md)
- [Arquitectura del proyecto](docs/ARCHITECTURE.md)
- [Guía de instalación](docs/INSTALLATION.md)
- [Documentación de módulos](docs/MODULES.md)
- [Detalle de scripts](docs/SCRIPTS.md)
- [Archivos de configuración](docs/CONFIGURATION.md)

## Autor

**K4rl0z**
