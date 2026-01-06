import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jygf/domain/async_value.dart';
import 'package:jygf/domain/model/community/community_model.dart';
import 'package:jygf/domain/model/navigator_model.dart';
import 'package:jygf/domain/remote_domain/domains/community.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/common_widgets/event_bus/event_bus.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/common_widgets/search_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/network_error.dart';
import 'package:jygf/ui_layer/screens/community/community_screen/content.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
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
      child: Scaffold(appBar: SearchAppBar(), body: _Body()),
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
  late final List<NavigatorModel> _titles = _config.forumNav ?? [];

  AsyncValue<List<CommunityCategoryTabModel>> _asyncValue = const AsyncInit();
  final List<CommunityCategoryTabModel> _categoryTabList = [];

  late StreamSubscription<MyEvent> _subscription;
  late final TabController? tabController;
  int _initialIndex = 0;

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    if (_asyncValue.isLoading) return;
    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final res = await _appDomain.getCategoryTabList();
    if (res.status == 1) {
      final categoryTabList = res.data;
      if (categoryTabList != null) {
        if (categoryTabList.isNotEmpty) {
          _categoryTabList.clear();
          _categoryTabList.addAll(categoryTabList);
          _initialIndex = _categoryTabList.indexWhere((e) => e.id == 1);
          tabController = TabController(initialIndex: _initialIndex, length: _categoryTabList.length, vsync: this);
          _asyncValue = AsyncData(_categoryTabList);
        } else {
          _asyncValue = const AsyncError();
        }
      } else {
        _asyncValue = const AsyncError();
      }
    } else {
      CommonUtils.log('社区分类tab出错:${res.msg}');
      _asyncValue = const AsyncError();
    }
    if (mounted) {
      setState(() {});
    }
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
        initialIndex: _initialIndex,
        titles: data.map((e) => e.title).toList(),
        views: data.map((e) {
          // if (e.type == 2) {//ASMR
          //   return const ASMRContentView();
          // } else if (e.type == 3) {//种子下载
          //   return const SeedDwonContentView();
          // } else {
          //
          // }
          // return Center(
          //   child: Text('煞笔'),
          // );
          return CommunityContentView(id: e.id);
        }).toList(),
      ),
      error: (_, __) => NetworkErrorView(onTap: _init),
      orElse: () => const LoadingView(),
    );
  }
}
