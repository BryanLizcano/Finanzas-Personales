import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../entities/report_models.dart';
import '../repositories/reports_repository.dart';

class GetCategoryBreakdown {
  final ReportsRepository _repository;

  const GetCategoryBreakdown(this._repository);

  Future<Result<List<CategoryBreakdownItem>, Failure>> call({
    required int year,
    required int month,
    TransactionKind kind = TransactionKind.expense,
  }) async {
    return _repository.getCategoryBreakdown(
      year: year,
      month: month,
      kind: kind,
    );
  }
}
