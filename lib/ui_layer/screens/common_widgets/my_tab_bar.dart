import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme.dart';
import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'my_image.dart';
import '../image_paths.dart';
import 'gradient_text.dart';

enum TabBarType {
  /// 下滑线
  line,

  /// 填充色
  fillColor,

  /// 选中时使用图片
  image,
}

enum IndicatorType {
  /// 渐变线条
  line,

  /// 使用 light 图片
  light,

  /// 使用 curve 图片
  curve,
}

class TabBarWithView extends StatefulWidget {
  TabBarWithView.line({
    super.key,
    required this.titles,
    required this.views,
    this.tabBarPadding,
    this.tabInterMargin = 10,
    this.tabBarHeight,
    this.isCenter = false,
    this.isScrollable = true,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.tabController,
    this.labelPadding = 8.0,
    this.initialIndex = 0,
    this.borderRadius,
    this.isStack = false,
    this.indexChangeCall,
    this.gradientColors,
    this.tabBarBottomWidget,
    this.indicatorType = IndicatorType.line,
  })  : type = TabBarType.line,
        selectedImgs = null,
        unselectedImgs = null,
        imageWidth = null,
        imageHeight = null,
        tabBarRightWidget = null;

  TabBarWithView.fillColor({
    super.key,
    required this.titles,
    required this.views,
    this.tabBarPadding,
    this.tabInterMargin = 10,
    this.tabBarHeight,
    this.isCenter = false,
    this.isScrollable = false,
    this.tabBarRightWidget,
    this.tabBarBottomWidget,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.tabController,
    this.borderRadius,
    this.labelPadding = 8.0,
    this.initialIndex = 0,
    this.isStack = false,
    this.indexChangeCall,
    this.gradientColors,
  })  : type = TabBarType.fillColor,
        selectedImgs = null,
        unselectedImgs = null,
        imageWidth = null,
        imageHeight = null,
        indicatorType = IndicatorType.line;

  TabBarWithView.image({
    super.key,
    required this.titles,
    required this.views,
    required this.selectedImgs,
    this.unselectedImgs,
    this.imageWidth,
    this.imageHeight,
    this.tabBarPadding,
    this.tabInterMargin = 10,
    this.tabBarHeight,
    this.isCenter = false,
    this.isScrollable = true,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.tabController,
    this.borderRadius,
    this.labelPadding = 8.0,
    this.initialIndex = 0,
    this.isStack = false,
    this.indexChangeCall,
    this.tabBarBottomWidget,
    this.gradientColors,
  })  : type = TabBarType.image,
        tabBarRightWidget = null,
        indicatorType = IndicatorType.line;

  final TabBarType type;
  final int initialIndex;

  final List<String> titles;
  final List<String>? selectedImgs;
  final List<String>? unselectedImgs;
  final double? imageWidth;
  final double? imageHeight;
  final List<Widget> views;
  final bool isCenter;

  final bool isScrollable;
  final EdgeInsetsGeometry? tabBarPadding;
  final double tabInterMargin;

  final double? tabBarHeight;
  final Widget? tabBarRightWidget;
  final Widget? tabBarBottomWidget;
  final TextStyle? labelStyle;
  final double? borderRadius;
  final TextStyle? unselectedLabelStyle;
  final TabController? tabController;

  final double labelPadding;
  final bool isStack; // 是colume上下分布 还是stack那样把标题重叠在上面
  final Function(int)? indexChangeCall;
  final IndicatorType indicatorType;
  final List<Color>? gradientColors;

  @override
  State<TabBarWithView> createState() => _TabBarWithViewState();
}

class _TabBarWithViewState extends State<TabBarWithView> with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      widget.tabController ?? TabController(length: widget.views.length, vsync: this, initialIndex: widget.initialIndex);

  late LinkPageController _pageController;
  bool _isImagePrecached = false;

  @override
  void initState() {
    super.initState();

    _pageController = LinkPageController(initialPage: widget.initialIndex);

    _tabController.addListener(_handleTabChange);
    _tabController.animation?.addListener(_handleTabAnimation);

    indexChangeNotifier = ValueNotifier(_tabController.index);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isImagePrecached) {
      _precacheIndicatorImages().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
      _isImagePrecached = true;
    }
  }

  Future<void> _precacheIndicatorImages() async {
    //  line 类型预加载
    if (widget.type == TabBarType.line) {
      if (widget.indicatorType == IndicatorType.light) {
        _doPrecache(MyImagePaths.appIndicatorLight);
      } else if (widget.indicatorType == IndicatorType.curve) {
        _doPrecache(MyImagePaths.appIndicatorCurve);
      }
    }

    // TabBarType.image 类型预加载
    if (widget.type == TabBarType.image && widget.selectedImgs != null) {
      for (var img in widget.selectedImgs!) {
        _doPrecache(img);
      }
    }
  }

  void _doPrecache(String path) {
    if (path.isEmpty) return;
    String processedPath = path;
    if (processedPath.startsWith('./')) {
      processedPath = processedPath.substring(2);
    }
    precacheImage(AssetImage(processedPath), context);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.animation?.removeListener(_handleTabAnimation);
    if (widget.tabController == null) {
      _tabController.dispose();
    }
    _pageController.dispose();
    indexChangeNotifier.dispose();
    super.dispose();
  }

  void _handleTabAnimation() {
    final double animationValue = _tabController.animation?.value ?? _tabController.index.toDouble();
    final double diff = (animationValue - _tabController.index).abs();
    if (_tabController.indexIsChanging || diff > 0.5) {
      if (indexChangeNotifier.value != _tabController.index) {
        indexChangeNotifier.value = _tabController.index;
      }
      return;
    }
    final int currentIndex = animationValue.round();
    if (indexChangeNotifier.value != currentIndex) {
      indexChangeNotifier.value = currentIndex;
    }
  }

  void _handleTabChange() {
    // Keep this for non-animated changes or final settlements
    if (indexChangeNotifier.value != _tabController.index) {
      indexChangeNotifier.value = _tabController.index;
    }
  }

  List<Widget> get tabs {
    if (widget.type == TabBarType.image) {
      return List.generate(widget.titles.length, (index) {
        final isSelected = indexChangeNotifier.value == index;
        if (isSelected) {
          return Tab(
            height: MyTheme.navbarHegiht,
            child: MyImage.asset(
              widget.selectedImgs?[index] ?? '',
              width: widget.imageWidth,
              height: widget.imageHeight,
              fit: BoxFit.contain,
            ),
          );
        }
        final unselectedImg = widget.unselectedImgs?[index];
        if (unselectedImg != null) {
          return Tab(
            height: MyTheme.navbarHegiht,
            child: MyImage.asset(
              unselectedImg,
              width: widget.imageWidth,
              height: widget.imageHeight,
              fit: BoxFit.contain,
            ),
          );
        }
        return Tab(
          height: MyTheme.navbarHegiht,
          child: Text(widget.titles[index]),
        );
      });
    }
    return List.generate(widget.titles.length, (index) {
      final title = widget.titles[index];
      final bool isSelected = indexChangeNotifier.value == index;

      return switch (widget.type) {
        TabBarType.fillColor => Tab(
            height: MyTheme.navbarHegiht,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.tabInterMargin.w),
              child: Text(
                title,
              ),
            ),
          ),
        _ => isSelected && widget.labelStyle == null
            ? Tab(
                height: MyTheme.navbarHegiht,
                child: GradientText(
                  title,
                  style: MyTheme.jellyCyan_17,
                  gradient: MyTheme.gradient_90_114,
                ),
              )
            : Tab(
                height: MyTheme.navbarHegiht,
                child: Text(
                  title,
                  style: isSelected ? (widget.labelStyle ?? MyTheme.jellyCyan_17) : (widget.unselectedLabelStyle ?? MyTheme.white08_15),
                ),
              ),
      };
    });
  }

  late final TabBarTheme tabBarTheme = switch (widget.type) {
    TabBarType.line => MyTabBarTheme.line(
        labelStyle: widget.labelStyle,
        unselectedLabelStyle: widget.unselectedLabelStyle,
        indicatorType: widget.indicatorType,
        gradientColors: widget.gradientColors,
      ),
    TabBarType.fillColor => MyTabBarTheme.fillColor(
        tabAlignment:
            widget.isScrollable ? (widget.isCenter ? TabAlignment.center : TabAlignment.start) : (widget.isCenter ? TabAlignment.center : null),
        labelStyle: widget.labelStyle,
        borderRadius: widget.borderRadius,
        unselectedLabelStyle: widget.unselectedLabelStyle,
      ),
    TabBarType.image => MyTabBarTheme.line(
        labelStyle: widget.labelStyle,
        unselectedLabelStyle: widget.unselectedLabelStyle,
        gradientColors: widget.gradientColors,
      ).copyWith(indicator: const BoxDecoration(color: Colors.transparent)),
  };

  late final ValueNotifier<int> indexChangeNotifier;

  @override
  Widget build(BuildContext context) {
    return widget.isStack
        ? Stack(
            children: [
              configExtendedTabBarView(),
              configTabView(),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              configTabView(),
              Expanded(
                child: configExtendedTabBarView(),
              ),
            ],
          );
  }

  Widget configExtendedTabBarView() {
    return ScrollConfiguration(
        behavior: NoScrollbarAndGlowBehavior(),
        child: ExtendedTabBarView(
          controller: _tabController,
          pageController: _pageController,
          shouldIgnorePointerWhenScrolling: false,
          link: true,
          children: widget.views,
        ));
  }

  Widget configTabView() {
    if (widget.titles.isNotEmpty) {
      // return Padding(
      //   padding: widget.tabBarPadding ?? EdgeInsets.zero,
      //   child: SizedBox(
      //     height: widget.tabBarHeight ?? MyTheme.navbarHegiht,
      //     child: Row(
      //       children: [
      //         Expanded(
      //           child: Theme(
      //             data: Theme.of(context).copyWith(tabBarTheme: tabBarTheme),
      //             child: RepaintBoundary(
      //               child: ScrollConfiguration(
      //                 behavior: ScrollConfiguration.of(context).copyWith(
      //                   scrollbars: false,
      //                 ),
      //                 child: TabBar(
      //                   physics: const BouncingScrollPhysics(),
      //                   isScrollable: widget.isScrollable,
      //                   padding: EdgeInsets.symmetric(vertical: 2.w),
      //                   controller: _tabController,
      //                   tabs: tabs,
      //                   tabAlignment: widget.isScrollable
      //                       ? TabAlignment.start
      //                       : TabAlignment.fill,
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      //         if (widget.tabBarRightWidget case final view?) view,
      //       ],
      //     ),
      //   ),
      // );
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: widget.tabBarHeight ?? MyTheme.navbarHegiht,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Theme(
                    data: Theme.of(context).copyWith(tabBarTheme: tabBarTheme),
                    child: RepaintBoundary(
                      child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(
                            scrollbars: false,
                          ),
                          child: ValueListenableBuilder(
                              valueListenable: indexChangeNotifier,
                              builder: (context, selectedIndex, child) {
                                final bool effectiveIsScrollable = widget.isCenter ? true : widget.isScrollable;

                                return TabBar(
                                  physics: const BouncingScrollPhysics(),
                                  isScrollable: effectiveIsScrollable,
                                  padding: widget.tabBarPadding ?? EdgeInsets.symmetric(vertical: 2.w),
                                  controller: _tabController,
                                  tabs: tabs,
                                  indicatorColor: Colors.transparent,
                                  dividerColor: Colors.transparent,
                                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                                  tabAlignment: effectiveIsScrollable
                                      ? (widget.isCenter ? TabAlignment.center : TabAlignment.start)
                                      : (widget.isCenter ? TabAlignment.center : TabAlignment.fill),
                                  // labelPadding: widget.type == TabBarType.line
                                  //     ? EdgeInsets.symmetric(
                                  //         horizontal: widget.labelPadding / 4)
                                  //     : EdgeInsets.symmetric(
                                  //         horizontal: widget.labelPadding),
                                  // tabAlignment: widget.isCenter
                                  //     ? TabAlignment.center
                                  //     : TabAlignment.start,
                                );
                              })),
                    ),
                  ),
                ),
                if (widget.tabBarRightWidget case final view?) view,
              ],
            ),
          ),
          if (widget.tabBarBottomWidget case final view?) view,
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

// @override
// Widget build(BuildContext context) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       if (widget.titles.isNotEmpty)
//         Padding(
//           padding: widget.tabBarPadding ?? EdgeInsets.zero,
//           child: SizedBox(
//             height: widget.tabBarHeight ?? MyTheme.navbarHegiht,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Theme(
//                     data:
//                         Theme.of(context).copyWith(tabBarTheme: tabBarTheme),
//                     child: RepaintBoundary(
//                       child: ScrollConfiguration(
//                         behavior: ScrollConfiguration.of(context).copyWith(
//                           scrollbars: false,
//                         ),
//                         child: TabBar(
//                           physics: const BouncingScrollPhysics(),
//                           isScrollable: widget.isScrollable,
//                           padding: EdgeInsets.symmetric(vertical: 2.w),
//                           controller: _tabController,
//                           tabs: tabs,
//                           tabAlignment: widget.isScrollable
//                               ? TabAlignment.start
//                               : TabAlignment.fill,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 if (widget.tabBarRightWidget case final view?) view,
//               ],
//             ),
//           ),
//         ),
//       Expanded(
//         child: TabBarView(
//           controller: _tabController,
//           children: widget.views,
//         ),
//       ),
//     ],
//   );
// }
}

//隐藏页面底部的半透明横条
class NoScrollbarAndGlowBehavior extends MaterialScrollBehavior {
  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return child; //不包任何 Scrollbar
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child; //不包任何 glow
  }
}

class MyTabBarTheme extends TabBarTheme {
  const MyTabBarTheme({
    super.indicator,
    super.indicatorColor,
    super.indicatorSize,
    super.dividerColor,
    super.dividerHeight,
    super.labelColor,
    super.labelPadding,
    super.labelStyle,
    super.unselectedLabelColor,
    super.unselectedLabelStyle,
    super.overlayColor,
    super.splashFactory,
    super.mouseCursor,
    super.tabAlignment,
  });

  factory MyTabBarTheme.line({
    TextStyle? labelStyle,
    TextStyle? unselectedLabelStyle,
    List<Color>? gradientColors,
    IndicatorType indicatorType = IndicatorType.line,
  }) {
    // web下统一使用默认类型
    final effectiveIndicatorType = kIsWeb ? IndicatorType.line : indicatorType;

    return MyTabBarTheme(
      labelStyle: labelStyle ?? MyTheme.jellyCyan_17,
      labelPadding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      unselectedLabelStyle: unselectedLabelStyle ??
          TextStyle(
            color: const Color.fromRGBO(255, 255, 255, 0.6),
            fontSize: 17.sp,
            overflow: TextOverflow.visible,
            decoration: TextDecoration.none,
          ),
      indicatorSize: TabBarIndicatorSize.label,
      indicator: LineIndicator(
        indicatorType: effectiveIndicatorType,
        gradientColors: gradientColors,
      ),
      indicatorColor: Colors.transparent,
      overlayColor: WidgetStateProperty.resolveWith<Color>(
        (_) => Colors.transparent,
      ),
      tabAlignment: TabAlignment.start,
      dividerColor: Colors.transparent,
    );
  }

  factory MyTabBarTheme.fillColor({
    TabAlignment? tabAlignment,
    TextStyle? labelStyle,
    double? borderRadius,
    TextStyle? unselectedLabelStyle,
  }) =>
      MyTabBarTheme(
        labelStyle: labelStyle ?? MyTheme.green85_15,
        labelPadding: tabAlignment == null ? EdgeInsets.zero : EdgeInsets.only(right: 16.w, top: 2.w),
        unselectedLabelStyle: unselectedLabelStyle ?? MyTheme.gray232_15,
        overlayColor: WidgetStateProperty.resolveWith<Color>(
          (_) => Colors.transparent,
        ),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: Colors.transparent,
        indicator: BoxDecoration(
          gradient: MyTheme.gradient_90_114,
          borderRadius: BorderRadius.circular(borderRadius ?? 30.w),
        ),
        tabAlignment: tabAlignment,
        dividerColor: Colors.transparent,
      );
}

class LineIndicator extends Decoration {
  const LineIndicator({
    this.indicatorType = IndicatorType.line,
    this.gradientColors,
  });

  final IndicatorType indicatorType;
  final List<Color>? gradientColors;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _LinePainter(this, gradientColors, onChanged)..init();
  }
}

class _LinePainter extends BoxPainter {
  _LinePainter(
    this.decoration,
    this.gradientColors,
    super.onChanged,
  );

  final List<Color>? gradientColors;
  final LineIndicator decoration;
  ui.Image? _cachedImage;
  ImageStream? _imageStream;
  ImageStreamListener? _listener;

  void init() {
    if (decoration.indicatorType != IndicatorType.line) {
      _loadImage();
    }
  }

  @override
  void dispose() {
    if (_imageStream != null && _listener != null) {
      _imageStream!.removeListener(_listener!);
    }
    _cachedImage?.dispose();
    super.dispose();
  }

  void _loadImage() {
    if (_cachedImage != null) return;

    String imagePath;
    switch (decoration.indicatorType) {
      case IndicatorType.line:
        // line 使用默认
        return;
      case IndicatorType.light:
        imagePath = MyImagePaths.appIndicatorLight;
        break;
      case IndicatorType.curve:
        imagePath = MyImagePaths.appIndicatorCurve;
        break;
    }

    String processedPath = imagePath;
    if (processedPath.startsWith('./')) {
      processedPath = processedPath.substring(2);
    }

    _imageStream = AssetImage(processedPath).resolve(const ImageConfiguration());
    _listener = ImageStreamListener(
      (ImageInfo info, _) {
        _cachedImage = info.image;
        onChanged?.call();
      },
    );
    _imageStream!.addListener(_listener!);
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final size = configuration.size!;

    switch (decoration.indicatorType) {
      case IndicatorType.light:
        // if (_cachedImage == null) _loadImage();
        if (_cachedImage != null) {
          final imageWidth = _cachedImage!.width.toDouble();
          final imageHeight = _cachedImage!.height.toDouble();

          final w = 32.w;
          final h = 17.w;

          final rect = Rect.fromLTWH(
            offset.dx + (size.width - w) / 2,
            size.height - h - 1.5,
            w,
            h,
          );
          canvas.drawImageRect(
            _cachedImage!,
            Rect.fromLTWH(0, 0, imageWidth, imageHeight),
            rect,
            Paint(),
          );
        }
        break;

      case IndicatorType.curve:
        if (_cachedImage == null) _loadImage();
        if (_cachedImage != null) {
          final imageWidth = _cachedImage!.width.toDouble();
          final imageHeight = _cachedImage!.height.toDouble();

          final w = 19.w;
          final h = 5.w;

          final rect = Rect.fromLTWH(
            offset.dx + (size.width - w) / 2,
            size.height - h - 4,
            w,
            h,
          );
          canvas.drawImageRect(
            _cachedImage!,
            Rect.fromLTWH(0, 0, imageWidth, imageHeight),
            rect,
            Paint(),
          );
        }
        break;

      case IndicatorType.line:
      default:
        final indicatorW = 21.5.w;
        final indicator = Rect.fromLTWH(
          offset.dx + (size.width - indicatorW) / 2,
          size.height - 8,
          indicatorW,
          3.5.w,
        );
        final centerY = indicator.center.dy;
        final start = Offset(indicator.left, centerY);
        final end = Offset(indicator.right, centerY);
        canvas.drawLine(
          start,
          end,
          Paint()
            ..shader = ui.Gradient.linear(start, end, gradientColors ?? MyTheme.gradient_90_114_colors)
            ..strokeWidth = 4.w
            ..strokeCap = StrokeCap.round,
        );
        break;
    }
  }
}
