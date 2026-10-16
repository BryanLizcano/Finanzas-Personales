import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../entities/receivable.dart';

abstract class ReceivableRepository {
  Future<Result<ReceivableEntity, Failure>> createReceivable({
    required String person,
    required int initialAmount,
    required DateTime createdAt,
    String note = '',
  });

  Future<Result<void, Failure>> archiveReceivable({
    required int id,
    required bool archived,
  });

  Future<Result<ReceivableEntity?, Failure>> getReceivableById(int id);

  Future<Result<ReceivableWithBalance, Failure>> getReceivableWithBalance(
    int id,
  );

  Stream<List<ReceivableWithBalance>> watchReceivablesWithBalance({
    bool includeArchived = false,
  });

  Future<List<ReceivableWithBalance>> getReceivablesWithBalance({
    bool includeArchived = false,
  });

  Future<int> getTotalPendingReceivable();
}
