import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../app/theme/finance_colors.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../accounts/presentation/providers/accounts_providers.dart';
import '../../../budget/presentation/providers/budget_providers.dart';
import '../../../categories/presentation/providers/categories_providers.dart';
import '../../../debts/presentation/providers/debts_providers.dart';
import '../../../receivables/presentation/providers/receivables_providers.dart';
import '../../../reports/presentation/providers/reports_providers.dart';
import '../../../savings/presentation/providers/savings_providers.dart';
import '../../../transactions/presentation/providers/transactions_providers.dart';
import '../../domain/entities/backup_manifest.dart';
import '../providers/backup_providers.dart';

class BackupPage extends ConsumerStatefulWidget {
  const BackupPage({super.key});

  @override
  ConsumerState<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends ConsumerState<BackupPage> {
  bool _isCreating = false;
  bool _isRestoring = false;
  String? _lastCreatedPath;
  String? _lastCreatedJson;
  List<File> _savedBackups = const [];
  final _restoreJsonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedBackups();
  }

  @override
  void dispose() {
    _restoreJsonController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedBackups() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final backupDir = Directory('${appDir.path}/backups');
      if (!await backupDir.exists()) return;
      final files =
          await backupDir
                .list()
                .where((e) => e is File && e.path.endsWith('.json'))
                .cast<File>()
                .toList()
            ..sort((a, b) => b.path.compareTo(a.path));
      if (mounted) {
        setState(() => _savedBackups = files);
      }
    } catch (_) {}
  }

  Future<void> _handleCreateBackup() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _isCreating = true);
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final backupDir = Directory('${appDir.path}/backups');
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }

      final createBackup = ref.read(createBackupUseCaseProvider);
      final res = await createBackup(directoryPath: backupDir.path);

      await res.fold(
        onOk: (path) async {
          String? jsonContent;
          String displayPath = path;
          try {
            jsonContent = await File(path).readAsString();
            await Clipboard.setData(ClipboardData(text: jsonContent));
          } catch (_) {}

          // Intentar guardar copia adicional en la carpeta Descargas pública de Android
          try {
            final fileName = path.split(Platform.pathSeparator).last;
            final downloadDir = Directory('/storage/emulated/0/Download');
            if (await downloadDir.exists() && jsonContent != null) {
              final publicFile = File('${downloadDir.path}/$fileName');
              await publicFile.writeAsString(jsonContent, flush: true);
              displayPath = publicFile.path;
            }
          } catch (_) {}

          await _loadSavedBackups();
          if (!mounted) return;
          setState(() {
            _lastCreatedPath = displayPath;
            _lastCreatedJson = jsonContent;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Copia creada y JSON copiado automáticamente al portapapeles. Pégalo en un bloc de notas o chat para guardarlo.',
              ),
              duration: Duration(seconds: 5),
            ),
          );
        },
        onError: (failure) async {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.toLocalizedMessage(l10n))),
          );
        },
      );
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  Future<void> _handleRestorePreview() async {
    final l10n = AppLocalizations.of(context);
    final jsonStr = _restoreJsonController.text.trim();

    if (jsonStr.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.failure_invalidBackupFile)));
      return;
    }

    setState(() => _isRestoring = true);
    try {
      final restoreUseCase = ref.read(restoreBackupUseCaseProvider);
      final previewRes = await restoreUseCase.validatePreview(jsonStr);

      previewRes.fold(
        onOk: (counts) {
          _showRestoreConfirmDialog(jsonStr, counts);
        },
        onError: (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.toLocalizedMessage(l10n))),
          );
        },
      );
    } finally {
      if (mounted) setState(() => _isRestoring = false);
    }
  }

  void _showRestoreConfirmDialog(String jsonStr, BackupDataCounts counts) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.backupRestorePreviewTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.backupRestorePreviewCounts(
                counts.accountsCount,
                counts.transactionsCount,
                counts.debtsCount,
                counts.goalsCount,
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.expense.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                l10n.backupRestoreWarning,
                style: TextStyle(color: colors.expense, fontSize: 13),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: colors.expense),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final appDir = await getApplicationDocumentsDirectory();
              final restoreUseCase = ref.read(restoreBackupUseCaseProvider);
              final restoreRes = await restoreUseCase(
                jsonString: jsonStr,
                backupBeforeRestoreDirectory: '${appDir.path}/backups',
              );

              restoreRes.fold(
                onOk: (_) {
                  ref.invalidate(accountsWithBalanceProvider);
                  ref.invalidate(debtsWithBalanceStreamProvider);
                  ref.invalidate(suggestedDebtPaymentProvider);
                  ref.invalidate(receivablesWithBalanceStreamProvider);
                  ref.invalidate(totalPendingReceivableProvider);
                  ref.invalidate(savingsGoalsWithProgressStreamProvider);
                  ref.invalidate(totalSavedAmountProvider);
                  ref.invalidate(allCategoriesProvider);
                  ref.invalidate(activeExpenseCategoriesProvider);
                  ref.invalidate(activeIncomeCategoriesProvider);
                  ref.invalidate(baseIncomeStreamProvider);
                  ref.invalidate(allocationRulesStreamProvider);
                  ref.invalidate(safeAvailableProvider);
                  ref.invalidate(monthlySummaryProvider);
                  ref.invalidate(transactionsStreamProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.backupRestoreSuccess)),
                  );
                },
                onError: (f) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(f.toLocalizedMessage(l10n))),
                  );
                },
              );
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.backupTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Retention notice card
            Card(
              color: colors.primary.withValues(alpha: 0.08),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: colors.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.backupRetentionNotice,
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(color: colors.onSurface),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Create backup section
            Text(
              l10n.backupCreateNow,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AppButton(
              label: l10n.backupCreateNow,
              isLoading: _isCreating,
              icon: Icons.backup_rounded,
              onPressed: _handleCreateBackup,
            ),
            if (_lastCreatedPath != null) ...[
              const SizedBox(height: 8),
              Text(
                'Guardado: $_lastCreatedPath',
                style: TextStyle(fontSize: 12, color: colors.onSurfaceMuted),
              ),
              if (_lastCreatedJson != null) ...[
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(text: _lastCreatedJson!),
                    );
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'JSON copiado al portapapeles. Pégalo en tus Notas o en WhatsApp.',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  label: const Text('Copiar JSON al portapapeles'),
                ),
              ],
            ],
            if (_savedBackups.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                'Copias guardadas en este dispositivo',
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._savedBackups.take(5).map((file) {
                final name = file.path.split(Platform.pathSeparator).last;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    dense: true,
                    leading: Icon(
                      Icons.description_outlined,
                      color: colors.primary,
                    ),
                    title: Text(name, style: const TextStyle(fontSize: 13)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Copiar JSON',
                          icon: const Icon(Icons.copy_rounded, size: 18),
                          onPressed: () async {
                            final content = await file.readAsString();
                            await Clipboard.setData(
                              ClipboardData(text: content),
                            );
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'JSON de $name copiado al portapapeles',
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          tooltip: 'Cargar para restaurar',
                          icon: Icon(
                            Icons.restore_rounded,
                            size: 20,
                            color: colors.primary,
                          ),
                          onPressed: () async {
                            final content = await file.readAsString();
                            setState(() {
                              _restoreJsonController.text = content;
                            });
                            await _handleRestorePreview();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
            const SizedBox(height: 28),

            // Restore section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.backupRestoreFromFile,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () async {
                    final data = await Clipboard.getData(Clipboard.kTextPlain);
                    if (data?.text != null && data!.text!.trim().isNotEmpty) {
                      setState(() {
                        _restoreJsonController.text = data.text!.trim();
                      });
                    }
                  },
                  icon: const Icon(Icons.content_paste_rounded, size: 18),
                  label: const Text('Pegar'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _restoreJsonController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText:
                    'Pega el contenido JSON del archivo de respaldo aquí...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppButton(
              label: l10n.backupRestoreFromFile,
              isLoading: _isRestoring,
              isSecondary: true,
              icon: Icons.restore_rounded,
              onPressed: _handleRestorePreview,
            ),
          ],
        ),
      ),
    );
  }
}
