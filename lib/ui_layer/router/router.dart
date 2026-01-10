import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/report/ui_layer/report_timing_observer.dart';
import 'package:jygf/ui_layer/router/approute_observer.dart';
import 'paths.dart';
import 'routes.dart';

class AppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final GoRouter router = GoRouter(
    navigatorKey: AppRouter.rootNavigatorKey,
    initialLocation: AppRouterPaths.root,
    routes: $appRoutes,
    observers: [
      BotToastNavigatorObserver(),
      AppRouteObserver().routeObserver,
      ReportTimingObserver()
    ],
  );
}
