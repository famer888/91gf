import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/bit_nav_model.dart';
import 'package:jygf/domain/model/game/game_section/game_section_model.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/model/part_nav_model.dart';
import 'package:jygf/domain/remote_domain/domains/game.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/common_widgets/game/cartoon_section_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/general_banner.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';

class GameRecContent extends StatefulWidget {
  const GameRecContent({super.key, required this.id});

  final int id;

  @override
  State<GameRecContent> createState() => _GameRecContentState();
}

class _GameRecContentState extends State<GameRecContent> {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final List<BitNavModel> titles = _homeConfig.config.comicSortNav ?? [];
  final ValueNotifier<List<BannerModel>> _bannersNotifier = ValueNotifier([]);
  final ValueNotifier<List<PartModel>> _partNotifier = ValueNotifier([]);
  final ValueNotifier<List<TipModel>> _tipsNotifier = ValueNotifier([]);

  late final _domain = context.read<GameDomain>();
  bool isInit = false;

  @override
  void initState() {
    super.initState();
    _getData(page: 1, pageSize: 15);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<GameSectionModel>?> _getData({required int page, required int pageSize}) async {
    final result = await _domain.gameRec(
      id: widget.id,
      page: page,
      limit: pageSize,
    );

    if (!isInit) {
      setState(() {
        isInit = true;
      });
    }

    if (result.status == 1) {
      if (result.data['banner'] case final List data when data.isNotEmpty && _bannersNotifier.value.isEmpty) {
        final banner = data.map((x) => BannerModel.fromJson(x)).toList();
        _bannersNotifier.value = banner;
      }

      if (result.data['tips'] case final List data when data.isNotEmpty && _tipsNotifier.value.isEmpty) {
        final tipss = data.map((x) => TipModel.fromJson(x)).toList();
        _tipsNotifier.value = tipss;
      }

      if (result.data['nav'] case final List data when data.isNotEmpty && _partNotifier.value.isEmpty) {
        final part = data.map((x) => PartModel.fromJson(x)).toList();
        _partNotifier.value = part;
      }

      return result.data['games']?.map<GameSectionModel>((x) => GameSectionModel.fromJson(x)).toList();
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
    return Scaffold(
      body: MyListView.list(
        header: _Header(
          bannersNotifier: _bannersNotifier,
          tipsNotifier: _tipsNotifier,
          partNotifier: _partNotifier,
        ),
        contentPadding: 15.w,
        padding: EdgeInsets.only(left: MyTheme.pagePadding, right: MyTheme.pagePadding, top: 5.w),
        itemBuilder: (context, item, index) => GameSectionCard(model: item),
        onFetchingMore: (currentPage, pageSize) => _getData(page: currentPage, pageSize: pageSize),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.bannersNotifier,
    required this.partNotifier,
    required this.tipsNotifier,
  });

  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final ValueNotifier<List<PartModel>> partNotifier;
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
              child: GeneralBannerAppsListWidget(data: banners),
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
        ValueListenableBuilder(
          valueListenable: partNotifier,
          builder: (context, parts, child) {
            if (parts.isEmpty) return const SizedBox.shrink();
            return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: parts.length,
                padding: EdgeInsets.all(MyTheme.pagePadding),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 80.w / 70.w,
                  mainAxisSpacing: 10.w,
                  crossAxisSpacing: 10.w,
                ),
                itemBuilder: (context, index) {
                  final partsItem = parts[index];
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      CommonUtils.openRoute(context, partsItem.toJson());
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 45.w,
                          child: MyImage.network(
                            partsItem.icon,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Center(
                          child: Text(
                            partsItem.title ?? '',
                            style: MyTheme.white13,
                          ),
                        ),
                      ],
                    ),
                  );
                });
          },
        ),
        // SizedBox(height: 5.w),
      ],
    );
  }
}
