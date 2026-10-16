import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../entities/report_models.dart';

abstract class ReportsRepository {
  Future<Result<MonthlySummary, Failure>> getMonthlySummary({
    required int year,
    required int month,
  });

  Future<Result<List<CategoryBreakdownItem>, Failure>> getCategoryBreakdown({
    required int year,
    required int month,
    TransactionKind kind = TransactionKind.expense,
  });

  Future<Result<List<MonthlyTotalItem>, Failure>> getMonthlyTotals({
    int numberOfMonths = 6,
  });

  Future<Result<GroupedExpenseReport, Failure>> getGroupedExpenses({
    required int year,
    required int month,
    required List<String> categoryKeys,
    required String groupName,
  });

  Future<Result<ReminderEntity, Failure>> createReminder({
    required String title,
    required DateTime dueAt,
    String? repeatRule,
  });

  Future<Result<void, Failure>> setReminderDone({
    required int id,
    required bool done,
  });

  Stream<List<ReminderEntity>> watchPendingReminders();
}
