import 'package:flutter/material.dart';

import '../../app/theme/finance_colors.dart';

class AppProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final Color? color;
  final double height;

  const AppProgressBar({
    super.key,
    required this.progress,
    this.color,
    this.height = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final effectiveColor = color ?? colors.primary;
    final clampedProgress = progress.clamp(0.0, 1.0);
    final disableAnimations =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: Container(
        height: height,
        width: double.infinity,
        color: colors.surfaceVariant,
        alignment: Alignment.centerLeft,
        child: disableAnimations
            ? FractionallySizedBox(
                widthFactor: clampedProgress,
                child: Container(color: effectiveColor),
              )
            : TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: clampedProgress),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) {
                  return FractionallySizedBox(
                    widthFactor: value,
                    child: Container(color: effectiveColor),
                  );
                },
              ),
      ),
    );
  }
}

class AppCircularProgress extends StatelessWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final Color? color;
  final Widget? centerChild;

  const AppCircularProgress({
    super.key,
    required this.progress,
    this.size = 90.0,
    this.strokeWidth = 8.0,
    this.color,
    this.centerChild,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final effectiveColor = color ?? colors.savings;
    final clampedProgress = progress.clamp(0.0, 1.0);
    final disableAnimations =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation(colors.surfaceVariant),
          ),
          if (disableAnimations)
            CircularProgressIndicator(
              value: clampedProgress,
              strokeWidth: strokeWidth,
              strokeCap: StrokeCap.round,
              valueColor: AlwaysStoppedAnimation(effectiveColor),
            )
          else
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: clampedProgress),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return CircularProgressIndicator(
                  value: value,
                  strokeWidth: strokeWidth,
                  strokeCap: StrokeCap.round,
                  valueColor: AlwaysStoppedAnimation(effectiveColor),
                );
              },
            ),
          ?centerChild,
        ],
      ),
    );
  }
}
