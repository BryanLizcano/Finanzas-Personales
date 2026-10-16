class ReceivableEntity {
  final int id;
  final String person;
  final int initialAmount;
  final DateTime createdAt;
  final String note;
  final bool archived;

  const ReceivableEntity({
    required this.id,
    required this.person,
    required this.initialAmount,
    required this.createdAt,
    this.note = '',
    this.archived = false,
  });

  ReceivableEntity copyWith({
    String? person,
    int? initialAmount,
    DateTime? createdAt,
    String? note,
    bool? archived,
  }) {
    return ReceivableEntity(
      id: id,
      person: person ?? this.person,
      initialAmount: initialAmount ?? this.initialAmount,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
      archived: archived ?? this.archived,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReceivableEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          person == other.person &&
          initialAmount == other.initialAmount &&
          createdAt == other.createdAt &&
          note == other.note &&
          archived == other.archived;

  @override
  int get hashCode =>
      Object.hash(id, person, initialAmount, createdAt, note, archived);
}

class ReceivableWithBalance {
  final ReceivableEntity receivable;
  final int collectedAmount;
  final int pendingBalance;

  const ReceivableWithBalance({
    required this.receivable,
    required this.collectedAmount,
    required this.pendingBalance,
  });

  bool get isSettled => pendingBalance <= 0;

  double get progressRatio => receivable.initialAmount == 0
      ? 1.0
      : (collectedAmount / receivable.initialAmount).clamp(0.0, 1.0);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReceivableWithBalance &&
          runtimeType == other.runtimeType &&
          receivable == other.receivable &&
          collectedAmount == other.collectedAmount &&
          pendingBalance == other.pendingBalance;

  @override
  int get hashCode => Object.hash(receivable, collectedAmount, pendingBalance);
}
