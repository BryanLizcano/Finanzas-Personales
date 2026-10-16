import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/services/widget_data_service.dart';

class SharedPreferencesWidgetDataService implements WidgetDataService {
  final SharedPreferences? _prefs;

  const SharedPreferencesWidgetDataService([this._prefs]);

  Future<SharedPreferences> _getPrefs() async {
    return _prefs ?? await SharedPreferences.getInstance();
  }

  @override
  Future<void> updateSummaryWidget({
    required int safeAvailable,
    required int monthlyBalance,
  }) async {
    final prefs = await _getPrefs();
    await prefs.setInt('widget_safe_available', safeAvailable);
    await prefs.setInt('widget_monthly_balance', monthlyBalance);
  }

  @override
  Future<void> updateQuickCategories({
    required List<String> expenseCategories,
    required List<String> incomeCategories,
  }) async {
    final prefs = await _getPrefs();
    await prefs.setStringList('widget_expense_categories', expenseCategories);
    await prefs.setStringList('widget_income_categories', incomeCategories);
  }
}
