import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/model/bit_nav_model.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/acg/novel/novel_content/novel_content.dart';
import 'package:jygf/ui_layer/screens/acg/novel/novel_content/novel_follow_content.dart';
import 'package:jygf/ui_layer/screens/acg/novel/novel_content/novel_rec_content.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/theme.dart';

class NovelScreen extends StatefulWidget {
  const NovelScreen({super.key});

  @override
  State<NovelScreen> createState() => _NovelScreenState();
}

class _NovelScreenState extends State<NovelScreen> {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final List<BitNavModel> titles = List.from(_homeConfig.config.novelNav ?? []);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: cofigContentView());
  }

  Widget cofigContentView() {
    return TabBarWithView.line(
        tabBarPadding: EdgeInsets.only( bottom: 5.w),
        titles: titles.map((e) => e.name ?? '').toList(),
        views: titles.map((e) {
          if(e.type == 3){
            //关注
            return const KeepAliveWrapper(
              child: NovelFollowContent(),
            );
          } else if (e.type == 2) {
            //推荐
            return KeepAliveWrapper(
              child: NovelRecContent(id: e.id ?? 0),
            );
          } else {
            return KeepAliveWrapper(
              child: NovelContent(id: e.id ?? 0),
            );
          }
        }).toList());
  }
}
