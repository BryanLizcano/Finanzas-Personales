import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/finance_colors.dart';

/// Minimalist 2x2 Quick Actions Widget with formal, visually relaxing tones:
/// - Top-left (Warm Ochre): Entrada rápida
/// - Top-right (Calm Steel Blue): Nueva transferencia
/// - Bottom-left (Sage Eucalyptus): Ingresos nuevos (Entrada)
/// - Bottom-right (Muted Terracotta): Nuevo gasto (Salida)
class QuickActionsWidget extends StatelessWidget {
  final VoidCallback onQuickEntry;
  final VoidCallback onNewTransfer;
  final VoidCallback onNewIncome;
  final VoidCallback onNewExpense;

  const QuickActionsWidget({
    super.key,
    required this.onQuickEntry,
    required this.onNewTransfer,
    required this.onNewIncome,
    required this.onNewExpense,
  });

  static const Color yellowCard = Color(0xFFC9933B);
  static const Color blueCard = Color(0xFF4A7C9B);
  static const Color mintCard = Color(0xFF3B8266);
  static const Color coralCard = Color(0xFFBC5454);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? colors.surface : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colors.outline.withValues(alpha: isDark ? 0.3 : 0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: _QuickActionTile(
                  label: 'Entrada rápida',
                  backgroundColor: yellowCard,
                  iconWidget: const _ZigZagIcon(color: yellowCard),
                  onTap: onQuickEntry,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _QuickActionTile(
                  label: 'Nueva transferencia',
                  backgroundColor: blueCard,
                  iconWidget: const Icon(
                    Icons.swap_horiz_rounded,
                    color: blueCard,
                    size: 20,
                  ),
                  onTap: onNewTransfer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _QuickActionTile(
                  label: 'Ingresos nuevos',
                  backgroundColor: mintCard,
                  iconWidget: const Icon(
                    Icons.add_rounded,
                    color: mintCard,
                    size: 22,
                  ),
                  onTap: onNewIncome,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _QuickActionTile(
                  label: 'Nuevo gasto',
                  backgroundColor: coralCard,
                  iconWidget: const Icon(
                    Icons.remove_rounded,
                    color: coralCard,
                    size: 22,
                  ),
                  onTap: onNewExpense,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Widget iconWidget;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.label,
    required this.backgroundColor,
    required this.iconWidget,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(18),
        splashColor: Colors.white.withValues(alpha: 0.18),
        highlightColor: Colors.white.withValues(alpha: 0.08),
        child: Container(
          height: 86,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: iconWidget,
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ZigZagIcon extends StatelessWidget {
  final Color color;

  const _ZigZagIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(16, 16),
      painter: _ZigZagPainter(color),
    );
  }
}

class _ZigZagPainter extends CustomPainter {
  final Color color;

  const _ZigZagPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(size.width * 0.12, size.height * 0.68)
      ..lineTo(size.width * 0.40, size.height * 0.35)
      ..lineTo(size.width * 0.62, size.height * 0.60)
      ..lineTo(size.width * 0.88, size.height * 0.28);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ZigZagPainter oldDelegate) =>
      oldDelegate.color != color;
}
