import 'package:flutter/material.dart';

class ColoredNumberText extends StatelessWidget {
  final String text;
  final TextStyle? normalTextStyle;
  final TextStyle? colorTextStyle;

  const ColoredNumberText(this.text, {super.key, this.normalTextStyle, this.colorTextStyle});

  @override
  Widget build(BuildContext context) {
    final numberRegex = RegExp(r'\d+'); // 匹配所有数字
    final spans = <TextSpan>[];

    // 遍历整个字符串，将数字与文字分开
    text.splitMapJoin(
      numberRegex,
      onMatch: (m) {
        spans.add(TextSpan(text: m.group(0), style: colorTextStyle ?? const TextStyle(color: Colors.blue, fontSize: 14)));
        return '';
      },
      onNonMatch: (nonMatch) {
        spans.add(TextSpan(text: nonMatch, style: normalTextStyle ?? const TextStyle(color: Colors.white, fontSize: 14)));
        return '';
      },
    );

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}
