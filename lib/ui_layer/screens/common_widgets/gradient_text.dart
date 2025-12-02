import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String text;
  final int maxLines;
  final TextAlign textAlign;
  final TextStyle? style;
  final Gradient gradient;

  const GradientText(
    this.text, {
    super.key,
    this.style,
    this.maxLines = 1,
    this.textAlign = TextAlign.left,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(text, maxLines: maxLines, textAlign: textAlign, style: style?.copyWith(color: Colors.white)),
    );
  }
}
