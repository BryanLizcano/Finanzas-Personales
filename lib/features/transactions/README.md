# Feature: Transactions

## Propósito
Registro de movimientos de dinero: ingresos, gastos y transferencias entre cuentas. Soporta eliminación lógica (soft-delete), restauración ("Deshacer"), filtrado avanzado y paginación reactiva.

## Providers Públicos

| Provider | Tipo | Qué devuelve |
|---|---|---|
| `transactionsStreamProvider(filter)` | `StreamProvider.family<List<TransactionEntity>, TransactionFilter?>` | Flujo reactivo de transacciones ordenadas por fecha descendente según filtros |
| `addTransactionUseCaseProvider` | `Provider<AddTransaction>` | Caso de uso para registrar transacciones |
| `updateTransactionUseCaseProvider` | `Provider<UpdateTransaction>` | Caso de uso para editar transacciones |
| `deleteTransactionUseCaseProvider` | `Provider<DeleteTransaction>` | Caso de uso para eliminación lógica |
| `restoreTransactionUseCaseProvider` | `Provider<RestoreTransaction>` | Caso de uso para deshacer eliminación |
| `transferBetweenAccountsUseCaseProvider` | `Provider<TransferBetweenAccounts>` | Caso de uso para transferencias entre cuentas |
| `watchTransactionsUseCaseProvider` | `Provider<WatchTransactions>` | Caso de uso para observar transacciones |

## Casos de Uso

### `AddTransaction`
- **Firma:** `Future<Result<TransactionEntity, Failure>> call({required TransactionKind kind, required int amount, required int accountId, int? toAccountId, int? categoryId, int? debtId, int? receivableId, int? goalId, required DateTime occurredAt, String note = ''})`
- **Reglas validadas:**
  - `amount > 0`: `FailureCode.invalidAmount`
  - Transferencias: `toAccountId != null` y `toAccountId != accountId`, sin categoría: `FailureCode.invalidTransferSameAccount`
  - `debt_id` solo en gastos; `receivable_id` solo en ingresos.

### `TransferBetweenAccounts`
- **Firma:** `Future<Result<TransactionEntity, Failure>> call({required int sourceAccountId, required int targetAccountId, required int amount, required DateTime occurredAt, int? goalId, String note = ''})`
- **Failures posibles:**
  - `FailureCode.invalidAmount`
  - `FailureCode.invalidTransferSameAccount`
  - `FailureCode.databaseError`

### `DeleteTransaction`
- **Firma:** `Future<Result<void, Failure>> call(int id)`
- **Efecto:** Marca `deleted_at = DateTime.now()` (soft delete).

### `RestoreTransaction`
- **Firma:** `Future<Result<TransactionEntity, Failure>> call(int id)`
- **Efecto:** Limpia `deleted_at` para restaurar el movimiento tras presionar "Deshacer".

## Ejemplo de Uso en la UI
```dart
// Registrar gasto:
final addTx = ref.read(addTransactionUseCaseProvider);
final result = await addTx(
  kind: TransactionKind.expense,
  amount: 25000,
  accountId: account.id,
  categoryId: category.id,
  occurredAt: DateTime.now(),
  note: 'Almuerzo de trabajo',
);

// Deshacer eliminación tras SnackBar:
final deleteTx = ref.read(deleteTransactionUseCaseProvider);
await deleteTx(txId);

ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Movimiento eliminado'),
    action: SnackBarAction(
      label: 'Deshacer',
      onPressed: () => ref.read(restoreTransactionUseCaseProvider)(txId),
    ),
  ),
);
```
