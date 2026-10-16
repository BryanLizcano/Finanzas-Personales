import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../data/repositories/backup_repository_impl.dart';
import '../../domain/repositories/backup_repository.dart';
import '../../domain/usecases/create_backup.dart';
import '../../domain/usecases/restore_backup.dart';
import '../../domain/usecases/schedule_auto_backup.dart';

final backupRepositoryProvider = Provider<BackupRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return BackupRepositoryImpl(db);
});

final createBackupUseCaseProvider = Provider<CreateBackup>((ref) {
  return CreateBackup(ref.watch(backupRepositoryProvider));
});

final restoreBackupUseCaseProvider = Provider<RestoreBackup>((ref) {
  return RestoreBackup(ref.watch(backupRepositoryProvider));
});

final scheduleAutoBackupUseCaseProvider = Provider<ScheduleAutoBackup>((ref) {
  return const ScheduleAutoBackup();
});
