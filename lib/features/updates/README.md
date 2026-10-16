# Feature: In-App Updates (Actualizaciones desde GitHub Releases)

## Propósito
Comprobación e instalación de nuevas versiones de la aplicación a través de la API pública de GitHub Releases sin intermediarios de tiendas comerciales (RF-25). Incluye comparación de versiones semver, descarga con progreso y verificación criptográfica de SHA-256 antes de solicitar la instalación.

> [!NOTE]
> Configurado con placeholders `TODO_OWNER` y `TODO_REPO` (documentado en `Manual.md`).

## Providers Públicos

| Provider | Tipo | Qué devuelve |
|---|---|---|
| `latestUpdateInfoProvider` | `FutureProvider<UpdateInfo>` | Información de la última versión (si hay actualización, notas y URL de descarga) |
| `checkForUpdateUseCaseProvider` | `Provider<CheckForUpdate>` | Caso de uso para consultar actualizaciones |
| `downloadAndVerifyUpdateUseCaseProvider` | `Provider<DownloadAndVerifyUpdate>` | Caso de uso para descargar y verificar el hash SHA-256 |

## Casos de Uso

### `CheckForUpdate`
- **Firma:** `Future<Result<UpdateInfo, Failure>> call()`
- **Failures posibles:**
  - `FailureCode.networkError` (sin conexión a internet o error en la API de GitHub)

### `DownloadAndVerifyUpdate`
- **Firma:** `Future<Result<String, Failure>> call({required String downloadUrl, required String expectedSha256, required String destinationFilePath, void Function(double progress)? onProgress})`
- **Failures posibles:**
  - `FailureCode.packageDownloadFailed`
  - `FailureCode.sha256VerificationFailed`

## Ejemplo de Uso en la UI
```dart
final updateAsync = ref.watch(latestUpdateInfoProvider);

updateAsync.when(
  data: (info) {
    if (info.hasUpdate) {
      return Card(
        child: ListTile(
          title: Text('Nueva versión disponible: ${info.latestVersion}'),
          subtitle: Text(info.releaseNotes),
          trailing: ElevatedButton(
            onPressed: () async {
              final download = ref.read(downloadAndVerifyUpdateUseCaseProvider);
              await download(
                downloadUrl: info.apkDownloadUrl,
                expectedSha256: info.sha256Expected ?? '',
                destinationFilePath: targetPath,
                onProgress: (p) => print('Progreso: $p'),
              );
            },
            child: const Text('Actualizar'),
          ),
        ),
      );
    }
    return const Text('La aplicación está al día.');
  },
  loading: () => const CircularProgressIndicator(),
  error: (err, stack) => Text('Error al buscar actualizaciones'),
);
```
