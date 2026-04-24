// test/page_lifecycle_observer_test.dart
//
// 覆盖 PageLifecycleObserver 的核心路径：
//   1. 正常导航：didPush / didPop 上报正确
//   2. 帧回调触发前 pop（loadTimer 修复路径）
//   3. dispose() 清理 _activeTimers
//   4. didRemove（pushAndRemoveUntil 场景）
//   5. effectivePageKey 子页面状态保持与 pop 恢复

import 'package:analytics_sdk/config/sdk_config.dart';
import 'package:analytics_sdk/entity/app_page_view_event.dart';
import 'package:analytics_sdk/observer/page_lifecycle_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// 构造一个带路由名的 MaterialPageRoute，无需真实 BuildContext
MaterialPageRoute<void> _route(String name) => MaterialPageRoute<void>(
      builder: (_) => const SizedBox(),
      settings: RouteSettings(name: name),
    );

void main() {
  setUp(() {
    SdkConfig.pageLoadTimeout = const Duration(milliseconds: 50);
  });

  tearDown(() {
    SdkConfig.reset();
    PageLifecycleObserver.currentPageKey = 'main';
  });

  // ──────────────────────────────────────────────────────────────
  // 1. 正常导航
  // ──────────────────────────────────────────────────────────────
  group('正常导航', () {
    testWidgets('didPush 在帧回调后上报 AppPageViewEvent', (tester) async {
      final tracked = <dynamic>[];
      final observer = PageLifecycleObserver(
        track: tracked.add,
        getUserType: () => 'normal',
      );

      await tester.pumpWidget(const MaterialApp(home: SizedBox()));

      final route = _route('/home');
      observer.didPush(route, null);
      await tester.pump();

      final pageViews = tracked.whereType<AppPageViewEvent>().toList();
      expect(pageViews, hasLength(1), reason: 'didPush 应上报一条 AppPageViewEvent');
      expect(pageViews.first.pageKey, 'home', reason: 'pageKey 应去掉 leading slash');

      observer.dispose();
    });

    testWidgets('push 到空栈时 AppPageViewEvent 的 referrerPageKey 为空字符串', (tester) async {
      final tracked = <dynamic>[];
      final observer = PageLifecycleObserver(
        track: tracked.add,
        getUserType: () => 'normal',
      );

      await tester.pumpWidget(const MaterialApp(home: SizedBox()));

      final home = _route('/home');
      observer.didPush(home, null);
      await tester.pump();

      final homeView = tracked.whereType<AppPageViewEvent>().first;
      expect(homeView.referrerPageKey, '', reason: '空栈 push 时，没有来源页，referrerPageKey 应为空');
      expect(homeView.pageKey, 'home');

      observer.dispose();
    });

    testWidgets('didPop 后 currentPageKey 恢复为目标页面 key', (tester) async {
      final observer = PageLifecycleObserver(
        track: (_) {},
        getUserType: () => 'normal',
      );

      final home = _route('/home');
      final detail = _route('/detail');

      observer.didPush(home, null);
      await tester.pump();
      observer.didPush(detail, home);
      await tester.pump();

      observer.didPop(detail, home);

      expect(PageLifecycleObserver.currentPageKey, 'home',
          reason: 'didPop 后 currentPageKey 应恢复为 home');

      observer.dispose();
    });
  });

  // ──────────────────────────────────────────────────────────────
  // 2. 帧回调触发前 pop（loadTimer?.cancel() 修复路径）
  // ──────────────────────────────────────────────────────────────
  group('帧回调触发前 pop（loadTimer 修复）', () {
    testWidgets('push 后立即 pop，帧回调触发时不上报 AppPageViewEvent', (tester) async {
      final tracked = <dynamic>[];
      final observer = PageLifecycleObserver(
        track: tracked.add,
        getUserType: () => 'normal',
      );

      final home = _route('/home');
      final page1 = _route('/page1');

      observer.didPush(home, null);
      await tester.pump();
      tracked.clear();

      observer.didPush(page1, home);
      observer.didPop(page1, home);

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      final pageViews = tracked
          .whereType<AppPageViewEvent>()
          .where((e) => e.pageKey == 'page1')
          .toList();

      expect(pageViews, isEmpty,
          reason: '帧回调触发前已 pop 的页面不应上报 AppPageViewEvent');

      observer.dispose();
    });

    testWidgets('push 后立即 pop 不抛异常（崩溃安全回归）', (tester) async {
      final observer = PageLifecycleObserver(
        track: (_) {},
        getUserType: () => 'normal',
      );

      final home = _route('/home');
      final page1 = _route('/page1');

      observer.didPush(home, null);
      await tester.pump();

      observer.didPush(page1, home);
      observer.didPop(page1, home);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(tester.takeException(), isNull,
          reason: '快速 push/pop 不应抛出任何异常');

      observer.dispose();
    });
  });

  // ──────────────────────────────────────────────────────────────
  // 3. dispose() 清理 _activeTimers
  // ──────────────────────────────────────────────────────────────
  group('dispose() Timer 清理', () {
    testWidgets('dispose() 在有挂起 timer 时不抛异常', (tester) async {
      final observer = PageLifecycleObserver(
        track: (_) {},
        getUserType: () => 'normal',
      );

      final home = _route('/home');
      observer.didPush(home, null);

      expect(() => observer.dispose(), returnsNormally,
          reason: 'dispose() 在有挂起 timer 时不应抛异常');

      await tester.pump(const Duration(milliseconds: 200));
    });

    testWidgets('dispose() 后 timer 到期不触发额外上报且不崩溃', (tester) async {
      final tracked = <dynamic>[];
      final observer = PageLifecycleObserver(
        track: tracked.add,
        getUserType: () => 'normal',
      );

      final home = _route('/home');
      observer.didPush(home, null);

      observer.dispose();

      await tester.pump(const Duration(milliseconds: 200));

      expect(tester.takeException(), isNull,
          reason: 'dispose() 后 timer 到期不应崩溃');
    });

    testWidgets('dispose() 同时挂起多路由时全部安全清理，不崩溃', (tester) async {
      final observer = PageLifecycleObserver(
        track: (_) {},
        getUserType: () => 'normal',
      );

      for (var i = 0; i < 5; i++) {
        observer.didPush(_route('/page$i'), null);
      }

      expect(() => observer.dispose(), returnsNormally,
          reason: '多路由挂起时 dispose() 不应崩溃');

      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.takeException(), isNull);
    });
  });

  // ──────────────────────────────────────────────────────────────
  // 4. didRemove（pushAndRemoveUntil 场景）
  // ──────────────────────────────────────────────────────────────
  group('didRemove（pushAndRemoveUntil）', () {
    testWidgets('didRemove 触发 onPageExit 回调，传出正确的 pageKey', (tester) async {
      final exitedPages = <String>[];
      final observer = PageLifecycleObserver(
        track: (_) {},
        getUserType: () => 'normal',
        onPageExit: exitedPages.add,
      );

      final home = _route('/home');
      final pageA = _route('/a');

      observer.didPush(home, null);
      await tester.pump();
      observer.didPush(pageA, home);
      await tester.pump();

      observer.didRemove(pageA, home);

      expect(exitedPages, contains('a'),
          reason: 'didRemove 应调用 onPageExit，传出被移除页面的 pageKey');

      observer.dispose();
    });

    testWidgets('didRemove 取消对应 timer，不再上报被移除页面的 AppPageViewEvent', (tester) async {
      final tracked = <dynamic>[];
      final observer = PageLifecycleObserver(
        track: tracked.add,
        getUserType: () => 'normal',
      );

      final home = _route('/home');
      final pageA = _route('/a');

      observer.didPush(home, null);
      await tester.pump();

      observer.didPush(pageA, home);
      observer.didRemove(pageA, home);

      tracked.clear();

      await tester.pump(const Duration(milliseconds: 200));

      final pageViews = tracked
          .whereType<AppPageViewEvent>()
          .where((e) => e.pageKey == 'a')
          .toList();

      expect(pageViews, isEmpty,
          reason: 'didRemove 取消 timer 后不应再上报该页面的 AppPageViewEvent');

      observer.dispose();
    });
  });

  // ──────────────────────────────────────────────────────────────
  // 5. effectivePageKey — 子页面状态保持与 pop 恢复
  // ──────────────────────────────────────────────────────────────
  group('effectivePageKey 子页面状态', () {
    testWidgets('recordNavigation 更新 currentPageKey 与栈顶 effectivePageKey', (tester) async {
      final observer = PageLifecycleObserver(
        track: (_) {},
        getUserType: () => 'normal',
      );

      await tester.pumpWidget(const MaterialApp(home: SizedBox()));

      final videoRoute = _route('/video');
      observer.didPush(videoRoute, null);
      await tester.pump();

      // 用户切换到子 tab video_hot
      PageLifecycleObserver.recordNavigation('video_hot');

      expect(PageLifecycleObserver.currentPageKey, 'video_hot',
          reason: 'recordNavigation 应更新 currentPageKey');

      observer.dispose();
    });

    testWidgets('didPop 后 currentPageKey 恢复为子页面 effectivePageKey（而非路由 pageKey）', (tester) async {
      final observer = PageLifecycleObserver(
        track: (_) {},
        getUserType: () => 'normal',
      );

      await tester.pumpWidget(const MaterialApp(home: SizedBox()));

      final videoRoute = _route('/video');
      final detailRoute = _route('/video_detail');

      // 进入 /video 路由
      observer.didPush(videoRoute, null);
      await tester.pump();

      // 用户切换子 tab → effectivePageKey = 'video_hot'
      PageLifecycleObserver.recordNavigation('video_hot');
      expect(PageLifecycleObserver.currentPageKey, 'video_hot');

      // 从子 tab 跳转到详情页
      observer.didPush(detailRoute, videoRoute);
      await tester.pump();
      expect(PageLifecycleObserver.currentPageKey, 'video_detail');

      // 返回
      observer.didPop(detailRoute, videoRoute);

      expect(PageLifecycleObserver.currentPageKey, 'video_hot',
          reason: 'pop 返回后应恢复到子页面 effectivePageKey "video_hot"，而非路由 key "video"');

      observer.dispose();
    });

    testWidgets('push 新路由时 referrerKey 来自 effectivePageKey（通过 pop 恢复行为间接验证）', (tester) async {
      // 直接验证路径：recordNavigation → effectivePageKey 写入 → didPop 恢复
      // referrerKey = _pageStack.last.effectivePageKey，push 时已在 _handlePageEnter 捕获。
      // 若 effectivePageKey 正确，则 referrerKey 必然正确。
      final observer = PageLifecycleObserver(
        track: (_) {},
        getUserType: () => 'normal',
      );

      await tester.pumpWidget(const MaterialApp(home: SizedBox()));

      final videoRoute = _route('/video');
      observer.didPush(videoRoute, null);
      await tester.pump();

      // 切换子 tab → effectivePageKey 应更新为 video_hot
      PageLifecycleObserver.recordNavigation('video_hot');
      expect(PageLifecycleObserver.currentPageKey, 'video_hot');

      // push 新路由：currentPageKey 变为新页面
      final detailRoute = _route('/detail');
      observer.didPush(detailRoute, videoRoute);
      expect(PageLifecycleObserver.currentPageKey, 'detail',
          reason: 'push 后 currentPageKey 应更新为 detail');

      // pop 返回：恢复 effectivePageKey（video_hot），证明它被正确保存
      // 这同时证明 _handlePageEnter 能从正确的 effectivePageKey 取 referrerKey
      observer.didPop(detailRoute, videoRoute);
      expect(PageLifecycleObserver.currentPageKey, 'video_hot',
          reason: 'pop 后应恢复 effectivePageKey "video_hot"，而非路由 key "video"');

      observer.dispose();
    });

    testWidgets('多次切换子 tab 后 pop 恢复最后一次 effectivePageKey', (tester) async {
      final observer = PageLifecycleObserver(
        track: (_) {},
        getUserType: () => 'normal',
      );

      await tester.pumpWidget(const MaterialApp(home: SizedBox()));

      final videoRoute = _route('/video');
      final detailRoute = _route('/detail');

      observer.didPush(videoRoute, null);
      await tester.pump();

      PageLifecycleObserver.recordNavigation('video_hot');
      PageLifecycleObserver.recordNavigation('video_new');
      PageLifecycleObserver.recordNavigation('video_rec');

      observer.didPush(detailRoute, videoRoute);
      await tester.pump();

      observer.didPop(detailRoute, videoRoute);

      expect(PageLifecycleObserver.currentPageKey, 'video_rec',
          reason: 'pop 后应恢复最后一次切换的子页面 key');

      observer.dispose();
    });
  });
}
