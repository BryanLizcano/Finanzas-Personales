# Registro de Decisiones de Arquitectura (ADR)

Este documento registra las decisiones arquitectónicas clave adoptadas en la aplicación de Finanzas Personales.

---

## ADR-001: Clean Architecture por Funcionalidades (Feature-First)

### Estado
Aceptado

### Contexto
La aplicación maneja múltiples dominios financieros interconectados (cuentas, transacciones, deudas, préstamos, metas de ahorro, presupuestos y reportes) y requiere desacoplar la lógica de negocio de la tecnología de presentación (Flutter) y persistencia (Drift/SQLite).

### Decisión
Organizar el código siguiendo Clean Architecture estructurado por funcionalidades (`features/*`):
- `domain`: entidades inmutables puras en Dart, interfaces de repositorios y casos de uso individuales con un único método de ejecución (`call` o `execute`). Sin dependencias de Flutter ni plugins.
- `data`: implementación de repositorios, DAOs de Drift, mapeadores (Data Models <-> Domain Entities) y servicios de plataforma.
- `presentation`: notifiers y providers de Riverpod que exponen estado a los widgets (responsabilidad del agente visual).

### Consecuencias
- Facilidad de pruebas unitarias al 100% en la capa de dominio sin emuladores ni mocks de Flutter.
- Contrato claro entre agentes (el agente de lógica expone use cases y providers en `README.md` de cada feature).

---

## ADR-002: Persistencia Local con Drift (SQLite) sin Backend

### Estado
Aceptado

### Contexto
La aplicación es 100% offline-first (RNF-01). No existe servidor central ni Firebase. Los datos del usuario residen exclusivamente en su dispositivo. Se requieren consultas SQL reactivas (`Stream`), agregaciones eficientes para reportes y migraciones seguras y versionadas.

### Decisión
Utilizar Drift (`drift`, `drift_dev`, `sqlite3_flutter_libs`) para gestionar SQLite localmente.
- Esquema relacional con claves foráneas e índices en transacciones (`occurred_at`, `account_id`, `category_id`, `debt_id`, `receivable_id`).
- Consultas reactivas expuestas como `Stream` hacia la capa de presentación.
- Pruebas de integración con base de datos en memoria (`NativeDatabase.memory()`).

### Consecuencias
- Seguridad de tipos en tiempo de compilación.
- Soporte para migraciones de esquema verificables en tests.

---

## ADR-003: Representación de Dinero con Números Enteros (`Money` y `Currency`)

### Estado
Aceptado

### Contexto
Los tipos de coma flotante (`double`) introducen errores de redondeo en aritmética financiera (p.ej. `0.1 + 0.2 = 0.30000000000000004`). Los requerimientos RNF-02 y RN-01 prohíben explícitamente el uso de `double` para montos.

### Decisión
Crear una abstracción `Money` inmutable en `lib/core/money/`:
- `units`: entero (`int` de 64 bits) representando la menor unidad de la divisa (pesos para COP con 0 decimales, centavos para USD y EUR con 2 decimales).
- `currency`: enum `Currency` (`cop`, `usd`, `eur`).
- Operaciones aritméticas seguras (+, -, *, división entera) que rechazan operaciones entre divisas distintas.
- Formateo basado en `intl` según la divisa e idioma del sistema o seleccionado.

### Consecuencias
- Cero errores de redondeo en acumulados, amortizaciones y saldos.
- Imposibilidad técnica de registrar dinero fraccionario inválido.

---

## ADR-004: Manejo Explícito de Errores con `Result<T, Failure>`

### Estado
Aceptado

### Contexto
Lanzar excepciones no tipadas a la capa de presentación degrada la robustez de la app y obliga a usar bloques `try/catch` propensos a omisiones. Se requiere que cada fallo de negocio tenga un código estable para que la UI lo traduzca en su respectivo idioma sin que la lógica contenga cadenas de texto localizadas.

### Decisión
Implementar el patrón `Result<T, Failure>`:
- `Success<T>` con el valor obtenido.
- `Error<T>` con un objeto `Failure` tipado (`FailureCode`, mensaje de depuración técnico opcional).
- Los casos de uso nunca lanzan excepciones no controladas hacia la UI; devuelven `Future<Result<T, Failure>>` o `Result<T, Failure>`.

### Consecuencias
- Obliga al llamador a manejar explícitamente el caso de error.
- Desacopla la lógica de las cadenas de texto del usuario (RNF-06).

---

## ADR-005: Formato y Estrategia de Copias de Seguridad (Backup JSON Versionado)

### Estado
Aceptado

### Contexto
El usuario es dueño de sus datos y debe poder respaldarlos en una carpeta de su elección y restaurarlos en un nuevo dispositivo (RF-21, RF-22, RNF-10).

### Decisión
- Generar archivos JSON con nombre `finanzas_backup_YYYYMMDD_HHmm.json`.
- Estructura con metadatos: `schemaVersion`, `appVersion`, `createdAt`, `checksum` (SHA-256 del bloque de datos serializado) y `data` conteniendo todas las entidades.
- Validación estricta previa a la restauración:
  1. Integridad del JSON.
  2. Verificación del checksum SHA-256.
  3. Comprobación de que `schemaVersion` sea menor o igual al soportado por la versión actual de la app.
- Creación de un respaldo automático del estado actual antes de sobrescribir cualquier dato.
- Restauración atómica en una única transacción de SQLite.

### Consecuencias
- Protección contra corrupción de datos y pérdida accidental.
- Compatibilidad hacia adelante y atrás controlada.

---

## ADR-006: Actualizaciones In-App mediante GitHub Releases API

### Estado
Aceptado

### Contexto
Para distribución independiente y directa sin depender de tiendas comerciales (RF-25, 08_plataforma_widgets_backup_updates.md), la app debe verificar si existen nuevas versiones, descargar el APK y facilitar su instalación.

### Decisión
- Consumir el endpoint público `https://api.github.com/repos/{owner}/{repo}/releases/latest`.
- Comparar semver (`vMAJOR.MINOR.PATCH`) de la versión instalada contra el `tag_name`.
- Descargar el archivo APK (`app-release.apk`) junto a su `app-release.apk.sha256`.
- Verificar el hash SHA-256 antes de solicitar al sistema la apertura del archivo de instalación.
- Configurar valores por defecto `TODO_OWNER` y `TODO_REPO` para desacoplar el código de un repositorio específico hasta su despliegue final.

### Consecuencias
- Independencia total de servicios privativos.
- Seguridad reforzada mediante comprobación de firma de hash.
