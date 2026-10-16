# 09 — Guía de desarrollo

## Principios de código
1. **Pocos comentarios.** El código se explica solo con buenos nombres. Comentar únicamente el *porqué* no obvio (una regla de negocio, un workaround). Prohibido comentar el *qué*, código muerto o TODOs sin issue.
2. **Clean Architecture** estricta: dominio sin dependencias de Flutter ni de plugins.
3. **SOLID, funciones cortas** (≈ 20 líneas), una responsabilidad por clase, archivos < 300 líneas.
4. **Inmutabilidad:** entidades con `freezed`; sin estado mutable compartido.
5. **Dinero:** siempre tipo `Money` (entero + moneda). Prohibido `double` para montos.
6. **Sin textos ni colores fijos** en widgets: localización y tema.
7. **Errores explícitos** con `Result<T, Failure>`; sin `catch` vacíos ni `print`.
8. **Null safety estricta**, sin `!` salvo con justificación en una línea.
9. **Nombres en inglés** en código; textos de usuario en ARB.
10. **Widgets pequeños y reutilizables**; sin lógica de negocio en `build`.

## Convenciones
- Archivos `snake_case.dart`; clases `PascalCase`; providers terminan en `Provider`; casos de uso en infinitivo (`AddTransactionUseCase`).
- Un caso de uso = una acción de negocio, con un método `call` o `execute`.
- Imports ordenados; usar rutas relativas dentro de un feature y absolutas (`package:`) entre features.
- Lint estricto en `analysis_options.yaml`; CI falla con cualquier warning.

## Git
- Ramas: `main` (estable, solo releases), `develop`, `feat/<id>-nombre`, `fix/<id>-nombre`.
- **Conventional Commits:** `feat:`, `fix:`, `refactor:`, `test:`, `docs:`, `chore:`.
- PR pequeño, vinculado a una tarea del backlog, con descripción y captura si cambia la UI.
- Versionado semántico; `CHANGELOG.md` actualizado en cada release.

## Pruebas
| Nivel | Qué | Meta |
|-------|-----|------|
| Unitarias | Casos de uso, entidades, reglas de negocio, `Money` | ≥ 80 % del dominio |
| Repositorios | Drift en memoria, incluida migración | Todas las consultas |
| Widget | Pantallas clave en claro/oscuro, es/en, tamaños pequeño/grande, escala 1.3× | MVP |
| Golden (opcional) | Componentes de diseño | |
| Integración | Registrar gasto, abonar deuda, backup y restaurar | Flujos críticos |

Test-first para reglas de negocio. Datos de prueba mediante builders.

## Documentación
- Cada feature con un `README.md` breve (propósito, casos de uso, decisiones).
- Decisiones relevantes como ADR en `10_decisiones_adr.md`.
- Actualizar el documento correspondiente en el mismo PR que cambia el comportamiento.
- Mermaid para diagramas, versionado como texto.

## Seguridad y privacidad
- Sin telemetría ni permisos innecesarios.
- Sin secretos en el repositorio; keystore y claves como secretos de CI.
- Validar toda entrada del usuario y todo archivo de backup antes de usarlo.

## Rendimiento
- Consultas paginadas y con índices; agregaciones en SQL, no en Dart.
- `const` donde se pueda; `ListView.builder`; evitar reconstrucciones amplias con `select` de Riverpod.

## Definition of Done
- [ ] Cumple los criterios de aceptación de la tarea
- [ ] Sin warnings de `flutter analyze`
- [ ] Pruebas nuevas y existentes en verde
- [ ] Probado en claro/oscuro, es/en y pantallas pequeña/grande
- [ ] Sin textos ni colores fijos
- [ ] Documentación y ADR actualizados si aplica
- [ ] Sin comentarios innecesarios ni código muerto
- [ ] PR revisado y con Conventional Commits

## Cómo trabaja un agente
1. Leer `00` a `11`.
2. Tomar una tarea por ID; si hay ambigüedad, anotar la suposición en el PR y seguir con la opción más simple coherente con los documentos.
3. Implementar de dominio hacia afuera: entidad → caso de uso (con pruebas) → repositorio → UI.
4. Ejecutar `dart format`, `flutter analyze`, `flutter test` antes de cada commit.
5. No añadir dependencias nuevas sin justificarlas en un ADR.
