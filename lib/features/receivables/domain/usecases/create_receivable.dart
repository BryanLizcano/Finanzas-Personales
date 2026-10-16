import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../entities/receivable.dart';
import '../repositories/receivable_repository.dart';

class CreateReceivable {
  final ReceivableRepository _repository;

  const CreateReceivable(this._repository);

  Future<Result<ReceivableEntity, Failure>> call({
    required String person,
    required int initialAmount,
    required DateTime createdAt,
    String note = '',
  }) async {
    final trimmedPerson = person.trim();
    if (trimmedPerson.isEmpty) {
      return const Result.error(
        Failure(FailureCode.invalidAmount, 'Person name cannot be empty'),
      );
    }
    if (initialAmount <= 0) {
      return const Result.error(
        Failure(FailureCode.invalidAmount, 'Amount must be greater than 0'),
      );
    }

    return _repository.createReceivable(
      person: trimmedPerson,
      initialAmount: initialAmount,
      createdAt: createdAt,
      note: note.trim(),
    );
  }
}
