import 'package:flutter/material.dart';
import 'package:jygf/domain/model/bit_nav_model.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/acg/yellow_game/content/content.dart';
import 'package:jygf/ui_layer/screens/acg/yellow_game/content/rec_content.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:provider/provider.dart';

class YellowGameScreen extends StatefulWidget {
  const YellowGameScreen({super.key});

  @override
  State<YellowGameScreen> createState() => _YellowGameScreenState();
}

class _YellowGameScreenState extends State<YellowGameScreen> with TickerProviderStateMixin {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final List<BitNavModel> titles = _homeConfig.config.gameTopNav ?? [];
  late final TabController? tabController;
  int _initialIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: _initialIndex, length: titles.length, vsync: this);
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
        tabController: tabController,
        initialIndex: _initialIndex,
        titles: titles.map((e) => e.name).toList(),
        views: titles.map((e) {
          if (e.type == 2) {
            //推荐
            return KeepAliveWrapper(child: GameRecContent(id: e.id));
          } else {
            return KeepAliveWrapper(child: GameContent(id: e.id));
          }
        }).toList());
  }
}
