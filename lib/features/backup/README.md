# Feature: Backup & Restore (Copias de Seguridad y Restauración)

## Propósito
Generación de copias de seguridad íntegras en formato JSON versionado (`schemaVersion: 1`), con validación de checksum SHA-256 para evitar corrupción o manipulación, retención automática de las últimas 10 copias y restauración atómica en una única transacción de SQLite.

## Providers Públicos

| Provider | Tipo | Qué devuelve |
|---|---|---|
| `createBackupUseCaseProvider` | `Provider<CreateBackup>` | Caso de uso para crear copia de seguridad manual en archivo |
| `restoreBackupUseCaseProvider` | `Provider<RestoreBackup>` | Caso de uso para previsualizar y restaurar desde archivo JSON |
| `scheduleAutoBackupUseCaseProvider` | `Provider<ScheduleAutoBackup>` | Caso de uso para programar backup automático |

## Casos de Uso

### `CreateBackup`
- **Firma:** `Future<Result<String, Failure>> call({required String directoryPath, String? customFileName})`
- Genera el archivo `finanzas_backup_YYYYMMDD_HHmm.json` en la carpeta elegida por el usuario y purga archivos antiguos para conservar las últimas 10 copias.

### `RestoreBackup`
- **Previsualización:** `Future<Result<BackupDataCounts, Failure>> validatePreview(String jsonString)`
  - Devuelve el conteo de elementos (`accountsCount`, `transactionsCount`, etc.) o `Failure` si el archivo es inválido, corrupto o de una versión no soportada.
- **Restauración:** `Future<Result<void, Failure>> call({required String jsonString, String? backupBeforeRestoreDirectory})`
  - **Failures posibles:**
    - `FailureCode.invalidBackupFile` (JSON malformado o estructura inválida)
    - `FailureCode.invalidBackupChecksum` (SHA-256 no coincide)
    - `FailureCode.unsupportedBackupVersion` (`schemaVersion > 1`)
  - Genera una copia de seguridad automática de seguridad antes de restaurar si se provee la ruta.
  - Reemplaza todas las tablas en una transacción atómica.

## Ejemplo de Uso en la UI
```dart
final restoreUseCase = ref.read(restoreBackupUseCaseProvider);

// 1. Validar y ver resumen
final previewRes = await restoreUseCase.validatePreview(fileContent);
previewRes.fold(
  onOk: (counts) {
    // Mostrar diálogo de confirmación: "Restaurarás ${counts.transactionsCount} movimientos..."
  },
  onError: (failure) {
    // Mostrar error según failure.code
  },
);

// 2. Confirmar restauración
final restoreRes = await restoreUseCase(
  jsonString: fileContent,
  backupBeforeRestoreDirectory: autoBackupFolder,
);
```
