import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../services/widget_data_service.dart';

class UpdateWidgetData {
  final WidgetDataService _service;

  const UpdateWidgetData(this._service);

  Future<Result<void, Failure>> call({
    required int safeAvailable,
    required int monthlyBalance,
  }) async {
    try {
      await _service.updateSummaryWidget(
        safeAvailable: safeAvailable,
        monthlyBalance: monthlyBalance,
      );
      return const Result.ok(null);
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }
}
