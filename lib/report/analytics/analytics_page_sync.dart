import 'package:analytics_sdk/manager/page_name_manager.dart';
import 'package:analytics_sdk/observer/page_lifecycle_observer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class AnalyticsPageInfo {
  const AnalyticsPageInfo({
    required this.pageKey,
    required this.pageName,
  });

  final String pageKey;
  final String pageName;
}

AnalyticsPageInfo syncAnalyticsPageFromContext(BuildContext context) {
  try {
    final router = GoRouter.of(context);
    final matches = router.routerDelegate.currentConfiguration.matches;
    final uriPath = router.routerDelegate.currentConfiguration.uri.path;
    String path = '';

    // 优先拿最深层 GoRoute 的 path pattern（如 videoDetail / xxx/:id），
    // 避免在 StatefulShellRoute 场景下只拿到一级页面路径。
    for (final match in matches.reversed) {
      final route = match.route;
      if (route is GoRoute && route.path.isNotEmpty) {
        path = route.path;
        break;
      }
    }

    // 兜底用当前 uri.path
    path = path.isEmpty ? uriPath : path;
    final normalizedPath = PageNameMapper.normalizeKey(path);
    final pageInfo = PageNameMapper.resolvePageInfo(normalizedPath);
    final finalPageKey = (pageInfo.key == '/') ? 'launch' : pageInfo.key;
    final finalPageName = pageInfo.name == '/' ? '启动页' : pageInfo.name;

    if (kDebugMode) {
      debugPrint(
        '[AnalyticsPageSync] uriPath=$uriPath, matchedPath=$path, normalizedPath=$normalizedPath, pageKey=$finalPageKey, pageName=$finalPageName',
      );
    }
    PageLifecycleObserver.recordNavigation(finalPageKey);
    return AnalyticsPageInfo(
      pageKey: finalPageKey,
      pageName: finalPageName,
    );
  } catch (_) {
    final pageKey = PageLifecycleObserver.currentPageKey;
    final pageName = PageNameMapper.getPageName(pageKey);
    return AnalyticsPageInfo(
      pageKey: pageKey == '/' ? 'launch' : pageKey,
      pageName: pageName == '/' ? '启动页' : pageName,
    );
  }
}
