import 'package:flutter/material.dart';
import 'package:jygf/app_global.dart';
import 'package:provider/provider.dart';

import '../../notifiers/home_config_notifier.dart';
import '../common_widgets/screen_background.dart';
import '../common_widgets/top_navi_view.dart';
import '../common_widgets/search_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final homeConfigNotifier = context.read<HomeConfigNotifier>();
  late final id = homeConfigNotifier.config.navId;

  @override
  Widget build(BuildContext context) {
    AppGlobal.context = context;
    return ScreenBackground(
      child: Scaffold(
        appBar: const SearchAppBar(),
        body: TopNaviView(id: id),
      ),
    );
  }
}
