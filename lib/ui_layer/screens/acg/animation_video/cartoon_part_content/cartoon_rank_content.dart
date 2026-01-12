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
import 'package:provider/provider.dart';

class CartoonRankContent extends StatefulWidget {
  const CartoonRankContent({super.key});

  @override
  State<CartoonRankContent> createState() => _CartoonRankContentState();
}

class _CartoonRankContentState extends State<CartoonRankContent> {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final List<RankNavigatorModel> _titles =
      _homeConfig.config.rankTopNav ?? [];

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(title: 'bd'.tr(context: context)),
        body: TabBarWithView.line(
          // tabBarHeight: 42.w,
          isCenter: true,
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