import '../../../transactions/domain/entities/transaction.dart';

class QuickAddPayload {
  final TransactionKind kind;
  final String? categoryKey;
  final int? amount;

  const QuickAddPayload({required this.kind, this.categoryKey, this.amount});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuickAddPayload &&
          runtimeType == other.runtimeType &&
          kind == other.kind &&
          categoryKey == other.categoryKey &&
          amount == other.amount;

  @override
  int get hashCode => Object.hash(kind, categoryKey, amount);
}
