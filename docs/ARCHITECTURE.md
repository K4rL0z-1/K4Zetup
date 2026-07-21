# Arquitectura del Proyecto K4zetup

## Visión General

K4zetup sigue un patrón de arquitectura modular basado en directorios, donde cada funcionalidad encapsulada se organiza en módulos independientes. El sistema está diseñado para ser extensible, mantenible y fácil de personalizar.

## Diagrama de Estructura

```
┌─────────────────────────────────────────────────────────────┐
│                      install.sh                             │
│                    (Punto de Entrada)                        │
├─────────────────────────────────────────────────────────────┤
│  • Configura variables globales                             │
│  • Inicializa proceso de sudo                               │
│  • Importa utilidades (core/utils.sh)                       │
│  • Muestra interfaz Gum                                     │
│  • Ejecuta módulos seleccionados                            │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      core/utils.sh                          │
│                   (Funciones Base)                           │
├─────────────────────────────────────────────────────────────┤
│  • ls_scripts()     - Lista scripts de un módulo            │
│  • execute_scripts() - Ejecuta scripts en orden             │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      modules/                               │
│                   (Sistema Modular)                          │
├─────────────┬─────────────┬─────────────┬───────────────────┤
│   01-apps   │   02-dev    │   03-ai     │   04-gaming       │
├─────────────┼─────────────┼─────────────┼───────────────────┤
│  scripts/   │  scripts/   │  scripts/   │  scripts/         │
│  *.sh       │  *.sh       │  *.sh       │  *.sh             │
│             │             │             │                   │
│  *.txt      │  *.txt      │             │                   │
│ (paquetes)  │ (extensiones│             │                   │
└─────────────┴─────────────┴─────────────┴───────────────────┘
```

## Componentes Principales

### 1. Punto de Entrada (`install.sh`)

El script principal actúa como orquestador del sistema completo:

- **Gestión de sudo**: Mantiene la sesión sudo activa durante ejecución prolongada
- **Variables globales**: Define rutas base y directorios de módulos
- **Interfaz de usuario**: Utiliza Gum para selección interactiva
- **Ejecución secuencial**: Procesa módulos en orden predefinido

### 2. Núcleo (`core/utils.sh`)

Contiene funciones utilitarias reutilizables:

```bash
# Lista scripts disponibles en un módulo
ls_scripts() {
    ls "$MODULES_DIR"/"$1"/scripts/
}

# Ejecuta scripts de un módulo específico
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

### 3. Sistema Modular (`modules/`)

Cada módulo contiene:

- **Directorio `scripts/`**: Scripts bash ejecutables
- **Archivos `*.txt`**: Listas de paquetes o configuraciones
- **Estructura consistente**: Formato numérico para orden de ejecución

## Patrones de Diseño

### Encapsulación por Módulo

Cada módulo es independiente y autocontenido:

```
modules/XX-nombre/
├── scripts/
│   ├── 01-primer-script.sh
│   ├── 02-segundo-script.sh
│   └── 03-tercer-script.sh
├── paquetes.txt          (opcional)
├── configuracion.txt     (opcional)
└── README.md             (opcional)
```

### Convención de Nomenclatura

| Elemento | Formato | Ejemplo |
|----------|---------|---------|
| Directorio módulo | `XX-descripcion` | `01-apps`, `02-dev` |
| Script | `XX-descripcion.sh` | `01-system-packages.sh` |
| Lista de paquetes | `nombre.txt` | `system-packages.txt` |

### Flujo de Datos

```
instalador.sh
    │
    ├─► ls_scripts("01-apps") ──────► ["01-system-packages.sh", "02-flatpak-apps.sh"]
    │
    ├─► gum choose (selección usuario) ──► ["01-system-packages.sh"]
    │
    └─► execute_scripts() ──► bash modules/01-apps/scripts/01-system-packages.sh
                                    │
                                    └─► Lee modules/01-apps/system-packages.txt
                                        │
                                        └─► sudo apt install [paquetes...]
```

## Variables Globales

| Variable | Descripción | Valor |
|----------|-------------|-------|
| `BASE_DIR` | Directorio raíz del proyecto | `/ruta/a/K4zetup` |
| `MODULES_DIR` | Directorio de módulos | `$BASE_DIR/modules` |
| `APPS_MODULE` | Ruta módulo apps | `$MODULES_DIR/01-apps` |
| `DEV_MODULE` | Ruta módulo dev | `$MODULES_DIR/02-dev` |
| `AI_MODULE` | Ruta módulo AI | `$MODULES_DIR/03-ai` |
| `GAMING_MODULE` | Ruta módulo gaming | `$MODULES_DIR/04-gaming` |
| `EXTRA_MODULE` | Ruta módulo extra | `$MODULES_DIR/05-extra` |

## Extensibilidad

### Agregar un Nuevo Módulo

1. Crear directorio: `modules/XX-nuevo-modulo/`
2. Crear subdirectorio: `modules/XX-nuevo-modulo/scripts/`
3. Agregar scripts: `modules/XX-nuevo-modulo/scripts/01-script.sh`
4. Agregar listas de paquetes: `modules/XX-nuevo-modulo/paquetes.txt`
5. Actualizar `install.sh` con variable y llamada al módulo

### Agregar Script a un Módulo Existente

1. Crear script en `modules/XX-modulo/scripts/`
2. Usar formato: `XX-descripcion.sh`
3. El script se mostrará automáticamente en la interfaz

## Dependencias del Sistema

### Requeridas

- `bash` >= 4.0
- `gum` (Charm)
- `sudo`
- `coreutils`

### Opcionales (según módulos)

- `flatpak` (para Flatpak apps)
- `code` (para VSCode extensions)
- `curl` (para descargas)
- `nvm` (para Node.js)
