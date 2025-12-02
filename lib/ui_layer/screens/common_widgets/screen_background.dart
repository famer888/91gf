import 'package:flutter/material.dart';
import '../image_paths.dart';
import 'my_image.dart';

class ScreenBackground extends StatelessWidget {
  const ScreenBackground({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const MyImage.asset(
            MyImagePaths.appBg,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Theme(
            data: Theme.of(context).copyWith(
              scaffoldBackgroundColor: Colors.transparent,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
