import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/router/router.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/event_bus/event_bus.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/common_widgets/search_app_bar.dart';
import 'package:jygf/ui_layer/screens/community/issue/screen.dart';
import 'package:jygf/ui_layer/screens/community/ori_create_group_chat/screen.dart';
import 'package:jygf/ui_layer/screens/community/original_screen/original_content.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:provider/provider.dart';

class OriginalCommunityScreen extends StatefulWidget {
  const OriginalCommunityScreen({super.key});

  @override
  State<OriginalCommunityScreen> createState() =>
      _OriginalCommunityScreenState();
}

class _OriginalCommunityScreenState extends State<OriginalCommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return const ScreenBackground(
      child: Scaffold(
        appBar: SearchAppBar(),
        body: _Body(),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with TickerProviderStateMixin {
  late final _config = context.read<HomeConfigNotifier>().config;
  late final data = _config.originalTopNav;

  late final TabController? tabController;
  late StreamSubscription<MyEvent> _subscription;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tabController = TabController(length: data.length, vsync: this);

    // 订阅首页ASMR和种子下载点击事件
    _subscription = eventBus.on<MyEvent>().listen((event) {
      if (event.message == 'to-blogger') {
        int index = data.indexWhere((model) => model.type == 'blogger');
        if (index == -1) return;
        tabController?.index = index;
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel(); // 取消订阅
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarWithView.line(
      tabController: tabController,
      titles: data.map((e) => e.title).toList(),
      views: data.map((e) {
        if (e.type == 'chatgroup') {
          return const OriginAndGroupChatScreen();
        } else {
          return OriginalCommunityContentView(data: e);
        }
      }).toList(),
    );
  }
}
