# Feature: Reports (Reportes y Resumen Mensual)

## Propósito
Consolidación analítica y visual de las finanzas del usuario: totales mensuales agregados directamente en SQLite (para alto rendimiento con miles de registros), dona de distribución por categoría, evolución mensual en barras, y reportes agrupados dedicados: "Moto" (RN-22) y "Salidas y pareja" (RN-23).

## Providers Públicos

| Provider | Tipo | Qué devuelve |
|---|---|---|
| `monthlySummaryProvider((year: Y, month: M))` | `FutureProvider.family<MonthlySummary, ...>` | Resumen del mes (ingresos, gastos, balance, deuda total, cobros pendientes, ahorro) |
| `categoryBreakdownProvider((year: Y, month: M))` | `FutureProvider.family<List<CategoryBreakdownItem>, ...>` | Distribución de gastos por categoría con porcentajes para gráficos de dona |
| `monthlyTotalsProvider` | `FutureProvider<List<MonthlyTotalItem>>` | Histórico de ingresos y gastos de los últimos 6 meses para gráficos de barras |
| `motoReportProvider((year: Y, month: M))` | `FutureProvider.family<GroupedExpenseReport, ...>` | Gastos agrupados de moto (`fuel`, `moto_maintenance`, `moto_documents`) |
| `coupleReportProvider((year: Y, month: M))` | `FutureProvider.family<GroupedExpenseReport, ...>` | Gastos agrupados de pareja y salidas (`partner`, `outings`) |

## Casos de Uso

### `GetMonthlySummary`
- **Firma:** `Future<Result<MonthlySummary, Failure>> call({required int year, required int month})`
- Devuelve agregaciones financieras consolidadas sin sobrecargar la memoria.

### `GetCategoryBreakdown`
- **Firma:** `Future<Result<List<CategoryBreakdownItem>, Failure>> call({required int year, required int month, TransactionKind kind = TransactionKind.expense})`
- Agrupación por categoría ordenada por monto descendente con porcentaje.

### `GetMonthlyTotals`
- **Firma:** `Future<Result<List<MonthlyTotalItem>, Failure>> call({int numberOfMonths = 6})`
- Lista cronológica para barras comparativas.

## Ejemplo de Uso en la UI
```dart
final summaryAsync = ref.watch(monthlySummaryProvider((year: 2026, month: 10)));
final breakdownAsync = ref.watch(categoryBreakdownProvider((year: 2026, month: 10)));
final motoAsync = ref.watch(motoReportProvider((year: 2026, month: 10)));
```
