import 'package:drift/native.dart';
import 'package:finanzas_personales/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('AppDatabase & Initial Migration (T-007)', () {
    test('creates schema v1 and seeds default data', () async {
      expect(db.schemaVersion, 1);

      // Check seeded categories
      final categories = await db.select(db.categoriesTable).get();
      final expenses = categories.where((c) => c.kind == 'expense').toList();
      final incomes = categories.where((c) => c.kind == 'income').toList();

      expect(expenses.length, 14);
      expect(incomes.length, 8);
      expect(categories.every((c) => c.isDefault && c.isActive), isTrue);

      // Check specific default keys
      expect(expenses.any((c) => c.key == 'food'), isTrue);
      expect(expenses.any((c) => c.key == 'moto_maintenance'), isTrue);
      expect(expenses.any((c) => c.key == 'debt_payment'), isTrue);
      expect(incomes.any((c) => c.key == 'salary'), isTrue);
      expect(incomes.any((c) => c.key == 'loan_collection'), isTrue);

      // Check allocation rules
      final rules = await db.select(db.allocationRulesTable).get();
      expect(rules.length, 3);
      final debtRule = rules.firstWhere((r) => r.target == 'debts');
      final savingsRule = rules.firstWhere((r) => r.target == 'savings');
      final freeRule = rules.firstWhere((r) => r.target == 'free');

      expect(debtRule.percent, 50);
      expect(savingsRule.percent, 20);
      expect(freeRule.percent, 30);

      // Check app settings
      final settings = await db.select(db.appSettingsTable).get();
      final debtStrategy = settings.firstWhere((s) => s.key == 'debt_strategy');
      expect(debtStrategy.value, 'avalanche');
    });
  });
}
