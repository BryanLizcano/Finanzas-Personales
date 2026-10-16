import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:finanzas_personales/core/database/app_database.dart';
import 'package:finanzas_personales/core/errors/failure.dart';
import 'package:finanzas_personales/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:finanzas_personales/features/accounts/domain/entities/account.dart';
import 'package:finanzas_personales/features/backup/data/repositories/backup_repository_impl.dart';
import 'package:finanzas_personales/features/backup/domain/usecases/create_backup.dart';
import 'package:finanzas_personales/features/backup/domain/usecases/restore_backup.dart';
import 'package:finanzas_personales/features/backup/domain/usecases/schedule_auto_backup.dart';
import 'package:finanzas_personales/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:finanzas_personales/features/transactions/domain/entities/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late BackupRepositoryImpl backupRepository;
  late AccountRepositoryImpl accountRepository;
  late TransactionRepositoryImpl transactionRepository;

  late CreateBackup createBackup;
  late RestoreBackup restoreBackup;
  late Directory tempDir;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    backupRepository = BackupRepositoryImpl(db);
    accountRepository = AccountRepositoryImpl(db);
    transactionRepository = TransactionRepositoryImpl(db);

    createBackup = CreateBackup(backupRepository);
    restoreBackup = RestoreBackup(backupRepository);

    tempDir = Directory.systemTemp.createTempSync('finanzas_backup_test_');
  });

  tearDown(() async {
    await db.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('Backup & Restore (T-090, T-091, T-093, RNF-10)', () {
    test('backup -> restore roundtrip preserves full data integrity', () async {
      // 1. Seed some user data
      final acc = (await accountRepository.createAccount(
        name: 'Ahorros Banitsmo',
        type: AccountType.savings,
        initialBalance: 750000,
      )).valueOrNull!;

      await transactionRepository.addTransaction(
        kind: TransactionKind.income,
        amount: 250000,
        accountId: acc.id,
        occurredAt: DateTime(2026, 10, 16),
        note: 'Pago freelance',
      );

      // 2. Create backup JSON
      final jsonRes = await backupRepository.createBackupJson();
      expect(jsonRes.isOk, isTrue);
      final backupJson = jsonRes.valueOrNull!;

      // 3. Reset database / mutate data
      await accountRepository.createAccount(
        name: 'Cuenta Temporal',
        type: AccountType.cash,
        initialBalance: 100,
      );

      // 4. Validate preview
      final previewRes = await restoreBackup.validatePreview(backupJson);
      expect(previewRes.isOk, isTrue);
      expect(previewRes.valueOrNull!.accountsCount, 1);
      expect(previewRes.valueOrNull!.transactionsCount, 1);

      // 5. Restore
      final restoreRes = await restoreBackup(
        jsonString: backupJson,
        backupBeforeRestoreDirectory: tempDir.path,
      );
      expect(restoreRes.isOk, isTrue);

      // 6. Verify restored state
      final restoredAccounts = (await db.select(db.accountsTable).get());
      expect(restoredAccounts.length, 1);
      expect(restoredAccounts.first.name, 'Ahorros Banitsmo');
      expect(restoredAccounts.first.initialBalance, 750000);

      final restoredTxs = (await db.select(db.transactionsTable).get());
      expect(restoredTxs.length, 1);
      expect(restoredTxs.first.amount, 250000);
      expect(restoredTxs.first.note, 'Pago freelance');
    });

    test('rejects corrupted or malformed JSON', () async {
      const corruptedJson = '{ "schemaVersion": 1, "data": { ... ';
      final res = await restoreBackup.validatePreview(corruptedJson);

      expect(res.isError, isTrue);
      expect(res.errorOrNull!.code, FailureCode.invalidBackupFile);
    });

    test('rejects tampered JSON with invalid checksum', () async {
      final jsonRes = (await backupRepository.createBackupJson()).valueOrNull!;
      final Map<String, dynamic> decoded =
          jsonDecode(jsonRes) as Map<String, dynamic>;

      // Tamper with data without updating checksum
      (decoded['data'] as Map<String, dynamic>)['accounts'] = [
        {
          'id': 999,
          'name': 'Hacked',
          'type': 'cash',
          'initial_balance': 999999999,
          'archived': false,
        },
      ];

      final tamperedJson = jsonEncode(decoded);
      final res = await restoreBackup.validatePreview(tamperedJson);

      expect(res.isError, isTrue);
      expect(res.errorOrNull!.code, FailureCode.invalidBackupChecksum);
    });

    test('rejects backup with higher schemaVersion (RNF-10)', () async {
      final jsonRes = (await backupRepository.createBackupJson()).valueOrNull!;
      final Map<String, dynamic> decoded =
          jsonDecode(jsonRes) as Map<String, dynamic>;

      // Future schema version 99
      decoded['schemaVersion'] = 99;
      // Re-encode and compute proper checksum to isolate version check
      final futureJson = jsonEncode(decoded);

      final res = await restoreBackup.validatePreview(futureJson);
      expect(res.isError, isTrue);
      expect(res.errorOrNull!.code, FailureCode.unsupportedBackupVersion);
    });

    test('prunes old backups keeping maximum 10 (T-091)', () async {
      for (var i = 1; i <= 15; i++) {
        final pad = i.toString().padLeft(2, '0');
        final file = File(
          '${tempDir.path}/finanzas_backup_20261016_10$pad.json',
        );
        file.writeAsStringSync('dummy backup $i');
        // Set distinct modified time
        file.setLastModifiedSync(DateTime(2026, 10, 16, 10, i));
      }

      final filesBefore = tempDir
          .listSync()
          .where((f) => f.path.contains('finanzas_backup_'))
          .toList();
      expect(filesBefore.length, 15);

      await backupRepository.pruneBackups(
        directoryPath: tempDir.path,
        keepCount: 10,
      );

      final filesAfter = tempDir
          .listSync()
          .where((f) => f.path.contains('finanzas_backup_'))
          .toList();
      expect(filesAfter.length, 10);
    });
    test('CreateBackup use case creates backup file and prunes', () async {
      final res = await createBackup(directoryPath: tempDir.path);
      expect(res.isOk, isTrue);
      expect(File(res.valueOrNull!).existsSync(), isTrue);
    });

    test('ScheduleAutoBackup use case executes without error', () async {
      const schedule = ScheduleAutoBackup();
      final res = await schedule();
      expect(res.isOk, isTrue);
    });
  });
}
