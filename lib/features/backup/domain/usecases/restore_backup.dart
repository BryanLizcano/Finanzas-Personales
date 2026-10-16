import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../entities/backup_manifest.dart';
import '../repositories/backup_repository.dart';

class RestoreBackup {
  final BackupRepository _repository;

  const RestoreBackup(this._repository);

  Future<Result<BackupDataCounts, Failure>> validatePreview(
    String jsonString,
  ) async {
    final validation = await _repository.validateBackupJson(jsonString);
    if (validation.isError) {
      return Result.error(validation.errorOrNull!);
    }
    return Result.ok(validation.valueOrNull!.counts);
  }

  Future<Result<void, Failure>> call({
    required String jsonString,
    String? backupBeforeRestoreDirectory,
  }) async {
    // 1. Validate
    final validation = await _repository.validateBackupJson(jsonString);
    if (validation.isError) {
      return Result.error(validation.errorOrNull!);
    }

    // 2. Pre-restore automatic backup if directory provided (RF-22)
    if (backupBeforeRestoreDirectory != null) {
      await _repository.saveBackupToFile(
        directoryPath: backupBeforeRestoreDirectory,
        customFileName: 'pre_restore_backup.json',
      );
    }

    // 3. Atomically restore
    return _repository.restoreFromJson(jsonString);
  }
}
