import 'package:drift/drift.dart';

class AccountsTable extends Table {
  @override
  String get tableName => 'accounts';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get type => text()(); // cash, bank, savings
  IntColumn get initialBalance => integer().named('initial_balance')();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
}

class CategoriesTable extends Table {
  @override
  String get tableName => 'categories';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().nullable()();
  TextColumn get name => text().nullable()();
  TextColumn get kind => text()(); // income, expense
  TextColumn get icon => text()();
  IntColumn get color => integer()();
  BoolColumn get isDefault =>
      boolean().named('is_default').withDefault(const Constant(false))();
  BoolColumn get isActive =>
      boolean().named('is_active').withDefault(const Constant(true))();
  IntColumn get sortOrder =>
      integer().named('sort_order').withDefault(const Constant(0))();
}

class DebtsTable extends Table {
  @override
  String get tableName => 'debts';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get creditor => text()();
  IntColumn get initialAmount => integer().named('initial_amount')();
  IntColumn get interestRateBp =>
      integer().named('interest_rate_bp')(); // basis points (100 = 1%)
  IntColumn get minPayment => integer().named('min_payment')();
  IntColumn get dueDay => integer().named('due_day')();
  IntColumn get priority => integer()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
}

class ReceivablesTable extends Table {
  @override
  String get tableName => 'receivables';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get person => text()();
  IntColumn get initialAmount => integer().named('initial_amount')();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  TextColumn get note => text().withDefault(const Constant(''))();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
}

class SavingsGoalsTable extends Table {
  @override
  String get tableName => 'savings_goals';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get targetAmount => integer().named('target_amount')();
  DateTimeColumn get targetDate => dateTime().named('target_date').nullable()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
}

class AllocationRulesTable extends Table {
  @override
  String get tableName => 'allocation_rules';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get target => text()(); // debts, savings, free
  IntColumn get percent => integer()();
}

@TableIndex(name: 'idx_transactions_occurred_at', columns: {#occurredAt})
@TableIndex(name: 'idx_transactions_account_id', columns: {#accountId})
@TableIndex(name: 'idx_transactions_category_id', columns: {#categoryId})
@TableIndex(name: 'idx_transactions_debt_id', columns: {#debtId})
@TableIndex(name: 'idx_transactions_receivable_id', columns: {#receivableId})
class TransactionsTable extends Table {
  @override
  String get tableName => 'transactions';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get kind => text()(); // income, expense, transfer
  IntColumn get amount => integer()(); // must be > 0
  @ReferenceName('outgoingTransactions')
  IntColumn get accountId =>
      integer().named('account_id').references(AccountsTable, #id)();
  @ReferenceName('incomingTransactions')
  IntColumn get toAccountId => integer()
      .named('to_account_id')
      .nullable()
      .references(AccountsTable, #id)();
  IntColumn get categoryId => integer()
      .named('category_id')
      .nullable()
      .references(CategoriesTable, #id)();
  IntColumn get debtId =>
      integer().named('debt_id').nullable().references(DebtsTable, #id)();
  IntColumn get receivableId => integer()
      .named('receivable_id')
      .nullable()
      .references(ReceivablesTable, #id)();
  IntColumn get goalId => integer()
      .named('goal_id')
      .nullable()
      .references(SavingsGoalsTable, #id)();
  DateTimeColumn get occurredAt => dateTime().named('occurred_at')();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  DateTimeColumn get deletedAt => dateTime().named('deleted_at').nullable()();
}

class AppSettingsTable extends Table {
  @override
  String get tableName => 'app_settings';

  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

class RemindersTable extends Table {
  @override
  String get tableName => 'reminders';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  DateTimeColumn get dueAt => dateTime().named('due_at')();
  TextColumn get repeatRule => text().named('repeat_rule').nullable()();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
}
