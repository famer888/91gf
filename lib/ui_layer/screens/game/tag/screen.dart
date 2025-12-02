import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/model/bit_nav_model.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/game/tag/content.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';

class GameTagScreen extends StatefulWidget {
  const GameTagScreen({super.key, required this.tag});

  final String tag;

  @override
  State<GameTagScreen> createState() => _GameTagScreenState();
}

class _GameTagScreenState extends State<GameTagScreen> {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final List<BitNavModel> titles = _homeConfig.config.gameTagSortNav ?? [];

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
    return Scaffold(body: configContentView());
  }

  Widget configContentView() {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: widget.tag,
        ),
        body: GameTagContent(tag: widget.tag),
      ),
    );
  }
}
