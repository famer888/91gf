import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/navigator_model.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import '../theme.dart';

enum TabBarType {
  /// 下滑线
  line,

  /// 填充色
  fillColor
}

class TabFilterBarWithView extends StatefulWidget {
  const TabFilterBarWithView.line(
      {super.key,
      required this.titles,
      required this.views,
      this.tabBarPadding,
      this.tabBarHeight,
      this.isScrollable = true,
      this.labelStyle,
      this.unselectedLabelStyle,
      this.tabController,
      this.onTapTab,
      this.slideChageTab,
      this.fillCorlor})
      : type = TabBarType.line,
        tabBarRightWidget = null;

  const TabFilterBarWithView.fillColor({
    super.key,
    required this.titles,
    required this.views,
    this.tabBarPadding,
    this.tabBarHeight,
    this.isScrollable = false,
    this.tabBarRightWidget,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.tabController,
    this.onTapTab,
    this.slideChageTab,
    this.fillCorlor = const Color.fromRGBO(35, 35, 55, 1),
  }) : type = TabBarType.fillColor;

  final TabBarType type;

  final List<dynamic> titles; // 支持 FaceSortModel 和 VideoFaceSortModel
  final List<Widget> views;
  final bool isScrollable;
  final EdgeInsetsGeometry? tabBarPadding;
  final double? tabBarHeight;
  final Widget? tabBarRightWidget;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final TabController? tabController;
  final Function(int)? onTapTab;
  final Color? fillCorlor;

  final Function(int)? slideChageTab;
  @override
  State<TabFilterBarWithView> createState() => _TabFilterBarWithViewState();
}

class _TabFilterBarWithViewState extends State<TabFilterBarWithView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = widget.tabController ??
      TabController(length: widget.views.length, vsync: this);

  @override
  void initState() {
    super.initState();

    _tabController.addListener(() {
      int currentIndex = _tabController.index;
      widget.slideChageTab?.call(currentIndex);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> get tabs => widget.titles
      .map((title) => switch (widget.type) {
            TabBarType.fillColor => Tab(
                height: MyTheme.navbarHegiht,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_getTitle(title)),
                      _canSort(title)
                          ? SizedBox(width: 3.w)
                          : Container(), //推荐没有排序
                      _canSort(title)
                          ? (_getSort(title) == null
                              ? MyImage.asset(MyImagePaths.appFliterDefual,
                                  width: 7.w, height: 11.w)
                              : MyImage.asset(
                                  _getSort(title) == 'asc'
                                      ? MyImagePaths.appFliterUp
                                      : MyImagePaths.appFliterDown,
                                  width: 7.w,
                                  height: 11.w))
                          : Container(),
                    ],
                  ),
                ),
              ),
            _ => Tab(
                height: MyTheme.navbarHegiht,
                text: _getTitle(title),
              ),
          })
      .toList();

  String _getTitle(dynamic title) {
    if (title is FaceSortModel) {
      return title.title;
    } else if (title is VideoFaceSortModel) {
      return title.title;
    }
    return '';
  }

  String? _getSort(dynamic title) {
    if (title is FaceSortModel) {
      return title.sort;
    } else if (title is VideoFaceSortModel) {
      return title.sort;
    }
    return null;
  }

  bool _canSort(dynamic title) {
    if (title is FaceSortModel) {
      return title.type != 1;
    } else if (title is VideoFaceSortModel) {
      return true;
    }
    return false;
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
        fillColor: widget.fillCorlor),
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.titles.isNotEmpty)
          Padding(
            padding: widget.tabBarPadding ?? EdgeInsets.zero,
            child: SizedBox(
              height: widget.tabBarHeight ?? MyTheme.navbarHegiht,
              child: Row(
                children: [
                  Expanded(
                    child: Theme(
                      data:
                          Theme.of(context).copyWith(tabBarTheme: tabBarTheme),
                      child: RepaintBoundary(
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(
                            scrollbars: false,
                          ),
                          child: TabBar(
                            physics: const BouncingScrollPhysics(),
                            isScrollable: widget.isScrollable,
                            padding: EdgeInsets.symmetric(vertical: 2.w),
                            controller: _tabController,
                            tabs: tabs,
                            onTap: widget.onTapTab,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (widget.tabBarRightWidget case final view?) view,
                ],
              ),
            ),
          ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.views,
          ),
        ),
      ],
    );
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
        labelStyle: labelStyle ?? MyTheme.jellyCyan_18,
        labelPadding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
        unselectedLabelStyle: unselectedLabelStyle ??
            TextStyle(
              color: const Color.fromRGBO(255, 255, 255, 1),
              fontSize: 18.sp,
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

  factory MyTabBarTheme.fillColor(
          {TabAlignment? tabAlignment,
          TextStyle? labelStyle,
          TextStyle? unselectedLabelStyle,
          Color? fillColor}) =>
      MyTabBarTheme(
        labelStyle: labelStyle ?? MyTheme.green85_15,
        labelPadding: tabAlignment == null
            ? EdgeInsets.zero
            : EdgeInsets.only(right: 16.w),
        unselectedLabelStyle: unselectedLabelStyle ?? MyTheme.gray232_15,
        overlayColor: WidgetStateProperty.resolveWith<Color>(
          (_) => Colors.transparent,
        ),
        // indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: Colors.transparent,
        indicator: BoxDecoration(
          color: fillColor ?? const Color.fromRGBO(35, 35, 55, 1),
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
