import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    this.color = AppColors.textPrimary,
    this.fontSize = 16,
    this.showTagline = true,
  });

  final Color color;
  final double fontSize;
  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _LogoMark(color: color, size: fontSize + 12),
        const SizedBox(width: 8),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                style: TextStyle(
                  color: color,
                  fontSize: fontSize,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                ),
                children: const [
                  TextSpan(text: 'TOKIO '),
                  TextSpan(
                    text: 'MARINE',
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            if (showTagline)
              Text(
                'SEGURADORA',
                style: TextStyle(
                  color: color.withValues(alpha: 0.8),
                  fontSize: fontSize * 0.5,
                  letterSpacing: 3,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _LogoMarkPainter(color)),
    );
  }
}

class _LogoMarkPainter extends CustomPainter {
  _LogoMarkPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1.5;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.09
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, paint);

    final path = Path()
      ..moveTo(center.dx - radius * 0.55, center.dy + radius * 0.1)
      ..cubicTo(
        center.dx - radius * 0.2,
        center.dy - radius * 0.75,
        center.dx + radius * 0.2,
        center.dy + radius * 0.75,
        center.dx + radius * 0.55,
        center.dy - radius * 0.1,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_LogoMarkPainter oldDelegate) => oldDelegate.color != color;
}
