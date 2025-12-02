import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jygf/domain/async_value.dart';
import 'package:jygf/domain/model/bit_nav_model.dart';
import 'package:jygf/domain/remote_domain/domains/community.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/common_widgets/event_bus/event_bus.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/common_widgets/search_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/network_error.dart';
import 'package:jygf/ui_layer/screens/asmr/asmr_content.dart';
import 'package:jygf/ui_layer/screens/community/community_screen/content.dart';
import 'package:jygf/ui_layer/screens/community/community_screen/seed_down_content.dart';
import 'package:provider/provider.dart';


class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {

  @override
  Widget build(BuildContext context) {
    return const ScreenBackground(
      child: Scaffold(
        appBar: SearchAppBar(),
        body: _Body()
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
  late final _appDomain = context.read<CommunityDomain>();
  late final _config = context.read<HomeConfigNotifier>().config;
  AsyncValue<List<BitNavModel>> _asyncValue = const AsyncInit();
  late StreamSubscription<MyEvent> _subscription;
  late final TabController? tabController;
  List<BitNavModel> navList = [];

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {

    navList = _config.communityNav;

    if (_asyncValue.isLoading) return;
    setState(() {
      _asyncValue = const AsyncLoading();
    });

    tabController = TabController(length: navList.length, vsync: this);

    // 订阅首页ASMR和种子下载点击事件
    _subscription = eventBus.on<MyEvent>().listen((event) {
      if (event.message == 'to-asmr') {
        int index = navList.indexWhere((model) => model.type == 2);
        if (index == -1) return;
        tabController?.index = index;
      } else if (event.message == 'to-torrentDownload') {
        int index = navList.indexWhere((model) => model.type == 3);
        if (index == -1) return;
        tabController?.index = index;
      }
    });

    setState(() {
      if (navList.isNotEmpty) {
        _asyncValue = AsyncData(navList);
      } else {
        _asyncValue = const AsyncError();
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
    return _asyncValue.maybeWhen(
      data: (data) => TabBarWithView.line(
        tabController: tabController,
        titles: data.map((e) => e.title ?? '').toList(),
        views: data.map((e) {
          if (e.type == 2) {//ASMR
            return const ASMRContentView();
          } else if (e.type == 3) {//种子下载
            return const SeedDwonContentView();
          } else {
            return CommunityContentView(id: e.id);
          }
        }).toList(),
      ),
      error: (_, __) => NetworkErrorView(onTap: _init),
      orElse: () => const LoadingView(),
    );
  }
}
