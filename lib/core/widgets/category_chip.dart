import 'package:flutter/material.dart';

import '../../app/theme/finance_colors.dart';
import 'icon_helper.dart';

class CategoryChip extends StatelessWidget {
  final String title;
  final String icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final iconData = getIconData(icon);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.18) : colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : colors.outline.withValues(alpha: 0.4),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? color : color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: isSelected ? colors.onPrimary : color,
                size: 20,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: colors.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
