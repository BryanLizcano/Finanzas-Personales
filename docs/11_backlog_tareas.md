# 11 — Backlog de tareas

Cada tarea: **ID — descripción — requerimientos — criterio de aceptación (CA)**. Orden de ejecución de arriba abajo salvo dependencias. Terminar con la Definition of Done de `09`.

## Hitos
| Hito | Contenido | Resultado |
|------|-----------|-----------|
| M0 | Base del proyecto | Repo, CI, tema, i18n, DB vacía |
| M1 | Núcleo de movimientos | Registrar y ver ingresos/gastos |
| M2 | Deudas, cobros y ahorro | Flujo financiero completo |
| M3 | Presupuesto y reportes | Disponible seguro y resumen |
| M4 | Plataforma | Widgets, backup, actualización |
| M5 | Pulido y release 1.0 | Pruebas, accesibilidad, APK firmado |

## E0 — Fundaciones (M0)
- **T-001** Crear proyecto Flutter, estructura de carpetas de `03`, `analysis_options.yaml` estricto. CA: `flutter analyze` sin warnings.
- **T-002** CI en GitHub Actions: formato, análisis, pruebas. CA: PR falla si algo rompe.
- **T-003** Localización es/en con ARB y selector (sistema por defecto). RF-19, RNF-06. CA: cambiar idioma actualiza toda la UI sin reiniciar.
- **T-004** Tema claro/oscuro con tokens de `07` y `ThemeExtension`. RF-20. CA: sigue al sistema; cambio manual persistente.
- **T-005** `Money`, `Currency` (COP/USD/EUR) y formateo. RF-18, RNF-02. CA: pruebas de formato y aritmética sin `double`.
- **T-006** `Result`, `Failure` y manejo global de errores.
- **T-007** Configurar Drift, esquema v1, migración inicial con categorías por defecto. CA: prueba de migración.
- **T-008** Router con go_router y barra de navegación inferior de 4 destinos. CA: navegación estable en pantallas pequeñas.
- **T-009** Primer arranque: elegir moneda, ingreso base opcional y cuenta inicial.

## E1 — Cuentas y categorías (M1)
- **T-010** Dominio y data de cuentas. RF-01. CA: crear, editar, archivar; saldo calculado.
- **T-011** Dominio y data de categorías. RF-04, RF-05. CA: por defecto traducidas; crear; inhabilitar; no borrar con uso.
- **T-012** Pantalla de categorías con interruptores. CA: las inactivas no aparecen al registrar.

## E2 — Transacciones (M1)
- **T-020** Caso de uso `AddTransaction` con validaciones de `04`. RF-02. CA: pruebas de todas las reglas de integridad.
- **T-021** Pantalla Registrar con teclado numérico, categorías en rejilla, cuenta y fecha. CA: registrar en ≤ 5 toques; adaptativa.
- **T-022** Lista de movimientos agrupada por día con stream reactivo. CA: fluida con 10 000 registros.
- **T-023** Editar, eliminar lógico y deshacer. RF-03.
- **T-024** Transferencias entre cuentas. CA: no cuentan como ingreso ni gasto.
- **T-025** Filtros y búsqueda. RF-23.

## E3 — Deudas (M2)
- **T-030** Entidad y repositorio de deudas. RF-06.
- **T-031** Abono a deuda (`RegisterDebtPayment`). RF-07, RN-14, RN-15. CA: crea gasto vinculado y reduce saldo; no excede.
- **T-032** Pantallas de lista y detalle con progreso e historial.
- **T-033** Sugerencia de abono por estrategia. RF-08, RN-13. CA: pruebas de avalancha y bola de nieve.
- **T-034** Recordatorio de cuota próxima. RN-17.

## E4 — Préstamos por cobrar (M2)
- **T-040** Entidad y repositorio. RF-09.
- **T-041** Registrar cobro (`RegisterCollection`). RF-10, RN-18, RN-20. CA: crea ingreso vinculado; reduce saldo; no excede.
- **T-042** Pantallas por persona con historial. CA: el total por cobrar no se suma al disponible.

## E5 — Ahorro (M2)
- **T-050** Metas y aportes. RF-11, RN-25. CA: progreso correcto.
- **T-051** Pantalla de metas con progreso circular.

## E6 — Presupuesto (M3)
- **T-060** Ingreso base y cálculo de ingreso extra. RF-12, RN-04 a RN-07.
- **T-061** Reglas de reparto y sugerencias. RF-13, RN-09 a RN-12. CA: porcentajes suman 100; nada se crea sin confirmar.
- **T-062** Disponible seguro. RF-15. CA: caso de déficit en rojo.

## E7 — Reportes (M3)
- **T-070** Resumen mensual en Inicio. RF-14.
- **T-071** Dona por categoría y barras mensuales (SQL agregado).
- **T-072** Reportes "Moto" y "Salidas y pareja". RN-22, RN-23.
- **T-073** Recordatorios de moto (SOAT, tecnomecánica, mantenimiento). RF-16.

## E8 — Widgets (M4)
- **T-080** Deep link `finanzas://quick-add` y `QuickAddPage`. RF-17.
- **T-081** Widget Kotlin de gasto rápido. CA: del toque a guardado ≤ 5 s.
- **T-082** Widget de ingreso rápido.
- **T-083** Widget de resumen y actualización de datos tras cada cambio.
- **T-084** Ajuste para elegir qué categorías muestran los widgets.

## E9 — Copias de seguridad (M4)
- **T-090** Serialización JSON versionada con checksum. RF-21, RNF-10.
- **T-091** Selección de carpeta (SAF), creación manual y retención de 10.
- **T-092** Backup automático con workmanager y antes de migraciones.
- **T-093** Restauración con validación, vista previa y copia previa. RF-22. CA: ida y vuelta sin pérdida de datos.
- **T-094** Compartir copia y recordatorio mensual.

## E10 — Actualizaciones (M4)
- **T-100** Cliente de GitHub Releases y comparación semver. RF-25.
- **T-101** Descarga con progreso, verificación SHA-256 e instalación. CA: maneja sin red y descarga interrumpida.
- **T-102** Workflow de release firmado en GitHub Actions al subir un tag.
- **T-103** Pantalla "Acerca de / Actualizaciones" con notas del release.

## E11 — Pulido (M5)
- **T-110** Revisión de adaptabilidad: pantallas pequeña/mediana/grande y escala 1.3×.
- **T-111** Revisión de contraste y accesibilidad (etiquetas semánticas).
- **T-112** Estados vacíos, de carga y de error en todas las pantallas.
- **T-113** Pruebas de integración de flujos críticos.
- **T-114** Rendimiento con datos de 10 000 transacciones.
- **T-115** Documentación final, CHANGELOG y release 1.0.0.

## Post-MVP
Transacciones recurrentes (RF-24), bloqueo biométrico (RF-26), exportar CSV (RF-27), cifrado de backups, moneda por cuenta con tasas manuales, tablet, registro de widget sin abrir la app.
