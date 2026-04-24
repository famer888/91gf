import 'package:analytics_sdk/analytics_sdk.dart';
import 'package:analytics_sdk/entity/analytics_tab.dart';
import 'package:analytics_sdk/entity/app_page_view_event.dart';
import 'package:analytics_sdk/entity/navigation_event.dart';
import 'package:analytics_sdk/manager/page_name_manager.dart';
import 'package:analytics_sdk/observer/page_lifecycle_observer.dart';
import 'package:analytics_sdk/utils/logger.dart';
import 'package:analytics_sdk/widget/_tab_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// TabBar 的 analytics 包装。
///
/// 监听 [TabController]，Tab 切换完成时在下一帧渲染后自动上报：
///   - [AppPageViewEvent]：含来路页面 key（取自切换前的 [PageLifecycleObserver.currentPageKey]）
///   - [NavigationEvent]：用于导航行为报表
///
/// 同时调用 [PageLifecycleObserver.recordNavigation] 更新全局 currentPageKey
/// 及栈顶 effectivePageKey，确保后续 page_click 归属正确的子页面；
/// 即便从详情页 pop 返回，也能恢复到切换前的子 Tab key。
///
/// 不应直接使用；通过 [AnalyticsTabBarExtension.withAnalytics] 调用。
class AnalyticsTabBarWrapper extends StatefulWidget implements PreferredSizeWidget {
  final TabBar child;
  final List<AnalyticsTab> tabs;

  /// 仅供测试使用；null 时走 AnalyticsSdk.instance.track。
  @visibleForTesting
  final void Function(dynamic event)? onTrack;

  const AnalyticsTabBarWrapper({
    super.key,
    required this.child,
    required this.tabs,
    this.onTrack,
  });

  @override
  Size get preferredSize => child.preferredSize;

  @override
  State<AnalyticsTabBarWrapper> createState() => _AnalyticsTabBarWrapperState();
}

class _AnalyticsTabBarWrapperState extends State<AnalyticsTabBarWrapper> {
  /// 当前监听的 TabController；在 [didChangeDependencies] / [didUpdateWidget] 中维护。
  TabController? _controller;

  /// 最近一次上报的 tab 索引，过滤 indexIsChanging 动画期间的重复触发。
  int _lastTrackedIndex = -1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      _attachController(_resolveController());
    } catch (e) {
      Logger.analyticsSdk('AnalyticsTabBarWrapper.didChangeDependencies 异常，已安全处理: $e');
    }
  }

  @override
  void didUpdateWidget(AnalyticsTabBarWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    try {
      final newController = _resolveController();
      if (newController != _controller) {
        _attachController(newController);
        _lastTrackedIndex = -1; // 新 controller 时重置，防止去重误判
      }
    } catch (e) {
      Logger.analyticsSdk('AnalyticsTabBarWrapper.didUpdateWidget 异常，已安全处理: $e');
    }
  }

  /// 优先取 widget.child.controller，回退到 [DefaultTabController]。
  TabController? _resolveController() {
    return widget.child.controller ?? DefaultTabController.maybeOf(context);
  }

  /// 切换监听目标：移除旧 controller 监听后绑定新 controller；controller 未变时直接返回。
  void _attachController(TabController? controller) {
    if (controller == _controller) return;
    _controller?.removeListener(_onControllerChange);
    _controller = controller;
    _controller?.addListener(_onControllerChange);
  }

  /// TabController 索引变化回调。
  ///
  /// 过滤动画帧（indexIsChanging）和重复索引后，通过 [SchedulerBinding.addPostFrameCallback]
  /// 在渲染完成后上报 [AppPageViewEvent] 和 [NavigationEvent]，
  /// pageLoadTime 反映从点击到渲染完成的真实耗时。
  void _onControllerChange() {
    try {
      final ctrl = _controller;
      if (ctrl == null || ctrl.indexIsChanging) return;

      final index = ctrl.index;
      if (index == _lastTrackedIndex) return;
      _lastTrackedIndex = index;

      if (widget.tabs.isEmpty) return;

      final tab = resolveTab(widget.tabs, index);
      final pageKey = tab.key;
      final pageName = resolveTabName(tab);

      final referrerKey = PageLifecycleObserver.currentPageKey;
      final referrerName = PageNameMapper.getPageName(referrerKey);
      PageLifecycleObserver.recordNavigation(pageKey);

      final tapTime = DateTime.now();
      final onTrackSnapshot = widget.onTrack;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        final pageLoadTime = DateTime.now().difference(tapTime).inMilliseconds;
        try {
          trackWith(onTrackSnapshot, AppPageViewEvent(
            userType: AnalyticsSdk.userTypeProvider(),
            pageKey: pageKey,
            pageName: pageName,
            referrerPageKey: referrerKey,
            referrerPageName: referrerName,
            currentPageKey: pageKey,
            currentPageName: pageName,
            pageLoadTime: pageLoadTime,
          ));
          trackWith(onTrackSnapshot, NavigationEvent(
            navigationKey: pageKey,
            navigationName: pageName,
          ));
        } catch (e) {
          Logger.analyticsSdk('TabBarWrapper.post-frame 上报异常，已安全处理: $e');
        }
      });
    } catch (e) {
      Logger.analyticsSdk('TabBarWrapper._onControllerChange 异常，已安全处理: $e');
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onControllerChange);
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
