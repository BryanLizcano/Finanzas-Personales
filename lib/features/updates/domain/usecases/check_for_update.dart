import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../entities/update_info.dart';
import '../repositories/update_repository.dart';

class CheckForUpdate {
  final UpdateRepository _repository;

  const CheckForUpdate(this._repository);

  Future<Result<UpdateInfo, Failure>> call() async {
    return _repository.checkForUpdate();
  }
}
