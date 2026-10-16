abstract class WidgetDataService {
  Future<void> updateSummaryWidget({
    required int safeAvailable,
    required int monthlyBalance,
  });

  Future<void> updateQuickCategories({
    required List<String> expenseCategories,
    required List<String> incomeCategories,
  });
}
