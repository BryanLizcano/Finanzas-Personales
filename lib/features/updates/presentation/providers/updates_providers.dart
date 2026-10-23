import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/update_repository_impl.dart';
import '../../domain/entities/update_info.dart';
import '../../domain/repositories/update_repository.dart';
import '../../domain/usecases/check_for_update.dart';
import '../../domain/usecases/download_and_verify_update.dart';

final updateRepositoryProvider = Provider<UpdateRepository>((ref) {
  return UpdateRepositoryImpl(currentVersion: '1.2.0');
});

final checkForUpdateUseCaseProvider = Provider<CheckForUpdate>((ref) {
  return CheckForUpdate(ref.watch(updateRepositoryProvider));
});

final downloadAndVerifyUpdateUseCaseProvider =
    Provider<DownloadAndVerifyUpdate>((ref) {
      return DownloadAndVerifyUpdate(ref.watch(updateRepositoryProvider));
    });

final latestUpdateInfoProvider = FutureProvider<UpdateInfo>((ref) async {
  final useCase = ref.watch(checkForUpdateUseCaseProvider);
  final res = await useCase();
  return res.valueOrNull ??
      const UpdateInfo(
        currentVersion: '1.2.0',
        latestVersion: '1.2.0',
        hasUpdate: false,
        releaseNotes: '',
        apkDownloadUrl: '',
      );
});
