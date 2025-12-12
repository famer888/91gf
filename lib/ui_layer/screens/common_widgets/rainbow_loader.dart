import 'package:flutter/material.dart';


class AdvancedRainbowLoader extends StatefulWidget {
  final double width;
  final double height;

  const AdvancedRainbowLoader({
    super.key,
    this.width = 300,
    this.height = 6,
  });

  @override
  State<AdvancedRainbowLoader> createState() => _AdvancedRainbowLoaderState();
}

class _AdvancedRainbowLoaderState extends State<AdvancedRainbowLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<Color> _rainbowColors = const [
    Color(0xFFFFAD33), 
    Color(0xFFFF00CC), 
    Color(0xFFBB00FF), 
    Color(0xFF0066FF), 
    Color(0xFF00FFFF), 
    Color(0xFF66FF00), 
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getGradientColor(double t) {
    if (t <= 0) return _rainbowColors.first;
    if (t >= 1) return _rainbowColors.last;

    int segmentCount = _rainbowColors.length - 1;
    double segmentLength = 1.0 / segmentCount;

    int index = (t / segmentLength).floor();
    
    double localT = (t - (index * segmentLength)) / segmentLength;

    return Color.lerp(
      _rainbowColors[index], 
      _rainbowColors[index + 1], 
      localT
    )!;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height * 6, 
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.height),
              gradient: LinearGradient(
                colors: _rainbowColors,
              ),
            ),
          ),

          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final Color currentColor = _getGradientColor(_controller.value);
              
              return Positioned(
                left: _controller.value * widget.width - (widget.width * 0.05),
                child: Container(
                  width: widget.width * 0.1, 
                  height: widget.height,     
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.height),
                  color: currentColor, 
                  boxShadow: [
                    BoxShadow(
                      color: currentColor.withOpacity(0.6), 
                      blurRadius: 25, 
                      spreadRadius: 10, 
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.9),
                      blurRadius: 10,
                      spreadRadius: -2, 
                    ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
      ),
    );
  }
}
