# Placarcito 🌿

Armario digital inteligente y asistente de estilismo personal para iOS, diseñado bajo una estética minimalista escandinava y construido con **SwiftUI**, **SwiftData** y el framework **Vision** de Apple.

Placarcito digitaliza tu guardarropa, optimiza la rotación de tus prendas, sugiere combinaciones según el clima y ocasión, y analiza prendas mediante visión artificial en el dispositivo.

---

## 📱 Características principales

* **Armario Digital (`ClosetView`)**: Categorización de prendas (superiores, inferiores, calzado, abrigos, accesorios), gestión de estados de lavado y registro de fotos con cámara nativa.
* **Procesamiento de Imágenes con Apple Vision (`VisionService`)**: Remoción automática de fondo de prendas en el dispositivo mediante `VNGenerateForegroundInstanceMaskRequest` (iOS 17+), aislando la ropa sin enviar datos a servidores externos.
* **Generador Inteligente de Outfits (`OutfitEngine`)**: Motor de reglas que combina prendas limpias evaluando la temperatura actual (`WeatherService`), ocasión (formal, casual, noche) y armonía de color.
* **Asistente de Estilo con IA (`AIAssistantService`)**: Chat interactivo que sugiere combinaciones personalizadas para eventos específicos y consejos de superposición (*layering* nórdico).
* **Seguimiento de Lavandería (`LaundryTrackerView`)**: Control de prendas limpias, en uso y para lavar, asegurando que las sugerencias de atuendos solo usen ropa disponible.
* **Métricas y Análisis de Uso (`ClosetAnalyticsView`)**: Estadísticas de rotación de prendas, cálculo de costo por uso (*cost-per-wear*) y prendas menos aprovechadas.

---

## 🛠️ Stack Tecnológico y Arquitectura

| Componente | Detalle |
| :--- | :--- |
| **Plataforma** | iOS 17.0+ |
| **Lenguaje** | Swift |
| **Interfaz (UI)** | SwiftUI (Diseño minimalista escandinavo) |
| **Persistencia** | SwiftData (`ModelContainer`, `@Model`, `Schema`) |
| **Machine Learning / CV** | Apple Vision Framework (`VNGenerateForegroundInstanceMaskRequest`), CoreImage |
| **Estado y Reactividad** | Macro `@Observable` |
| **Testing** | Suite de pruebas unitarias (`XCTest` / Test Runner) |
| **Privacidad** | 100% Offline-first (procesamiento en el dispositivo, sin APIs externas) |

### Estructura del Proyecto

```text
placarcito/
├── App/             # Configuración del ciclo de vida y ModelContainer de SwiftData
├── Models/          # Entidades persistentes (ClothingItem, Outfit, LoggedOutfit, SeedData)
├── Services/        # Lógica de dominio y servicios desacoplados
│   ├── AIAssistantService.swift  # Motor de respuestas y asesoría de estilo
│   ├── OutfitEngine.swift        # Reglas algorítmicas de combinación y clima
│   ├── VisionService.swift       # Segmentación y remoción de fondo con Apple Vision
│   └── WeatherService.swift      # Estado meteorológico y reglas térmicas
├── Views/           # Pantallas modulares divididas por feature
│   ├── Closet/      # Armario, detalle y captura de prendas
│   ├── Generator/   # Generador interactivo de looks
│   ├── Assistant/   # Chat interactivo con el estilista
│   ├── Calendar/    # Seguimiento de lavandería y registro de uso
│   ├── Analytics/   # Métricas de rotación del armario
│   └── Shared/      # Componentes de diseño reutilizables
└── placarcitoTests/ # Suite de tests unitarios
```

---

## 🧪 Pruebas Unitarias

El proyecto incluye tests unitarios para validar la lógica del motor de estilismo, visión y modelos:

```bash
# Ejecutar suite de pruebas en el simulador de iOS:
./run_tests.sh
```

Pruebas cubiertas:
* `OutfitEngineTests`: Validación de reglas de combinación por temperatura y ocasión.
* `WeatherServiceTests`: Transiciones de rangos térmicos e iconografía.
* `VisionServiceTests`: Procesamiento y aislamiento de máscaras de imagen.
* `ClothingItemTests`: Validación de estados de lavado y ciclo de vida de prendas.

---

## 📄 Licencia

Este proyecto está bajo la Licencia MIT.
