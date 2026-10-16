import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../entities/report_models.dart';
import '../repositories/reports_repository.dart';

class GetMonthlyTotals {
  final ReportsRepository _repository;

  const GetMonthlyTotals(this._repository);

  Future<Result<List<MonthlyTotalItem>, Failure>> call({
    int numberOfMonths = 6,
  }) async {
    return _repository.getMonthlyTotals(numberOfMonths: numberOfMonths);
  }
}
