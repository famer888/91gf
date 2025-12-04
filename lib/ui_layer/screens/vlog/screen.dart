import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/async_value.dart';
import 'package:jygf/domain/model/navigator_model.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/ai_server/screen.dart';
import 'package:jygf/ui_layer/screens/asmr/asmr_content.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/network_error.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/live_video/live_nav/broadcastTopNavView.dart';
import 'package:flutter/material.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/common_widgets/search_app_bar.dart';
import 'package:jygf/ui_layer/screens/live_video/live_nav/broadcastTopNavView.dart';
import 'package:jygf/ui_layer/screens/live_video/live_nav/screen.dart';
import 'package:jygf/ui_layer/screens/live_video/live_sub_screen/screen.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/screens/vlog/discover_screen.dart';
import 'package:jygf/ui_layer/screens/vlog/vlog_focus_page.dart';
import 'package:jygf/ui_layer/screens/vlog/vlog_play_screen.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:provider/provider.dart';

class VlogScreen extends StatefulWidget {
  const VlogScreen({super.key});

  @override
  State<VlogScreen> createState() => _VlogScreenState();
}

class _VlogScreenState extends State<VlogScreen> with TickerProviderStateMixin {
  late final config = context.read<HomeConfigNotifier>().config;
  late final navList = config.vlogNav ?? [];
  AsyncValue<List<VlogNavigatorModel>> _asyncValue = const AsyncInit();
  late final TabController _tabController;

  final GlobalKey _globalKey = GlobalKey();
  final GlobalKey<VlogPlayScreenState> _globalVlogPageKey =
      GlobalKey<VlogPlayScreenState>();
  int? selSortIndex;

  int initialIndex = 0;

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

    for (var element in navList) {
      if (element.value == 2) {
        initialIndex = navList.indexOf(element);
      }
    }
    _tabController = TabController(
        length: navList.length, vsync: this, initialIndex: initialIndex);
    _asyncValue = AsyncData(navList);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return _asyncValue.maybeWhen(
      data: (data) => Scaffold(
        // appBar: SearchAppBar(),
        body: Stack(
          children: [
            TabBarWithView.image(
              selectedImgs:const [MyImagePaths.appDiscoverHkj,MyImagePaths.appDiscoverZb,MyImagePaths.appDiscoverDsp,MyImagePaths.appDiscoverYs],
              labelPadding: 20.w,
              tabController: _tabController,
              tabBarPadding: EdgeInsets.only(top: MyTheme.statusHeight

                  // MyTheme.navbarHegiht,
                  ),
              isStack: true,
              isCenter: true,
              initialIndex: initialIndex,
              titles: data.map((e) => e.label).toList(),
              views: navList.map((e) {
                if (e.value == 1) {
                  return KeepAliveWrapper(
                    child: AiServerScreen(
                      needNavi: false,
                      topPadding: MyTheme.statusHeight + MyTheme.navbarHegiht,
                    ),
                  );
                } else if (e.value == 2) {
                   return const LiveBroadcastScreen();
                  

                  // return KeepAliveWrapper(
                  //   child: Padding(
                  //     padding: EdgeInsets.only(
                  //         top: MyTheme.statusHeight + MyTheme.navbarHegiht),
                  //     child: const BroadcastTopNavView(),
                  //   ),
                  // );
                } else if (e.value == 3) {
                  return (selSortIndex == null || selSortIndex == 0)
                      ? Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: VlogPlayScreen(
                            apiUrl: 'vlog/list_sort',
                          ),
                        )
                      : KeepAliveWrapper(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: VlogPlayScreen(
                              key: _globalVlogPageKey,
                              apiUrl: 'vlog/list_sort',
                              selSortIndex: selSortIndex,
                            ),
                          ),
                        );
                 
                } else if (e.value == 4) {
                  return  KeepAliveWrapper(
                    child: ASMRContentView(topPadding: MyTheme.statusHeight + MyTheme.navbarHegiht),
                  );
                } else {
                  return Container();
                }
              }).toList(),
            ),
          ],
        ),
      ),
      error: (_, __) => NetworkErrorView(onTap: _init),
      orElse: () => const LoadingView(),
    );
  }
}
