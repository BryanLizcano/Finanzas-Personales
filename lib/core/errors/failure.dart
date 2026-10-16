enum FailureCode {
  invalidAmount,
  invalidDate,
  accountNotFound,
  accountHasTransactions,
  insufficientBalance,
  categoryNotFound,
  categoryHasTransactions,
  defaultCategoryCannotBeDeleted,
  debtNotFound,
  debtPaymentExceedsBalance,
  receivableNotFound,
  receivableCollectionExceedsBalance,
  savingsGoalNotFound,
  invalidTransferSameAccount,
  invalidAllocationRulePercentSum,
  invalidBackupFile,
  invalidBackupChecksum,
  unsupportedBackupVersion,
  networkError,
  packageDownloadFailed,
  sha256VerificationFailed,
  invalidQuickAddLink,
  notFound,
  databaseError,
}

class Failure {
  final FailureCode code;
  final String? debugMessage;

  const Failure(this.code, [this.debugMessage]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          debugMessage == other.debugMessage;

  @override
  int get hashCode => Object.hash(code, debugMessage);

  @override
  String toString() =>
      'Failure($code${debugMessage != null ? ': $debugMessage' : ''})';
}
