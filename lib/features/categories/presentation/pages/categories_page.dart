import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/finance_colors.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/icon_helper.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/category.dart';
import '../providers/categories_providers.dart';

class CategoriesPage extends ConsumerStatefulWidget {
  const CategoriesPage({super.key});

  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final allCatsAsync = ref.watch(allCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.categoriesTitle),
        bottom: TabBar(
          controller: _tabController,
          labelColor: colors.primary,
          unselectedLabelColor: colors.onSurfaceMuted,
          indicatorColor: colors.primary,
          tabs: [
            Tab(text: l10n.transactionFilterExpense),
            Tab(text: l10n.transactionFilterIncome),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCategoryDialog(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.newCategory),
      ),
      body: allCatsAsync.when(
        data: (categories) {
          final expenseCats = categories
              .where((c) => c.kind == CategoryKind.expense)
              .toList();
          final incomeCats = categories
              .where((c) => c.kind == CategoryKind.income)
              .toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _CategoryListView(categories: expenseCats),
              _CategoryListView(categories: incomeCats),
            ],
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.all(16.0),
          child: SkeletonList(itemCount: 8),
        ),
        error: (err, _) => ErrorStateWidget(
          customMessage: err.toString(),
          onRetry: () => ref.refresh(allCategoriesProvider),
        ),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;

    final nameCtrl = TextEditingController();
    var kind = _tabController.index == 0
        ? CategoryKind.expense
        : CategoryKind.income;
    var selectedColor = colors.primary.toARGB32();
    var selectedIcon = 'category';

    final availableColors = [
      colors.primary.toARGB32(),
      colors.income.toARGB32(),
      colors.expense.toARGB32(),
      colors.savings.toARGB32(),
      colors.debt.toARGB32(),
    ];

    final availableIcons = [
      'category',
      'restaurant',
      'local_bar',
      'celebration',
      'directions_bus',
      'local_gas_station',
      'build',
      'savings',
      'medical_services',
      'school',
      'work',
      'store',
      'delivery_dining',
      'payments',
    ];

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: Text(l10n.newCategory),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(labelText: l10n.categoryName),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ChoiceChip(
                      label: Text(l10n.transactionFilterExpense),
                      selected: kind == CategoryKind.expense,
                      onSelected: (_) =>
                          setModalState(() => kind = CategoryKind.expense),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: Text(l10n.transactionFilterIncome),
                      selected: kind == CategoryKind.income,
                      onSelected: (_) =>
                          setModalState(() => kind = CategoryKind.income),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.categoryColor,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: availableColors.map((c) {
                    final isSel = selectedColor == c;
                    return GestureDetector(
                      onTap: () => setModalState(() => selectedColor = c),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Color(c),
                          shape: BoxShape.circle,
                          border: isSel
                              ? Border.all(color: Colors.white, width: 3)
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.categoryIcon,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: availableIcons.map((ic) {
                    final isSel = selectedIcon == ic;
                    return GestureDetector(
                      onTap: () => setModalState(() => selectedIcon = ic),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isSel
                              ? colors.primary.withValues(alpha: 0.2)
                              : colors.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                          border: isSel
                              ? Border.all(color: colors.primary, width: 2)
                              : null,
                        ),
                        child: Icon(getIconData(ic), size: 20),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameCtrl.text.trim();
                if (name.isEmpty) return;

                final createUseCase = ref.read(createCategoryUseCaseProvider);
                final res = await createUseCase(
                  name: name,
                  kind: kind,
                  icon: selectedIcon,
                  color: selectedColor,
                );

                res.fold(
                  onOk: (_) => Navigator.of(ctx).pop(),
                  onError: (f) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(f.toLocalizedMessage(l10n))),
                  ),
                );
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryListView extends ConsumerWidget {
  final List<Category> categories;

  const _CategoryListView({required this.categories});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);

    if (categories.isEmpty) {
      return EmptyStateWidget(
        title: l10n.emptyStateTitle,
        subtitle: l10n.emptyStateMessage,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        final displayName = cat.displayName(
          (k) => l10n.translateCategoryKey(k),
        );
        final catColor = Color(cat.color);

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: catColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(getIconData(cat.icon), color: catColor, size: 20),
            ),
            title: Text(
              displayName,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: cat.isActive ? colors.onSurface : colors.onSurfaceMuted,
                decoration: cat.isActive ? null : TextDecoration.lineThrough,
              ),
            ),
            subtitle: cat.isDefault
                ? Text(
                    l10n.categoryDefaultProtected,
                    style: TextStyle(
                      color: colors.onSurfaceMuted,
                      fontSize: 11,
                    ),
                  )
                : null,
            trailing: Switch(
              value: cat.isActive,
              activeThumbColor: colors.primary,
              onChanged: (val) async {
                final setActive = ref.read(setCategoryActiveUseCaseProvider);
                await setActive(id: cat.id, isActive: val);
              },
            ),
          ),
        );
      },
    );
  }
}
