import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/model/bit_nav_model.dart';
import 'package:jygf/domain/model/vlog_model.dart';
import 'package:jygf/domain/remote_domain/domains/vlog.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/acg/animation_video/cartoon_content_view.dart';
import 'package:jygf/ui_layer/screens/acg/animation_video/cartoon_rec_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
class AnimationVideo extends StatefulWidget {
  const AnimationVideo({super.key});

  @override
  State<AnimationVideo> createState() => _AnimationVideoState();
}

class _AnimationVideoState extends State<AnimationVideo>
    with TickerProviderStateMixin {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final List<BitNavModel> titles = _homeConfig.config.cartoonTopNav ?? [];
  // late final _domain = context.read<VlogDomain>();
  bool isInit = false;
  List<VlogModel> array = [];

  late final TabController _tabController;

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    _tabController = TabController(length: titles.length, vsync: this);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return TabBarWithView.line(
      tabBarHeight: 32.w,
      tabBarPadding: EdgeInsets.symmetric(vertical: 5.w),
      tabController: _tabController,
      titles: titles.map((e) => e.name ?? '').toList(),
      views: titles.map(
            (e) => KeepAliveWrapper(
                child: e.type == 2
                    ? CartoonRecView(linkModel: e, onLinkNavTap: (value) {})
                    : CartoonContentView(
                        linkModel: e,
                        onLinkNavTap: (value) {
                          // if (titles.indexWhere((element) => element.linkUrl == value)
                          //     case final index when index != -1) {
                          //   _tabController.index = index;
                          // }
                        },
                      )),
          ).toList(),
    );
  }
}
