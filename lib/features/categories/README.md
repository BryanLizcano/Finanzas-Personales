# Feature: Categories

## Propósito
Gestión de categorías de ingresos y gastos. Incluye soporte para categorías por defecto traducibles (mediante claves i18n) y categorías personalizadas creadas por el usuario. Regla de negocio: las categorías con transacciones no se borran, solo se inhabilitan. Las categorías por defecto no se pueden borrar.

## Providers Públicos

| Provider | Tipo | Qué devuelve |
|---|---|---|
| `allCategoriesProvider` | `StreamProvider<List<Category>>` | Todas las categorías registradas |
| `activeExpenseCategoriesProvider` | `StreamProvider<List<Category>>` | Categorías de gasto activas (para formulario de registro) |
| `activeIncomeCategoriesProvider` | `StreamProvider<List<Category>>` | Categorías de ingreso activas (para formulario de registro) |
| `createCategoryUseCaseProvider` | `Provider<CreateCategory>` | Instancia del caso de uso `CreateCategory` |
| `updateCategoryUseCaseProvider` | `Provider<UpdateCategory>` | Instancia del caso de uso `UpdateCategory` |
| `setCategoryActiveUseCaseProvider` | `Provider<SetCategoryActive>` | Instancia del caso de uso `SetCategoryActive` |

## Casos de Uso

### `CreateCategory`
- **Firma:** `Future<Result<Category, Failure>> call({required String name, required CategoryKind kind, required String icon, required int color})`
- **Failures posibles:**
  - `FailureCode.invalidAmount` (si el nombre está vacío)
  - `FailureCode.databaseError`

### `UpdateCategory`
- **Firma:** `Future<Result<Category, Failure>> call({required int id, String? name, String? icon, int? color})`
- **Failures posibles:**
  - `FailureCode.invalidAmount`
  - `FailureCode.categoryNotFound`
  - `FailureCode.databaseError`

### `SetCategoryActive`
- **Firma:** `Future<Result<void, Failure>> call({required int id, required bool isActive})`
- **Failures posibles:**
  - `FailureCode.categoryNotFound`
  - `FailureCode.databaseError`

## Ejemplo de Visualización con Localización
```dart
final categoriesAsync = ref.watch(activeExpenseCategoriesProvider);

categoriesAsync.when(
  data: (categories) => GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
    itemCount: categories.length,
    itemBuilder: (context, i) {
      final cat = categories[i];
      // Para categorías por defecto se usa su clave de localización; para personalizadas, su nombre:
      final title = cat.displayName((key) => l10n.translateCategory(key));
      return CategoryChip(title: title, icon: cat.icon, color: Color(cat.color));
    },
  ),
  loading: () => const CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
);
```
