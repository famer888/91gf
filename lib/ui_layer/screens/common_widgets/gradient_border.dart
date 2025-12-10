import 'package:flutter/material.dart';

class GradientBorder extends StatelessWidget {
  final Widget child;
  final double strokeWidth;
  final Gradient gradient;
  final double padding;
  final BorderRadius borderRadius;

  const GradientBorder({
    super.key,
    required this.child,
    this.strokeWidth = 2.0,
    this.padding = 0.0,
    required this.gradient,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GradientBorderPainter(
        strokeWidth: strokeWidth,
        gradient: gradient,
        borderRadius: borderRadius,
      ),
      child: Padding(padding: EdgeInsets.all(padding), child: child),
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  final double strokeWidth;
  final Gradient gradient;
  final BorderRadius borderRadius;

  _GradientBorderPainter({
    required this.strokeWidth,
    required this.gradient,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rRect = borderRadius.toRRect(rect);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = gradient.createShader(rect);

    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
