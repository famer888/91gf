import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


enum _Type {
  highEmphasis,
  lowEmphasis,
  gradient,
}

class MyButton extends StatefulWidget {
  const MyButton.highEmphasis({
    super.key,
    this.minimumSize,
    this.onPressed,
    this.padding,
    this.child,
    this.text,
    this.color,
    this.borderRadius,
  })  : _type = _Type.highEmphasis,
        gradient = null;

  const MyButton.lowEmphasis({
    super.key,
    this.minimumSize,
    this.onPressed,
    this.padding,
    this.child,
    this.text,
    this.color,
    this.borderRadius,
  })  : _type = _Type.lowEmphasis,
        gradient = null;

  const MyButton.gradient({
    super.key,
    this.minimumSize,
    this.onPressed,
    this.padding,
    this.child,
    this.text,
    this.gradient,
    this.borderRadius,
  })  : _type = _Type.gradient,
        color = null;

  final Size? minimumSize;
  final Widget? child;
  final String? text;
  final AsyncCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final Gradient? gradient;
  final Color? color;
  final double? borderRadius;

  final _Type _type;
  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool _isLoading = false;

  @override
  void didUpdateWidget(covariant MyButton oldWidget) {
    if (oldWidget.onPressed != widget.onPressed) {
      _isLoading = false;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final minimumSize = widget.minimumSize;
    final padding = widget.padding;

    late final Widget child;

    if (_isLoading) {
      child = const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: Colors.white,
        ),
      );
    } else if (widget.child != null) {
      child = widget.child!;
    } else if (widget.text != null) {
      child = Text(
        widget.text!,
        textAlign: TextAlign.center,
        style: MyTheme.white255_15_semibold,
      );
    } else {
      child = const SizedBox.shrink();
    }

    final onPressed = widget.onPressed == null
        ? null
        : () async {
            if (_isLoading) return;
            setState(() {
              _isLoading = true;
            });
            await widget.onPressed?.call();
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          };

    return switch (widget._type) {
      _Type.highEmphasis => FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: widget.color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? (minimumSize?.height ?? 8.w) / 2),
            ),
            minimumSize: minimumSize,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: padding,
          ),
          onPressed: onPressed,
          child: child,
        ),
      _Type.gradient => ReportGestureDetector(
          onTap: onPressed,
          child: Container(
            padding: padding,
            alignment: padding == null ? Alignment.center : null,
            constraints: BoxConstraints(
              minWidth: minimumSize?.width ?? 0,
              minHeight: minimumSize?.height ?? 0,
            ),
            decoration: BoxDecoration(
              gradient: widget.gradient ?? MyTheme.gradient_90_114,
              borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? (minimumSize?.height ?? 8.w) / 2),
            ),
            child: child,
          ),
        ),
      // TODO: Handle this case.
      _Type.lowEmphasis => OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color(0x19ECAE37),
            side: const BorderSide(width: 1.0, color: Color(0x99ECAE37)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? (minimumSize?.height ?? 8.w) / 2),
            ),
            minimumSize: minimumSize,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: padding,
          ),
          onPressed: onPressed,
          child: child,
        ),
    };
  }
}
