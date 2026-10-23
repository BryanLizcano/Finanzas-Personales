enum TransactionKind {
  income,
  expense,
  transfer;

  static TransactionKind fromString(String value) {
    switch (value.toLowerCase()) {
      case 'income':
        return TransactionKind.income;
      case 'expense':
        return TransactionKind.expense;
      case 'transfer':
      default:
        return TransactionKind.transfer;
    }
  }
}

class TransactionEntity {
  final int id;
  final TransactionKind kind;
  final int amount; // > 0
  final int accountId;
  final int? toAccountId;
  final int? categoryId;
  final int? debtId;
  final int? receivableId;
  final int? goalId;
  final DateTime occurredAt;
  final String note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const TransactionEntity({
    required this.id,
    required this.kind,
    required this.amount,
    required this.accountId,
    this.toAccountId,
    this.categoryId,
    this.debtId,
    this.receivableId,
    this.goalId,
    required this.occurredAt,
    this.note = '',
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  bool get isDeleted => deletedAt != null;

  TransactionEntity copyWith({
    TransactionKind? kind,
    int? amount,
    int? accountId,
    int? toAccountId,
    int? categoryId,
    int? debtId,
    int? receivableId,
    int? goalId,
    DateTime? occurredAt,
    String? note,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return TransactionEntity(
      id: id,
      kind: kind ?? this.kind,
      amount: amount ?? this.amount,
      accountId: accountId ?? this.accountId,
      toAccountId: toAccountId ?? this.toAccountId,
      categoryId: categoryId ?? this.categoryId,
      debtId: debtId ?? this.debtId,
      receivableId: receivableId ?? this.receivableId,
      goalId: goalId ?? this.goalId,
      occurredAt: occurredAt ?? this.occurredAt,
      note: note ?? this.note,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          kind == other.kind &&
          amount == other.amount &&
          accountId == other.accountId &&
          toAccountId == other.toAccountId &&
          categoryId == other.categoryId &&
          debtId == other.debtId &&
          receivableId == other.receivableId &&
          goalId == other.goalId &&
          occurredAt == other.occurredAt &&
          note == other.note &&
          deletedAt == other.deletedAt;

  @override
  int get hashCode => Object.hash(
    id,
    kind,
    amount,
    accountId,
    toAccountId,
    categoryId,
    debtId,
    receivableId,
    goalId,
    occurredAt,
    note,
    deletedAt,
  );
}

class TransactionFilter {
  final DateTime? startDate;
  final DateTime? endDate;
  final int? accountId;
  final int? categoryId;
  final TransactionKind? kind;
  final String? searchQuery;
  final bool includeDeleted;

  const TransactionFilter({
    this.startDate,
    this.endDate,
    this.accountId,
    this.categoryId,
    this.kind,
    this.searchQuery,
    this.includeDeleted = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionFilter &&
          runtimeType == other.runtimeType &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          accountId == other.accountId &&
          categoryId == other.categoryId &&
          kind == other.kind &&
          searchQuery == other.searchQuery &&
          includeDeleted == other.includeDeleted;

  @override
  int get hashCode => Object.hash(
    startDate,
    endDate,
    accountId,
    categoryId,
    kind,
    searchQuery,
    includeDeleted,
  );
}
