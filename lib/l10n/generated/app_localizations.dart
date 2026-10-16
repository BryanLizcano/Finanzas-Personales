import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Finanzas Personales'**
  String get appTitle;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @confirm.
  ///
  /// In es, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get edit;

  /// No description provided for @undo.
  ///
  /// In es, this message translates to:
  /// **'Deshacer'**
  String get undo;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get close;

  /// No description provided for @accept.
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get accept;

  /// No description provided for @back.
  ///
  /// In es, this message translates to:
  /// **'Atrás'**
  String get back;

  /// No description provided for @continueText.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get continueText;

  /// No description provided for @search.
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In es, this message translates to:
  /// **'Filtrar'**
  String get filter;

  /// No description provided for @all.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get all;

  /// No description provided for @emptyStateTitle.
  ///
  /// In es, this message translates to:
  /// **'Sin datos por aquí'**
  String get emptyStateTitle;

  /// No description provided for @emptyStateMessage.
  ///
  /// In es, this message translates to:
  /// **'No hay registros disponibles en este momento.'**
  String get emptyStateMessage;

  /// No description provided for @loading.
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get loading;

  /// No description provided for @success.
  ///
  /// In es, this message translates to:
  /// **'Operación exitosa'**
  String get success;

  /// No description provided for @navHome.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get navHome;

  /// No description provided for @navTransactions.
  ///
  /// In es, this message translates to:
  /// **'Movimientos'**
  String get navTransactions;

  /// No description provided for @navDebts.
  ///
  /// In es, this message translates to:
  /// **'Deudas y cobros'**
  String get navDebts;

  /// No description provided for @navSettings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get navSettings;

  /// No description provided for @navAdd.
  ///
  /// In es, this message translates to:
  /// **'Registrar'**
  String get navAdd;

  /// No description provided for @homeTotalBalance.
  ///
  /// In es, this message translates to:
  /// **'Saldo total'**
  String get homeTotalBalance;

  /// No description provided for @homeSafeAvailable.
  ///
  /// In es, this message translates to:
  /// **'Disponible seguro'**
  String get homeSafeAvailable;

  /// No description provided for @homeMonthlyIncome.
  ///
  /// In es, this message translates to:
  /// **'Ingreso del mes'**
  String get homeMonthlyIncome;

  /// No description provided for @homeBaseIncome.
  ///
  /// In es, this message translates to:
  /// **'Ingreso base'**
  String get homeBaseIncome;

  /// No description provided for @homeDeficitWarning.
  ///
  /// In es, this message translates to:
  /// **'Déficit proyectado para este mes'**
  String get homeDeficitWarning;

  /// No description provided for @homeTotalDebt.
  ///
  /// In es, this message translates to:
  /// **'Total deudas'**
  String get homeTotalDebt;

  /// No description provided for @homeTotalReceivables.
  ///
  /// In es, this message translates to:
  /// **'Por cobrar'**
  String get homeTotalReceivables;

  /// No description provided for @homeTotalSavings.
  ///
  /// In es, this message translates to:
  /// **'Total ahorrado'**
  String get homeTotalSavings;

  /// No description provided for @homeRecentTransactions.
  ///
  /// In es, this message translates to:
  /// **'Últimos movimientos'**
  String get homeRecentTransactions;

  /// No description provided for @homeViewAll.
  ///
  /// In es, this message translates to:
  /// **'Ver todos'**
  String get homeViewAll;

  /// No description provided for @homeQuickActions.
  ///
  /// In es, this message translates to:
  /// **'Acciones rápidas'**
  String get homeQuickActions;

  /// No description provided for @homeSavingsGoals.
  ///
  /// In es, this message translates to:
  /// **'Metas de ahorro'**
  String get homeSavingsGoals;

  /// No description provided for @homeReports.
  ///
  /// In es, this message translates to:
  /// **'Reportes y estadísticas'**
  String get homeReports;

  /// No description provided for @homeAccounts.
  ///
  /// In es, this message translates to:
  /// **'Cuentas y bolsillos'**
  String get homeAccounts;

  /// No description provided for @homeExtraIncomeSplit.
  ///
  /// In es, this message translates to:
  /// **'Reparto de ingreso extra'**
  String get homeExtraIncomeSplit;

  /// No description provided for @homeSuggestSplit.
  ///
  /// In es, this message translates to:
  /// **'Sugerir reparto'**
  String get homeSuggestSplit;

  /// No description provided for @homeSplitDebts.
  ///
  /// In es, this message translates to:
  /// **'Abono a deudas ({percent}%)'**
  String homeSplitDebts(int percent);

  /// No description provided for @homeSplitSavings.
  ///
  /// In es, this message translates to:
  /// **'Aporte a ahorro ({percent}%)'**
  String homeSplitSavings(int percent);

  /// No description provided for @homeSplitFree.
  ///
  /// In es, this message translates to:
  /// **'Disponible libre ({percent}%)'**
  String homeSplitFree(int percent);

  /// No description provided for @homeSplitConfirm.
  ///
  /// In es, this message translates to:
  /// **'Aplicar sugerencia'**
  String get homeSplitConfirm;

  /// No description provided for @transactionIncome.
  ///
  /// In es, this message translates to:
  /// **'Ingreso'**
  String get transactionIncome;

  /// No description provided for @transactionExpense.
  ///
  /// In es, this message translates to:
  /// **'Gasto'**
  String get transactionExpense;

  /// No description provided for @transactionTransfer.
  ///
  /// In es, this message translates to:
  /// **'Transferencia'**
  String get transactionTransfer;

  /// No description provided for @transactionAmount.
  ///
  /// In es, this message translates to:
  /// **'Monto'**
  String get transactionAmount;

  /// No description provided for @transactionAccount.
  ///
  /// In es, this message translates to:
  /// **'Cuenta'**
  String get transactionAccount;

  /// No description provided for @transactionSourceAccount.
  ///
  /// In es, this message translates to:
  /// **'Cuenta origen'**
  String get transactionSourceAccount;

  /// No description provided for @transactionTargetAccount.
  ///
  /// In es, this message translates to:
  /// **'Cuenta destino'**
  String get transactionTargetAccount;

  /// No description provided for @transactionCategory.
  ///
  /// In es, this message translates to:
  /// **'Categoría'**
  String get transactionCategory;

  /// No description provided for @transactionDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get transactionDate;

  /// No description provided for @transactionNote.
  ///
  /// In es, this message translates to:
  /// **'Nota u observación (opcional)'**
  String get transactionNote;

  /// No description provided for @transactionSaved.
  ///
  /// In es, this message translates to:
  /// **'Movimiento registrado con éxito'**
  String get transactionSaved;

  /// No description provided for @transactionDeleted.
  ///
  /// In es, this message translates to:
  /// **'Movimiento eliminado'**
  String get transactionDeleted;

  /// No description provided for @transactionRestored.
  ///
  /// In es, this message translates to:
  /// **'Movimiento restaurado'**
  String get transactionRestored;

  /// No description provided for @transactionUpdated.
  ///
  /// In es, this message translates to:
  /// **'Movimiento actualizado'**
  String get transactionUpdated;

  /// No description provided for @transactionFilterAll.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get transactionFilterAll;

  /// No description provided for @transactionFilterExpense.
  ///
  /// In es, this message translates to:
  /// **'Gastos'**
  String get transactionFilterExpense;

  /// No description provided for @transactionFilterIncome.
  ///
  /// In es, this message translates to:
  /// **'Ingresos'**
  String get transactionFilterIncome;

  /// No description provided for @transactionFilterTransfer.
  ///
  /// In es, this message translates to:
  /// **'Transferencias'**
  String get transactionFilterTransfer;

  /// No description provided for @transactionSearchPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Buscar por nota, categoría o cuenta...'**
  String get transactionSearchPlaceholder;

  /// No description provided for @transactionEmpty.
  ///
  /// In es, this message translates to:
  /// **'No hay transacciones registradas'**
  String get transactionEmpty;

  /// No description provided for @transactionEmptySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Presiona el botón + para registrar tu primer ingreso o gasto.'**
  String get transactionEmptySubtitle;

  /// No description provided for @addTransactionTitle.
  ///
  /// In es, this message translates to:
  /// **'Registrar Movimiento'**
  String get addTransactionTitle;

  /// No description provided for @quickAddTitle.
  ///
  /// In es, this message translates to:
  /// **'Registro Rápido'**
  String get quickAddTitle;

  /// No description provided for @selectAccount.
  ///
  /// In es, this message translates to:
  /// **'Selecciona cuenta'**
  String get selectAccount;

  /// No description provided for @selectCategory.
  ///
  /// In es, this message translates to:
  /// **'Selecciona categoría'**
  String get selectCategory;

  /// No description provided for @debtsTab.
  ///
  /// In es, this message translates to:
  /// **'Mis Deudas'**
  String get debtsTab;

  /// No description provided for @receivablesTab.
  ///
  /// In es, this message translates to:
  /// **'Por Cobrar'**
  String get receivablesTab;

  /// No description provided for @newDebt.
  ///
  /// In es, this message translates to:
  /// **'Nueva Deuda'**
  String get newDebt;

  /// No description provided for @newReceivable.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Préstamo'**
  String get newReceivable;

  /// No description provided for @debtName.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la deuda'**
  String get debtName;

  /// No description provided for @debtCreditor.
  ///
  /// In es, this message translates to:
  /// **'Acreedor'**
  String get debtCreditor;

  /// No description provided for @debtInitialAmount.
  ///
  /// In es, this message translates to:
  /// **'Monto inicial'**
  String get debtInitialAmount;

  /// No description provided for @debtInterestRate.
  ///
  /// In es, this message translates to:
  /// **'Interés mensual (%)'**
  String get debtInterestRate;

  /// No description provided for @debtMinPayment.
  ///
  /// In es, this message translates to:
  /// **'Cuota mínima mensual'**
  String get debtMinPayment;

  /// No description provided for @debtDueDay.
  ///
  /// In es, this message translates to:
  /// **'Día de pago (1-31)'**
  String get debtDueDay;

  /// No description provided for @debtCurrentBalance.
  ///
  /// In es, this message translates to:
  /// **'Saldo pendiente'**
  String get debtCurrentBalance;

  /// No description provided for @debtMakePayment.
  ///
  /// In es, this message translates to:
  /// **'Abonar a Deuda'**
  String get debtMakePayment;

  /// No description provided for @debtPaymentAmount.
  ///
  /// In es, this message translates to:
  /// **'Monto a abonar'**
  String get debtPaymentAmount;

  /// No description provided for @debtSuggestionTitle.
  ///
  /// In es, this message translates to:
  /// **'Sugerencia inteligente de abono'**
  String get debtSuggestionTitle;

  /// No description provided for @debtSuggestionSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Basado en tu estrategia ({strategy})'**
  String debtSuggestionSubtitle(String strategy);

  /// No description provided for @strategyAvalanche.
  ///
  /// In es, this message translates to:
  /// **'Avalancha (mayor interés)'**
  String get strategyAvalanche;

  /// No description provided for @strategySnowball.
  ///
  /// In es, this message translates to:
  /// **'Bola de nieve (menor saldo)'**
  String get strategySnowball;

  /// No description provided for @debtDueSoonAlert.
  ///
  /// In es, this message translates to:
  /// **'¡Cuota próxima a vencer en 3 días!'**
  String get debtDueSoonAlert;

  /// No description provided for @debtSettled.
  ///
  /// In es, this message translates to:
  /// **'Saldada'**
  String get debtSettled;

  /// No description provided for @debtEmpty.
  ///
  /// In es, this message translates to:
  /// **'No tienes deudas activas'**
  String get debtEmpty;

  /// No description provided for @debtEmptySubtitle.
  ///
  /// In es, this message translates to:
  /// **'¡Excelente! Mantén tus finanzas libres de deudas.'**
  String get debtEmptySubtitle;

  /// No description provided for @receivablePerson.
  ///
  /// In es, this message translates to:
  /// **'Persona o deudor'**
  String get receivablePerson;

  /// No description provided for @receivableInitialAmount.
  ///
  /// In es, this message translates to:
  /// **'Monto prestado'**
  String get receivableInitialAmount;

  /// No description provided for @receivableRegisterCollection.
  ///
  /// In es, this message translates to:
  /// **'Registrar Cobro'**
  String get receivableRegisterCollection;

  /// No description provided for @receivablePendingBalance.
  ///
  /// In es, this message translates to:
  /// **'Saldo pendiente'**
  String get receivablePendingBalance;

  /// No description provided for @receivableEmpty.
  ///
  /// In es, this message translates to:
  /// **'No tienes préstamos por cobrar'**
  String get receivableEmpty;

  /// No description provided for @receivableEmptySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Aquí aparecerán las personas a quienes les has prestado dinero.'**
  String get receivableEmptySubtitle;

  /// No description provided for @savingsTitle.
  ///
  /// In es, this message translates to:
  /// **'Metas de Ahorro'**
  String get savingsTitle;

  /// No description provided for @newGoal.
  ///
  /// In es, this message translates to:
  /// **'Nueva Meta'**
  String get newGoal;

  /// No description provided for @goalName.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la meta'**
  String get goalName;

  /// No description provided for @goalTargetAmount.
  ///
  /// In es, this message translates to:
  /// **'Monto objetivo'**
  String get goalTargetAmount;

  /// No description provided for @goalTargetDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha límite (opcional)'**
  String get goalTargetDate;

  /// No description provided for @goalAccumulated.
  ///
  /// In es, this message translates to:
  /// **'Ahorrado'**
  String get goalAccumulated;

  /// No description provided for @goalProgress.
  ///
  /// In es, this message translates to:
  /// **'Progreso'**
  String get goalProgress;

  /// No description provided for @goalContribute.
  ///
  /// In es, this message translates to:
  /// **'Aportar a Meta'**
  String get goalContribute;

  /// No description provided for @goalContributeSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Transferencia a cuenta de ahorros'**
  String get goalContributeSubtitle;

  /// No description provided for @savingsEmpty.
  ///
  /// In es, this message translates to:
  /// **'No tienes metas de ahorro activas'**
  String get savingsEmpty;

  /// No description provided for @savingsEmptySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Crea una meta como \'Fondo de emergencia\' o \'Vacaciones\'.'**
  String get savingsEmptySubtitle;

  /// No description provided for @reportsTitle.
  ///
  /// In es, this message translates to:
  /// **'Reportes y Estadísticas'**
  String get reportsTitle;

  /// No description provided for @reportsMonth.
  ///
  /// In es, this message translates to:
  /// **'Mes'**
  String get reportsMonth;

  /// No description provided for @reportsCategoryBreakdown.
  ///
  /// In es, this message translates to:
  /// **'Distribución de Gastos'**
  String get reportsCategoryBreakdown;

  /// No description provided for @reportsMonthlyEvolution.
  ///
  /// In es, this message translates to:
  /// **'Evolución Últimos 6 Meses'**
  String get reportsMonthlyEvolution;

  /// No description provided for @reportsSpecialGroupings.
  ///
  /// In es, this message translates to:
  /// **'Reportes Agrupados Especiales'**
  String get reportsSpecialGroupings;

  /// No description provided for @reportMotoTitle.
  ///
  /// In es, this message translates to:
  /// **'Gastos de Moto'**
  String get reportMotoTitle;

  /// No description provided for @reportMotoDescription.
  ///
  /// In es, this message translates to:
  /// **'Combustible, mantenimiento y documentos (SOAT / Tecno)'**
  String get reportMotoDescription;

  /// No description provided for @reportOutingsTitle.
  ///
  /// In es, this message translates to:
  /// **'Salidas y Pareja'**
  String get reportOutingsTitle;

  /// No description provided for @reportOutingsDescription.
  ///
  /// In es, this message translates to:
  /// **'Salidas, restaurantes y gastos de pareja'**
  String get reportOutingsDescription;

  /// No description provided for @reportsTotalExpense.
  ///
  /// In es, this message translates to:
  /// **'Gasto total'**
  String get reportsTotalExpense;

  /// No description provided for @reportsTotalIncome.
  ///
  /// In es, this message translates to:
  /// **'Ingreso total'**
  String get reportsTotalIncome;

  /// No description provided for @reportsNetBalance.
  ///
  /// In es, this message translates to:
  /// **'Balance neto'**
  String get reportsNetBalance;

  /// No description provided for @reportsEmptyData.
  ///
  /// In es, this message translates to:
  /// **'No hay movimientos registrados para este período'**
  String get reportsEmptyData;

  /// No description provided for @accountsTitle.
  ///
  /// In es, this message translates to:
  /// **'Cuentas y Bolsillos'**
  String get accountsTitle;

  /// No description provided for @newAccount.
  ///
  /// In es, this message translates to:
  /// **'Nueva Cuenta'**
  String get newAccount;

  /// No description provided for @editAccount.
  ///
  /// In es, this message translates to:
  /// **'Editar Cuenta'**
  String get editAccount;

  /// No description provided for @accountName.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la cuenta'**
  String get accountName;

  /// No description provided for @accountType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de cuenta'**
  String get accountType;

  /// No description provided for @accountTypeCash.
  ///
  /// In es, this message translates to:
  /// **'Efectivo'**
  String get accountTypeCash;

  /// No description provided for @accountTypeBank.
  ///
  /// In es, this message translates to:
  /// **'Cuenta bancaria'**
  String get accountTypeBank;

  /// No description provided for @accountTypeSavings.
  ///
  /// In es, this message translates to:
  /// **'Bolsillo de ahorro'**
  String get accountTypeSavings;

  /// No description provided for @accountInitialBalance.
  ///
  /// In es, this message translates to:
  /// **'Saldo inicial'**
  String get accountInitialBalance;

  /// No description provided for @accountArchived.
  ///
  /// In es, this message translates to:
  /// **'Archivada'**
  String get accountArchived;

  /// No description provided for @accountArchiveConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Deseas archivar esta cuenta?'**
  String get accountArchiveConfirm;

  /// No description provided for @accountArchiveNotice.
  ///
  /// In es, this message translates to:
  /// **'Las cuentas con movimientos no se borran; solo se ocultan de nuevos registros.'**
  String get accountArchiveNotice;

  /// No description provided for @categoriesTitle.
  ///
  /// In es, this message translates to:
  /// **'Categorías'**
  String get categoriesTitle;

  /// No description provided for @newCategory.
  ///
  /// In es, this message translates to:
  /// **'Nueva Categoría'**
  String get newCategory;

  /// No description provided for @categoryName.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get categoryName;

  /// No description provided for @categoryKind.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get categoryKind;

  /// No description provided for @categoryIcon.
  ///
  /// In es, this message translates to:
  /// **'Ícono'**
  String get categoryIcon;

  /// No description provided for @categoryColor.
  ///
  /// In es, this message translates to:
  /// **'Color'**
  String get categoryColor;

  /// No description provided for @categoryActive.
  ///
  /// In es, this message translates to:
  /// **'Activa'**
  String get categoryActive;

  /// No description provided for @categoryDefaultProtected.
  ///
  /// In es, this message translates to:
  /// **'Categoría del sistema (no eliminable)'**
  String get categoryDefaultProtected;

  /// No description provided for @categoryDeactivated.
  ///
  /// In es, this message translates to:
  /// **'Categoría desactivada'**
  String get categoryDeactivated;

  /// No description provided for @categoryActivated.
  ///
  /// In es, this message translates to:
  /// **'Categoría activada'**
  String get categoryActivated;

  /// No description provided for @settingsTitle.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In es, this message translates to:
  /// **'Apariencia'**
  String get settingsAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In es, this message translates to:
  /// **'Tema visual'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In es, this message translates to:
  /// **'Tema del sistema'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In es, this message translates to:
  /// **'Modo claro'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In es, this message translates to:
  /// **'Modo oscuro'**
  String get settingsThemeDark;

  /// No description provided for @settingsLanguage.
  ///
  /// In es, this message translates to:
  /// **'Idioma de la aplicación'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In es, this message translates to:
  /// **'Idioma del sistema'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageEs.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get settingsLanguageEs;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In es, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// No description provided for @settingsCurrency.
  ///
  /// In es, this message translates to:
  /// **'Moneda principal'**
  String get settingsCurrency;

  /// No description provided for @settingsCurrencyNotice.
  ///
  /// In es, this message translates to:
  /// **'Cambiar la moneda solo altera el símbolo y formato, no convierte los montos.'**
  String get settingsCurrencyNotice;

  /// No description provided for @settingsBudgetAndRules.
  ///
  /// In es, this message translates to:
  /// **'Presupuesto y Reparto'**
  String get settingsBudgetAndRules;

  /// No description provided for @settingsBaseIncome.
  ///
  /// In es, this message translates to:
  /// **'Ingreso base seguro'**
  String get settingsBaseIncome;

  /// No description provided for @settingsAllocationRules.
  ///
  /// In es, this message translates to:
  /// **'Reglas de reparto de ingresos extra'**
  String get settingsAllocationRules;

  /// No description provided for @settingsAllocationDebts.
  ///
  /// In es, this message translates to:
  /// **'% a deudas'**
  String get settingsAllocationDebts;

  /// No description provided for @settingsAllocationSavings.
  ///
  /// In es, this message translates to:
  /// **'% a ahorro'**
  String get settingsAllocationSavings;

  /// No description provided for @settingsAllocationFree.
  ///
  /// In es, this message translates to:
  /// **'% disponible libre'**
  String get settingsAllocationFree;

  /// No description provided for @settingsDebtStrategy.
  ///
  /// In es, this message translates to:
  /// **'Estrategia preferida de deudas'**
  String get settingsDebtStrategy;

  /// No description provided for @settingsBackup.
  ///
  /// In es, this message translates to:
  /// **'Copias de Seguridad'**
  String get settingsBackup;

  /// No description provided for @settingsUpdates.
  ///
  /// In es, this message translates to:
  /// **'Actualizaciones de la App'**
  String get settingsUpdates;

  /// No description provided for @settingsAbout.
  ///
  /// In es, this message translates to:
  /// **'Acerca de Finanzas Personales'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In es, this message translates to:
  /// **'Versión'**
  String get settingsVersion;

  /// No description provided for @settingsOfflineNotice.
  ///
  /// In es, this message translates to:
  /// **'100% offline y privado. Tus datos nunca salen de tu dispositivo.'**
  String get settingsOfflineNotice;

  /// No description provided for @backupTitle.
  ///
  /// In es, this message translates to:
  /// **'Copia de Seguridad y Restauración'**
  String get backupTitle;

  /// No description provided for @backupCreateNow.
  ///
  /// In es, this message translates to:
  /// **'Crear copia ahora'**
  String get backupCreateNow;

  /// No description provided for @backupSelectFolder.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar carpeta de destino'**
  String get backupSelectFolder;

  /// No description provided for @backupRestoreFromFile.
  ///
  /// In es, this message translates to:
  /// **'Restaurar desde archivo'**
  String get backupRestoreFromFile;

  /// No description provided for @backupRetentionNotice.
  ///
  /// In es, this message translates to:
  /// **'Se conservan automáticamente las últimas 10 copias de seguridad.'**
  String get backupRetentionNotice;

  /// No description provided for @backupCreatedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Copia de seguridad creada en: {path}'**
  String backupCreatedSuccess(String path);

  /// No description provided for @backupRestorePreviewTitle.
  ///
  /// In es, this message translates to:
  /// **'Confirmar Restauración'**
  String get backupRestorePreviewTitle;

  /// No description provided for @backupRestorePreviewCounts.
  ///
  /// In es, this message translates to:
  /// **'Esta copia contiene: {accounts} cuentas, {transactions} movimientos, {debts} deudas y {goals} metas de ahorro.'**
  String backupRestorePreviewCounts(
    int accounts,
    int transactions,
    int debts,
    int goals,
  );

  /// No description provided for @backupRestoreWarning.
  ///
  /// In es, this message translates to:
  /// **'¡Atención! Restaurar reemplazará los datos actuales. Se creará una copia previa automáticamente.'**
  String get backupRestoreWarning;

  /// No description provided for @backupRestoreSuccess.
  ///
  /// In es, this message translates to:
  /// **'Restauración completada con éxito'**
  String get backupRestoreSuccess;

  /// No description provided for @backupShare.
  ///
  /// In es, this message translates to:
  /// **'Compartir copia'**
  String get backupShare;

  /// No description provided for @updatesTitle.
  ///
  /// In es, this message translates to:
  /// **'Actualizaciones'**
  String get updatesTitle;

  /// No description provided for @updatesCheckNow.
  ///
  /// In es, this message translates to:
  /// **'Buscar actualizaciones'**
  String get updatesCheckNow;

  /// No description provided for @updatesChecking.
  ///
  /// In es, this message translates to:
  /// **'Comprobando GitHub Releases...'**
  String get updatesChecking;

  /// No description provided for @updatesUpToDate.
  ///
  /// In es, this message translates to:
  /// **'¡Tu aplicación está actualizada!'**
  String get updatesUpToDate;

  /// No description provided for @updatesAvailable.
  ///
  /// In es, this message translates to:
  /// **'Nueva versión disponible: {version}'**
  String updatesAvailable(String version);

  /// No description provided for @updatesReleaseNotes.
  ///
  /// In es, this message translates to:
  /// **'Notas de la versión'**
  String get updatesReleaseNotes;

  /// No description provided for @updatesDownloadAndInstall.
  ///
  /// In es, this message translates to:
  /// **'Descargar e Instalar'**
  String get updatesDownloadAndInstall;

  /// No description provided for @updatesDownloading.
  ///
  /// In es, this message translates to:
  /// **'Descargando actualización ({percent}%)...'**
  String updatesDownloading(int percent);

  /// No description provided for @updatesVerifying.
  ///
  /// In es, this message translates to:
  /// **'Verificando integridad SHA-256...'**
  String get updatesVerifying;

  /// No description provided for @updatesInstallReady.
  ///
  /// In es, this message translates to:
  /// **'Archivo verificado listo para instalar'**
  String get updatesInstallReady;

  /// No description provided for @onboardingTitle.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido a Finanzas Personales'**
  String get onboardingTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Control total de tu dinero, libre de deudas, con privacidad absoluta.'**
  String get onboardingSubtitle;

  /// No description provided for @onboardingStepCurrency.
  ///
  /// In es, this message translates to:
  /// **'Elige tu moneda principal'**
  String get onboardingStepCurrency;

  /// No description provided for @onboardingStepBaseIncome.
  ///
  /// In es, this message translates to:
  /// **'¿Cuál es tu ingreso base seguro mensual?'**
  String get onboardingStepBaseIncome;

  /// No description provided for @onboardingStepBaseIncomeHelp.
  ///
  /// In es, this message translates to:
  /// **'El mínimo que recibes con total certeza cada mes.'**
  String get onboardingStepBaseIncomeHelp;

  /// No description provided for @onboardingStepAccount.
  ///
  /// In es, this message translates to:
  /// **'Crea tu cuenta principal inicial'**
  String get onboardingStepAccount;

  /// No description provided for @onboardingInitialAccountName.
  ///
  /// In es, this message translates to:
  /// **'Mi Efectivo / Banco'**
  String get onboardingInitialAccountName;

  /// No description provided for @onboardingStartButton.
  ///
  /// In es, this message translates to:
  /// **'Comenzar a Administrar'**
  String get onboardingStartButton;

  /// No description provided for @category_food.
  ///
  /// In es, this message translates to:
  /// **'Comida y alimentación'**
  String get category_food;

  /// No description provided for @category_drinks.
  ///
  /// In es, this message translates to:
  /// **'Bebidas'**
  String get category_drinks;

  /// No description provided for @category_outings.
  ///
  /// In es, this message translates to:
  /// **'Salidas y restaurantes'**
  String get category_outings;

  /// No description provided for @category_partner.
  ///
  /// In es, this message translates to:
  /// **'Pareja'**
  String get category_partner;

  /// No description provided for @category_hygiene.
  ///
  /// In es, this message translates to:
  /// **'Aseo e higiene'**
  String get category_hygiene;

  /// No description provided for @category_transport.
  ///
  /// In es, this message translates to:
  /// **'Transporte público'**
  String get category_transport;

  /// No description provided for @category_fuel.
  ///
  /// In es, this message translates to:
  /// **'Gasolina / Combustible'**
  String get category_fuel;

  /// No description provided for @category_moto_maintenance.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento moto'**
  String get category_moto_maintenance;

  /// No description provided for @category_moto_documents.
  ///
  /// In es, this message translates to:
  /// **'Documentos moto (SOAT/Tecno)'**
  String get category_moto_documents;

  /// No description provided for @category_debt_payment.
  ///
  /// In es, this message translates to:
  /// **'Abono a deuda'**
  String get category_debt_payment;

  /// No description provided for @category_savings_contribution.
  ///
  /// In es, this message translates to:
  /// **'Aporte a ahorro'**
  String get category_savings_contribution;

  /// No description provided for @category_health.
  ///
  /// In es, this message translates to:
  /// **'Salud y medicina'**
  String get category_health;

  /// No description provided for @category_education.
  ///
  /// In es, this message translates to:
  /// **'Educación'**
  String get category_education;

  /// No description provided for @category_other_expense.
  ///
  /// In es, this message translates to:
  /// **'Otros gastos'**
  String get category_other_expense;

  /// No description provided for @category_salary.
  ///
  /// In es, this message translates to:
  /// **'Salario base'**
  String get category_salary;

  /// No description provided for @category_drinks_business.
  ///
  /// In es, this message translates to:
  /// **'Ganancia negocio de bebidas'**
  String get category_drinks_business;

  /// No description provided for @category_deliveries.
  ///
  /// In es, this message translates to:
  /// **'Domicilios / Entregas'**
  String get category_deliveries;

  /// No description provided for @category_moto_rental.
  ///
  /// In es, this message translates to:
  /// **'Alquiler de moto'**
  String get category_moto_rental;

  /// No description provided for @category_family_support.
  ///
  /// In es, this message translates to:
  /// **'Ayuda familiar'**
  String get category_family_support;

  /// No description provided for @category_external_services.
  ///
  /// In es, this message translates to:
  /// **'Servicios externos'**
  String get category_external_services;

  /// No description provided for @category_loan_collection.
  ///
  /// In es, this message translates to:
  /// **'Cobro de préstamo'**
  String get category_loan_collection;

  /// No description provided for @category_other_income.
  ///
  /// In es, this message translates to:
  /// **'Otros ingresos'**
  String get category_other_income;

  /// No description provided for @failure_invalidAmount.
  ///
  /// In es, this message translates to:
  /// **'El monto ingresado es inválido o debe ser mayor a cero.'**
  String get failure_invalidAmount;

  /// No description provided for @failure_invalidDate.
  ///
  /// In es, this message translates to:
  /// **'La fecha o día ingresado no es válido.'**
  String get failure_invalidDate;

  /// No description provided for @failure_accountNotFound.
  ///
  /// In es, this message translates to:
  /// **'Cuenta no encontrada.'**
  String get failure_accountNotFound;

  /// No description provided for @failure_accountHasTransactions.
  ///
  /// In es, this message translates to:
  /// **'Esta cuenta tiene movimientos registrados y no puede eliminarse.'**
  String get failure_accountHasTransactions;

  /// No description provided for @failure_insufficientBalance.
  ///
  /// In es, this message translates to:
  /// **'Saldo insuficiente en la cuenta seleccionada.'**
  String get failure_insufficientBalance;

  /// No description provided for @failure_categoryNotFound.
  ///
  /// In es, this message translates to:
  /// **'Categoría no encontrada.'**
  String get failure_categoryNotFound;

  /// No description provided for @failure_categoryHasTransactions.
  ///
  /// In es, this message translates to:
  /// **'Esta categoría tiene movimientos registrados; solo puede desactivarse.'**
  String get failure_categoryHasTransactions;

  /// No description provided for @failure_defaultCategoryCannotBeDeleted.
  ///
  /// In es, this message translates to:
  /// **'Las categorías predeterminadas del sistema no pueden ser eliminadas.'**
  String get failure_defaultCategoryCannotBeDeleted;

  /// No description provided for @failure_debtNotFound.
  ///
  /// In es, this message translates to:
  /// **'Deuda no encontrada.'**
  String get failure_debtNotFound;

  /// No description provided for @failure_debtPaymentExceedsBalance.
  ///
  /// In es, this message translates to:
  /// **'El monto del abono supera el saldo pendiente de la deuda.'**
  String get failure_debtPaymentExceedsBalance;

  /// No description provided for @failure_receivableNotFound.
  ///
  /// In es, this message translates to:
  /// **'Registro de préstamo por cobrar no encontrado.'**
  String get failure_receivableNotFound;

  /// No description provided for @failure_receivableCollectionExceedsBalance.
  ///
  /// In es, this message translates to:
  /// **'El monto a cobrar supera el saldo pendiente del préstamo.'**
  String get failure_receivableCollectionExceedsBalance;

  /// No description provided for @failure_savingsGoalNotFound.
  ///
  /// In es, this message translates to:
  /// **'Meta de ahorro no encontrada.'**
  String get failure_savingsGoalNotFound;

  /// No description provided for @failure_invalidTransferSameAccount.
  ///
  /// In es, this message translates to:
  /// **'La cuenta origen y la cuenta destino deben ser diferentes.'**
  String get failure_invalidTransferSameAccount;

  /// No description provided for @failure_invalidAllocationRulePercentSum.
  ///
  /// In es, this message translates to:
  /// **'La suma de los porcentajes de reparto debe ser exactamente 100%.'**
  String get failure_invalidAllocationRulePercentSum;

  /// No description provided for @failure_invalidBackupFile.
  ///
  /// In es, this message translates to:
  /// **'El archivo de copia de seguridad no es válido o está dañado.'**
  String get failure_invalidBackupFile;

  /// No description provided for @failure_invalidBackupChecksum.
  ///
  /// In es, this message translates to:
  /// **'La verificación de integridad (checksum SHA-256) del backup ha fallado.'**
  String get failure_invalidBackupChecksum;

  /// No description provided for @failure_unsupportedBackupVersion.
  ///
  /// In es, this message translates to:
  /// **'La versión del archivo de respaldo es más reciente que esta app. Actualiza la aplicación primero.'**
  String get failure_unsupportedBackupVersion;

  /// No description provided for @failure_networkError.
  ///
  /// In es, this message translates to:
  /// **'Error de conexión de red al comunicarse con el servidor.'**
  String get failure_networkError;

  /// No description provided for @failure_packageDownloadFailed.
  ///
  /// In es, this message translates to:
  /// **'Falló la descarga del paquete de actualización.'**
  String get failure_packageDownloadFailed;

  /// No description provided for @failure_sha256VerificationFailed.
  ///
  /// In es, this message translates to:
  /// **'La verificación de firma de la descarga falló. El archivo podría estar corrupto.'**
  String get failure_sha256VerificationFailed;

  /// No description provided for @failure_invalidQuickAddLink.
  ///
  /// In es, this message translates to:
  /// **'Enlace de registro rápido inválido o malformado.'**
  String get failure_invalidQuickAddLink;

  /// No description provided for @failure_notFound.
  ///
  /// In es, this message translates to:
  /// **'Elemento no encontrado.'**
  String get failure_notFound;

  /// No description provided for @failure_databaseError.
  ///
  /// In es, this message translates to:
  /// **'Ocurrió un error en la base de datos local.'**
  String get failure_databaseError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
