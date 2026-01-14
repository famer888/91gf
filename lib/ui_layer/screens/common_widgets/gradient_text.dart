import 'package:flutter/foundation.dart' show kIsWeb;
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


  Color _sampleGradientColor(double t) {
    final colors = gradient.colors;
    if (colors.length == 1) return colors.first;
    final stops = gradient.stops ?? List.generate(colors.length, (i) => i / (colors.length - 1));

    for (int i = 0; i < stops.length - 1; i++) {
      if (t >= stops[i] && t <= stops[i + 1]) {
        final localT = (t - stops[i]) / (stops[i + 1] - stops[i]);
        return Color.lerp(colors[i], colors[i + 1], localT)!;
      }
    }
    return colors.last;
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // Web下使用颜色中间值
      final color = _sampleGradientColor(0.5);
      return Text(text, maxLines: maxLines, textAlign: textAlign, style: style?.copyWith(color: color));
    }
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(text, maxLines: maxLines, textAlign: textAlign, style: style?.copyWith(color: Colors.white)),
    );
  }
}
