// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Control de finanzas';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get confirm => 'Confirm';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get undo => 'Undo';

  @override
  String get retry => 'Retry';

  @override
  String get close => 'Close';

  @override
  String get accept => 'Accept';

  @override
  String get back => 'Back';

  @override
  String get continueText => 'Continue';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get all => 'All';

  @override
  String get emptyStateTitle => 'No data here';

  @override
  String get emptyStateMessage => 'No records available at the moment.';

  @override
  String get loading => 'Loading...';

  @override
  String get success => 'Operation successful';

  @override
  String get navHome => 'Home';

  @override
  String get navTransactions => 'Transactions';

  @override
  String get navDebts => 'Debts & Loans';

  @override
  String get navSettings => 'Settings';

  @override
  String get navAdd => 'Add';

  @override
  String get homeTotalBalance => 'Total balance';

  @override
  String get homeSafeAvailable => 'Safe available';

  @override
  String get homeMonthlyIncome => 'Monthly income';

  @override
  String get homeBaseIncome => 'Base income';

  @override
  String get homeDeficitWarning => 'Projected deficit for this month';

  @override
  String get homeTotalDebt => 'Total debts';

  @override
  String get homeTotalReceivables => 'Receivables';

  @override
  String get homeTotalSavings => 'Total saved';

  @override
  String get homeRecentTransactions => 'Recent transactions';

  @override
  String get homeViewAll => 'View all';

  @override
  String get homeQuickActions => 'Quick actions';

  @override
  String get homeSavingsGoals => 'Savings goals';

  @override
  String get homeReports => 'Reports & statistics';

  @override
  String get homeAccounts => 'Accounts & wallets';

  @override
  String get homeExtraIncomeSplit => 'Extra income split';

  @override
  String get homeSuggestSplit => 'Suggest split';

  @override
  String homeSplitDebts(int percent) {
    return 'To debts ($percent%)';
  }

  @override
  String homeSplitSavings(int percent) {
    return 'To savings ($percent%)';
  }

  @override
  String homeSplitFree(int percent) {
    return 'Free to spend ($percent%)';
  }

  @override
  String get homeSplitConfirm => 'Apply suggestion';

  @override
  String get transactionIncome => 'Income';

  @override
  String get transactionExpense => 'Expense';

  @override
  String get transactionTransfer => 'Transfer';

  @override
  String get transactionAmount => 'Amount';

  @override
  String get transactionAccount => 'Account';

  @override
  String get transactionSourceAccount => 'Source account';

  @override
  String get transactionTargetAccount => 'Target account';

  @override
  String get transactionCategory => 'Category';

  @override
  String get transactionDate => 'Date';

  @override
  String get transactionNote => 'Note (optional)';

  @override
  String get transactionAnnotation => 'Annotation';

  @override
  String get transactionAnnotationHint => 'Annotation e.g. Coca Cola (max 25)';

  @override
  String get editAnnotation => 'Edit annotation';

  @override
  String get transactionDetailsTitle => 'Transaction Details';

  @override
  String get deleteTransactionConfirmTitle =>
      'Are you sure you want to delete?';

  @override
  String get deleteTransactionConfirmMessage =>
      'Do you want to delete this transaction? Your balances will be recalculated automatically.';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get transactionSaved => 'Transaction saved successfully';

  @override
  String get transactionDeleted => 'Transaction deleted';

  @override
  String get transactionRestored => 'Transaction restored';

  @override
  String get transactionUpdated => 'Transaction updated';

  @override
  String get transactionFilterAll => 'All';

  @override
  String get transactionFilterExpense => 'Expenses';

  @override
  String get transactionFilterIncome => 'Incomes';

  @override
  String get transactionFilterTransfer => 'Transfers';

  @override
  String get transactionSearchPlaceholder =>
      'Search by note, category or account...';

  @override
  String get transactionEmpty => 'No transactions recorded';

  @override
  String get transactionEmptySubtitle =>
      'Press the + button to record your first income or expense.';

  @override
  String get addTransactionTitle => 'Add Transaction';

  @override
  String get quickAddTitle => 'Quick Add';

  @override
  String get selectAccount => 'Select account';

  @override
  String get selectCategory => 'Select category';

  @override
  String get debtsTab => 'My Debts';

  @override
  String get receivablesTab => 'Receivables';

  @override
  String get newDebt => 'New Debt';

  @override
  String get newReceivable => 'New Loan';

  @override
  String get debtName => 'Debt name';

  @override
  String get debtCreditor => 'Creditor';

  @override
  String get debtInitialAmount => 'Initial amount';

  @override
  String get debtInterestRate => 'Monthly interest (%)';

  @override
  String get debtMinPayment => 'Minimum payment';

  @override
  String get debtDueDay => 'Due day (1-31)';

  @override
  String get debtCurrentBalance => 'Remaining balance';

  @override
  String get debtMakePayment => 'Make a Payment';

  @override
  String get debtPaymentAmount => 'Payment amount';

  @override
  String get debtSuggestionTitle => 'Smart payment suggestion';

  @override
  String debtSuggestionSubtitle(String strategy) {
    return 'Based on your strategy ($strategy)';
  }

  @override
  String get strategyAvalanche => 'Avalanche (highest interest)';

  @override
  String get strategySnowball => 'Snowball (lowest balance)';

  @override
  String get debtDueSoonAlert => 'Payment due in 3 days!';

  @override
  String get debtSettled => 'Settled';

  @override
  String get debtEmpty => 'No active debts';

  @override
  String get debtEmptySubtitle => 'Great! Keep your finances debt-free.';

  @override
  String get receivablePerson => 'Debtor / Person';

  @override
  String get receivableInitialAmount => 'Loaned amount';

  @override
  String get receivableRegisterCollection => 'Register Collection';

  @override
  String get receivablePendingBalance => 'Remaining receivable';

  @override
  String get receivableEmpty => 'No active receivables';

  @override
  String get receivableEmptySubtitle =>
      'People you have loaned money to will appear here.';

  @override
  String get savingsTitle => 'Savings Goals';

  @override
  String get newGoal => 'New Goal';

  @override
  String get goalName => 'Goal name';

  @override
  String get goalTargetAmount => 'Target amount';

  @override
  String get goalTargetDate => 'Target date (optional)';

  @override
  String get goalAccumulated => 'Saved';

  @override
  String get goalProgress => 'Progress';

  @override
  String get goalContribute => 'Contribute to Goal';

  @override
  String get goalContributeSubtitle => 'Transfer to savings account';

  @override
  String get savingsEmpty => 'No active savings goals';

  @override
  String get savingsEmptySubtitle =>
      'Create a goal like \'Emergency fund\' or \'Vacations\'.';

  @override
  String get reportsTitle => 'Reports & Statistics';

  @override
  String get reportsMonth => 'Month';

  @override
  String get reportsCategoryBreakdown => 'Expense Breakdown';

  @override
  String get reportsMonthlyEvolution => 'Last 6 Months Evolution';

  @override
  String get reportsSpecialGroupings => 'Special Grouped Reports';

  @override
  String get reportMotoTitle => 'Motorcycle Expenses';

  @override
  String get reportMotoDescription =>
      'Fuel, maintenance and legal documents (SOAT / Tecno)';

  @override
  String get reportOutingsTitle => 'Outings & Partner';

  @override
  String get reportOutingsDescription =>
      'Outings, dining out and partner expenses';

  @override
  String get reportsTotalExpense => 'Total expense';

  @override
  String get reportsTotalIncome => 'Total income';

  @override
  String get reportsNetBalance => 'Net balance';

  @override
  String get reportsEmptyData => 'No transactions recorded for this period';

  @override
  String get accountsTitle => 'Accounts & Wallets';

  @override
  String get newAccount => 'New Account';

  @override
  String get editAccount => 'Edit Account';

  @override
  String get accountName => 'Account name';

  @override
  String get accountType => 'Account type';

  @override
  String get accountTypeCash => 'Cash';

  @override
  String get accountTypeBank => 'Bank account';

  @override
  String get accountTypeSavings => 'Savings pocket';

  @override
  String get accountInitialBalance => 'Initial balance';

  @override
  String get accountArchived => 'Archived';

  @override
  String get accountArchiveConfirm => 'Do you want to archive this account?';

  @override
  String get accountArchiveNotice =>
      'Accounts with transactions are not deleted; only hidden from new entries.';

  @override
  String get categoriesTitle => 'Categories';

  @override
  String get newCategory => 'New Category';

  @override
  String get categoryName => 'Name';

  @override
  String get categoryKind => 'Kind';

  @override
  String get categoryIcon => 'Icon';

  @override
  String get categoryColor => 'Color';

  @override
  String get categoryActive => 'Active';

  @override
  String get categoryDefaultProtected => 'System category (cannot be deleted)';

  @override
  String get categoryDeactivated => 'Category deactivated';

  @override
  String get categoryActivated => 'Category activated';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Visual theme';

  @override
  String get settingsThemeSystem => 'System theme';

  @override
  String get settingsThemeLight => 'Light mode';

  @override
  String get settingsThemeDark => 'Dark mode';

  @override
  String get settingsLanguage => 'Application language';

  @override
  String get settingsLanguageSystem => 'System language';

  @override
  String get settingsLanguageEs => 'Spanish';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsCurrency => 'Main currency';

  @override
  String get settingsCurrencyNotice =>
      'Changing the currency only modifies display symbol and formatting, it does not convert monetary amounts.';

  @override
  String get settingsBudgetAndRules => 'Budget & Allocations';

  @override
  String get settingsBaseIncome => 'Safe base income';

  @override
  String get settingsAllocationRules => 'Extra income allocation rules';

  @override
  String get settingsAllocationDebts => '% to debts';

  @override
  String get settingsAllocationSavings => '% to savings';

  @override
  String get settingsAllocationFree => '% free to spend';

  @override
  String get settingsDebtStrategy => 'Preferred debt strategy';

  @override
  String get settingsBackup => 'Backups & Restore';

  @override
  String get settingsUpdates => 'App Updates';

  @override
  String get settingsAbout => 'About Personal Finance';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsOfflineNotice =>
      '100% offline and private. Your data never leaves your device.';

  @override
  String get backupTitle => 'Backup & Restore';

  @override
  String get backupCreateNow => 'Create backup now';

  @override
  String get backupSelectFolder => 'Select destination folder';

  @override
  String get backupRestoreFromFile => 'Restore from file';

  @override
  String get backupRetentionNotice =>
      'The last 10 backups are kept automatically.';

  @override
  String backupCreatedSuccess(String path) {
    return 'Backup successfully created at: $path';
  }

  @override
  String get backupRestorePreviewTitle => 'Confirm Restore';

  @override
  String backupRestorePreviewCounts(
    int accounts,
    int transactions,
    int debts,
    int goals,
  ) {
    return 'This backup contains: $accounts accounts, $transactions transactions, $debts debts and $goals savings goals.';
  }

  @override
  String get backupRestoreWarning =>
      'Warning! Restoring will replace current data. An automatic backup will be created beforehand.';

  @override
  String get backupRestoreSuccess => 'Restore completed successfully';

  @override
  String get backupShare => 'Share backup file';

  @override
  String get updatesTitle => 'Updates';

  @override
  String get updatesCheckNow => 'Check for updates';

  @override
  String get updatesChecking => 'Checking GitHub Releases...';

  @override
  String get updatesUpToDate => 'Your app is up to date!';

  @override
  String updatesAvailable(String version) {
    return 'New version available: $version';
  }

  @override
  String get updatesReleaseNotes => 'Release Notes';

  @override
  String get updatesDownloadAndInstall => 'Download & Install';

  @override
  String updatesDownloading(int percent) {
    return 'Downloading update ($percent%)...';
  }

  @override
  String get updatesVerifying => 'Verifying SHA-256 integrity...';

  @override
  String get updatesInstallReady => 'Verified package ready to install';

  @override
  String get onboardingTitle => 'Welcome to Personal Finance';

  @override
  String get onboardingSubtitle =>
      'Total control of your money, debt-free, 100% private.';

  @override
  String get onboardingStepCurrency => 'Choose your primary currency';

  @override
  String get onboardingStepBaseIncome =>
      'What is your safe monthly base income?';

  @override
  String get onboardingStepBaseIncomeHelp =>
      'The minimum amount you receive with certainty every month.';

  @override
  String get onboardingStepAccount => 'Create your first main account';

  @override
  String get onboardingInitialAccountName => 'Cash / Bank';

  @override
  String get onboardingStartButton => 'Start Managing';

  @override
  String get category_food => 'Food & Groceries';

  @override
  String get category_drinks => 'Drinks';

  @override
  String get category_outings => 'Outings & Restaurants';

  @override
  String get category_partner => 'Partner';

  @override
  String get category_hygiene => 'Hygiene & Personal Care';

  @override
  String get category_transport => 'Public Transport';

  @override
  String get category_fuel => 'Fuel';

  @override
  String get category_moto_maintenance => 'Motorcycle Maintenance';

  @override
  String get category_moto_documents => 'Motorcycle Documents (SOAT/Tecno)';

  @override
  String get category_debt_payment => 'Debt Payment';

  @override
  String get category_savings_contribution => 'Savings Contribution';

  @override
  String get category_health => 'Health & Medicine';

  @override
  String get category_education => 'Education';

  @override
  String get category_other_expense => 'Other Expenses';

  @override
  String get category_salary => 'Salary';

  @override
  String get category_drinks_business => 'Beverage Business Profit';

  @override
  String get category_deliveries => 'Deliveries';

  @override
  String get category_moto_rental => 'Motorcycle Rental';

  @override
  String get category_family_support => 'Family Support';

  @override
  String get category_external_services => 'External Services';

  @override
  String get category_loan_collection => 'Loan Collection';

  @override
  String get category_other_income => 'Other Income';

  @override
  String get failure_invalidAmount =>
      'The amount entered is invalid or must be greater than zero.';

  @override
  String get failure_invalidDate => 'The date or day entered is invalid.';

  @override
  String get failure_accountNotFound => 'Account not found.';

  @override
  String get failure_accountHasTransactions =>
      'This account has transactions and cannot be deleted.';

  @override
  String get failure_insufficientBalance =>
      'Insufficient balance in selected account.';

  @override
  String get failure_categoryNotFound => 'Category not found.';

  @override
  String get failure_categoryHasTransactions =>
      'This category has transactions; it can only be deactivated.';

  @override
  String get failure_defaultCategoryCannotBeDeleted =>
      'Default system categories cannot be deleted.';

  @override
  String get failure_debtNotFound => 'Debt not found.';

  @override
  String get failure_debtPaymentExceedsBalance =>
      'Payment amount exceeds remaining debt balance.';

  @override
  String get failure_receivableNotFound => 'Receivable loan record not found.';

  @override
  String get failure_receivableCollectionExceedsBalance =>
      'Collection amount exceeds remaining loan balance.';

  @override
  String get failure_savingsGoalNotFound => 'Savings goal not found.';

  @override
  String get failure_invalidTransferSameAccount =>
      'Source account and destination account must be different.';

  @override
  String get failure_invalidAllocationRulePercentSum =>
      'The sum of allocation percentages must equal exactly 100%.';

  @override
  String get failure_invalidBackupFile =>
      'The backup file is invalid or corrupted.';

  @override
  String get failure_invalidBackupChecksum =>
      'Backup integrity check (SHA-256 checksum) failed.';

  @override
  String get failure_unsupportedBackupVersion =>
      'The backup file version is newer than this app. Please update the app first.';

  @override
  String get failure_networkError =>
      'Network connection error when reaching the server.';

  @override
  String get failure_packageDownloadFailed =>
      'Failed to download update package.';

  @override
  String get failure_sha256VerificationFailed =>
      'Package SHA-256 verification failed. File may be corrupted.';

  @override
  String get failure_invalidQuickAddLink =>
      'Invalid or malformed quick add link.';

  @override
  String get failure_notFound => 'Item not found.';

  @override
  String get failure_databaseError => 'A local database error occurred.';
}
