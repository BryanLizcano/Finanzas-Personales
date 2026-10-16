# 07 — Diseño UI/UX

**Dirección visual:** limpia, moderna, calmada; transmite control y crecimiento. Material 3, esquinas redondeadas (16 dp), mucho aire, tipografía legible, cifras protagonistas.

## Paleta (tokens)
Validar contraste AA con una herramienta antes de fijarla.

| Token | Claro | Oscuro |
|-------|-------|--------|
| `primary` (verde azulado) | `#0F766E` | `#5EEAD4` |
| `onPrimary` | `#FFFFFF` | `#042F2E` |
| `background` | `#F6F8F7` | `#0E1514` |
| `surface` | `#FFFFFF` | `#162120` |
| `surfaceVariant` | `#E5EDEB` | `#223230` |
| `onSurface` | `#14201E` | `#E6EDEB` |
| `onSurfaceMuted` | `#51625F` | `#9DB1AD` |
| `income` (verde) | `#15803D` | `#4ADE80` |
| `expense` (rojo) | `#DC2626` | `#F87171` |
| `savings` (ámbar) | `#B45309` | `#FBBF24` |
| `debt` (violeta) | `#6D28D9` | `#A78BFA` |
| `outline` | `#C5D2CF` | `#34504C` |

Regla: ingresos en verde, gastos en rojo, ahorro en ámbar, deudas en violeta. Nunca se usa solo el color para comunicar; acompañar con ícono o signo.

## Tipografía
Inter incluida como asset (sin descargas en tiempo de ejecución). Escala: Display 32, Title 22, Body 16, Label 13. Cifras con `tabularFigures`.

## Tema
- Opciones: Sistema (por defecto), Claro, Oscuro.
- Implementado con `ThemeMode.system` y `ColorScheme` propios construidos con los tokens.
- Ningún color se escribe directo en widgets: solo `Theme.of(context)` o `ThemeExtension<FinanceColors>`.

## Idioma
- Opciones: Sistema (por defecto), Español, English.
- ARB en `lib/l10n/`. Si el idioma del sistema no es es/en, usar inglés.
- Fechas y números formateados con `intl` según el idioma elegido.

## Moneda
- Selector en primer arranque y en Ajustes: COP, USD, EUR.
- Formato: COP `$ 1.250.000`, USD `$1,250.00`, EUR `1.250,00 €` (según locale).
- Teclado numérico propio para montos: sin decimales en COP.

## Adaptabilidad
| Clase | Ancho | Ajustes |
|-------|-------|---------|
| Pequeño | < 360 dp | Una columna, tarjetas compactas, íconos 20 dp, resumen colapsable |
| Mediano | 360–411 dp | Diseño base |
| Grande | ≥ 412 dp | Más espacio, rejilla de categorías de 4 columnas |
| Tablet (opcional) | ≥ 600 dp | Navegación lateral y dos paneles |

Reglas: `LayoutBuilder`/`MediaQuery` para clasificar; sin tamaños fijos en píxeles para textos; probar con escala de fuente 1.3×; `SafeArea` siempre; prohibido el desbordamiento (`RenderFlex overflow`).

## Navegación
Barra inferior con 4 destinos: **Inicio**, **Movimientos**, **Deudas y cobros**, **Ajustes**. Botón flotante central "+" para registrar. Ahorro y reportes se abren desde Inicio.

## Pantallas MVP
1. **Inicio:** saldo total, disponible seguro, ingreso del mes vs base, tarjetas de deuda total / por cobrar / ahorro, últimos movimientos.
2. **Registrar:** toggle gasto/ingreso/transferencia, monto grande, categorías en rejilla, cuenta, fecha, nota.
3. **Movimientos:** lista agrupada por día, filtros, búsqueda.
4. **Deudas:** lista con progreso, sugerencia de cuál abonar, detalle con historial.
5. **Por cobrar:** lista por persona, detalle con abonos.
6. **Ahorro:** metas con progreso circular.
7. **Reportes:** dona por categoría, barras mensuales.
8. **Categorías:** lista con interruptor activar/desactivar y crear nueva.
9. **Ajustes:** tema, idioma, moneda, ingreso base, reglas de reparto, copias, actualizaciones, acerca de.

## Estados obligatorios
Cada pantalla define estado de carga, vacío (con ilustración y acción), error y éxito.

## Microinteracciones
Animaciones breves (≤ 250 ms), háptico ligero al guardar, snackbar con "Deshacer", sin diálogos innecesarios.
