# 05 — Diagramas

## Casos de uso
```mermaid
flowchart LR
  U((Usuario))
  U --> A[Registrar gasto / ingreso]
  U --> B[Transferir entre cuentas]
  U --> C[Gestionar categorías]
  U --> D[Registrar y abonar deudas]
  U --> E[Registrar préstamo y cobros]
  U --> F[Gestionar metas de ahorro]
  U --> G[Configurar ingreso base y reparto]
  U --> H[Ver resumen y reportes]
  U --> I[Crear / restaurar copia]
  U --> J[Actualizar la app]
  U --> K[Registrar desde widget]
  U --> L[Cambiar tema, idioma, moneda]
```

## Capas y dependencias
```mermaid
flowchart TB
  P[Presentation] --> D[Domain]
  Dt[Data] --> D
  Dt --> Drift[(Drift / SQLite)]
```

## Reparto de un ingreso extra
```mermaid
flowchart TD
  S([Ingreso registrado]) --> Q{¿Categoría cuenta<br/>para reparto?}
  Q -- No --> E([Fin])
  Q -- Sí --> R[Calcular monto extra<br/>sobre ingreso base]
  R --> D1[% a deudas → sugerir abono<br/>a la deuda prioritaria]
  R --> D2[% a ahorro → sugerir aporte<br/>a la meta activa]
  R --> D3[% libre → disponible]
  D1 --> N[Mostrar sugerencia al usuario]
  D2 --> N
  D3 --> N
  N --> E
```
La app **sugiere**; el usuario confirma cada movimiento.

## Secuencia: gasto desde el widget
```mermaid
sequenceDiagram
  actor U as Usuario
  participant W as Widget Android
  participant A as App (QuickAddPage)
  participant UC as AddTransactionUseCase
  participant R as TransactionRepository
  participant DB as SQLite
  U->>W: Toca categoría "Comida"
  W->>A: Deep link finanzas://quick-add?kind=expense&cat=food
  A->>U: Teclado numérico + cuenta preseleccionada
  U->>A: Ingresa monto y confirma
  A->>UC: execute(AddTransactionInput)
  UC->>R: insert(transaction)
  R->>DB: INSERT
  DB-->>R: ok
  R-->>UC: Result.ok
  UC-->>A: Result.ok
  A->>W: Actualiza datos del widget
  A-->>U: Confirmación y cierra
```

## Secuencia: abono de préstamo por cobrar
```mermaid
sequenceDiagram
  actor U as Usuario
  participant P as ReceivablePage
  participant UC as RegisterCollectionUseCase
  participant R as TransactionRepository
  U->>P: Ingresa abono de la persona
  P->>UC: execute(receivableId, amount, accountId)
  UC->>UC: Validar amount <= saldo pendiente
  UC->>R: insert(income, category loan_collection, receivable_id)
  R-->>UC: ok
  UC-->>P: nuevo saldo pendiente
```

## Estados de una deuda / préstamo
```mermaid
stateDiagram-v2
  [*] --> Activa
  Activa --> Activa: abono parcial
  Activa --> Saldada: saldo = 0
  Saldada --> Archivada: usuario archiva
  Saldada --> Activa: se elimina el último abono
```

## Secuencia: copia de seguridad
```mermaid
sequenceDiagram
  participant T as Disparador (manual / WorkManager)
  participant UC as CreateBackupUseCase
  participant DB as Repositorios
  participant F as Carpeta elegida (SAF)
  T->>UC: execute()
  UC->>DB: leer todas las tablas
  UC->>UC: serializar JSON + schemaVersion + checksum
  UC->>F: escribir finanzas_backup_YYYYMMDD_HHmm.json
  UC->>F: aplicar retención (últimas N)
  UC-->>T: Result.ok
```

## Secuencia: actualización dentro de la app
```mermaid
sequenceDiagram
  actor U as Usuario
  participant A as App
  participant G as GitHub Releases API
  U->>A: Ajustes → Buscar actualización
  A->>G: GET /repos/{owner}/{repo}/releases/latest
  G-->>A: tag, notas, URL del APK, SHA-256
  A->>A: Comparar con versión instalada (semver)
  alt Hay versión nueva
    A->>U: Mostrar notas y botón Actualizar
    U->>A: Confirma
    A->>G: Descargar APK (progreso)
    A->>A: Verificar SHA-256
    A->>U: Abrir instalador del sistema
  else Al día
    A->>U: Ya tienes la última versión
  end
```
