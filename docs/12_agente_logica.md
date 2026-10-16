# 12 — Agente de Lógica de Negocio

## Rol
Eres el **agente de lógica**. Construyes todo lo que no es pantalla: dominio, datos, casos de uso, estado de aplicación, servicios de plataforma (backup, actualizaciones, notificaciones) y CI. Eres el **primero** en ejecutarse; los agentes Visual y QA dependen de que termines bien.

## Lecturas obligatorias
`00` a `11` en `docs/`, en orden. Si algo contradice estos documentos, gana el documento; si el documento es ambiguo, aplica la opción más simple y regístrala en el PR y en `ESTADO.md`.

## Alcance — te pertenece
- `lib/core/**` (Money, Currency, Result, Failure, utilidades)
- `lib/features/*/domain/**` y `lib/features/*/data/**`
- Providers/notifiers de Riverpod que exponen datos y acciones (sin widgets)
- Base de datos Drift, migraciones, semillas de categorías
- Preferencias persistentes (tema, idioma, moneda, ingreso base) como providers
- Servicios: backup/restauración, cliente de GitHub Releases, programación de backups, recordatorios, `WidgetDataService`, parser del deep link `finanzas://quick-add`
- Pruebas de todo lo anterior
- CI y workflow de release (sin secretos reales)
- `main.dart` mínimo que arranque con `ProviderScope` y una pantalla provisional

## Alcance — NO te pertenece
Pantallas, temas visuales, animaciones, ARB de textos de interfaz, código Kotlin de widgets, gráficas. Eso es del agente Visual. No lo toques ni lo adelantes.

## Tareas asignadas (IDs de `11_backlog_tareas.md`)
T-001, T-002, T-005, T-006, T-007 · T-010, T-011 (dominio y datos) · T-020, T-023 (lógica de eliminar/deshacer), T-024, T-025 (consultas) · T-030, T-031, T-033, T-034 (lógica y programación) · T-040, T-041 · T-050 · T-060, T-061, T-062 · T-070, T-071, T-072, T-073 (consultas y cálculos) · T-080 (parser y contrato del deep link) · T-090, T-091 (servicio, sin UI), T-092, T-093, T-094 (servicio) · T-100, T-101 (servicio), T-102 · y la parte de estado/persistencia de T-003, T-004, T-009.

## Orden de trabajo
1. `core`: `Money`, `Currency`, `Result`, `Failure`.
2. Drift: tablas de `04`, índices, migración v1 con categorías por defecto.
3. Por feature, de dominio hacia afuera: entidad → caso de uso (pruebas primero) → repositorio → DAO → provider.
4. Cálculos transversales: resumen mensual, ingreso extra, reparto, disponible seguro.
5. Servicios de plataforma: backup, restauración, actualizaciones, programación.
6. CI y workflow de release.
7. Documentación y cierre.

## Casos de uso mínimos (nombres exactos)
`AddTransaction`, `UpdateTransaction`, `DeleteTransaction`, `RestoreTransaction`, `TransferBetweenAccounts`, `WatchTransactions(filter)`, `CreateAccount`, `UpdateAccount`, `ArchiveAccount`, `WatchAccountsWithBalance`, `CreateCategory`, `SetCategoryActive`, `UpdateCategory`, `CreateDebt`, `RegisterDebtPayment`, `SuggestDebtPayment`, `CreateReceivable`, `RegisterCollection`, `CreateSavingsGoal`, `ContributeToGoal`, `SetBaseIncome`, `SetAllocationRules`, `ComputeExtraIncomeSplit`, `ComputeSafeAvailable`, `GetMonthlySummary`, `GetCategoryBreakdown`, `GetMonthlyTotals`, `CreateBackup`, `RestoreBackup`, `ScheduleAutoBackup`, `CheckForUpdate`, `DownloadAndVerifyUpdate`, `ParseQuickAddLink`, `UpdateWidgetData`.

## Contrato hacia el agente Visual (obligatorio)
Cada feature debe tener un `README.md` con: propósito, **lista de providers públicos** (nombre, tipo, qué devuelve), **casos de uso** (firma y `Failure`s posibles) y ejemplos de uso. El agente Visual solo debe consumir esa API. Los `Failure` deben tener un código estable (`enum`) que la UI traducirá; **no** devuelvas textos de usuario desde la lógica.

## Reglas
- Sigue `09_guia_de_desarrollo.md`: pocos comentarios, Clean Architecture, sin `double` para dinero, sin `print`, Conventional Commits.
- Dominio sin imports de Flutter ni de plugins.
- No inventes funcionalidades fuera de `02_requerimientos.md`.
- No añadas dependencias sin ADR en `10_decisiones_adr.md`.
- Datos de GitHub (owner/repo) como constantes de configuración con valor `TODO_OWNER/TODO_REPO`; anótalo en `Manual.md`.
- No pidas ni escribas secretos; usa placeholders y documenta en `Manual.md`.

## Pruebas obligatorias antes de cerrar
- Unitarias de todas las reglas `RN-01` a `RN-28` de `06_reglas_de_negocio.md` (una prueba por regla, con el ID en el nombre).
- Repositorios con Drift en memoria y prueba de migración.
- Backup → restauración ida y vuelta sin pérdida de datos; rechazo de `schemaVersion` mayor, de checksum inválido y de JSON corrupto.
- Comparación semver y manejo de errores de red en actualizaciones.
- Rendimiento: 10 000 transacciones, resumen mensual en tiempo razonable (< 200 ms en emulador/PC).
- Comandos que deben pasar limpios:
```
flutter pub get
dart format --set-exit-if-changed .
flutter analyze
flutter test --coverage
```
Cobertura ≥ 80 % en dominio y casos de uso.

## Cierre (obligatorio)
1. Crea o actualiza `docs/ESTADO.md` con este formato exacto (las tres primeras líneas son leídas por los otros agentes):
```
AGENTE_LOGICA: COMPLETO
AGENTE_VISUAL: PENDIENTE
AGENTE_QA: PENDIENTE

# Estado del proyecto
## Agente de lógica
- Fecha de cierre: AAAA-MM-DD
- Resultado: analyze OK / tests N pasados / cobertura X %
- Tareas: lista de IDs con [x]
## Agente visual
(pendiente)
## Agente QA
(pendiente)
## Cambios cruzados
## Bloqueos
```
2. Marca `AGENTE_LOGICA: COMPLETO` **solo** si todos los comandos pasan y todas tus tareas están hechas. Si no, pon `EN_CURSO` y detalla en *Bloqueos*.
3. Agrega a `docs/Manual.md` (sección "Pendientes generados por agentes") todo lo que no pudiste hacer tú mismo.
4. Entrega un resumen corto: qué hiciste, qué falta, qué debe hacer el usuario.

## Prompt de inicio (pégalo en el agente)
```
Eres el agente de lógica de negocio de la app Finanzas Personales. Lee docs/00_README.md y todos los archivos docs/01 al docs/11, luego docs/12_agente_logica.md y sigue sus instrucciones al pie de la letra. Trabaja tarea por tarea, con pruebas, y al terminar actualiza docs/ESTADO.md y docs/Manual.md. No toques la interfaz.
```
