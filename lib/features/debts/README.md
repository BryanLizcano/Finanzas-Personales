# Feature: Debts

## Propósito
Gestión de deudas contraídas, seguimiento de saldos pendientes en tiempo real, registro de abonos y sugerencias de amortización según estrategias financieras (Avalancha vs Bola de Nieve).

## Providers Públicos

| Provider | Tipo | Qué devuelve |
|---|---|---|
| `debtsWithBalanceStreamProvider` | `StreamProvider<List<DebtWithBalance>>` | Lista reactiva de deudas activas con saldo pendiente y progreso |
| `debtStrategyProvider` | `FutureProvider<DebtStrategy>` | Estrategia configurada (`avalanche` o `snowball`) |
| `suggestedDebtPaymentProvider(availableAmount)` | `FutureProvider.family<DebtPaymentSuggestion, int?>` | Deuda priorizada y monto sugerido para abonar |
| `createDebtUseCaseProvider` | `Provider<CreateDebt>` | Caso de uso para registrar nueva deuda |
| `registerDebtPaymentUseCaseProvider` | `Provider<RegisterDebtPayment>` | Caso de uso para abonar a una deuda |
| `suggestDebtPaymentUseCaseProvider` | `Provider<SuggestDebtPayment>` | Caso de uso para calcular la sugerencia de abono |

## Casos de Uso

### `CreateDebt`
- **Firma:** `Future<Result<DebtEntity, Failure>> call({required String name, required String creditor, required int initialAmount, required int interestRateBp, required int minPayment, required int dueDay, int priority = 1})`
- **Failures posibles:**
  - `FailureCode.invalidAmount` (si el nombre está vacío o monto <= 0)
  - `FailureCode.invalidDate` (si `dueDay` no está entre 1 y 31)

### `RegisterDebtPayment`
- **Firma:** `Future<Result<TransactionEntity, Failure>> call({required int debtId, required int amount, required int accountId, required DateTime occurredAt, String note = ''})`
- **Reglas:**
  - Si `amount > debtWithBalance.currentBalance`: `FailureCode.debtPaymentExceedsBalance` (RN-15).
  - Vincula la transacción creada al `debt_id` y a la categoría `debt_payment` (RN-14).

### `SuggestDebtPayment`
- **Firma:** `Future<Result<DebtPaymentSuggestion, Failure>> call({int? availableAmount, DebtStrategy? strategyOverride})`
- **Estrategias (RN-13):**
  - **Avalancha:** Prioriza mayor tasa de interés (`interestRateBp`).
  - **Bola de nieve:** Prioriza menor saldo pendiente (`currentBalance`).

## Ejemplo de Uso en la UI
```dart
final debtsAsync = ref.watch(debtsWithBalanceStreamProvider);
final suggestionAsync = ref.watch(suggestedDebtPaymentProvider(null));

// Abonar a deuda:
final payUseCase = ref.read(registerDebtPaymentUseCaseProvider);
final result = await payUseCase(
  debtId: debt.id,
  amount: 50000,
  accountId: account.id,
  occurredAt: DateTime.now(),
);
```
