import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../categories/domain/repositories/category_repository.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../repositories/debt_repository.dart';

class RegisterDebtPayment {
  final DebtRepository debtRepository;
  final CategoryRepository categoryRepository;
  final TransactionRepository transactionRepository;

  const RegisterDebtPayment({
    required this.debtRepository,
    required this.categoryRepository,
    required this.transactionRepository,
  });

  Future<Result<TransactionEntity, Failure>> call({
    required int debtId,
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
          'Payment amount must be greater than 0',
        ),
      );
    }

    // 2. Fetch debt and current balance
    final debtRes = await debtRepository.getDebtWithBalance(debtId);
    if (debtRes.isError) {
      return Result.error(debtRes.errorOrNull!);
    }
    final debtWithBalance = debtRes.valueOrNull!;

    // 3. RN-15: payment cannot exceed pending balance
    if (amount > debtWithBalance.currentBalance) {
      return const Result.error(
        Failure(
          FailureCode.debtPaymentExceedsBalance,
          'Payment amount cannot exceed pending debt balance',
        ),
      );
    }

    // 4. Find category 'debt_payment'
    final catRes = await categoryRepository.getCategoryByKey('debt_payment');
    final categoryId = catRes.valueOrNull?.id;

    // 5. RN-14: create expense transaction linked to debt
    return transactionRepository.addTransaction(
      kind: TransactionKind.expense,
      amount: amount,
      accountId: accountId,
      categoryId: categoryId,
      debtId: debtId,
      occurredAt: occurredAt,
      note: note.isEmpty ? 'Abono a deuda: ${debtWithBalance.debt.name}' : note,
    );
  }
}
