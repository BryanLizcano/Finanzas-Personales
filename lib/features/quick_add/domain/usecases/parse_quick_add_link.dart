import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../entities/quick_add_payload.dart';

class ParseQuickAddLink {
  const ParseQuickAddLink();

  Result<QuickAddPayload, Failure> call(String rawUriString) {
    final uri = Uri.tryParse(rawUriString.trim());
    if (uri == null) {
      return const Result.error(
        Failure(FailureCode.invalidQuickAddLink, 'Malformed URI'),
      );
    }

    final isCustomScheme =
        uri.scheme == 'finanzas' &&
        (uri.host == 'quick-add' || uri.path == '/quick-add');
    final isInternalRoute = uri.scheme.isEmpty && uri.path == '/quick-add';

    if (!isCustomScheme && !isInternalRoute) {
      return const Result.error(
        Failure(
          FailureCode.invalidQuickAddLink,
          'Expected scheme finanzas://quick-add',
        ),
      );
    }

    final kindParam = uri.queryParameters['kind']?.toLowerCase();
    final kind = switch (kindParam) {
      'income' => TransactionKind.income,
      'transfer' => TransactionKind.transfer,
      _ => TransactionKind.expense,
    };

    final catParam = uri.queryParameters['cat']?.trim();
    final categoryKey = (catParam != null && catParam.isNotEmpty)
        ? catParam
        : null;

    final amountParam = uri.queryParameters['amount'];
    final amount = amountParam != null ? int.tryParse(amountParam) : null;

    return Result.ok(
      QuickAddPayload(
        kind: kind,
        categoryKey: categoryKey,
        amount: (amount != null && amount > 0) ? amount : null,
      ),
    );
  }
}
