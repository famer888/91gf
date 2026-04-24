import 'package:analytics_sdk/analytics_sdk.dart';
import 'package:analytics_sdk/manager/page_name_manager.dart';
import 'package:analytics_sdk/observer/page_lifecycle_observer.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/report/ui_layer/report_timing_observer.dart';
import 'package:jygf/ui_layer/router/approute_observer.dart';
import 'paths.dart';
import 'routes.dart';

class AppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final GoRouter router = _buildRouter();

  static GoRouter _buildRouter() {
    final router = GoRouter(
      navigatorKey: AppRouter.rootNavigatorKey,
      initialLocation: AppRouterPaths.root,
      routes: $appRoutes,
      observers: [
        BotToastNavigatorObserver(),
        AppRouteObserver().routeObserver,
        ReportTimingObserver(),
        AnalyticsSdk.instance.pageObserver,
      ],
    );

    void syncCurrentPageFromLocation() {
      final path = router.routerDelegate.currentConfiguration.uri.path;
      final normalizedPath = PageNameMapper.normalizeKey(path);
      final pageInfo = PageNameMapper.resolvePageInfo(normalizedPath);
      PageLifecycleObserver.recordNavigation(pageInfo.key);
    }

    router.routerDelegate.addListener(syncCurrentPageFromLocation);
    syncCurrentPageFromLocation();
    return router;
  }
}
