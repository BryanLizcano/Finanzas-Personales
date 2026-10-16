import 'package:flutter/material.dart';

import '../../app/theme/finance_colors.dart';
import '../../l10n/generated/app_localizations.dart';
import '../errors/failure.dart';
import '../errors/failure_message.dart';

class ErrorStateWidget extends StatelessWidget {
  final Failure? failure;
  final String? customMessage;
  final VoidCallback? onRetry;

  const ErrorStateWidget({
    super.key,
    this.failure,
    this.customMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);

    final message =
        customMessage ??
        (failure != null
            ? failure!.toLocalizedMessage(l10n)
            : l10n.emptyStateMessage);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.expense.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: colors.expense,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: colors.onSurface),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(l10n.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
