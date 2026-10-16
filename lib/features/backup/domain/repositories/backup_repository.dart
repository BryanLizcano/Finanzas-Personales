import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../entities/backup_manifest.dart';

abstract class BackupRepository {
  Future<Result<String, Failure>> createBackupJson();

  Future<Result<BackupManifest, Failure>> validateBackupJson(String jsonString);

  Future<Result<void, Failure>> restoreFromJson(String jsonString);

  Future<Result<String, Failure>> saveBackupToFile({
    required String directoryPath,
    String? customFileName,
  });

  Future<Result<void, Failure>> pruneBackups({
    required String directoryPath,
    int keepCount = 10,
  });
}
