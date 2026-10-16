import 'package:finanzas_personales/core/errors/failure.dart';
import 'package:finanzas_personales/features/quick_add/data/services/widget_data_service_impl.dart';
import 'package:finanzas_personales/features/quick_add/domain/services/widget_data_service.dart';
import 'package:finanzas_personales/features/quick_add/domain/usecases/parse_quick_add_link.dart';
import 'package:finanzas_personales/features/quick_add/domain/usecases/update_widget_data.dart';
import 'package:finanzas_personales/features/transactions/domain/entities/transaction.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _ThrowingWidgetDataService implements WidgetDataService {
  @override
  Future<void> updateSummaryWidget({
    required int safeAvailable,
    required int monthlyBalance,
  }) {
    throw Exception('Storage error');
  }

  @override
  Future<void> updateQuickCategories({
    required List<String> expenseCategories,
    required List<String> incomeCategories,
  }) {
    throw Exception('Storage error');
  }
}

void main() {
  group('Quick Add Deep Link & Widget Sync (T-080, RF-17)', () {
    const parser = ParseQuickAddLink();

    test('parses full deep link with kind, category and amount', () {
      final res = parser(
        'finanzas://quick-add?kind=expense&cat=food&amount=35000',
      );

      expect(res.isOk, isTrue);
      final payload = res.valueOrNull!;
      expect(payload.kind, TransactionKind.expense);
      expect(payload.categoryKey, 'food');
      expect(payload.amount, 35000);
    });

    test('parses income deep link with default amount null', () {
      final res = parser('finanzas://quick-add?kind=income&cat=salary');

      expect(res.isOk, isTrue);
      final payload = res.valueOrNull!;
      expect(payload.kind, TransactionKind.income);
      expect(payload.categoryKey, 'salary');
      expect(payload.amount, isNull);
    });

    test('rejects deep links with invalid scheme or host', () {
      final invalidScheme = parser('https://quick-add?kind=expense');
      expect(invalidScheme.isError, isTrue);
      expect(invalidScheme.errorOrNull!.code, FailureCode.invalidQuickAddLink);

      final invalidHost = parser('finanzas://settings');
      expect(invalidHost.isError, isTrue);
      expect(invalidHost.errorOrNull!.code, FailureCode.invalidQuickAddLink);
    });

    test('UpdateWidgetData persists values to SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final service = SharedPreferencesWidgetDataService(prefs);
      final updateUseCase = UpdateWidgetData(service);

      final res = await updateUseCase(
        safeAvailable: 450000,
        monthlyBalance: 820000,
      );

      expect(res.isOk, isTrue);
      expect(prefs.getInt('widget_safe_available'), 450000);
      expect(prefs.getInt('widget_monthly_balance'), 820000);
    });

    test('UpdateWidgetData handles service errors gracefully', () async {
      final updateUseCase = UpdateWidgetData(_ThrowingWidgetDataService());
      final res = await updateUseCase(safeAvailable: 100, monthlyBalance: 200);
      expect(res.isError, isTrue);
    });
  });
}
