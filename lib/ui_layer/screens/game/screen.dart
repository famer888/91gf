import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/model/bit_nav_model.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/game/content/content.dart';
import 'package:jygf/ui_layer/screens/game/content/rec_content.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';

class YellowGameScreen extends StatefulWidget {
  const YellowGameScreen({super.key});

  @override
  State<YellowGameScreen> createState() => _YellowGameScreenState();
}

class _YellowGameScreenState extends State<YellowGameScreen> {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final List<BitNavModel> titles = _homeConfig.config.gameTopNav ?? [];

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
    return Scaffold(
        appBar: MyAppBar(
          title: 'hyou'.tr(context: context),
        ),
        body: configContentView());
  }

  Widget configContentView() {
    return TabBarWithView.line(
        // isNeedLine: false,
        tabBarPadding: EdgeInsets.symmetric(horizontal: 5.w),
        titles: titles.map((e) => e.name ?? '').toList(),
        views: titles.map((e) {
          if (e.type == 2) {
            //推荐
            return KeepAliveWrapper(
              child: GameRecContent(id: e.id),
            );
          } else {
            return KeepAliveWrapper(
              child: GameContent(id: e.id),
            );
          }
        }).toList());
  }
}
