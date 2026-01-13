import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/bit_nav_model.dart';
import 'package:jygf/domain/model/game/game_model.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/remote_domain/domains/game.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/common_widgets/game/card/game_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';import 'package:jygf/report/ui_layer/report_general_banner.dart';



class GameContent extends StatefulWidget {
  const GameContent({super.key, required this.id});

  final int id;

  @override
  State<GameContent> createState() => _GameContentState();
}

class _GameContentState extends State<GameContent> {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final List<BitNavModel> titles = _homeConfig.config.gameSortNav ?? [];
  final ValueNotifier<List<BannerModel>> _bannersNotifier = ValueNotifier([]);
  final ValueNotifier<List<TipModel>> _tipsNotifier = ValueNotifier([]);
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
      {required String sort, required int page, required int pageSize}) async {
    final result = await _domain.gameTheme(
      id: widget.id,
      sort: sort,
      page: page,
      limit: pageSize,
    );

    if (!isInit) {
      setState(() {
        isInit = true;
      });
    }

    if (result.status == 1) {
      if (result.data['banner'] case final List data
          when data.isNotEmpty && _bannersNotifier.value.isEmpty) {
        final banner = data.map((x) => BannerModel.fromJson(x)).toList();
        _bannersNotifier.value = banner;
      }

      if (result.data['tips'] case final List data
          when data.isNotEmpty && _tipsNotifier.value.isEmpty) {
        final tipss = data.map((x) => TipModel.fromJson(x)).toList();
        _tipsNotifier.value = tipss;
      }

      return result.data['games']
          ?.map<GameModel>((x) => GameModel.fromJson(x))
          .toList();
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
    return NestedScrollView(
      headerSliverBuilder: (_, __) => [
        SliverToBoxAdapter(
          child: _Header(
            bannersNotifier: _bannersNotifier,
            tipsNotifier: _tipsNotifier,
          ),
        ),
      ],
      body: TabBarWithView.fillColor(
        tabBarPadding: EdgeInsets.only(
            left: 13.w, right: 13.w, bottom: 5.w),
        titles: isInit ? [for (final title in titles) title.title ?? ''] : [],
        views: [
          for (final BitNavModel nav in titles)
            MyListView.grid(
              childAspectRatio: GameCard.aspectRatio,
              contentPadding: 10.w,
              mainAxisSpacing: 5.w,
              crossAxisCount: 2,
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              itemBuilder: (context, item, index) => GameCard(data: item),
              onFetchingMore: (currentPage, pageSize) => _getData(
                  sort: nav.sort ?? '', page: currentPage, pageSize: pageSize),
            )
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.bannersNotifier,
    required this.tipsNotifier,
  });

  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final ValueNotifier<List<TipModel>> tipsNotifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // SizedBox(height: 6.w),
        ValueListenableBuilder(
          valueListenable: bannersNotifier,
          builder: (context, banners, child) {
            if (banners.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: ReportGeneralAppsListVidget(data: banners),
            );
          },
        ),
        SizedBox(height: 4.w),
        ValueListenableBuilder(
          valueListenable: tipsNotifier,
          builder: (context, tips, child) {
            if (tips.isEmpty) return SizedBox(height: 5.w);
            return CommonUtils.buildNotifyWidget(tips);
          },
        ),
        SizedBox(height: 5.w),
      ],
    );
  }
}
