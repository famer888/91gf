import 'package:flutter/material.dart';

class GradientBorderButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double borderWidth;
  final BorderRadius borderRadius;
  final VoidCallback? onPressed;

  GradientBorderButton({
    required this.child,
    this.gradient = const LinearGradient(
      colors: [Colors.blue, Colors.purple],
    ),
    this.borderWidth = 2.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: borderRadius,
        ),
        child: Padding(
          padding: EdgeInsets.all(borderWidth),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(
                borderRadius.topLeft.x - borderWidth,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}