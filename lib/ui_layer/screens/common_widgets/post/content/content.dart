import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PostContentView extends StatelessWidget {
  const PostContentView({super.key, required this.content, required this.textStyle});
  final String? content;
  final TextStyle textStyle;
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return _WebText(
        content: content ?? '',
        style: textStyle
      );
    }
    return Text(
      content ?? '',
      style: textStyle
    );
  }
}

class _WebText extends StatefulWidget {
  const _WebText({required this.content, required this.style});
  final String content;
  final TextStyle style;
  @override
  State<_WebText> createState() => _WebTextState();
}

class _WebTextState extends State<_WebText> {
  late TextPainter textPainter;

  @override
  Widget build(BuildContext context) {
    return img ??
        LayoutBuilder(builder: (context, c) {
          if (!_isCreated) {
            _isCreated = true;
            textPainter = TextPainter(
              text: TextSpan(
                text: widget.content,
                style: widget.style,
              ),
              textDirection: TextDirection.ltr,
            )..layout(minWidth: c.maxWidth, maxWidth: c.maxWidth);

            final recorder = PictureRecorder();
            final canvas = Canvas(recorder);
            canvas.drawColor(Colors.transparent, BlendMode.srcOver);
            textPainter.paint(canvas, Offset.zero);

            getCanvasImage(recorder.endRecording());

            return SizedBox(
              width: textPainter.width,
              height: textPainter.height,
            );
          }

          return SizedBox(
            width: textPainter.width,
            height: textPainter.height,
          );
        });
  }

  Widget? img;
  bool _isCreated = false;

  void getCanvasImage(Picture picture) async {
    final res = await picture.toImage(
        textPainter.width.toInt(), textPainter.height.toInt());
    final data = await res.toByteData(format: ImageByteFormat.png);
    if (data != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          img = Image.memory(
            Uint8List.view(data.buffer),
            width: textPainter.width,
            height: textPainter.height,
          );
        });
      });
    }
  }
}
