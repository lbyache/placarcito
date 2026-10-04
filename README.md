# placarcito

Armario digital y asistente de estilismo personal para iOS, implementado con SwiftUI, SwiftData y el framework Vision de Apple.

La aplicacion permite digitalizar prendas, registrar su uso para calcular métricas de rotación y costo por uso, sugerir combinaciones según condiciones meteorológicas y aislar prendas mediante segmentación visual en el dispositivo.

## Funcionalidades

- **Catalogo de prendas (`ClosetView`)**: Categorización por tipo (superiores, inferiores, calzado, abrigos, accesorios), gestión de estado de lavado y captura fotográfica.
- **Segmentación con Apple Vision (`VisionService`)**: Remoción de fondo en el dispositivo mediante `VNGenerateForegroundInstanceMaskRequest` (iOS 17+), aislando la prenda sin enviar imágenes a servicios externos.
- **Motor de combinaciones (`OutfitEngine`)**: Reglas de combinación basadas en disponibilidad de prendas limpias, temperatura reportada (`WeatherService`), ocasión y armonía cromática.
- **Asistente de estilismo (`AIAssistantService`)**: Interfaz de consulta para recomendaciones según evento, estación y capas térmicas.
- **Control de lavadero (`LaundryTrackerView`)**: Registro de ciclo de vida de prendas (limpio, en uso, en lavadero), restringiendo sugerencias a prendas listas para usar.
- **Métricas de rotación (`ClosetAnalyticsView`)**: Estadísticas de uso por prenda, cálculo de costo por uso (*cost-per-wear*) e identificación de prendas con baja frecuencia de uso.

## Arquitectura y tecnologías

| Componente | Especificación |
| :--- | :--- |
| Plataforma | iOS 17.0+ |
| Lenguaje | Swift (concurrencia estructurada, Swift 6) |
| UI | SwiftUI |
| Persistencia | SwiftData (`@Model`, `ModelContainer`, `ModelContext`) |
| Procesamiento de imagen | Apple Vision (`VNGenerateForegroundInstanceMaskRequest`), CoreImage |
| Estado reactivo | Macro `@Observable` |
| Tests | XCTest / Swift Testing |
| Dependencias | Ninguna (frameworks nativos de Apple) |

### Estructura del repositorio

```text
placarcito/
├── placarcito/
│   ├── placarcitoApp.swift      # Ciclo de vida y configuración de ModelContainer
│   ├── ContentView.swift        # Navegación principal por pestañas
│   ├── Models/                  # Entidades SwiftData (@Model)
│   │   ├── ClothingItem.swift   # Prenda, estado de lavado, categoría y métricas
│   │   ├── Outfit.swift         # Combinación de prendas, rango térmico y ocasión
│   │   ├── LoggedOutfit.swift   # Historial de uso con fecha
│   │   └── SeedData.swift       # Carga inicial de datos de muestra
│   ├── Services/                # Lógica de dominio y servicios desacoplados
│   │   ├── VisionService.swift  # Segmentación y remoción de fondo
│   │   ├── OutfitEngine.swift   # Algoritmo de sugerencias y filtros térmicos
│   │   ├── WeatherService.swift # Rangos de temperatura y condiciones
│   │   └── AIAssistantService.swift # Generación de recomendaciones de estilo
│   └── Views/                   # Vistas modulares por feature
│       ├── Closet/              # Armario y detalle de prendas
│       ├── Generator/           # Generador de combinaciones
│       ├── Assistant/           # Asistente de estilo
│       ├── Calendar/            # Control de lavado
│       └── Analytics/           # Tablero de métricas
└── placarcitoTests/             # Suite de pruebas unitarias
```

## Pruebas unitarias

El proyecto cuenta con cobertura de pruebas unitarias sobre los módulos de dominio y procesamiento:

```bash
# Ejecutar suite de pruebas en el simulador:
./run_tests.sh
```

Suites incluidas:
- `OutfitEngineTests`: Filtrado de prendas limpias y reglas térmicas para abrigos.
- `ClothingItemTests`: Cálculo de costo por uso y transiciones de estado de lavado.
- `AIAssistantServiceTests`: Flujo de mensajería y generación contextual de looks.
- `VisionServiceTests`: Procesamiento de imagen y manejo de fallbacks.
- `OutfitTests`: Disponibilidad según el estado de las prendas componentes.
- `WeatherServiceTests`: Clasificación de rangos térmicos.

## Ejecución

1. Abrir `placarcito.xcodeproj` en Xcode 16+.
2. Seleccionar esquema `placarcito` y un destino de simulador iOS 17 o superior.
3. Ejecutar (`Cmd + R`).

## Licencia

MIT
