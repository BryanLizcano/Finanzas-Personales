import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final AppDatabase _db;

  CategoryRepositoryImpl(this._db);

  Category _toEntity(CategoriesTableData row) {
    return Category(
      id: row.id,
      key: row.key,
      name: row.name,
      kind: CategoryKind.fromString(row.kind),
      icon: row.icon,
      color: row.color,
      isDefault: row.isDefault,
      isActive: row.isActive,
      sortOrder: row.sortOrder,
    );
  }

  @override
  Future<Result<Category, Failure>> createCategory({
    required String name,
    required CategoryKind kind,
    required String icon,
    required int color,
  }) async {
    try {
      final id = await _db
          .into(_db.categoriesTable)
          .insert(
            CategoriesTableCompanion.insert(
              name: Value(name),
              kind: kind.name,
              icon: icon,
              color: color,
              isDefault: const Value(false),
              isActive: const Value(true),
            ),
          );

      final row = await (_db.select(
        _db.categoriesTable,
      )..where((t) => t.id.equals(id))).getSingle();

      return Result.ok(_toEntity(row));
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<Category, Failure>> updateCategory({
    required int id,
    String? name,
    String? icon,
    int? color,
  }) async {
    try {
      final existing = await (_db.select(
        _db.categoriesTable,
      )..where((t) => t.id.equals(id))).getSingleOrNull();

      if (existing == null) {
        return const Result.error(Failure(FailureCode.categoryNotFound));
      }

      await (_db.update(
        _db.categoriesTable,
      )..where((t) => t.id.equals(id))).write(
        CategoriesTableCompanion(
          name: name != null ? Value(name) : const Value.absent(),
          icon: icon != null ? Value(icon) : const Value.absent(),
          color: color != null ? Value(color) : const Value.absent(),
        ),
      );

      final updated = await (_db.select(
        _db.categoriesTable,
      )..where((t) => t.id.equals(id))).getSingle();

      return Result.ok(_toEntity(updated));
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<void, Failure>> setCategoryActive({
    required int id,
    required bool isActive,
  }) async {
    try {
      final rows =
          await (_db.update(_db.categoriesTable)..where((t) => t.id.equals(id)))
              .write(CategoriesTableCompanion(isActive: Value(isActive)));

      if (rows == 0) {
        return const Result.error(Failure(FailureCode.categoryNotFound));
      }

      return const Result.ok(null);
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<void, Failure>> deleteCategory(int id) async {
    try {
      final existing = await (_db.select(
        _db.categoriesTable,
      )..where((t) => t.id.equals(id))).getSingleOrNull();

      if (existing == null) {
        return const Result.error(Failure(FailureCode.categoryNotFound));
      }

      if (existing.isDefault) {
        return const Result.error(
          Failure(FailureCode.defaultCategoryCannotBeDeleted),
        );
      }

      final inUse = await hasTransactions(id);
      if (inUse) {
        return const Result.error(Failure(FailureCode.categoryHasTransactions));
      }

      await (_db.delete(
        _db.categoriesTable,
      )..where((t) => t.id.equals(id))).go();

      return const Result.ok(null);
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<Category?, Failure>> getCategoryById(int id) async {
    try {
      final row = await (_db.select(
        _db.categoriesTable,
      )..where((t) => t.id.equals(id))).getSingleOrNull();

      if (row == null) {
        return const Result.ok(null);
      }

      return Result.ok(_toEntity(row));
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<Category?, Failure>> getCategoryByKey(String key) async {
    try {
      final row = await (_db.select(
        _db.categoriesTable,
      )..where((t) => t.key.equals(key))).getSingleOrNull();

      if (row == null) {
        return const Result.ok(null);
      }

      return Result.ok(_toEntity(row));
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Stream<List<Category>> watchCategories({
    CategoryKind? kind,
    bool onlyActive = false,
  }) {
    final query = _db.select(_db.categoriesTable);

    if (kind != null) {
      query.where((t) => t.kind.equals(kind.name));
    }
    if (onlyActive) {
      query.where((t) => t.isActive.equals(true));
    }

    query.orderBy([
      (t) => OrderingTerm(expression: t.sortOrder, mode: OrderingMode.asc),
      (t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc),
    ]);

    return query.watch().map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Future<bool> hasTransactions(int categoryId) async {
    final query = _db.select(_db.transactionsTable)
      ..where((t) => t.categoryId.equals(categoryId) & t.deletedAt.isNull())
      ..limit(1);

    final res = await query.get();
    return res.isNotEmpty;
  }
}
