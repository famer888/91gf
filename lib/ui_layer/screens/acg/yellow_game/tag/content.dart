import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/model/bit_nav_model.dart';
import 'package:jygf/domain/model/game/game_model.dart';
import 'package:jygf/domain/remote_domain/domains/game.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/common_widgets/game/card/game_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';

class GameTagContent extends StatefulWidget {
  const GameTagContent({super.key, required this.tag});

  final String tag;

  @override
  State<GameTagContent> createState() => _GameTagContentState();
}

class _GameTagContentState extends State<GameTagContent> {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final List<BitNavModel> titles = _homeConfig.config.gameTagSortNav ?? [];
  late final _domain = context.read<GameDomain>();
  bool isInit = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<GameModel>?> _getData(
      {required String type, required int page, required int pageSize}) async {
    final result = await _domain.gameTag(
      tag: widget.tag,
      type: type,
      page: page,
      limit: pageSize,
    );

    if (!isInit) {
      setState(() {
        isInit = true;
      });
    }

    if (result.status == 1) {
      return result.data;
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: configContentView());
  }

  Widget configContentView() {
    return TabBarWithView.fillColor(
      tabBarPadding: EdgeInsets.only(bottom: 5.w),
      tabBarHeight: 32.w,
      labelStyle: MyTheme.white14Medium,
      unselectedLabelStyle: MyTheme.white07_14,
      titles: isInit ? [for (final title in titles) title.title ?? ''] : [],
      views: [
        for (final BitNavModel nav in titles)
          MyListView.grid(
            childAspectRatio: GameCard.aspectRatio,
            contentPadding: 10.w,
            crossAxisCount: 2,
            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
            itemBuilder: (context, item, index) => GameCard(data: item),
            onFetchingMore: (currentPage, pageSize) => _getData(
                type: nav.sort ?? '', page: currentPage, pageSize: pageSize),
          )
      ],
    );
  }
}
