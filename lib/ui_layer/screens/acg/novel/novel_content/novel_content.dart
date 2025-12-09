import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/model/novel_model.dart';
import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/bit_nav_model.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/remote_domain/domains/novel.dart';
import 'package:jygf/ui_layer/const.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/acg/novel/card/novel_item_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/general_banner.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';

class NovelContent extends StatefulWidget {
  const NovelContent({super.key, required this.id});

  final int id;

  @override
  State<NovelContent> createState() => _NovelContentState();
}

class _NovelContentState extends State<NovelContent> {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final List<BitNavModel> titles = _homeConfig.config.novelSort ?? [];
  final ValueNotifier<List<BannerModel>> _bannersNotifier = ValueNotifier([]);
  final ValueNotifier<List<TipModel>> _tipsNotifier = ValueNotifier([]);
  late final _domain = context.read<NovelDomain>();
  bool isInit = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<NovelItemsModel>?> _getData(
      {required String sort, required int page, required int pageSize}) async {
    final result = await _domain.novelSortList(
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
      if (result.data?.banner case final data?
      when data.isNotEmpty && _bannersNotifier.value.isEmpty) {
        _bannersNotifier.value = data;
      }
      if (result.data?.tips case final data?
      when data.isNotEmpty && _tipsNotifier.value.isEmpty) {
        _tipsNotifier.value = data;
      }

      return result.data?.novels;
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: cofigContentView());
  }
  Widget cofigContentView() {
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
        tabBarPadding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 5.w),
        tabBarHeight: 32.w,
        titles: isInit ? [for (final title in titles) title.title ?? ''] : [],
        views: [
          for (final BitNavModel nav in titles)
            KeepAliveWrapper(
              child: MyListView.grid(
                childAspectRatio: UILayerConst.pictureRatio,
                contentPadding: 10.w,
                crossAxisCount: 3,
                padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                itemBuilder: (context, item, index) => NovelItemCard(data: item),
                onFetchingMore: (currentPage, pageSize) => _getData(
                    sort: nav.sort ?? '', page: currentPage, pageSize: pageSize),
              ),
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
        ValueListenableBuilder(
          valueListenable: bannersNotifier,
          builder: (context, banners, child) {
            if (banners.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: GeneralBannerAppsListWidget(data: banners),
            );
          },
        ),
        SizedBox(height: 4.w),
        ValueListenableBuilder(
          valueListenable: tipsNotifier,
          builder: (context, tips, child) {
            if (tips.isEmpty) return const SizedBox.shrink();
            return CommonUtils.buildNotifyWidget(tips);
          },
        ),
        SizedBox(height: 5.w),
      ],
    );
  }
}
