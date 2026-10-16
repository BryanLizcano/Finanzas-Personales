import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/finance_colors.dart';
import '../money/currency.dart';
import '../money/money.dart';

class ChartSegment {
  final String label;
  final int amount;
  final double percentage; // 0.0 to 100.0
  final Color color;

  const ChartSegment({
    required this.label,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}

class DonutChartPainter extends CustomPainter {
  final List<ChartSegment> segments;
  final double progress; // 0.0 to 1.0
  final double strokeWidth;
  final Color emptyColor;

  DonutChartPainter({
    required this.segments,
    required this.progress,
    required this.strokeWidth,
    required this.emptyColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    if (segments.isEmpty) {
      final paint = Paint()
        ..color = emptyColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      canvas.drawCircle(center, radius, paint);
      return;
    }

    var startAngle = -math.pi / 2;
    for (final segment in segments) {
      final sweepAngle =
          (segment.percentage / 100.0) * (2 * math.pi) * progress;
      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + 0.04,
        math.max(0.01, sweepAngle - 0.08),
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant DonutChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.segments != segments ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class DonutChartWidget extends StatelessWidget {
  final List<ChartSegment> segments;
  final Money totalAmount;
  final String totalLabel;
  final double size;

  const DonutChartWidget({
    super.key,
    required this.segments,
    required this.totalAmount,
    required this.totalLabel,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context).languageCode;
    final disableAnimations =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    return Column(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (disableAnimations)
                CustomPaint(
                  size: Size(size, size),
                  painter: DonutChartPainter(
                    segments: segments,
                    progress: 1.0,
                    strokeWidth: 20,
                    emptyColor: colors.surfaceVariant,
                  ),
                )
              else
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) {
                    return CustomPaint(
                      size: Size(size, size),
                      painter: DonutChartPainter(
                        segments: segments,
                        progress: value,
                        strokeWidth: 20,
                        emptyColor: colors.surfaceVariant,
                      ),
                    );
                  },
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    totalLabel,
                    style: Theme.of(context).textTheme.labelSmall
                        ?.copyWith(color: colors.onSurfaceMuted),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    totalAmount.format(locale),
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: segments.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final seg = segments[index];
            final segMoney = Money(
              units: seg.amount,
              currency: totalAmount.currency,
            );
            return Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: seg.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    seg.label,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${seg.percentage.toStringAsFixed(1)}% (${segMoney.format(locale)})',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.onSurfaceMuted,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class BarChartItem {
  final String label;
  final int income;
  final int expense;

  const BarChartItem({
    required this.label,
    required this.income,
    required this.expense,
  });
}

class MonthlyBarChartWidget extends StatelessWidget {
  final List<BarChartItem> items;
  final Currency currency;

  const MonthlyBarChartWidget({
    super.key,
    required this.items,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final disableAnimations =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    var maxVal = 0;
    for (final item in items) {
      if (item.income > maxVal) maxVal = item.income;
      if (item.expense > maxVal) maxVal = item.expense;
    }
    if (maxVal == 0) maxVal = 1;

    return AspectRatio(
      aspectRatio: 1.6,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _legendItem(colors.income, 'Ingresos', context),
                  const SizedBox(width: 16),
                  _legendItem(colors.expense, 'Gastos', context),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: items.map((item) {
                    final incomeRatio = (item.income / maxVal).clamp(0.0, 1.0);
                    final expenseRatio = (item.expense / maxVal).clamp(
                      0.0,
                      1.0,
                    );

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: _animatedBar(
                                      incomeRatio,
                                      colors.income,
                                      disableAnimations,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Expanded(
                                    child: _animatedBar(
                                      expenseRatio,
                                      colors.expense,
                                      disableAnimations,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.label,
                              style: Theme.of(context).textTheme.labelSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String text, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(text, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }

  Widget _animatedBar(double ratio, Color color, bool disableAnimations) {
    if (disableAnimations) {
      return FractionallySizedBox(
        heightFactor: math.max(0.02, ratio),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
      );
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: math.max(0.02, ratio)),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return FractionallySizedBox(
          heightFactor: value,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
          ),
        );
      },
    );
  }
}
