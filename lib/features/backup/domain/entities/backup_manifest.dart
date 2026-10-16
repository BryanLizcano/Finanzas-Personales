class BackupDataCounts {
  final int accountsCount;
  final int categoriesCount;
  final int transactionsCount;
  final int debtsCount;
  final int receivablesCount;
  final int goalsCount;

  const BackupDataCounts({
    required this.accountsCount,
    required this.categoriesCount,
    required this.transactionsCount,
    required this.debtsCount,
    required this.receivablesCount,
    required this.goalsCount,
  });
}

class BackupManifest {
  final int schemaVersion;
  final String appVersion;
  final DateTime createdAt;
  final String checksum;
  final Map<String, dynamic> data;

  const BackupManifest({
    required this.schemaVersion,
    required this.appVersion,
    required this.createdAt,
    required this.checksum,
    required this.data,
  });

  BackupDataCounts get counts {
    return BackupDataCounts(
      accountsCount: (data['accounts'] as List?)?.length ?? 0,
      categoriesCount: (data['categories'] as List?)?.length ?? 0,
      transactionsCount: (data['transactions'] as List?)?.length ?? 0,
      debtsCount: (data['debts'] as List?)?.length ?? 0,
      receivablesCount: (data['receivables'] as List?)?.length ?? 0,
      goalsCount: (data['goals'] as List?)?.length ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'schemaVersion': schemaVersion,
    'appVersion': appVersion,
    'createdAt': createdAt.toIso8601String(),
    'checksum': checksum,
    'data': data,
  };
}
