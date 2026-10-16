// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Finanzas Personales';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get undo => 'Deshacer';

  @override
  String get retry => 'Reintentar';

  @override
  String get close => 'Cerrar';

  @override
  String get accept => 'Aceptar';

  @override
  String get back => 'Atrás';

  @override
  String get continueText => 'Continuar';

  @override
  String get search => 'Buscar';

  @override
  String get filter => 'Filtrar';

  @override
  String get all => 'Todos';

  @override
  String get emptyStateTitle => 'Sin datos por aquí';

  @override
  String get emptyStateMessage =>
      'No hay registros disponibles en este momento.';

  @override
  String get loading => 'Cargando...';

  @override
  String get success => 'Operación exitosa';

  @override
  String get navHome => 'Inicio';

  @override
  String get navTransactions => 'Movimientos';

  @override
  String get navDebts => 'Deudas y cobros';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get navAdd => 'Registrar';

  @override
  String get homeTotalBalance => 'Saldo total';

  @override
  String get homeSafeAvailable => 'Disponible seguro';

  @override
  String get homeMonthlyIncome => 'Ingreso del mes';

  @override
  String get homeBaseIncome => 'Ingreso base';

  @override
  String get homeDeficitWarning => 'Déficit proyectado para este mes';

  @override
  String get homeTotalDebt => 'Total deudas';

  @override
  String get homeTotalReceivables => 'Por cobrar';

  @override
  String get homeTotalSavings => 'Total ahorrado';

  @override
  String get homeRecentTransactions => 'Últimos movimientos';

  @override
  String get homeViewAll => 'Ver todos';

  @override
  String get homeQuickActions => 'Acciones rápidas';

  @override
  String get homeSavingsGoals => 'Metas de ahorro';

  @override
  String get homeReports => 'Reportes y estadísticas';

  @override
  String get homeAccounts => 'Cuentas y bolsillos';

  @override
  String get homeExtraIncomeSplit => 'Reparto de ingreso extra';

  @override
  String get homeSuggestSplit => 'Sugerir reparto';

  @override
  String homeSplitDebts(int percent) {
    return 'Abono a deudas ($percent%)';
  }

  @override
  String homeSplitSavings(int percent) {
    return 'Aporte a ahorro ($percent%)';
  }

  @override
  String homeSplitFree(int percent) {
    return 'Disponible libre ($percent%)';
  }

  @override
  String get homeSplitConfirm => 'Aplicar sugerencia';

  @override
  String get transactionIncome => 'Ingreso';

  @override
  String get transactionExpense => 'Gasto';

  @override
  String get transactionTransfer => 'Transferencia';

  @override
  String get transactionAmount => 'Monto';

  @override
  String get transactionAccount => 'Cuenta';

  @override
  String get transactionSourceAccount => 'Cuenta origen';

  @override
  String get transactionTargetAccount => 'Cuenta destino';

  @override
  String get transactionCategory => 'Categoría';

  @override
  String get transactionDate => 'Fecha';

  @override
  String get transactionNote => 'Nota u observación (opcional)';

  @override
  String get transactionSaved => 'Movimiento registrado con éxito';

  @override
  String get transactionDeleted => 'Movimiento eliminado';

  @override
  String get transactionRestored => 'Movimiento restaurado';

  @override
  String get transactionUpdated => 'Movimiento actualizado';

  @override
  String get transactionFilterAll => 'Todos';

  @override
  String get transactionFilterExpense => 'Gastos';

  @override
  String get transactionFilterIncome => 'Ingresos';

  @override
  String get transactionFilterTransfer => 'Transferencias';

  @override
  String get transactionSearchPlaceholder =>
      'Buscar por nota, categoría o cuenta...';

  @override
  String get transactionEmpty => 'No hay transacciones registradas';

  @override
  String get transactionEmptySubtitle =>
      'Presiona el botón + para registrar tu primer ingreso o gasto.';

  @override
  String get addTransactionTitle => 'Registrar Movimiento';

  @override
  String get quickAddTitle => 'Registro Rápido';

  @override
  String get selectAccount => 'Selecciona cuenta';

  @override
  String get selectCategory => 'Selecciona categoría';

  @override
  String get debtsTab => 'Mis Deudas';

  @override
  String get receivablesTab => 'Por Cobrar';

  @override
  String get newDebt => 'Nueva Deuda';

  @override
  String get newReceivable => 'Nuevo Préstamo';

  @override
  String get debtName => 'Nombre de la deuda';

  @override
  String get debtCreditor => 'Acreedor';

  @override
  String get debtInitialAmount => 'Monto inicial';

  @override
  String get debtInterestRate => 'Interés mensual (%)';

  @override
  String get debtMinPayment => 'Cuota mínima mensual';

  @override
  String get debtDueDay => 'Día de pago (1-31)';

  @override
  String get debtCurrentBalance => 'Saldo pendiente';

  @override
  String get debtMakePayment => 'Abonar a Deuda';

  @override
  String get debtPaymentAmount => 'Monto a abonar';

  @override
  String get debtSuggestionTitle => 'Sugerencia inteligente de abono';

  @override
  String debtSuggestionSubtitle(String strategy) {
    return 'Basado en tu estrategia ($strategy)';
  }

  @override
  String get strategyAvalanche => 'Avalancha (mayor interés)';

  @override
  String get strategySnowball => 'Bola de nieve (menor saldo)';

  @override
  String get debtDueSoonAlert => '¡Cuota próxima a vencer en 3 días!';

  @override
  String get debtSettled => 'Saldada';

  @override
  String get debtEmpty => 'No tienes deudas activas';

  @override
  String get debtEmptySubtitle =>
      '¡Excelente! Mantén tus finanzas libres de deudas.';

  @override
  String get receivablePerson => 'Persona o deudor';

  @override
  String get receivableInitialAmount => 'Monto prestado';

  @override
  String get receivableRegisterCollection => 'Registrar Cobro';

  @override
  String get receivablePendingBalance => 'Saldo pendiente';

  @override
  String get receivableEmpty => 'No tienes préstamos por cobrar';

  @override
  String get receivableEmptySubtitle =>
      'Aquí aparecerán las personas a quienes les has prestado dinero.';

  @override
  String get savingsTitle => 'Metas de Ahorro';

  @override
  String get newGoal => 'Nueva Meta';

  @override
  String get goalName => 'Nombre de la meta';

  @override
  String get goalTargetAmount => 'Monto objetivo';

  @override
  String get goalTargetDate => 'Fecha límite (opcional)';

  @override
  String get goalAccumulated => 'Ahorrado';

  @override
  String get goalProgress => 'Progreso';

  @override
  String get goalContribute => 'Aportar a Meta';

  @override
  String get goalContributeSubtitle => 'Transferencia a cuenta de ahorros';

  @override
  String get savingsEmpty => 'No tienes metas de ahorro activas';

  @override
  String get savingsEmptySubtitle =>
      'Crea una meta como \'Fondo de emergencia\' o \'Vacaciones\'.';

  @override
  String get reportsTitle => 'Reportes y Estadísticas';

  @override
  String get reportsMonth => 'Mes';

  @override
  String get reportsCategoryBreakdown => 'Distribución de Gastos';

  @override
  String get reportsMonthlyEvolution => 'Evolución Últimos 6 Meses';

  @override
  String get reportsSpecialGroupings => 'Reportes Agrupados Especiales';

  @override
  String get reportMotoTitle => 'Gastos de Moto';

  @override
  String get reportMotoDescription =>
      'Combustible, mantenimiento y documentos (SOAT / Tecno)';

  @override
  String get reportOutingsTitle => 'Salidas y Pareja';

  @override
  String get reportOutingsDescription =>
      'Salidas, restaurantes y gastos de pareja';

  @override
  String get reportsTotalExpense => 'Gasto total';

  @override
  String get reportsTotalIncome => 'Ingreso total';

  @override
  String get reportsNetBalance => 'Balance neto';

  @override
  String get reportsEmptyData =>
      'No hay movimientos registrados para este período';

  @override
  String get accountsTitle => 'Cuentas y Bolsillos';

  @override
  String get newAccount => 'Nueva Cuenta';

  @override
  String get editAccount => 'Editar Cuenta';

  @override
  String get accountName => 'Nombre de la cuenta';

  @override
  String get accountType => 'Tipo de cuenta';

  @override
  String get accountTypeCash => 'Efectivo';

  @override
  String get accountTypeBank => 'Cuenta bancaria';

  @override
  String get accountTypeSavings => 'Bolsillo de ahorro';

  @override
  String get accountInitialBalance => 'Saldo inicial';

  @override
  String get accountArchived => 'Archivada';

  @override
  String get accountArchiveConfirm => '¿Deseas archivar esta cuenta?';

  @override
  String get accountArchiveNotice =>
      'Las cuentas con movimientos no se borran; solo se ocultan de nuevos registros.';

  @override
  String get categoriesTitle => 'Categorías';

  @override
  String get newCategory => 'Nueva Categoría';

  @override
  String get categoryName => 'Nombre';

  @override
  String get categoryKind => 'Tipo';

  @override
  String get categoryIcon => 'Ícono';

  @override
  String get categoryColor => 'Color';

  @override
  String get categoryActive => 'Activa';

  @override
  String get categoryDefaultProtected =>
      'Categoría del sistema (no eliminable)';

  @override
  String get categoryDeactivated => 'Categoría desactivada';

  @override
  String get categoryActivated => 'Categoría activada';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsAppearance => 'Apariencia';

  @override
  String get settingsTheme => 'Tema visual';

  @override
  String get settingsThemeSystem => 'Tema del sistema';

  @override
  String get settingsThemeLight => 'Modo claro';

  @override
  String get settingsThemeDark => 'Modo oscuro';

  @override
  String get settingsLanguage => 'Idioma de la aplicación';

  @override
  String get settingsLanguageSystem => 'Idioma del sistema';

  @override
  String get settingsLanguageEs => 'Español';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsCurrency => 'Moneda principal';

  @override
  String get settingsCurrencyNotice =>
      'Cambiar la moneda solo altera el símbolo y formato, no convierte los montos.';

  @override
  String get settingsBudgetAndRules => 'Presupuesto y Reparto';

  @override
  String get settingsBaseIncome => 'Ingreso base seguro';

  @override
  String get settingsAllocationRules => 'Reglas de reparto de ingresos extra';

  @override
  String get settingsAllocationDebts => '% a deudas';

  @override
  String get settingsAllocationSavings => '% a ahorro';

  @override
  String get settingsAllocationFree => '% disponible libre';

  @override
  String get settingsDebtStrategy => 'Estrategia preferida de deudas';

  @override
  String get settingsBackup => 'Copias de Seguridad';

  @override
  String get settingsUpdates => 'Actualizaciones de la App';

  @override
  String get settingsAbout => 'Acerca de Finanzas Personales';

  @override
  String get settingsVersion => 'Versión';

  @override
  String get settingsOfflineNotice =>
      '100% offline y privado. Tus datos nunca salen de tu dispositivo.';

  @override
  String get backupTitle => 'Copia de Seguridad y Restauración';

  @override
  String get backupCreateNow => 'Crear copia ahora';

  @override
  String get backupSelectFolder => 'Seleccionar carpeta de destino';

  @override
  String get backupRestoreFromFile => 'Restaurar desde archivo';

  @override
  String get backupRetentionNotice =>
      'Se conservan automáticamente las últimas 10 copias de seguridad.';

  @override
  String backupCreatedSuccess(String path) {
    return 'Copia de seguridad creada en: $path';
  }

  @override
  String get backupRestorePreviewTitle => 'Confirmar Restauración';

  @override
  String backupRestorePreviewCounts(
    int accounts,
    int transactions,
    int debts,
    int goals,
  ) {
    return 'Esta copia contiene: $accounts cuentas, $transactions movimientos, $debts deudas y $goals metas de ahorro.';
  }

  @override
  String get backupRestoreWarning =>
      '¡Atención! Restaurar reemplazará los datos actuales. Se creará una copia previa automáticamente.';

  @override
  String get backupRestoreSuccess => 'Restauración completada con éxito';

  @override
  String get backupShare => 'Compartir copia';

  @override
  String get updatesTitle => 'Actualizaciones';

  @override
  String get updatesCheckNow => 'Buscar actualizaciones';

  @override
  String get updatesChecking => 'Comprobando GitHub Releases...';

  @override
  String get updatesUpToDate => '¡Tu aplicación está actualizada!';

  @override
  String updatesAvailable(String version) {
    return 'Nueva versión disponible: $version';
  }

  @override
  String get updatesReleaseNotes => 'Notas de la versión';

  @override
  String get updatesDownloadAndInstall => 'Descargar e Instalar';

  @override
  String updatesDownloading(int percent) {
    return 'Descargando actualización ($percent%)...';
  }

  @override
  String get updatesVerifying => 'Verificando integridad SHA-256...';

  @override
  String get updatesInstallReady => 'Archivo verificado listo para instalar';

  @override
  String get onboardingTitle => 'Bienvenido a Finanzas Personales';

  @override
  String get onboardingSubtitle =>
      'Control total de tu dinero, libre de deudas, con privacidad absoluta.';

  @override
  String get onboardingStepCurrency => 'Elige tu moneda principal';

  @override
  String get onboardingStepBaseIncome =>
      '¿Cuál es tu ingreso base seguro mensual?';

  @override
  String get onboardingStepBaseIncomeHelp =>
      'El mínimo que recibes con total certeza cada mes.';

  @override
  String get onboardingStepAccount => 'Crea tu cuenta principal inicial';

  @override
  String get onboardingInitialAccountName => 'Mi Efectivo / Banco';

  @override
  String get onboardingStartButton => 'Comenzar a Administrar';

  @override
  String get category_food => 'Comida y alimentación';

  @override
  String get category_drinks => 'Bebidas';

  @override
  String get category_outings => 'Salidas y restaurantes';

  @override
  String get category_partner => 'Pareja';

  @override
  String get category_hygiene => 'Aseo e higiene';

  @override
  String get category_transport => 'Transporte público';

  @override
  String get category_fuel => 'Gasolina / Combustible';

  @override
  String get category_moto_maintenance => 'Mantenimiento moto';

  @override
  String get category_moto_documents => 'Documentos moto (SOAT/Tecno)';

  @override
  String get category_debt_payment => 'Abono a deuda';

  @override
  String get category_savings_contribution => 'Aporte a ahorro';

  @override
  String get category_health => 'Salud y medicina';

  @override
  String get category_education => 'Educación';

  @override
  String get category_other_expense => 'Otros gastos';

  @override
  String get category_salary => 'Salario base';

  @override
  String get category_drinks_business => 'Ganancia negocio de bebidas';

  @override
  String get category_deliveries => 'Domicilios / Entregas';

  @override
  String get category_moto_rental => 'Alquiler de moto';

  @override
  String get category_family_support => 'Ayuda familiar';

  @override
  String get category_external_services => 'Servicios externos';

  @override
  String get category_loan_collection => 'Cobro de préstamo';

  @override
  String get category_other_income => 'Otros ingresos';

  @override
  String get failure_invalidAmount =>
      'El monto ingresado es inválido o debe ser mayor a cero.';

  @override
  String get failure_invalidDate => 'La fecha o día ingresado no es válido.';

  @override
  String get failure_accountNotFound => 'Cuenta no encontrada.';

  @override
  String get failure_accountHasTransactions =>
      'Esta cuenta tiene movimientos registrados y no puede eliminarse.';

  @override
  String get failure_insufficientBalance =>
      'Saldo insuficiente en la cuenta seleccionada.';

  @override
  String get failure_categoryNotFound => 'Categoría no encontrada.';

  @override
  String get failure_categoryHasTransactions =>
      'Esta categoría tiene movimientos registrados; solo puede desactivarse.';

  @override
  String get failure_defaultCategoryCannotBeDeleted =>
      'Las categorías predeterminadas del sistema no pueden ser eliminadas.';

  @override
  String get failure_debtNotFound => 'Deuda no encontrada.';

  @override
  String get failure_debtPaymentExceedsBalance =>
      'El monto del abono supera el saldo pendiente de la deuda.';

  @override
  String get failure_receivableNotFound =>
      'Registro de préstamo por cobrar no encontrado.';

  @override
  String get failure_receivableCollectionExceedsBalance =>
      'El monto a cobrar supera el saldo pendiente del préstamo.';

  @override
  String get failure_savingsGoalNotFound => 'Meta de ahorro no encontrada.';

  @override
  String get failure_invalidTransferSameAccount =>
      'La cuenta origen y la cuenta destino deben ser diferentes.';

  @override
  String get failure_invalidAllocationRulePercentSum =>
      'La suma de los porcentajes de reparto debe ser exactamente 100%.';

  @override
  String get failure_invalidBackupFile =>
      'El archivo de copia de seguridad no es válido o está dañado.';

  @override
  String get failure_invalidBackupChecksum =>
      'La verificación de integridad (checksum SHA-256) del backup ha fallado.';

  @override
  String get failure_unsupportedBackupVersion =>
      'La versión del archivo de respaldo es más reciente que esta app. Actualiza la aplicación primero.';

  @override
  String get failure_networkError =>
      'Error de conexión de red al comunicarse con el servidor.';

  @override
  String get failure_packageDownloadFailed =>
      'Falló la descarga del paquete de actualización.';

  @override
  String get failure_sha256VerificationFailed =>
      'La verificación de firma de la descarga falló. El archivo podría estar corrupto.';

  @override
  String get failure_invalidQuickAddLink =>
      'Enlace de registro rápido inválido o malformado.';

  @override
  String get failure_notFound => 'Elemento no encontrado.';

  @override
  String get failure_databaseError =>
      'Ocurrió un error en la base de datos local.';
}
