import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../repositories/backup_repository.dart';

class CreateBackup {
  final BackupRepository _repository;

  const CreateBackup(this._repository);

  Future<Result<String, Failure>> call({
    required String directoryPath,
    String? customFileName,
  }) async {
    final saveRes = await _repository.saveBackupToFile(
      directoryPath: directoryPath,
      customFileName: customFileName,
    );
    if (saveRes.isOk) {
      // Prune to maintain 10 backups retention (T-091)
      await _repository.pruneBackups(
        directoryPath: directoryPath,
        keepCount: 10,
      );
    }
    return saveRes;
  }
}
