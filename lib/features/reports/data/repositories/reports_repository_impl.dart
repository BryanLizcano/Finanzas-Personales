import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../budget/domain/repositories/budget_repository.dart';
import '../../../debts/domain/repositories/debt_repository.dart';
import '../../../receivables/domain/repositories/receivable_repository.dart';
import '../../../savings/domain/repositories/savings_repository.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../domain/entities/report_models.dart';
import '../../domain/repositories/reports_repository.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final AppDatabase db;
  final DebtRepository debtRepository;
  final ReceivableRepository receivableRepository;
  final SavingsRepository savingsRepository;
  final BudgetRepository budgetRepository;

  ReportsRepositoryImpl({
    required this.db,
    required this.debtRepository,
    required this.receivableRepository,
    required this.savingsRepository,
    required this.budgetRepository,
  });

  @override
  Future<Result<MonthlySummary, Failure>> getMonthlySummary({
    required int year,
    required int month,
  }) async {
    try {
      final start = DateTime(year, month, 1);
      final end = DateTime(year, month + 1, 0, 23, 59, 59, 999);

      // Income SQL sum
      final incomeQuery = db.selectOnly(db.transactionsTable)
        ..addColumns([db.transactionsTable.amount.sum()])
        ..where(
          db.transactionsTable.occurredAt.isBiggerOrEqualValue(start) &
              db.transactionsTable.occurredAt.isSmallerOrEqualValue(end) &
              db.transactionsTable.kind.equals('income') &
              db.transactionsTable.deletedAt.isNull(),
        );
      final totalIncome =
          await incomeQuery
              .map((row) => row.read(db.transactionsTable.amount.sum()))
              .getSingle() ??
          0;

      // Expense SQL sum
      final expenseQuery = db.selectOnly(db.transactionsTable)
        ..addColumns([db.transactionsTable.amount.sum()])
        ..where(
          db.transactionsTable.occurredAt.isBiggerOrEqualValue(start) &
              db.transactionsTable.occurredAt.isSmallerOrEqualValue(end) &
              db.transactionsTable.kind.equals('expense') &
              db.transactionsTable.deletedAt.isNull(),
        );
      final totalExpense =
          await expenseQuery
              .map((row) => row.read(db.transactionsTable.amount.sum()))
              .getSingle() ??
          0;

      // Debt total balance
      final debts = await debtRepository.getDebtsWithBalance(
        includeArchived: false,
      );
      final totalDebtBalance = debts.fold<int>(
        0,
        (sum, d) => sum + d.currentBalance,
      );
      final debtMinPayments = debts
          .where((d) => d.currentBalance > 0)
          .fold<int>(0, (sum, d) => sum + d.debt.minPayment);

      // Receivable total balance
      final totalReceivableBalance = await receivableRepository
          .getTotalPendingReceivable();

      // Total saved
      final totalSaved = await savingsRepository.getTotalSavedAmount();

      // Base income & safe available
      final baseIncomeRes = await budgetRepository.getBaseIncome();
      final baseIncome = baseIncomeRes.valueOrNull ?? 0;
      final safeAvailable = baseIncome - debtMinPayments;

      return Result.ok(
        MonthlySummary(
          year: year,
          month: month,
          totalIncome: totalIncome,
          totalExpense: totalExpense,
          balance: totalIncome - totalExpense,
          totalDebtBalance: totalDebtBalance,
          totalReceivableBalance: totalReceivableBalance,
          totalSaved: totalSaved,
          baseIncome: baseIncome,
          safeAvailable: safeAvailable,
        ),
      );
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<List<CategoryBreakdownItem>, Failure>> getCategoryBreakdown({
    required int year,
    required int month,
    TransactionKind kind = TransactionKind.expense,
  }) async {
    try {
      final start = DateTime(year, month, 1);
      final end = DateTime(year, month + 1, 0, 23, 59, 59, 999);

      final totalSumQuery = db.selectOnly(db.transactionsTable)
        ..addColumns([db.transactionsTable.amount.sum()])
        ..where(
          db.transactionsTable.occurredAt.isBiggerOrEqualValue(start) &
              db.transactionsTable.occurredAt.isSmallerOrEqualValue(end) &
              db.transactionsTable.kind.equals(kind.name) &
              db.transactionsTable.deletedAt.isNull(),
        );
      final totalSum =
          await totalSumQuery
              .map((row) => row.read(db.transactionsTable.amount.sum()))
              .getSingle() ??
          0;

      // Group by category SQL query
      final categoryAmountSum = db.transactionsTable.amount.sum();
      final query = db.selectOnly(db.transactionsTable)
        ..addColumns([db.transactionsTable.categoryId, categoryAmountSum])
        ..where(
          db.transactionsTable.occurredAt.isBiggerOrEqualValue(start) &
              db.transactionsTable.occurredAt.isSmallerOrEqualValue(end) &
              db.transactionsTable.kind.equals(kind.name) &
              db.transactionsTable.categoryId.isNotNull() &
              db.transactionsTable.deletedAt.isNull(),
        )
        ..groupBy([db.transactionsTable.categoryId])
        ..orderBy([
          OrderingTerm(expression: categoryAmountSum, mode: OrderingMode.desc),
        ]);

      final rows = await query.get();
      final categories = await db.select(db.categoriesTable).get();
      final catMap = {for (final c in categories) c.id: c};

      final result = <CategoryBreakdownItem>[];
      for (final row in rows) {
        final catId = row.read(db.transactionsTable.categoryId);
        final amount = row.read(categoryAmountSum) ?? 0;
        if (catId == null) continue;

        final cat = catMap[catId];
        final nameOrKey = cat?.key ?? cat?.name ?? 'category_$catId';
        final icon = cat?.icon ?? 'more_horiz';
        final color = cat?.color ?? 0xFF000000;
        final percentage = totalSum == 0 ? 0.0 : (amount / totalSum) * 100;

        result.add(
          CategoryBreakdownItem(
            categoryId: catId,
            categoryKeyOrName: nameOrKey,
            icon: icon,
            color: color,
            totalAmount: amount,
            percentage: percentage,
          ),
        );
      }

      return Result.ok(result);
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<List<MonthlyTotalItem>, Failure>> getMonthlyTotals({
    int numberOfMonths = 6,
  }) async {
    try {
      final now = DateTime.now();
      final list = <MonthlyTotalItem>[];

      for (var i = numberOfMonths - 1; i >= 0; i--) {
        final date = DateTime(now.year, now.month - i, 1);
        final y = date.year;
        final m = date.month;

        final start = DateTime(y, m, 1);
        final end = DateTime(y, m + 1, 0, 23, 59, 59, 999);

        final incQuery = db.selectOnly(db.transactionsTable)
          ..addColumns([db.transactionsTable.amount.sum()])
          ..where(
            db.transactionsTable.occurredAt.isBiggerOrEqualValue(start) &
                db.transactionsTable.occurredAt.isSmallerOrEqualValue(end) &
                db.transactionsTable.kind.equals('income') &
                db.transactionsTable.deletedAt.isNull(),
          );
        final inc =
            await incQuery
                .map((row) => row.read(db.transactionsTable.amount.sum()))
                .getSingle() ??
            0;

        final expQuery = db.selectOnly(db.transactionsTable)
          ..addColumns([db.transactionsTable.amount.sum()])
          ..where(
            db.transactionsTable.occurredAt.isBiggerOrEqualValue(start) &
                db.transactionsTable.occurredAt.isSmallerOrEqualValue(end) &
                db.transactionsTable.kind.equals('expense') &
                db.transactionsTable.deletedAt.isNull(),
          );
        final exp =
            await expQuery
                .map((row) => row.read(db.transactionsTable.amount.sum()))
                .getSingle() ??
            0;

        list.add(
          MonthlyTotalItem(
            year: y,
            month: m,
            totalIncome: inc,
            totalExpense: exp,
          ),
        );
      }

      return Result.ok(list);
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<GroupedExpenseReport, Failure>> getGroupedExpenses({
    required int year,
    required int month,
    required List<String> categoryKeys,
    required String groupName,
  }) async {
    try {
      final start = DateTime(year, month, 1);
      final end = DateTime(year, month + 1, 0, 23, 59, 59, 999);

      final categories = await (db.select(
        db.categoriesTable,
      )..where((t) => t.key.isIn(categoryKeys))).get();
      final catIds = categories.map((c) => c.id).toList();

      if (catIds.isEmpty) {
        return Result.ok(
          GroupedExpenseReport(
            groupName: groupName,
            categoryKeys: categoryKeys,
            totalAmount: 0,
          ),
        );
      }

      final query = db.selectOnly(db.transactionsTable)
        ..addColumns([db.transactionsTable.amount.sum()])
        ..where(
          db.transactionsTable.occurredAt.isBiggerOrEqualValue(start) &
              db.transactionsTable.occurredAt.isSmallerOrEqualValue(end) &
              db.transactionsTable.kind.equals('expense') &
              db.transactionsTable.categoryId.isIn(catIds) &
              db.transactionsTable.deletedAt.isNull(),
        );

      final sum =
          await query
              .map((row) => row.read(db.transactionsTable.amount.sum()))
              .getSingle() ??
          0;

      return Result.ok(
        GroupedExpenseReport(
          groupName: groupName,
          categoryKeys: categoryKeys,
          totalAmount: sum,
        ),
      );
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<ReminderEntity, Failure>> createReminder({
    required String title,
    required DateTime dueAt,
    String? repeatRule,
  }) async {
    try {
      final id = await db
          .into(db.remindersTable)
          .insert(
            RemindersTableCompanion.insert(
              title: title,
              dueAt: dueAt,
              repeatRule: repeatRule != null
                  ? Value(repeatRule)
                  : const Value.absent(),
              done: const Value(false),
            ),
          );

      return Result.ok(
        ReminderEntity(
          id: id,
          title: title,
          dueAt: dueAt,
          repeatRule: repeatRule,
          done: false,
        ),
      );
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<void, Failure>> setReminderDone({
    required int id,
    required bool done,
  }) async {
    try {
      await (db.update(db.remindersTable)..where((t) => t.id.equals(id))).write(
        RemindersTableCompanion(done: Value(done)),
      );
      return const Result.ok(null);
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Stream<List<ReminderEntity>> watchPendingReminders() {
    return (db.select(db.remindersTable)
          ..where((t) => t.done.equals(false))
          ..orderBy([
            (t) => OrderingTerm(expression: t.dueAt, mode: OrderingMode.asc),
          ]))
        .watch()
        .map(
          (rows) => rows
              .map(
                (r) => ReminderEntity(
                  id: r.id,
                  title: r.title,
                  dueAt: r.dueAt,
                  repeatRule: r.repeatRule,
                  done: r.done,
                ),
              )
              .toList(),
        );
  }
}
