import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/navigator_model.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/rank/content.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:provider/provider.dart';

class RankScreen extends StatefulWidget {
  const RankScreen({super.key});

  @override
  State<RankScreen> createState() => _RankScreenState();
}

class _RankScreenState extends State<RankScreen> {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final List<RankNavigatorModel> _titles = _homeConfig.config.rankTopNav ?? [];

  @override
  Widget build(BuildContext context) {

    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(title: 'bd'.tr(context: context)),
        body: TabBarWithView.line(
          tabBarPadding: EdgeInsets.symmetric(
            vertical: 0.w,
            horizontal: MyTheme.pagePadding,
          ),
          labelStyle: MyTheme.jellyCyan_15,
          unselectedLabelStyle: TextStyle(
            color: const Color.fromRGBO(255, 255, 255, 1),
            fontSize: 15.sp,
            overflow: TextOverflow.visible,
            decoration: TextDecoration.none,
          ),
          tabBarHeight: 40.w,
          isScrollable: false,
          titles: _titles.map((model) => model.title ?? '').toList(),
          views: _titles.map((model) {
            return KeepAliveWrapper(
              child: RankContentScreen(data: model),
            );
          }).toList(),
        ),
      ),
    );
  }
}
