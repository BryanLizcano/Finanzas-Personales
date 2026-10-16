import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../repositories/update_repository.dart';

class DownloadAndVerifyUpdate {
  final UpdateRepository _repository;

  const DownloadAndVerifyUpdate(this._repository);

  Future<Result<String, Failure>> call({
    required String downloadUrl,
    required String expectedSha256,
    required String destinationFilePath,
    void Function(double progress)? onProgress,
  }) async {
    return _repository.downloadAndVerifyUpdate(
      downloadUrl: downloadUrl,
      expectedSha256: expectedSha256,
      destinationFilePath: destinationFilePath,
      onProgress: onProgress,
    );
  }
}
