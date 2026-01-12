import 'package:flutter/material.dart';

/// 渐变边框
class GradientBorder extends StatelessWidget {
  final Widget child;
  final double radius;
  final double borderWidth;
  final LinearGradient? gradient;

  const GradientBorder({
    super.key,
    required this.child,
    this.radius = 8,
    this.borderWidth = 1,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          fit: StackFit.passthrough,
          children: [
            // 渐变边框
            Positioned.fill(
              child: ShaderMask(
                shaderCallback: (rect) {
                  if (gradient != null) {
                    return gradient!.createShader(rect);
                  }

                  return const LinearGradient(
                    colors: [
                      Color(0xFF9A3085),
                      Color(0xFF6A3FA0),
                      Color(0xFF3A5FD0),
                    ],
                  ).createShader(rect);
                },
                blendMode: BlendMode.srcIn,
                child: CustomPaint(
                  painter: _BorderPainter(radius, borderWidth),
                ),
              ),
            ),

            // 内容层（真正透明）
            Padding(
              padding: EdgeInsets.all(borderWidth),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius - borderWidth),
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BorderPainter extends CustomPainter {
  final double radius;
  final double stroke;

  _BorderPainter(this.radius, this.stroke);

  @override
  void paint(Canvas canvas, Size size) {
    final outer = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );

    final inner = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        stroke,
        stroke,
        size.width - stroke * 2,
        size.height - stroke * 2,
      ),
      Radius.circular(radius - stroke),
    );

    final path = Path()
      ..addRRect(outer)
      ..addRRect(inner)
      ..fillType = PathFillType.evenOdd; // 关键：中间挖空

    final paint = Paint()..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
