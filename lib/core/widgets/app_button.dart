import 'package:flutter/material.dart';

import '../../app/theme/finance_colors.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool isSecondary;
  final Color? backgroundColor;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isSecondary = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (isSecondary) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: BorderSide(color: colors.outline),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(colors.primary),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: colors.primary),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      );
    }

    final effectiveBg = backgroundColor ?? colors.primary;

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        backgroundColor: effectiveBg,
        foregroundColor: colors.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(colors.onPrimary),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20, color: colors.onPrimary),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }
}
