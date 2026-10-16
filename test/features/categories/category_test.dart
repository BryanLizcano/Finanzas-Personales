import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:finanzas_personales/core/database/app_database.dart';
import 'package:finanzas_personales/core/errors/failure.dart';
import 'package:finanzas_personales/features/categories/data/repositories/category_repository_impl.dart';
import 'package:finanzas_personales/features/categories/domain/entities/category.dart';
import 'package:finanzas_personales/features/categories/domain/usecases/create_category.dart';
import 'package:finanzas_personales/features/categories/domain/usecases/set_category_active.dart';
import 'package:finanzas_personales/features/categories/domain/usecases/update_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late CategoryRepositoryImpl repository;
  late CreateCategory createCategory;
  late UpdateCategory updateCategory;
  late SetCategoryActive setCategoryActive;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = CategoryRepositoryImpl(db);
    createCategory = CreateCategory(repository);
    updateCategory = UpdateCategory(repository);
    setCategoryActive = SetCategoryActive(repository);
  });

  tearDown(() async {
    await db.close();
  });

  group('Categories (T-011, RN-24)', () {
    test(
      'creates custom category with isDefault=false and active=true',
      () async {
        final res = await createCategory(
          name: 'Gimnasio',
          kind: CategoryKind.expense,
          icon: 'fitness_center',
          color: 0xFF123456,
        );

        expect(res.isOk, isTrue);
        final cat = res.valueOrNull!;
        expect(cat.id, isPositive);
        expect(cat.name, 'Gimnasio');
        expect(cat.isDefault, isFalse);
        expect(cat.isActive, isTrue);
        expect(cat.displayName((_) => 'traducido'), 'Gimnasio');
      },
    );

    test('updates custom category name and icon', () async {
      final created = (await createCategory(
        name: 'Gym',
        kind: CategoryKind.expense,
        icon: 'fitness_center',
        color: 0xFF123456,
      )).valueOrNull!;

      final updated = (await updateCategory(
        id: created.id,
        name: 'Fitness',
        icon: 'sports',
      )).valueOrNull!;

      expect(updated.name, 'Fitness');
      expect(updated.icon, 'sports');
    });

    test('inactivates category with setCategoryActive', () async {
      final defaultFood = (await repository.getCategoryByKey('food'))
          .valueOrNull!;
      expect(defaultFood.isActive, isTrue);

      final inactivateRes = await setCategoryActive(
        id: defaultFood.id,
        isActive: false,
      );
      expect(inactivateRes.isOk, isTrue);

      final fetched = (await repository.getCategoryById(defaultFood.id))
          .valueOrNull!;
      expect(fetched.isActive, isFalse);
    });

    test('cannot delete default category', () async {
      final defaultFood = (await repository.getCategoryByKey('food'))
          .valueOrNull!;

      final deleteRes = await repository.deleteCategory(defaultFood.id);
      expect(deleteRes.isError, isTrue);
      expect(
        deleteRes.errorOrNull!.code,
        FailureCode.defaultCategoryCannotBeDeleted,
      );
    });

    test('RN-24: cannot delete category with existing transactions', () async {
      final custom = (await createCategory(
        name: 'Suscripciones',
        kind: CategoryKind.expense,
        icon: 'subscriptions',
        color: 0xFF00FF00,
      )).valueOrNull!;

      // Create an account
      final accountId = await db
          .into(db.accountsTable)
          .insert(
            AccountsTableCompanion.insert(
              name: 'Banco',
              type: 'bank',
              initialBalance: 10000,
            ),
          );

      // Insert transaction linked to this category
      await db
          .into(db.transactionsTable)
          .insert(
            TransactionsTableCompanion.insert(
              kind: 'expense',
              amount: 25000,
              accountId: accountId,
              categoryId: Value(custom.id),
              occurredAt: DateTime.now(),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );

      // Try deleting category
      final deleteRes = await repository.deleteCategory(custom.id);
      expect(deleteRes.isError, isTrue);
      expect(deleteRes.errorOrNull!.code, FailureCode.categoryHasTransactions);
    });

    test('can delete custom category if it has no transactions', () async {
      final custom = (await createCategory(
        name: 'Sin Uso',
        kind: CategoryKind.expense,
        icon: 'cancel',
        color: 0xFF000000,
      )).valueOrNull!;

      final deleteRes = await repository.deleteCategory(custom.id);
      expect(deleteRes.isOk, isTrue);

      final fetched = await repository.getCategoryById(custom.id);
      expect(fetched.valueOrNull, isNull);
    });
  });
}
