# Feature: Quick Add & Widgets

## Propósito
Soporte de registro ultrarrápido (≤ 5 segundos) desde los widgets de la pantalla de inicio de Android y deep links `finanzas://quick-add`. Provee el analizador sintáctico del enlace y el servicio de sincronización de datos con los widgets.

## Formato del Deep Link
`finanzas://quick-add?kind=<expense|income>&cat=<key>&amount=<optional>`

- `kind`: `expense` (por defecto) o `income`.
- `cat`: Clave i18n de la categoría preseleccionada (ej. `food`, `fuel`, `transport`).
- `amount`: Monto inicial opcional en unidad menor (ej. `25000`).

## Providers Públicos

| Provider | Tipo | Qué devuelve |
|---|---|---|
| `parseQuickAddLinkUseCaseProvider` | `Provider<ParseQuickAddLink>` | Caso de uso para analizar el deep link |
| `updateWidgetDataUseCaseProvider` | `Provider<UpdateWidgetData>` | Caso de uso para actualizar los datos visibles en el widget |

## Casos de Uso

### `ParseQuickAddLink`
- **Firma:** `Result<QuickAddPayload, Failure> call(String rawUriString)`
- **Failures posibles:**
  - `FailureCode.invalidQuickAddLink` (si el esquema no es `finanzas://quick-add` o la URI es inválida)

### `UpdateWidgetData`
- **Firma:** `Future<Result<void, Failure>> call({required int safeAvailable, required int monthlyBalance})`
- Guarda en el almacenamiento compartido del sistema las cifras que los widgets de Android leen.

## Ejemplo de Uso en el Router de la UI
```dart
GoRoute(
  path: '/quick-add',
  builder: (context, state) {
    final link = state.uri.toString();
    final parseUseCase = ref.read(parseQuickAddLinkUseCaseProvider);
    final payload = parseUseCase(link).valueOrNull ??
        const QuickAddPayload(kind: TransactionKind.expense);
    return QuickAddPage(payload: payload);
  },
);
```
