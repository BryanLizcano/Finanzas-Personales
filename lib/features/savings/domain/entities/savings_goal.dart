class SavingsGoalEntity {
  final int id;
  final String name;
  final int targetAmount;
  final DateTime? targetDate;
  final bool archived;

  const SavingsGoalEntity({
    required this.id,
    required this.name,
    required this.targetAmount,
    this.targetDate,
    this.archived = false,
  });

  SavingsGoalEntity copyWith({
    String? name,
    int? targetAmount,
    DateTime? targetDate,
    bool? archived,
  }) {
    return SavingsGoalEntity(
      id: id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      targetDate: targetDate ?? this.targetDate,
      archived: archived ?? this.archived,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavingsGoalEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          targetAmount == other.targetAmount &&
          targetDate == other.targetDate &&
          archived == other.archived;

  @override
  int get hashCode => Object.hash(id, name, targetAmount, targetDate, archived);
}

class SavingsGoalWithProgress {
  final SavingsGoalEntity goal;
  final int currentAmount;
  final double progressRatio;

  const SavingsGoalWithProgress({
    required this.goal,
    required this.currentAmount,
    required this.progressRatio,
  });

  bool get isCompleted => currentAmount >= goal.targetAmount;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavingsGoalWithProgress &&
          runtimeType == other.runtimeType &&
          goal == other.goal &&
          currentAmount == other.currentAmount &&
          progressRatio == other.progressRatio;

  @override
  int get hashCode => Object.hash(goal, currentAmount, progressRatio);
}
