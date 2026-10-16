import 'package:flutter/material.dart';

import '../../app/theme/finance_colors.dart';
import '../money/money.dart';
import 'animated_count.dart';

class BalanceCard extends StatelessWidget {
  final String title;
  final Money money;
  final IconData? icon;
  final Color? accentColor;
  final String? subtitle;
  final VoidCallback? onTap;

  const BalanceCard({
    super.key,
    required this.title,
    required this.money,
    this.icon,
    this.accentColor,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final effectiveAccent = accentColor ?? colors.primary;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceMuted,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (icon != null)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: effectiveAccent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, size: 18, color: effectiveAccent),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              AnimatedMoneyText(
                money: money,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: effectiveAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: colors.onSurfaceMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
