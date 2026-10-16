# Finanzas Personales — Documentación para agentes

App móvil (Android primero) para llevar finanzas personales con ingresos variables, deudas, préstamos por cobrar, gastos de moto, ahorro y widgets de registro rápido. **Offline-first, datos locales, sin backend.**

## Orden de lectura obligatorio
| # | Archivo | Contenido |
|---|---------|-----------|
| 01 | `01_vision_y_alcance.md` | Problema, objetivos, alcance MVP / fuera de alcance |
| 02 | `02_requerimientos.md` | Requerimientos funcionales (RF) y no funcionales (RNF) con IDs |
| 03 | `03_arquitectura.md` | Clean Architecture, estructura de carpetas, stack |
| 04 | `04_modelo_de_datos.md` | Entidades, tablas, reglas de integridad |
| 05 | `05_diagramas.md` | Casos de uso, flujos, secuencias (Mermaid) |
| 06 | `06_reglas_de_negocio.md` | Reglas de dinero, deudas, préstamos, reparto de ingresos |
| 07 | `07_diseno_ui_ux.md` | Paleta, temas, adaptabilidad, i18n, monedas |
| 08 | `08_plataforma_widgets_backup_updates.md` | Widgets, copias de seguridad, actualización in-app |
| 09 | `09_guia_de_desarrollo.md` | Reglas de código, git, pruebas, CI |
| 10 | `10_decisiones_adr.md` | Decisiones tomadas y su justificación |
| 11 | `11_backlog_tareas.md` | Épicas, tareas, criterios de aceptación, hitos |

## Resumen técnico
- **Framework:** Flutter (Dart), Android como objetivo principal.
- **Datos:** SQLite local con Drift. Sin Firestore ni backend.
- **Estado/DI:** Riverpod. **Navegación:** go_router.
- **Idiomas:** español e inglés (por defecto el del sistema). **Monedas:** COP, USD, EUR.
- **Tema:** claro/oscuro (por defecto el del sistema), Material 3.
- **Copias de seguridad:** archivo versionado en una carpeta elegida por el usuario.
- **Actualizaciones:** GitHub Releases + instalación del APK desde la app.

## Reglas para el agente
1. Lee los 11 archivos antes de escribir código.
2. Trabaja **una tarea del backlog a la vez** (`11_backlog_tareas.md`), por ID.
3. Si una decisión no está documentada, propón un ADR en `10_decisiones_adr.md` antes de implementarla.
4. Toda tarea termina con la Definition of Done de `09_guia_de_desarrollo.md`.
5. Si cambias comportamiento, actualiza el documento correspondiente en el mismo PR.
