import 'package:flutter/material.dart';

import '../../app/theme/finance_colors.dart';

class EmptyStatePainter extends CustomPainter {
  final Color primaryColor;
  final Color outlineColor;

  EmptyStatePainter({required this.primaryColor, required this.outlineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final bgPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.42, bgPaint);

    final boxPaint = Paint()
      ..color = outlineColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final boxRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center.translate(0, 8),
        width: size.width * 0.48,
        height: size.height * 0.36,
      ),
      const Radius.circular(12),
    );
    canvas.drawRRect(boxRect, boxPaint);

    final lidPath = Path()
      ..moveTo(center.dx - size.width * 0.28, center.dy - 6)
      ..lineTo(center.dx, center.dy - 18)
      ..lineTo(center.dx + size.width * 0.28, center.dy - 6);
    canvas.drawPath(lidPath, boxPaint);

    final coinPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center.translate(0, -18), size.width * 0.10, coinPaint);

    final coinInner = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center.translate(0, -18), size.width * 0.05, coinInner);
  }

  @override
  bool shouldRepaint(covariant EmptyStatePainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.outlineColor != outlineColor;
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(
              size: const Size(120, 120),
              painter: EmptyStatePainter(
                primaryColor: colors.primary,
                outlineColor: colors.outline,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: colors.onSurfaceMuted),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
