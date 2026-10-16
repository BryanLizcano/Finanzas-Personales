import 'package:flutter/material.dart';

import '../money/money.dart';

class AnimatedMoneyText extends StatelessWidget {
  final Money money;
  final TextStyle? style;
  final String? locale;

  const AnimatedMoneyText({
    super.key,
    required this.money,
    this.style,
    this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (disableAnimations) {
      return Text(money.format(locale), style: style);
    }

    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: money.units),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final currentMoney = Money(units: value, currency: money.currency);
        return Text(currentMoney.format(locale), style: style);
      },
    );
  }
}
