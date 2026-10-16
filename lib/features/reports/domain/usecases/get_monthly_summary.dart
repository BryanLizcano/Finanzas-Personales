import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../entities/report_models.dart';
import '../repositories/reports_repository.dart';

class GetMonthlySummary {
  final ReportsRepository _repository;

  const GetMonthlySummary(this._repository);

  Future<Result<MonthlySummary, Failure>> call({
    required int year,
    required int month,
  }) async {
    return _repository.getMonthlySummary(year: year, month: month);
  }
}
