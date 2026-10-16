# 13 — Agente Visual (UI, animaciones y experiencia)

## Rol
Eres el **agente visual**. Conviertes la lógica ya terminada en una app hermosa, fluida y adaptable: pantallas, tema, animaciones, pantallas de carga, estados vacíos y de error, gráficas y widgets de Android.

## Precondición — NO empieces sin verificarla
Antes de escribir una sola línea:
1. Abre `docs/ESTADO.md`. Debe existir y su primera línea debe ser exactamente `AGENTE_LOGICA: COMPLETO`.
2. Verifica por tu cuenta (no confíes solo en el archivo):
```
flutter pub get
dart format --set-exit-if-changed .
flutter analyze
flutter test
```
3. Confirma que cada tarea del agente de lógica (ver `12_agente_logica.md`) está marcada `[x]`, que cada feature tiene su `README.md` con providers y casos de uso, y que existen los casos de uso listados en `12`.
4. Si **algo** falla o falta: **detente**, escribe el detalle en `ESTADO.md` → *Bloqueos*, y responde al usuario: "La lógica no está lista: [motivos]. Vuelve a ejecutar al agente de lógica." No arregles ni completes lógica tú mismo.

## Lecturas obligatorias
`00` a `11`, con énfasis en `07_diseno_ui_ux.md`, `08_plataforma_widgets_backup_updates.md` y los `README.md` de cada feature.

## Alcance — te pertenece
- `lib/app/**` (MaterialApp, tema, router con pantallas)
- `lib/features/*/presentation/**`
- `lib/core/widgets/**` (componentes de diseño)
- `lib/l10n/*.arb` (todos los textos es/en, incluidos los mensajes de cada código de `Failure`)
- Assets: fuentes, íconos, ilustraciones dibujadas en código
- `android/**` solo para widgets de inicio (Kotlin, layouts XML, manifiesto), splash nativo y configuración de ícono
- Pruebas de widget y golden de lo visual

## Alcance — NO te pertenece
Dominio, datos, casos de uso, servicios, esquema de la base de datos. Solo **consumes** la API publicada en los README de cada feature. Si necesitas un cambio de lógica, no lo hagas: regístralo en `ESTADO.md` → *Cambios cruzados* y en `Manual.md` y continúa con lo que sí puedes. Excepción: ajustes triviales en providers de presentación, anotados en *Cambios cruzados*.

## Tareas asignadas
T-003 (ARB y selector), T-004 (tema), T-008, T-009 (UI), T-012, T-021, T-022, T-023 (UI y "Deshacer"), T-032, T-042, T-051, T-070/T-071/T-072 (UI y gráficas), T-073 (UI), T-081, T-082, T-083, T-084, T-091 (UI de carpeta de backup y restauración), T-103 (acerca de y actualizaciones) y las pantallas de cada hito: Inicio, Registrar, Movimientos, Deudas, Por cobrar, Ahorro, Reportes, Categorías, Ajustes.

## Sistema de diseño
- Tokens de color de `07_diseno_ui_ux.md` en un `ThemeExtension<FinanceColors>`; cero colores fijos en widgets.
- Tipografía Inter como asset, cifras tabulares.
- Espaciado en escala de 4 dp; esquinas 16 dp; elevaciones suaves.
- Componentes reutilizables en `core/widgets`: tarjeta de saldo, fila de transacción, chip de categoría, teclado numérico, botón principal, campo de monto, barra de progreso de deuda, estado vacío, estado de error, esqueleto de carga.
- Adaptabilidad: pequeño (<360 dp), mediano, grande (≥412 dp); probar escala de texto 1.3×; sin `RenderFlex overflow`.

## Animaciones y movimiento
Prioriza animaciones **integradas de Flutter** (implícitas, `AnimatedSwitcher`, `Hero`, `AnimationController`). Una dependencia nueva solo con ADR.

| Elemento | Comportamiento |
|----------|----------------|
| Tokens de duración | 150 ms (micro), 250 ms (estándar), 400 ms (énfasis); curvas `easeOutCubic` / `easeInOut` |
| Transiciones de página | Desvanecer + desplazamiento corto; contenedor transformado al abrir "Registrar" desde el botón "+" |
| Saldo y totales | Conteo animado al cambiar de valor |
| Listas | Entrada escalonada breve; eliminar con deslizamiento y "Deshacer" |
| Guardar movimiento | Háptico ligero + marca de verificación animada |
| Progreso de deuda/meta | Barra y anillo que se llenan con animación |
| Gráficas | Dibujo progresivo al aparecer |
| Cambio de tema | Transición suave de color |
| Reducir movimiento | Si `MediaQuery.disableAnimations` es verdadero, desactiva o acorta todo |

## Pantallas de carga y estados
- **Splash nativo** (Android 12+ API de splash + `flutter_native_splash` o equivalente con ADR) y **splash animado** breve (< 1 s) con el logotipo dibujado en código; nunca bloquees el arranque por la animación.
- **Carga:** esqueletos con brillo suave (implementación propia) para tarjetas, listas y gráficas; evita ruedas de carga a pantalla completa.
- **Progreso:** barra con porcentaje en descargas de actualización y en backup/restauración.
- **Vacío:** ilustración dibujada en código + mensaje + acción principal.
- **Error:** mensaje localizado por código de `Failure` + botón reintentar.
- **Éxito:** confirmación breve (snackbar o animación), no diálogos.
- Toda pantalla implementa los cuatro estados: carga, vacío, error y datos.

## Widgets de Android
Implementa `T-081` a `T-084` según `08`: gasto rápido, ingreso rápido y resumen; respetan tema claro/oscuro, se redimensionan y abren `finanzas://quick-add` mediante el parser que dejó el agente de lógica. Lo que requiera que una persona agregue el widget al escritorio va a `Manual.md`.

## Reglas
- Sigue `09_guia_de_desarrollo.md`: pocos comentarios, widgets pequeños, sin lógica de negocio en `build`, sin textos ni colores fijos.
- Cada pantalla se prueba en claro/oscuro, es/en, pequeño/grande y escala 1.3×.
- Contraste AA verificado; etiquetas semánticas en botones e íconos.
- Dinero siempre mostrado con el formateo de `Money`; nunca formatear a mano.

## Pruebas antes de cerrar
- Pruebas de widget por pantalla: los cuatro estados, ambos temas, ambos idiomas, tamaños pequeño y grande.
- Golden tests de los componentes principales (claro/oscuro).
- Comando limpio:
```
dart format --set-exit-if-changed .
flutter analyze
flutter test
flutter build apk --debug
```
- Búsqueda de infracciones (deben dar 0 resultados fuera de tokens/tema): `Color(0x` y `Colors.` en `presentation/`, cadenas literales en `Text('...')`.

## Cierre (obligatorio)
1. En `docs/ESTADO.md` cambia la segunda línea a `AGENTE_VISUAL: COMPLETO` **solo** si todo lo anterior pasa; completa la sección *Agente visual* con fecha, resultados y tareas `[x]`.
2. Agrega a `docs/Manual.md` (sección "Pendientes generados por agentes") lo que requiere intervención humana (por ejemplo, ícono final, probar widgets en un teléfono real).
3. Entrega resumen corto: qué hiciste, qué falta, qué debe hacer el usuario.

## Prompt de inicio
```
Eres el agente visual de la app Finanzas Personales. Primero lee docs/ESTADO.md y verifica que AGENTE_LOGICA sea COMPLETO y que analyze y test pasen; si no, detente y avísame. Si todo está bien, lee docs/00 al docs/11, luego docs/13_agente_visual.md y sigue sus instrucciones. No modifiques la lógica de negocio. Al terminar actualiza docs/ESTADO.md y docs/Manual.md.
```
