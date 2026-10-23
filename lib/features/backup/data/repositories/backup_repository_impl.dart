import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/backup_manifest.dart';
import '../../domain/repositories/backup_repository.dart';

class BackupRepositoryImpl implements BackupRepository {
  final AppDatabase _db;
  final String _appVersion;

  BackupRepositoryImpl(this._db, [this._appVersion = '1.2.1']);

  @override
  Future<Result<String, Failure>> createBackupJson() async {
    try {
      final accounts = await _db.select(_db.accountsTable).get();
      final categories = await _db.select(_db.categoriesTable).get();
      final transactions = await _db.select(_db.transactionsTable).get();
      final debts = await _db.select(_db.debtsTable).get();
      final receivables = await _db.select(_db.receivablesTable).get();
      final goals = await _db.select(_db.savingsGoalsTable).get();
      final rules = await _db.select(_db.allocationRulesTable).get();
      final settings = await _db.select(_db.appSettingsTable).get();

      final data = <String, dynamic>{
        'accounts': accounts
            .map(
              (a) => {
                'id': a.id,
                'name': a.name,
                'type': a.type,
                'initial_balance': a.initialBalance,
                'archived': a.archived,
              },
            )
            .toList(),
        'categories': categories
            .map(
              (c) => {
                'id': c.id,
                'key': c.key,
                'name': c.name,
                'kind': c.kind,
                'icon': c.icon,
                'color': c.color,
                'is_default': c.isDefault,
                'is_active': c.isActive,
                'sort_order': c.sortOrder,
              },
            )
            .toList(),
        'transactions': transactions
            .map(
              (t) => {
                'id': t.id,
                'kind': t.kind,
                'amount': t.amount,
                'account_id': t.accountId,
                'to_account_id': t.toAccountId,
                'category_id': t.categoryId,
                'debt_id': t.debtId,
                'receivable_id': t.receivableId,
                'goal_id': t.goalId,
                'occurred_at': t.occurredAt.toIso8601String(),
                'note': t.note,
                'created_at': t.createdAt.toIso8601String(),
                'updated_at': t.updatedAt.toIso8601String(),
                'deleted_at': t.deletedAt?.toIso8601String(),
              },
            )
            .toList(),
        'debts': debts
            .map(
              (d) => {
                'id': d.id,
                'name': d.name,
                'creditor': d.creditor,
                'initial_amount': d.initialAmount,
                'interest_rate_bp': d.interestRateBp,
                'min_payment': d.minPayment,
                'due_day': d.dueDay,
                'priority': d.priority,
                'archived': d.archived,
              },
            )
            .toList(),
        'receivables': receivables
            .map(
              (r) => {
                'id': r.id,
                'person': r.person,
                'initial_amount': r.initialAmount,
                'created_at': r.createdAt.toIso8601String(),
                'note': r.note,
                'archived': r.archived,
              },
            )
            .toList(),
        'goals': goals
            .map(
              (g) => {
                'id': g.id,
                'name': g.name,
                'target_amount': g.targetAmount,
                'target_date': g.targetDate?.toIso8601String(),
                'archived': g.archived,
              },
            )
            .toList(),
        'rules': rules
            .map((r) => {'id': r.id, 'target': r.target, 'percent': r.percent})
            .toList(),
        'settings': {for (final s in settings) s.key: s.value},
      };

      final dataJson = jsonEncode(data);
      final checksum = 'sha256:${sha256.convert(utf8.encode(dataJson))}';

      final manifest = BackupManifest(
        schemaVersion: _db.schemaVersion,
        appVersion: _appVersion,
        createdAt: DateTime.now(),
        checksum: checksum,
        data: data,
      );

      return Result.ok(jsonEncode(manifest.toJson()));
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<BackupManifest, Failure>> validateBackupJson(
    String jsonString,
  ) async {
    try {
      final dynamic decoded = jsonDecode(jsonString);
      if (decoded is! Map<String, dynamic>) {
        return const Result.error(
          Failure(
            FailureCode.invalidBackupFile,
            'Backup root must be a JSON object',
          ),
        );
      }

      final schemaVersion = decoded['schemaVersion'] as int?;
      final checksum = decoded['checksum'] as String?;
      final data = decoded['data'] as Map<String, dynamic>?;

      if (schemaVersion == null || checksum == null || data == null) {
        return const Result.error(
          Failure(
            FailureCode.invalidBackupFile,
            'Missing required backup fields',
          ),
        );
      }

      // Check schema version (RNF-10)
      if (schemaVersion > _db.schemaVersion) {
        return const Result.error(
          Failure(
            FailureCode.unsupportedBackupVersion,
            'Backup schemaVersion is newer than current app version',
          ),
        );
      }

      // Check SHA-256 checksum
      final recomputedChecksum =
          'sha256:${sha256.convert(utf8.encode(jsonEncode(data)))}';
      if (checksum != recomputedChecksum) {
        return const Result.error(
          Failure(
            FailureCode.invalidBackupChecksum,
            'Checksum mismatch: file has been tampered with or corrupted',
          ),
        );
      }

      return Result.ok(
        BackupManifest(
          schemaVersion: schemaVersion,
          appVersion: decoded['appVersion'] as String? ?? '1.0.0',
          createdAt:
              DateTime.tryParse(decoded['createdAt'] as String? ?? '') ??
              DateTime.now(),
          checksum: checksum,
          data: data,
        ),
      );
    } on FormatException {
      return const Result.error(
        Failure(FailureCode.invalidBackupFile, 'Malformed JSON'),
      );
    } catch (e) {
      return Result.error(Failure(FailureCode.invalidBackupFile, e.toString()));
    }
  }

  @override
  Future<Result<void, Failure>> restoreFromJson(String jsonString) async {
    final validation = await validateBackupJson(jsonString);
    if (validation.isError) {
      return Result.error(validation.errorOrNull!);
    }

    final manifest = validation.valueOrNull!;
    final data = manifest.data;

    try {
      await _db.transaction(() async {
        // Clear all tables
        await _db.delete(_db.transactionsTable).go();
        await _db.delete(_db.remindersTable).go();
        await _db.delete(_db.allocationRulesTable).go();
        await _db.delete(_db.debtsTable).go();
        await _db.delete(_db.receivablesTable).go();
        await _db.delete(_db.savingsGoalsTable).go();
        await _db.delete(_db.categoriesTable).go();
        await _db.delete(_db.accountsTable).go();
        await _db.delete(_db.appSettingsTable).go();

        // Restore Accounts
        final accounts = (data['accounts'] as List?) ?? [];
        for (final item in accounts) {
          final m = item as Map<String, dynamic>;
          await _db
              .into(_db.accountsTable)
              .insert(
                AccountsTableCompanion.insert(
                  id: Value(m['id'] as int),
                  name: m['name'] as String,
                  type: m['type'] as String,
                  initialBalance: m['initial_balance'] as int,
                  archived: Value(m['archived'] as bool? ?? false),
                ),
              );
        }

        // Restore Categories
        final categories = (data['categories'] as List?) ?? [];
        for (final item in categories) {
          final m = item as Map<String, dynamic>;
          await _db
              .into(_db.categoriesTable)
              .insert(
                CategoriesTableCompanion.insert(
                  id: Value(m['id'] as int),
                  key: Value(m['key'] as String?),
                  name: Value(m['name'] as String?),
                  kind: m['kind'] as String,
                  icon: m['icon'] as String,
                  color: m['color'] as int,
                  isDefault: Value(m['is_default'] as bool? ?? false),
                  isActive: Value(m['is_active'] as bool? ?? true),
                  sortOrder: Value(m['sort_order'] as int? ?? 0),
                ),
              );
        }

        // Restore Debts
        final debts = (data['debts'] as List?) ?? [];
        for (final item in debts) {
          final m = item as Map<String, dynamic>;
          await _db
              .into(_db.debtsTable)
              .insert(
                DebtsTableCompanion.insert(
                  id: Value(m['id'] as int),
                  name: m['name'] as String,
                  creditor: m['creditor'] as String,
                  initialAmount: m['initial_amount'] as int,
                  interestRateBp: m['interest_rate_bp'] as int,
                  minPayment: m['min_payment'] as int,
                  dueDay: m['due_day'] as int,
                  priority: m['priority'] as int,
                  archived: Value(m['archived'] as bool? ?? false),
                ),
              );
        }

        // Restore Receivables
        final receivables = (data['receivables'] as List?) ?? [];
        for (final item in receivables) {
          final m = item as Map<String, dynamic>;
          await _db
              .into(_db.receivablesTable)
              .insert(
                ReceivablesTableCompanion.insert(
                  id: Value(m['id'] as int),
                  person: m['person'] as String,
                  initialAmount: m['initial_amount'] as int,
                  createdAt: DateTime.parse(m['created_at'] as String),
                  note: Value(m['note'] as String? ?? ''),
                  archived: Value(m['archived'] as bool? ?? false),
                ),
              );
        }

        // Restore Savings Goals
        final goals = (data['goals'] as List?) ?? [];
        for (final item in goals) {
          final m = item as Map<String, dynamic>;
          await _db
              .into(_db.savingsGoalsTable)
              .insert(
                SavingsGoalsTableCompanion.insert(
                  id: Value(m['id'] as int),
                  name: m['name'] as String,
                  targetAmount: m['target_amount'] as int,
                  targetDate: m['target_date'] != null
                      ? Value(DateTime.parse(m['target_date'] as String))
                      : const Value.absent(),
                  archived: Value(m['archived'] as bool? ?? false),
                ),
              );
        }

        // Restore Allocation Rules
        final rules = (data['rules'] as List?) ?? [];
        for (final item in rules) {
          final m = item as Map<String, dynamic>;
          await _db
              .into(_db.allocationRulesTable)
              .insert(
                AllocationRulesTableCompanion.insert(
                  id: Value(m['id'] as int),
                  target: m['target'] as String,
                  percent: m['percent'] as int,
                ),
              );
        }

        // Restore Settings
        final settings = (data['settings'] as Map<String, dynamic>?) ?? {};
        for (final entry in settings.entries) {
          await _db
              .into(_db.appSettingsTable)
              .insert(
                AppSettingsTableCompanion.insert(
                  key: entry.key,
                  value: entry.value.toString(),
                ),
              );
        }

        // Restore Transactions
        final transactions = (data['transactions'] as List?) ?? [];
        for (final item in transactions) {
          final m = item as Map<String, dynamic>;
          await _db
              .into(_db.transactionsTable)
              .insert(
                TransactionsTableCompanion.insert(
                  id: Value(m['id'] as int),
                  kind: m['kind'] as String,
                  amount: m['amount'] as int,
                  accountId: m['account_id'] as int,
                  toAccountId: m['to_account_id'] != null
                      ? Value(m['to_account_id'] as int)
                      : const Value.absent(),
                  categoryId: m['category_id'] != null
                      ? Value(m['category_id'] as int)
                      : const Value.absent(),
                  debtId: m['debt_id'] != null
                      ? Value(m['debt_id'] as int)
                      : const Value.absent(),
                  receivableId: m['receivable_id'] != null
                      ? Value(m['receivable_id'] as int)
                      : const Value.absent(),
                  goalId: m['goal_id'] != null
                      ? Value(m['goal_id'] as int)
                      : const Value.absent(),
                  occurredAt: DateTime.parse(m['occurred_at'] as String),
                  note: Value(m['note'] as String? ?? ''),
                  createdAt: DateTime.parse(m['created_at'] as String),
                  updatedAt: DateTime.parse(m['updated_at'] as String),
                  deletedAt: m['deleted_at'] != null
                      ? Value(DateTime.parse(m['deleted_at'] as String))
                      : const Value.absent(),
                ),
              );
        }
      });

      return const Result.ok(null);
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<String, Failure>> saveBackupToFile({
    required String directoryPath,
    String? customFileName,
  }) async {
    final jsonRes = await createBackupJson();
    if (jsonRes.isError) {
      return Result.error(jsonRes.errorOrNull!);
    }

    try {
      final dir = Directory(directoryPath);
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }

      final fileName =
          customFileName ??
          'finanzas_backup_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.json';
      final file = File(p.join(directoryPath, fileName));
      await file.writeAsString(jsonRes.valueOrNull!);

      return Result.ok(file.path);
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<void, Failure>> pruneBackups({
    required String directoryPath,
    int keepCount = 10,
  }) async {
    try {
      final dir = Directory(directoryPath);
      if (!dir.existsSync()) {
        return const Result.ok(null);
      }

      final backupFiles = dir
          .listSync()
          .whereType<File>()
          .where((f) => p.basename(f.path).startsWith('finanzas_backup_'))
          .toList();

      backupFiles.sort(
        (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
      );

      if (backupFiles.length > keepCount) {
        for (var i = keepCount; i < backupFiles.length; i++) {
          try {
            backupFiles[i].deleteSync();
          } catch (_) {}
        }
      }

      return const Result.ok(null);
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }
}
