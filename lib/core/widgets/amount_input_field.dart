import 'package:flutter/material.dart';

import '../../app/theme/finance_colors.dart';
import '../money/currency.dart';

class AmountInputField extends StatelessWidget {
  final String rawInput;
  final Currency currency;
  final Color? color;
  final VoidCallback? onTap;

  const AmountInputField({
    super.key,
    required this.rawInput,
    required this.currency,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final effectiveColor = color ?? colors.primary;

    final displayText = rawInput.isEmpty ? '0' : rawInput;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                currency == Currency.eur ? '€ ' : '\$ ',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: colors.onSurfaceMuted,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                displayText,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: effectiveColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
