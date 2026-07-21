# K4zetup - Documentación del Proyecto

## Descripción General

**K4zetup** es una herramienta de configuración automatizada de sistemas escrita en Bash, diseñada para distribuciones basadas en Debian/Ubuntu. Permite instalar y configurar aplicaciones, herramientas de desarrollo, software de IA, juegos y otros paquetes de forma interactiva y modular.

## Características Principales

- **Interfaz interactiva**: Utiliza [Gum](https://github.com/charmbracelet/gum) para una experiencia de usuario visual y amigable
- **Arquitectura modular**: Organización por categorías para fácil mantenimiento
- **Instalación selectiva**: El usuario elige qué módulos ejecutar
- **Soporte múltiple de paquetes**: apt, Flatpak y descargas directas (.deb)
- **Listas de paquetes editables**: Ficheros de configuración para personalizar instalaciones
- **Manejo de errores**: `set -euo pipefail` para ejecución segura

## Estructura del Proyecto

```
K4zetup/
├── install.sh              # Punto de entrada principal
├── core/
│   └── utils.sh            # Funciones utilitarias del sistema
├── modules/
│   ├── 01-apps/            # Aplicaciones del sistema
│   ├── 02-dev/             # Herramientas de desarrollo
│   ├── 03-ai/              # Herramientas de inteligencia artificial
│   ├── 04-gaming/          # Software de gaming
│   └── 05-extra/           # Módulos adicionales (futuro)
├── docs/                   # Documentación del proyecto
└── README.md               # Archivo principal
```

## Documentación Disponible

| Archivo | Descripción |
|---------|-------------|
| [README.md](README.md) | Este archivo - Descripción general |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Arquitectura y estructura del proyecto |
| [INSTALLATION.md](INSTALLATION.md) | Guía de instalación y requisitos |
| [MODULES.md](MODULES.md) | Documentación de módulos |
| [SCRIPTS.md](SCRIPTS.md) | Detalle de cada script |
| [CONFIGURATION.md](CONFIGURATION.md) | Archivos de configuración |

## Requisitos Previos

- **Sistema operativo**: Debian, Ubuntu o derivados
- **Dependencias**: `bash`, `gum`, `sudo`
- **Permisos**: Acceso sudo para instalación de paquetes

## Uso Rápido

```bash
# Clonar el repositorio
git clone <url-del-repositorio> K4zetup
cd K4zetup

# Ejecutar el instalador
./install.sh
```

## Flujo de Ejecución

1. El script principal solicita permisos sudo
2. Muestra una interfaz visual con Gum
3. Presenta módulos para selección interactiva
4. El usuario elige qué instalar
5. Se ejecutan los scripts seleccionados en orden
6. Se muestra mensaje de finalización

## Autor

Proyecto desarrollado por **K4rl0z**

## Licencia

Consultar el archivo LICENSE del repositorio principal.
