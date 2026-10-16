import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';

abstract class AutoBackupScheduler {
  Future<void> scheduleDailyBackup();
  Future<void> cancelDailyBackup();
}

class ScheduleAutoBackup {
  final AutoBackupScheduler? _scheduler;

  const ScheduleAutoBackup([this._scheduler]);

  Future<Result<void, Failure>> call() async {
    try {
      await _scheduler?.scheduleDailyBackup();
      return const Result.ok(null);
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }
}
