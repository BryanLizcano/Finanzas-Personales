import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../entities/update_info.dart';

abstract class UpdateRepository {
  Future<Result<UpdateInfo, Failure>> checkForUpdate();

  Future<Result<String, Failure>> downloadAndVerifyUpdate({
    required String downloadUrl,
    required String expectedSha256,
    required String destinationFilePath,
    void Function(double progress)? onProgress,
  });
}
