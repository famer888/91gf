import 'package:flutter/material.dart';
import 'package:jygf/domain/async_value.dart';
import 'package:jygf/domain/model/bit_nav_model.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/network_error.dart';
import 'package:jygf/ui_layer/screens/live_video/live_sub_screen/rec_screen.dart';
import 'package:jygf/ui_layer/screens/live_video/live_sub_screen/screen.dart';
import 'package:provider/provider.dart';

class BroadcastTopNavView extends StatefulWidget {
  const BroadcastTopNavView({super.key});

  @override
  State<BroadcastTopNavView> createState() => _TopNaviViewState();
}

class _TopNaviViewState extends State<BroadcastTopNavView>
    with TickerProviderStateMixin {
  late final config = context.read<HomeConfigNotifier>().config;
  late final navList = config.liveTopNav;
  AsyncValue<List<BitNavModel>> _asyncValue = const AsyncInit();
  late final TabController _tabController;
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

    _tabController = TabController(length: navList.length, vsync: this);
    _asyncValue = AsyncData(navList);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return _asyncValue.maybeWhen(
      data: (data) => TabBarWithView.line(
        tabController: _tabController,
        titles: data.map((e) => e.name).toList(),
        views: navList.map((e) {
          if (e.uiType == 0) {
            return RecLiveVideoView(nav: e, moreClickCallBack: (title) {
              //点击更多，滑动到对应栏目
              int index = navList.indexWhere((element) => element.name == title);
              _tabController.index = index;
            });
          } else {
            return LiveVideoView(nav: e);
          }
        }).toList(),
      ),
      error: (_, __) => NetworkErrorView(onTap: _init),
      orElse: () => const LoadingView(),
    );
  }
}
