import 'package:analytics_sdk/entity/analytics_tab.dart';
import 'package:analytics_sdk/entity/app_page_view_event.dart';
import 'package:analytics_sdk/entity/navigation_event.dart';
import 'package:analytics_sdk/manager/page_name_manager.dart';
import 'package:analytics_sdk/widget/analytics_tab_bar_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildTabApp({
  required List<AnalyticsTab> tabs,
  required List<dynamic> tracked,
  TabController? controller,
}) {
  return MaterialApp(
    home: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: AnalyticsTabBarWrapper(
            tabs: tabs,
            onTrack: tracked.add,
            child: TabBar(
              controller: controller,
              tabs: const [Tab(text: '视频'), Tab(text: '小说')],
            ),
          ),
        ),
        body: const TabBarView(
          children: [Text('视频内容'), Text('小说内容')],
        ),
      ),
    ),
  );
}

void main() {
  group('AnalyticsTabBarWrapper', () {
    setUp(() {
      PageNameMapper.clearCustom();
    });

    testWidgets('切换 Tab 时上报 NavigationEvent', (tester) async {
      final tracked = <dynamic>[];

      await tester.pumpWidget(_buildTabApp(
        tabs: const [AnalyticsTab('video', '视频'), AnalyticsTab('novel', '小说')],
        tracked: tracked,
      ));
      await tester.pump();

      await tester.tap(find.text('小说'));
      await tester.pumpAndSettle();

      // 切换 Tab 上报 AppPageViewEvent + NavigationEvent 各一条
      expect(tracked.length, 2);
      expect(tracked[0], isA<AppPageViewEvent>());
      expect(tracked[1], isA<NavigationEvent>());

      final nav = tracked[1] as NavigationEvent;
      expect(nav.navigationKey, 'novel');
      expect(nav.navigationName, '小说');
    });

    testWidgets('切换 Tab 同时上报 AppPageViewEvent', (tester) async {
      final tracked = <dynamic>[];

      await tester.pumpWidget(_buildTabApp(
        tabs: const [AnalyticsTab('video', '视频'), AnalyticsTab('novel', '小说')],
        tracked: tracked,
      ));
      await tester.pump();

      await tester.tap(find.text('小说'));
      await tester.pumpAndSettle();

      // AppPageViewEvent 先于 NavigationEvent 上报
      expect(tracked.length, 2);
      final pageView = tracked[0] as AppPageViewEvent;
      expect(pageView.pageKey, 'novel');
      expect(pageView.pageName, '小说');
    });

    testWidgets('重复点击同一 Tab 不重复上报', (tester) async {
      final tracked = <dynamic>[];

      await tester.pumpWidget(_buildTabApp(
        tabs: const [AnalyticsTab('video', '视频'), AnalyticsTab('novel', '小说')],
        tracked: tracked,
      ));
      await tester.pump();

      await tester.tap(find.text('小说'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('小说')); // 再次点击同一 Tab
      await tester.pumpAndSettle();

      // 第一次切换上报 AppPageViewEvent + NavigationEvent；同一 Tab 重复点击不再触发
      expect(tracked.length, 2);
    });

    testWidgets('tabs 为空时不崩溃', (tester) async {
      final tracked = <dynamic>[];

      await tester.pumpWidget(_buildTabApp(tabs: const [], tracked: tracked));
      await tester.pump();

      await tester.tap(find.text('小说'));
      await tester.pumpAndSettle();

      expect(tracked.length, 0);
    });

    testWidgets('index 超出 tabs 长度时用 tab_N 兜底', (tester) async {
      final tracked = <dynamic>[];

      await tester.pumpWidget(_buildTabApp(
        tabs: const [AnalyticsTab('video', '视频')], // 只有1个，但有2个 tab
        tracked: tracked,
      ));
      await tester.pump();

      await tester.tap(find.text('小说')); // index=1，超出 tabs 长度
      await tester.pumpAndSettle();

      // 兜底 key 为 tab_1，同样上报 AppPageViewEvent + NavigationEvent
      expect(tracked.length, 2);
      final nav = tracked[1] as NavigationEvent;
      expect(nav.navigationKey, 'tab_1');
    });
    testWidgets('TabController 已 disposed 时 widget 更新不崩溃', (tester) async {
      final controller1 = TabController(length: 2, vsync: tester);

      Widget buildWithController(TabController? ctrl) => MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                bottom: AnalyticsTabBarWrapper(
                  tabs: const [AnalyticsTab('a'), AnalyticsTab('b')],
                  onTrack: (_) {},
                  child: TabBar(
                    controller: ctrl,
                    tabs: const [Tab(text: 'A'), Tab(text: 'B')],
                  ),
                ),
              ),
              body: const SizedBox(),
            ),
          );

      await tester.pumpWidget(buildWithController(controller1));
      await tester.pump();

      // dispose 旧 controller，再用新 controller 触发 didUpdateWidget
      controller1.dispose();
      final controller2 = TabController(length: 2, vsync: tester);
      await tester.pumpWidget(buildWithController(controller2));
      await tester.pump();

      // 不应抛出异常
      expect(tester.takeException(), isNull);
      controller2.dispose();
    });
  });
}
