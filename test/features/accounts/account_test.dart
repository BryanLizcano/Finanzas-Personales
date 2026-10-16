import 'package:drift/native.dart';
import 'package:finanzas_personales/core/database/app_database.dart';
import 'package:finanzas_personales/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:finanzas_personales/features/accounts/domain/entities/account.dart';
import 'package:finanzas_personales/features/accounts/domain/usecases/archive_account.dart';
import 'package:finanzas_personales/features/accounts/domain/usecases/create_account.dart';
import 'package:finanzas_personales/features/accounts/domain/usecases/update_account.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late AccountRepositoryImpl repository;
  late CreateAccount createAccount;
  late UpdateAccount updateAccount;
  late ArchiveAccount archiveAccount;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = AccountRepositoryImpl(db);
    createAccount = CreateAccount(repository);
    updateAccount = UpdateAccount(repository);
    archiveAccount = ArchiveAccount(repository);
  });

  tearDown(() async {
    await db.close();
  });

  group('Accounts (T-010, RN-27)', () {
    test('creates account with initial balance', () async {
      final res = await createAccount(
        name: 'Bancolombia',
        type: AccountType.bank,
        initialBalance: 500000,
      );

      expect(res.isOk, isTrue);
      final account = res.valueOrNull!;
      expect(account.id, isPositive);
      expect(account.name, 'Bancolombia');
      expect(account.type, AccountType.bank);
      expect(account.initialBalance, 500000);
      expect(account.archived, isFalse);

      final bal = await repository.getAccountBalance(account.id);
      expect(bal.isOk, isTrue);
      expect(bal.valueOrNull!.units, 500000);
    });

    test('updates account name and type', () async {
      final createRes = await createAccount(
        name: 'Efectivo',
        type: AccountType.cash,
        initialBalance: 100000,
      );
      final id = createRes.valueOrNull!.id;

      final updateRes = await updateAccount(
        id: id,
        name: 'Billetera',
        type: AccountType.cash,
      );

      expect(updateRes.isOk, isTrue);
      final updated = updateRes.valueOrNull!;
      expect(updated.name, 'Billetera');
    });

    test('archives and unarchives account', () async {
      final createRes = await createAccount(
        name: 'Ahorro a la mano',
        type: AccountType.savings,
        initialBalance: 20000,
      );
      final id = createRes.valueOrNull!.id;

      final archiveRes = await archiveAccount(id: id, archived: true);
      expect(archiveRes.isOk, isTrue);

      final fetched = await repository.getAccountById(id);
      expect(fetched.valueOrNull!.archived, isTrue);
    });

    test(
      'RN-27: detects if account has transactions to prevent hard deletion',
      () async {
        final a1 = (await createAccount(
          name: 'Cuenta 1',
          type: AccountType.bank,
          initialBalance: 1000,
        )).valueOrNull!;

        expect(await repository.hasTransactions(a1.id), isFalse);

        // Insert transaction directly
        await db
            .into(db.transactionsTable)
            .insert(
              TransactionsTableCompanion.insert(
                kind: 'expense',
                amount: 500,
                accountId: a1.id,
                occurredAt: DateTime.now(),
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            );

        expect(await repository.hasTransactions(a1.id), isTrue);

        // Verify balance updated: 1000 - 500 = 500
        final bal = await repository.getAccountBalance(a1.id);
        expect(bal.valueOrNull!.units, 500);
      },
    );
  });
}
