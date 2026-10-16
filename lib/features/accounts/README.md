# Feature: Accounts

## Propósito
Gestión de cuentas y bolsillos del usuario (efectivo, banco, ahorros), archivo de cuentas y cálculo de saldos en tiempo real a partir de transacciones y transferencias.

## Providers Públicos

| Provider | Tipo | Qué devuelve |
|---|---|---|
| `accountsWithBalanceProvider` | `StreamProvider<List<AccountWithBalance>>` | Lista reactiva de cuentas activas con su saldo calculado |
| `createAccountUseCaseProvider` | `Provider<CreateAccount>` | Instancia del caso de uso `CreateAccount` |
| `updateAccountUseCaseProvider` | `Provider<UpdateAccount>` | Instancia del caso de uso `UpdateAccount` |
| `archiveAccountUseCaseProvider` | `Provider<ArchiveAccount>` | Instancia del caso de uso `ArchiveAccount` |
| `watchAccountsWithBalanceUseCaseProvider` | `Provider<WatchAccountsWithBalance>` | Instancia del caso de uso `WatchAccountsWithBalance` |

## Casos de Uso

### `CreateAccount`
- **Firma:** `Future<Result<Account, Failure>> call({required String name, required AccountType type, required int initialBalance})`
- **Failures posibles:**
  - `FailureCode.invalidAmount` (si el nombre está vacío)
  - `FailureCode.databaseError`

### `UpdateAccount`
- **Firma:** `Future<Result<Account, Failure>> call({required int id, required String name, required AccountType type})`
- **Failures posibles:**
  - `FailureCode.invalidAmount` (si el nombre está vacío)
  - `FailureCode.accountNotFound`
  - `FailureCode.databaseError`

### `ArchiveAccount`
- **Firma:** `Future<Result<void, Failure>> call({required int id, required bool archived})`
- **Failures posibles:**
  - `FailureCode.accountNotFound`
  - `FailureCode.databaseError`

### `WatchAccountsWithBalance`
- **Firma:** `Stream<List<AccountWithBalance>> call({bool includeArchived = false})`

## Ejemplo de Uso en la UI
```dart
final accountsAsync = ref.watch(accountsWithBalanceProvider);

accountsAsync.when(
  data: (accounts) => ListView.builder(
    itemCount: accounts.length,
    itemBuilder: (context, i) {
      final item = accounts[i];
      return ListTile(
        title: Text(item.account.name),
        trailing: Text(item.balance.format()),
      );
    },
  ),
  loading: () => const CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
);
```
