import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../app/theme/finance_colors.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_progress_bar.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../providers/updates_providers.dart';

class UpdatesPage extends ConsumerStatefulWidget {
  const UpdatesPage({super.key});

  @override
  ConsumerState<UpdatesPage> createState() => _UpdatesPageState();
}

class _UpdatesPageState extends ConsumerState<UpdatesPage> {
  bool _isChecking = false;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String? _statusMessage;

  Future<void> _handleCheck() async {
    setState(() {
      _isChecking = true;
      _statusMessage = null;
    });

    ref.invalidate(latestUpdateInfoProvider);
    await ref.read(latestUpdateInfoProvider.future);

    if (mounted) setState(() => _isChecking = false);
  }

  Future<void> _handleDownload(
    String downloadUrl,
    String expectedSha256,
  ) async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
      _statusMessage = l10n.updatesDownloading(0);
    });

    try {
      final appDir = await getTemporaryDirectory();
      final targetPath = '${appDir.path}/update.apk';

      final downloadUseCase = ref.read(downloadAndVerifyUpdateUseCaseProvider);
      final res = await downloadUseCase(
        downloadUrl: downloadUrl,
        expectedSha256: expectedSha256,
        destinationFilePath: targetPath,
        onProgress: (p) {
          if (mounted) {
            setState(() {
              _downloadProgress = p;
              _statusMessage = l10n.updatesDownloading((p * 100).round());
            });
          }
        },
      );

      res.fold(
        onOk: (path) {
          setState(() => _statusMessage = l10n.updatesInstallReady);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l10n.updatesInstallReady)));
        },
        onError: (f) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(f.toLocalizedMessage(l10n))));
        },
      );
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final updateAsync = ref.watch(latestUpdateInfoProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.updatesTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.system_update_rounded,
                    color: colors.primary,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Finanzas Personales v${updateAsync.value?.currentVersion ?? '1.1.0'}',
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.settingsOfflineNotice,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: colors.onSurfaceMuted),
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    label: l10n.updatesCheckNow,
                    isLoading: _isChecking,
                    icon: Icons.refresh_rounded,
                    onPressed: _handleCheck,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            updateAsync.when(
              data: (info) {
                if (info.hasUpdate) {
                  return Card(
                    color: colors.primary.withValues(alpha: 0.08),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.new_releases_rounded,
                                color: colors.primary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  l10n.updatesAvailable(info.latestVersion),
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: colors.primary,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.updatesReleaseNotes,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            info.releaseNotes.isEmpty
                                ? 'Mejoras y correcciones'
                                : info.releaseNotes,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          if (_isDownloading) ...[
                            AppProgressBar(progress: _downloadProgress),
                            const SizedBox(height: 8),
                            Text(
                              _statusMessage ?? '',
                              style: TextStyle(
                                color: colors.onSurfaceMuted,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                          AppButton(
                            label: l10n.updatesDownloadAndInstall,
                            isLoading: _isDownloading,
                            icon: Icons.download_rounded,
                            onPressed: () => _handleDownload(
                              info.apkDownloadUrl,
                              info.sha256Expected ?? '',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: colors.income,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.updatesUpToDate,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const SkeletonCard(height: 100),
              error: (err, _) => ErrorStateWidget(
                customMessage: 'No fue posible contactar GitHub Releases.',
                onRetry: _handleCheck,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
