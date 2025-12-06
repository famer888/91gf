import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme.dart';
import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/foundation.dart';
import 'my_image.dart';

enum TabBarType {
  /// 下滑线
  line,

  /// 填充色
  fillColor,

  /// 选中时使用图片
  image,
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
    this.isStack = false,
    this.indexChangeCall,
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
    this.labelStyle,
    this.unselectedLabelStyle,
    this.tabController,
    this.labelPadding = 8.0,
    this.initialIndex = 0,
    this.isStack = false,
    this.indexChangeCall,
  })  : type = TabBarType.fillColor,
        selectedImgs = null,
        unselectedImgs = null,
        imageWidth = null,
        imageHeight = null;

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
    this.labelPadding = 8.0,
    this.initialIndex = 0,
    this.isStack = false,
    this.indexChangeCall,
  })  : type = TabBarType.image,
        tabBarRightWidget = null;

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
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final TabController? tabController;

  final double labelPadding;
  final bool isStack; // 是colume上下分布 还是stack那样把标题重叠在上面
  final Function(int)? indexChangeCall;

  @override
  State<TabBarWithView> createState() => _TabBarWithViewState();
}

class _TabBarWithViewState extends State<TabBarWithView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = widget.tabController ??
      TabController(length: widget.views.length, vsync: this, initialIndex: widget.initialIndex);

  late LinkPageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = LinkPageController(initialPage: widget.initialIndex);

    _tabController.addListener(_handleTabChange);
    _tabController.animation?.addListener(_handleTabAnimation);

    indexChangeNotifier = ValueNotifier(_tabController.index);
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
    final double animationValue =
        _tabController.animation?.value ?? _tabController.index.toDouble();
    final double diff = (animationValue - _tabController.index).abs();
    // During a standard drag/scroll, _tabController.index is derived from animation.value.round(),
    // so diff will always be <= 0.5.
    // If diff > 0.5, it indicates the index (target) is forced (jump/animation) and we should stick to it.
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
      return switch (widget.type) {
        TabBarType.fillColor => Tab(
            height: MyTheme.navbarHegiht,
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: widget.tabInterMargin.w),
              child: Text(
                title,
              ),
            ),
          ),
        _ => (!kIsWeb && indexChangeNotifier.value == index)
            ? Tab(
                height: MyTheme.navbarHegiht,
                child: ShaderMask(
                  shaderCallback: (bounds) =>
                      MyTheme.gradient_90_114.createShader(bounds),
                  blendMode: BlendMode.srcIn,
                  child: Text(
                    title,
                    style: widget.labelStyle ?? MyTheme.jellyCyan_17,
                  ),
                ),
              )
            : Tab(
                height: MyTheme.navbarHegiht,
                text: title,
              ),
      };
    });
  }

  late final TabBarTheme tabBarTheme = switch (widget.type) {
    TabBarType.line => MyTabBarTheme.line(
        labelStyle: widget.labelStyle,
        unselectedLabelStyle: widget.unselectedLabelStyle,
      ),
    TabBarType.fillColor => MyTabBarTheme.fillColor(
        tabAlignment: widget.isScrollable ? TabAlignment.start : null,
        labelStyle: widget.labelStyle,
        unselectedLabelStyle: widget.unselectedLabelStyle,
      ),
    TabBarType.image => MyTabBarTheme.line(
        labelStyle: widget.labelStyle,
        unselectedLabelStyle: widget.unselectedLabelStyle,
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
      return Padding(
        padding: widget.tabBarPadding ?? EdgeInsets.zero,
        child: SizedBox(
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
                              return TabBar(
                                physics: const BouncingScrollPhysics(),
                                isScrollable: widget.isScrollable,
                                padding: EdgeInsets.symmetric(vertical: 2.w),
                                controller: _tabController,
                                tabs: tabs,
                                indicatorColor: Colors.transparent,
                                dividerColor: Colors.transparent,
                                overlayColor:
                                    WidgetStateProperty.all(Colors.transparent),
                                tabAlignment: widget.isScrollable
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
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
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
  }) =>
      MyTabBarTheme(
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
        indicator: const LineIndicator(),
        indicatorColor: Colors.transparent,
        overlayColor: WidgetStateProperty.resolveWith<Color>(
          (_) => Colors.transparent,
        ),
        tabAlignment: TabAlignment.start,
        dividerColor: Colors.transparent,
      );

  factory MyTabBarTheme.fillColor({
    TabAlignment? tabAlignment,
    TextStyle? labelStyle,
    TextStyle? unselectedLabelStyle,
  }) =>
      MyTabBarTheme(
        labelStyle: labelStyle ?? MyTheme.green85_15,
        labelPadding: tabAlignment == null
            ? EdgeInsets.zero
            : EdgeInsets.only(right: 16.w, top: 2.w),
        unselectedLabelStyle: unselectedLabelStyle ?? MyTheme.gray232_15,
        overlayColor: WidgetStateProperty.resolveWith<Color>(
          (_) => Colors.transparent,
        ),
        // indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: Colors.transparent,
        indicator: BoxDecoration(
          gradient: MyTheme.gradient_90_114,
          borderRadius: BorderRadius.circular(30.w),
        ),
        tabAlignment: tabAlignment,
        dividerColor: Colors.transparent,
      );
}

class LineIndicator extends Decoration {
  const LineIndicator();

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _LinePainter(this, onChanged);
  }
}

class _LinePainter extends BoxPainter {
  _LinePainter(
    this.decoration,
    super.onChanged,
  );

  final LineIndicator decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);

    final size = configuration.size!;

    final indicatorW = 21.5.w;

    final Rect indicator = Rect.fromLTWH(
      offset.dx + (size.width - indicatorW) / 2,
      size.height - 8,
      indicatorW,
      3.5.w,
    );

    final centerY = indicator.center.dy;
    final startOffset = Offset(indicator.left, centerY);
    final endOffset = Offset(indicator.right, centerY);
    canvas.drawLine(
      startOffset,
      endOffset,
      Paint()
        ..shader = ui.Gradient.linear(
          startOffset,
          endOffset,
          MyTheme.gradient_90_114_colors,
        )
        ..strokeWidth = 4.w
        ..strokeCap = StrokeCap.round,
    );
  }
}
