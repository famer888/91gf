import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/game/game_model.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/model/navigator_model.dart';
import 'package:jygf/domain/model/part_nav_model.dart';
import 'package:jygf/domain/remote_domain/domains/game.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/common_widgets/game/card/game_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

class GameNavScreen extends StatefulWidget {
  const GameNavScreen({super.key, required this.type, required this.title});

  final String type;
  final String title;

  @override
  State<GameNavScreen> createState() => _GameNavScreenState();
}

class _GameNavScreenState extends State<GameNavScreen> {
  late final _appDomain = context.read<GameDomain>();
  late final _homeConfig = context.read<HomeConfigNotifier>();
  final ValueNotifier<List<BannerModel>> bannersNotifier = ValueNotifier([]);
  final ValueNotifier<List<TipModel>> tipsNotifier = ValueNotifier([]);
  final ValueNotifier<List<PartModel>> partNotifier = ValueNotifier([]);
  late final List<NavigatorModel> titles = _homeConfig.config.sortNav ?? [];

  bool isInit = false;
  List<TipModel> tips = [];

  @override
  void initState() {
    super.initState();

    _getData(page: 1, pageSize: 15, type: widget.type);
  }

  Future<List<GameModel>?> _getData({
    required int page,
    required int pageSize,
    required String type,
  }) async {
    final result =
        await _appDomain.gameNav(type: type, page: page, limit: pageSize);

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
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: widget.title,
        ),
        body: MyListView.grid(
          padding: EdgeInsets.symmetric(
              horizontal: MyTheme.pagePadding, vertical: 8.w),
          childAspectRatio: GameCard.aspectRatio,
          crossAxisSpacing: 8.w,
          itemBuilder: (context, item, index) => GameCard(data: item),
          onFetchingMore: (currentPage, pageSize) => _getData(
              page: currentPage, pageSize: pageSize, type: widget.type),
        ),
      ),
    );
  }
}
