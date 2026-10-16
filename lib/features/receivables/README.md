# Feature: Receivables (Préstamos por cobrar)

## Propósito
Registro y seguimiento del dinero prestado a terceros. Permite registrar cobros que se suman como ingresos a las cuentas seleccionadas, reduciendo el saldo pendiente. El total por cobrar se muestra por separado y nunca se suma al saldo disponible (RN-21).

## Providers Públicos

| Provider | Tipo | Qué devuelve |
|---|---|---|
| `receivablesWithBalanceStreamProvider` | `StreamProvider<List<ReceivableWithBalance>>` | Flujo de personas con préstamos pendientes y su progreso |
| `totalPendingReceivableProvider` | `FutureProvider<int>` | Total de dinero por cobrar (para tarjeta en pantalla de inicio) |
| `createReceivableUseCaseProvider` | `Provider<CreateReceivable>` | Caso de uso para registrar nuevo préstamo |
| `registerCollectionUseCaseProvider` | `Provider<RegisterCollection>` | Caso de uso para registrar cobro de un préstamo |

## Casos de Uso

### `CreateReceivable`
- **Firma:** `Future<Result<ReceivableEntity, Failure>> call({required String person, required int initialAmount, required DateTime createdAt, String note = ''})`
- **Failures posibles:**
  - `FailureCode.invalidAmount` (si `person` está vacío o `initialAmount <= 0`)

### `RegisterCollection`
- **Firma:** `Future<Result<TransactionEntity, Failure>> call({required int receivableId, required int amount, required int accountId, required DateTime occurredAt, String note = ''})`
- **Reglas (RN-18, RN-20):**
  - Si `amount > receivableWithBalance.pendingBalance`: `FailureCode.receivableCollectionExceedsBalance`.
  - Registra transacción de ingreso (`kind: income`) vinculada a `receivable_id` con categoría `loan_collection`.

## Ejemplo de Uso en la UI
```dart
final receivablesAsync = ref.watch(receivablesWithBalanceStreamProvider);

// Registrar cobro:
final collectUseCase = ref.read(registerCollectionUseCaseProvider);
final res = await collectUseCase(
  receivableId: item.receivable.id,
  amount: 20000,
  accountId: cuentaDestino.id,
  occurredAt: DateTime.now(),
);
```
