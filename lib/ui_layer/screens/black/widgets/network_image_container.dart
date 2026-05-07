import 'dart:math';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/black/http/http_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';

final Uint8List kTransparentImage = Uint8List.fromList(<int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);

class NetworkImageContainer extends StatelessWidget {
  final BoxFit fit;
  final String url;
  final String? placeholder;
  final Image? placeholderImage;
  final Color? placeholderColor;

  final double height;
  final double width;

  final BorderRadius? borderRadius;
  final FilterQuality filterQuality;

  const NetworkImageContainer({
    super.key,
    this.fit = BoxFit.cover,
    required this.url,
    this.placeholder,
    required this.height,
    required this.width,
    this.borderRadius,
    this.placeholderImage,
    this.placeholderColor,
    this.filterQuality = FilterQuality.medium,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = NetworkImageWidget(
      fit: fit,
      url: url,
      placeholder: placeholder,
      placeholderImage: placeholderImage,
      placeholderColor: placeholderColor,
      filterQuality: filterQuality,
      width: width,
    );

    /// 大小
    child = SizedBox(width: width, height: height, child: child);

    /// 圆角
    if (borderRadius != null) {
      child = ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: child,
      );
    }
    return child;
  }
}

class NetworkImageWidget extends StatefulWidget {
  final BoxFit fit;
  final String url;
  final String? placeholder;
  final Image? placeholderImage;
  final Color? placeholderColor;
  final double? width;
  final bool isAnimated;
  final FilterQuality filterQuality;
  final bool isPlaceholder;
  final bool showloading;

  const NetworkImageWidget({
    super.key,
    this.fit = BoxFit.cover,
    required this.url,
    this.isPlaceholder = true,
    this.placeholder,
    this.placeholderImage,
    this.placeholderColor,
    this.width,
    this.isAnimated = true,
    this.filterQuality = FilterQuality.medium,
    this.showloading = false, // 加载状态
  });

  @override
  State createState() => _NetworkImageWidgetState();
}

class _NetworkImageWidgetState extends State<NetworkImageWidget>
    with SingleTickerProviderStateMixin {
  /// 动画
  late Animation<double> _animation;
  late AnimationController controller;

  /// 数据
  final GlobalKey _key = GlobalKey();
  late String url;
  Uint8List? bytes;

  bool isloaded = false; // 是否已加载过
  // isload 和 isfail 一起用
  bool isload = true;
  bool isfail = false;

  @override
  void initState() {
    super.initState();
    // 动画
    controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    Animation<double> curve = CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    );
    _animation = Tween(begin: .0, end: 1.0).animate(curve);

    // 数据
    url = clipImageUrl(widget.url, widget.width);

    if (kIsWeb) {
      // nothing to preload, will be loaded by Image.network in build
    } else {
      // 继续你当前的加载策略（如果你使用 HttpImage 拉字节）
      onloadImage();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    // LogUtil.i('--释放-- $_key ----> $url');
    HttpImage.instance.cancleImageTask(_key);
  }

  @override
  void didUpdateWidget(covariant NetworkImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.url != oldWidget.url) {
      url = clipImageUrl(widget.url, widget.width);
      onloadImage();
    }
  }

  void onloadImage() {
    LogUtil.d('$_key ----> $url');
    mounted ? setState(() => isload = true) : null;
    HttpImage.instance.addImageTask(
      key: _key,
      url: url,
      success: (data) {
        isload = false;
        mounted ? controller.forward(from: 0.0) : null;
        mounted
            ? setState(() {
                bytes = data;
              })
            : null;
      },
      failure: () {
        CommonUtils.log('图片加载解析失败11');
        isload = false;
        mounted ? setState(() => isfail = true) : null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // On web use Image.network directly — better CORS & browser handling
      return LayoutBuilder(builder: (context, constraints) {
        final w = widget.width ?? constraints.maxWidth;
        return SizedBox(
          width: w,
          height: widget.width != null ? (w * 9 / 16) : null,
          child: Image.network(
            url,
            fit: widget.fit,
            filterQuality: widget.filterQuality,
            loadingBuilder: (context, child, progress) {
              if (progress == null) {
                // fade in animation
                controller.forward(from: 0.0);
                return FadeTransition(opacity: _animation, child: child);
              }
              return widget.placeholderImage ??
                  const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stack) {
              // 打印 error 到控制台，便于调试 CORS / 403 等
              CommonUtils.log('Image load error: $error, url: $url');
              return widget.placeholderImage ??
                  Container(
                      color: widget.placeholderColor ?? Colors.grey[500],
                      child: Image.asset(
                        MyImagePaths.appFigureNNew,
                        width: 55.w,
                      ));
            },
          ),
        );
      });
    }
    // 非 web（移动端）保持原来的逻辑
    return _buildImageWidget;
  }

  Widget get _buildImageWidget {
    return LayoutBuilder(builder: (context, constraints) {
      Widget current = FadeInImage.memoryNetwork(
        image: url,
        fit: BoxFit.cover,
        fadeOutDuration: const Duration(milliseconds: 300),
        fadeInDuration: const Duration(milliseconds: 500),
        placeholder: kTransparentImage,
        imageErrorBuilder: (context, error, stackTrace) {
          return Container();
        },
      );

      // Widget current = Image.memory(
      //   bytes!,
      //   fit: widget.fit,
      //   filterQuality: widget.filterQuality,
      // );
      if (widget.isAnimated == false) return current;

      return FadeTransition(opacity: _animation, child: current);
    });
  }

  /////////////////////////placeholer////////////////////////////

  Widget get _buildPlaceholderWidget {
    if (widget.isPlaceholder == false) {
      return const SizedBox();
    }
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        _buildPlaceholderColorWidget,
        _buildPlaceholderImageWidget,
        _buildReloadImageClickWidget,
      ],
    );
  }

  /// placeholder color
  Widget get _buildPlaceholderColorWidget {
    return Container(color: widget.placeholderColor ?? MyTheme.white25504Color);
  }

  /// placeholder logo
  Widget get _buildPlaceholderImageWidget {
    if (widget.placeholderImage != null) return widget.placeholderImage!;
    return LayoutBuilder(builder: (ctx, constraints) {
      // LogUtil.dPrint('---> image placeholder $constraints');
      BoxConstraints bPlaceholder;
      if (constraints.maxHeight == 0 || constraints.maxWidth == 0) {
        bPlaceholder = BoxConstraints(
            maxHeight: min(constraints.maxHeight * 0.6, 105.w),
            maxWidth: min(constraints.maxWidth * 0.6, 107.w));
      } else {
        bPlaceholder =
            BoxConstraints(maxHeight: 107.w * 0.6, maxWidth: 105.w * 0.6);
      }
      return Container(
        constraints: bPlaceholder,
        child: Image.asset(
          widget.placeholder ?? MyImagePaths.appFigureNNew,
          width: 55.w,
        ),
      );
    });
  }

  /// reload image button
  Widget get _buildReloadImageClickWidget {
    if (widget.showloading == false) return const SizedBox();
    if (isload) return Image.asset(MyImagePaths.appLoading, width: 35);
    if (isfail == false) return const SizedBox();

    /// isfail => true
    Widget current = Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(color: Color(0x2C000000), blurRadius: 8.5),
      ], color: Colors.transparent),
      child: Image.asset(MyImagePaths.appReplyIcon, width: 35),
    );
    return ReportGestureDetector(onTap: () => onloadImage(), child: current);
  }

/////////////////////////////////////////////////////////////
}

clipImageUrl(String url, [double? inputWidth]) {
  if (kIsWeb) return url;
  if (inputWidth == null) return url;
  if (url.contains('!')) return url;
  if (url.isEmpty) return '';

  inputWidth = inputWidth * (ScreenUtil().pixelRatio ?? 1);
  int width = 120;
  if (inputWidth > 720) {
    return url;
  } else if (inputWidth > 360) {
    width = 720;
  } else if (inputWidth > 120) {
    width = 360;
  }
  var list = url.split('.');
  if (list.length < 2) {
    return url;
  }
  String t = '';
  for (var i = 0; i < list.length; i++) {
    t += list[i];

    if (i == list.length - 2) {
      t += '!${width}x0';
      t += '.';
      t += list.last;
      break;
    }
    t += '.';
  }
  return t;
}
