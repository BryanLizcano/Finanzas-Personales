# Feature: Savings (Metas de Ahorro)

## Propósito
Gestión de metas de ahorro personales. Un aporte a una meta es una transferencia hacia una cuenta de tipo `savings` con `goal_id` vinculado (RN-25). El progreso de la meta se calcula en tiempo real (RN-26).

## Providers Públicos

| Provider | Tipo | Qué devuelve |
|---|---|---|
| `savingsGoalsWithProgressStreamProvider` | `StreamProvider<List<SavingsGoalWithProgress>>` | Metas de ahorro activas con monto acumulado y porcentaje de avance |
| `totalSavedAmountProvider` | `FutureProvider<int>` | Total ahorrado acumulado en metas activas |
| `createSavingsGoalUseCaseProvider` | `Provider<CreateSavingsGoal>` | Caso de uso para crear nueva meta |
| `contributeToGoalUseCaseProvider` | `Provider<ContributeToGoal>` | Caso de uso para aportar a una meta |

## Casos de Uso

### `CreateSavingsGoal`
- **Firma:** `Future<Result<SavingsGoalEntity, Failure>> call({required String name, required int targetAmount, DateTime? targetDate})`
- **Failures posibles:**
  - `FailureCode.invalidAmount` (si el nombre está vacío o `targetAmount <= 0`)

### `ContributeToGoal`
- **Firma:** `Future<Result<TransactionEntity, Failure>> call({required int goalId, required int amount, required int sourceAccountId, required int targetSavingsAccountId, required DateTime occurredAt, String note = ''})`
- **Reglas (RN-25, RN-26):**
  - Origen y destino deben ser distintos.
  - La cuenta de destino debe ser de tipo `savings`.
  - Registra una transferencia vinculada a `goal_id`.

## Ejemplo de Uso en la UI
```dart
final goalsAsync = ref.watch(savingsGoalsWithProgressStreamProvider);

// Aportar a meta:
final contributeUseCase = ref.read(contributeToGoalUseCaseProvider);
final res = await contributeUseCase(
  goalId: goal.id,
  amount: 50000,
  sourceAccountId: cuentaEfectivo.id,
  targetSavingsAccountId: cuentaAhorros.id,
  occurredAt: DateTime.now(),
);
```
