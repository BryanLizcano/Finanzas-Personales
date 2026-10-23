import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/finance_colors.dart';
import '../money/currency.dart';

class NumericKeypad extends StatelessWidget {
  final Currency currency;
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onClear;

  const NumericKeypad({
    super.key,
    required this.currency,
    required this.onDigit,
    required this.onBackspace,
    required this.onClear,
  });

  Widget _buildKey(BuildContext context, String text, {VoidCallback? onTap}) {
    final colors = context.colors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          if (onTap != null) {
            onTap();
          } else {
            onDigit(text);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionKey(
    BuildContext context,
    IconData icon,
    VoidCallback onTap, {
    VoidCallback? onLongPress,
  }) {
    final colors = context.colors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        onLongPress: () {
          HapticFeedback.mediumImpact();
          if (onLongPress != null) onLongPress();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: colors.onSurface, size: 24),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasDecimals = currency.decimals > 0;
    final rows = <List<Widget>>[
      [
        _buildKey(context, '1'),
        _buildKey(context, '2'),
        _buildKey(context, '3'),
      ],
      [
        _buildKey(context, '4'),
        _buildKey(context, '5'),
        _buildKey(context, '6'),
      ],
      [
        _buildKey(context, '7'),
        _buildKey(context, '8'),
        _buildKey(context, '9'),
      ],
      [
        hasDecimals ? _buildKey(context, '.') : _buildKey(context, '00'),
        _buildKey(context, '0'),
        _buildActionKey(
          context,
          Icons.backspace_outlined,
          onBackspace,
          onLongPress: onClear,
        ),
      ],
    ];

    return SizedBox(
      height: 240,
      child: Column(
        children: [
          for (int r = 0; r < rows.length; r++) ...[
            if (r > 0) const SizedBox(height: 8),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (int c = 0; c < rows[r].length; c++) ...[
                    if (c > 0) const SizedBox(width: 8),
                    Expanded(child: rows[r][c]),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
