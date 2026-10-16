import '../../l10n/generated/app_localizations.dart';
import 'failure.dart';

extension FailureLocalization on Failure {
  String toLocalizedMessage(AppLocalizations l10n) {
    switch (code) {
      case FailureCode.invalidAmount:
        return l10n.failure_invalidAmount;
      case FailureCode.invalidDate:
        return l10n.failure_invalidDate;
      case FailureCode.accountNotFound:
        return l10n.failure_accountNotFound;
      case FailureCode.accountHasTransactions:
        return l10n.failure_accountHasTransactions;
      case FailureCode.insufficientBalance:
        return l10n.failure_insufficientBalance;
      case FailureCode.categoryNotFound:
        return l10n.failure_categoryNotFound;
      case FailureCode.categoryHasTransactions:
        return l10n.failure_categoryHasTransactions;
      case FailureCode.defaultCategoryCannotBeDeleted:
        return l10n.failure_defaultCategoryCannotBeDeleted;
      case FailureCode.debtNotFound:
        return l10n.failure_debtNotFound;
      case FailureCode.debtPaymentExceedsBalance:
        return l10n.failure_debtPaymentExceedsBalance;
      case FailureCode.receivableNotFound:
        return l10n.failure_receivableNotFound;
      case FailureCode.receivableCollectionExceedsBalance:
        return l10n.failure_receivableCollectionExceedsBalance;
      case FailureCode.savingsGoalNotFound:
        return l10n.failure_savingsGoalNotFound;
      case FailureCode.invalidTransferSameAccount:
        return l10n.failure_invalidTransferSameAccount;
      case FailureCode.invalidAllocationRulePercentSum:
        return l10n.failure_invalidAllocationRulePercentSum;
      case FailureCode.invalidBackupFile:
        return l10n.failure_invalidBackupFile;
      case FailureCode.invalidBackupChecksum:
        return l10n.failure_invalidBackupChecksum;
      case FailureCode.unsupportedBackupVersion:
        return l10n.failure_unsupportedBackupVersion;
      case FailureCode.networkError:
        return l10n.failure_networkError;
      case FailureCode.packageDownloadFailed:
        return l10n.failure_packageDownloadFailed;
      case FailureCode.sha256VerificationFailed:
        return l10n.failure_sha256VerificationFailed;
      case FailureCode.invalidQuickAddLink:
        return l10n.failure_invalidQuickAddLink;
      case FailureCode.notFound:
        return l10n.failure_notFound;
      case FailureCode.databaseError:
        return l10n.failure_databaseError;
    }
  }
}

extension CategoryLocalization on AppLocalizations {
  String translateCategoryKey(String key) {
    switch (key) {
      case 'food':
        return category_food;
      case 'drinks':
        return category_drinks;
      case 'outings':
        return category_outings;
      case 'partner':
        return category_partner;
      case 'hygiene':
        return category_hygiene;
      case 'transport':
        return category_transport;
      case 'fuel':
        return category_fuel;
      case 'moto_maintenance':
        return category_moto_maintenance;
      case 'moto_documents':
        return category_moto_documents;
      case 'debt_payment':
        return category_debt_payment;
      case 'savings_contribution':
        return category_savings_contribution;
      case 'health':
        return category_health;
      case 'education':
        return category_education;
      case 'other_expense':
        return category_other_expense;
      case 'salary':
        return category_salary;
      case 'drinks_business':
        return category_drinks_business;
      case 'deliveries':
        return category_deliveries;
      case 'moto_rental':
        return category_moto_rental;
      case 'family_support':
        return category_family_support;
      case 'external_services':
        return category_external_services;
      case 'loan_collection':
        return category_loan_collection;
      case 'other_income':
        return category_other_income;
      default:
        return key;
    }
  }
}
