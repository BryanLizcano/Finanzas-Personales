import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../categories/domain/repositories/category_repository.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../repositories/receivable_repository.dart';

class RegisterCollection {
  final ReceivableRepository receivableRepository;
  final CategoryRepository categoryRepository;
  final TransactionRepository transactionRepository;

  const RegisterCollection({
    required this.receivableRepository,
    required this.categoryRepository,
    required this.transactionRepository,
  });

  Future<Result<TransactionEntity, Failure>> call({
    required int receivableId,
    required int amount,
    required int accountId,
    required DateTime occurredAt,
    String note = '',
  }) async {
    // 1. Validate amount
    if (amount <= 0) {
      return const Result.error(
        Failure(
          FailureCode.invalidAmount,
          'Collection amount must be greater than 0',
        ),
      );
    }

    // 2. Fetch receivable with balance
    final recRes = await receivableRepository.getReceivableWithBalance(
      receivableId,
    );
    if (recRes.isError) {
      return Result.error(recRes.errorOrNull!);
    }
    final receivableWithBalance = recRes.valueOrNull!;

    // 3. RN-20: collection cannot exceed pending balance
    if (amount > receivableWithBalance.pendingBalance) {
      return const Result.error(
        Failure(
          FailureCode.receivableCollectionExceedsBalance,
          'Collection amount cannot exceed pending receivable balance',
        ),
      );
    }

    // 4. Find category 'loan_collection'
    final catRes = await categoryRepository.getCategoryByKey('loan_collection');
    final categoryId = catRes.valueOrNull?.id;

    // 5. RN-18: create income transaction linked to receivable
    return transactionRepository.addTransaction(
      kind: TransactionKind.income,
      amount: amount,
      accountId: accountId,
      categoryId: categoryId,
      receivableId: receivableId,
      occurredAt: occurredAt,
      note: note.isEmpty
          ? 'Cobro de préstamo: ${receivableWithBalance.receivable.person}'
          : note,
    );
  }
}
