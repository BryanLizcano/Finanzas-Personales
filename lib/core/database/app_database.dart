import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    AccountsTable,
    CategoriesTable,
    DebtsTable,
    ReceivablesTable,
    SavingsGoalsTable,
    AllocationRulesTable,
    TransactionsTable,
    AppSettingsTable,
    RemindersTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seedInitialData();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> _seedInitialData() async {
    // 1. Seed Expense Categories
    final defaultExpenses = [
      ('food', 'restaurant', 0xFFEF5350, 1),
      ('drinks', 'local_bar', 0xFFAB47BC, 2),
      ('outings', 'celebration', 0xFF5C6BC0, 3),
      ('partner', 'favorite', 0xFFEC407A, 4),
      ('hygiene', 'clean_hands', 0xFF26A69A, 5),
      ('transport', 'directions_bus', 0xFF42A5F5, 6),
      ('fuel', 'local_gas_station', 0xFFFF7043, 7),
      ('moto_maintenance', 'build', 0xFF8D6E63, 8),
      ('moto_documents', 'description', 0xFF78909C, 9),
      ('debt_payment', 'payments', 0xFF6D28D9, 10),
      ('savings_contribution', 'savings', 0xFFB45309, 11),
      ('health', 'medical_services', 0xFF26C6DA, 12),
      ('education', 'school', 0xFF66BB6A, 13),
      ('other_expense', 'more_horiz', 0xFF7E57C2, 14),
    ];

    for (final exp in defaultExpenses) {
      await into(categoriesTable).insert(
        CategoriesTableCompanion.insert(
          key: Value(exp.$1),
          kind: 'expense',
          icon: exp.$2,
          color: exp.$3,
          isDefault: const Value(true),
          isActive: const Value(true),
          sortOrder: Value(exp.$4),
        ),
      );
    }

    // 2. Seed Income Categories
    final defaultIncomes = [
      ('salary', 'work', 0xFF15803D, 1),
      ('drinks_business', 'store', 0xFF16A34A, 2),
      ('deliveries', 'delivery_dining', 0xFF22C55E, 3),
      ('moto_rental', 'two_wheeler', 0xFF34D399, 4),
      ('family_support', 'groups', 0xFF10B981, 5),
      ('external_services', 'handyman', 0xFF059669, 6),
      ('loan_collection', 'request_quote', 0xFF047857, 7),
      ('other_income', 'more_horiz', 0xFF065F46, 8),
    ];

    for (final inc in defaultIncomes) {
      await into(categoriesTable).insert(
        CategoriesTableCompanion.insert(
          key: Value(inc.$1),
          kind: 'income',
          icon: inc.$2,
          color: inc.$3,
          isDefault: const Value(true),
          isActive: const Value(true),
          sortOrder: Value(inc.$4),
        ),
      );
    }

    // 3. Seed Default Allocation Rules (RN-10: 50% debts, 20% savings, 30% free)
    await into(allocationRulesTable).insert(
      AllocationRulesTableCompanion.insert(target: 'debts', percent: 50),
    );
    await into(allocationRulesTable).insert(
      AllocationRulesTableCompanion.insert(target: 'savings', percent: 20),
    );
    await into(
      allocationRulesTable,
    ).insert(AllocationRulesTableCompanion.insert(target: 'free', percent: 30));

    // 4. Seed Default Settings
    await into(appSettingsTable).insert(
      AppSettingsTableCompanion.insert(
        key: 'debt_strategy',
        value: 'avalanche',
      ),
    );
    await into(
      appSettingsTable,
    ).insert(AppSettingsTableCompanion.insert(key: 'base_income', value: '0'));
    await into(appSettingsTable).insert(
      AppSettingsTableCompanion.insert(
        key: 'onboarding_completed',
        value: 'false',
      ),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_finanzas.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
