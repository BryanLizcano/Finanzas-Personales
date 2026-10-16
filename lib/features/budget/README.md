# Feature: Budget (Presupuesto y Reparto)

## Propósito
Cálculo del Disponible Seguro a partir del ingreso base del usuario y deducciones fijas (cuotas mínimas de deudas, gastos fijos y ahorro). Reparto de ingresos extra según porcentajes configurados (deudas, ahorro, disponible libre).

## Providers Públicos

| Provider | Tipo | Qué devuelve |
|---|---|---|
| `baseIncomeStreamProvider` | `StreamProvider<int>` | Flujo del ingreso base mensual configurado |
| `allocationRulesStreamProvider` | `StreamProvider<List<AllocationRule>>` | Reglas de reparto activas (porcentajes de deudas, ahorro, libre) |
| `safeAvailableProvider` | `FutureProvider<SafeAvailableResult>` | Disponible seguro mensual y estado de déficit (`isDeficit`) |
| `setBaseIncomeUseCaseProvider` | `Provider<SetBaseIncome>` | Caso de uso para actualizar ingreso base |
| `setAllocationRulesUseCaseProvider` | `Provider<SetAllocationRules>` | Caso de uso para actualizar reglas de reparto |
| `computeExtraIncomeSplitUseCaseProvider` | `Provider<ComputeExtraIncomeSplit>` | Caso de uso para calcular el reparto de un ingreso extra |
| `computeSafeAvailableUseCaseProvider` | `Provider<ComputeSafeAvailable>` | Caso de uso para calcular el disponible seguro |

## Casos de Uso

### `SetBaseIncome`
- **Firma:** `Future<Result<void, Failure>> call(int amount)`
- **Validación:** `amount >= 0`.

### `SetAllocationRules`
- **Firma:** `Future<Result<void, Failure>> call({required int debtsPercent, required int savingsPercent, required int freePercent})`
- **Validación (RN-09):** `debtsPercent + savingsPercent + freePercent == 100`. Si no, retorna `FailureCode.invalidAllocationRulePercentSum`.

### `ComputeExtraIncomeSplit`
- **Firma:** `Future<Result<ExtraIncomeSplit, Failure>> call({required int actualMonthlyIncome})`
- **Comportamiento (RN-06, RN-07):**
  - Si `actualMonthlyIncome < baseIncome`: `hasDeficit = true`, montos en 0 (no se sugiere reparto).
  - Si `actualMonthlyIncome >= baseIncome`: reparte `actualMonthlyIncome - baseIncome` según porcentajes enteros.

### `ComputeSafeAvailable`
- **Firma:** `Future<Result<SafeAvailableResult, Failure>> call({int fixedExpenses = 0, int savingsContribution = 0})`
- **Fórmula (RN-05):**
  `safeAvailable = baseIncome - fixedExpenses - debtMinPayments - savingsContribution`
  Si `safeAvailable < 0`, `isDeficit = true`.

## Ejemplo de Uso en la UI
```dart
final safeAvailableAsync = ref.watch(safeAvailableProvider);

safeAvailableAsync.when(
  data: (result) {
    return Column(
      children: [
        Text(
          'Disponible seguro: \$ ${result.safeAvailable}',
          style: TextStyle(
            color: result.isDeficit ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (result.isDeficit)
          const Text('Atención: Tienes un déficit este mes', style: TextStyle(color: Colors.red)),
      ],
    );
  },
  loading: () => const CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
);
```
