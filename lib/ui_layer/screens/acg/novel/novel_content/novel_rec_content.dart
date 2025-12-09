import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/model/comic_model.dart';
import 'package:jygf/domain/model/novel_model.dart';
import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/bit_nav_model.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/model/part_nav_model.dart';
import 'package:jygf/domain/remote_domain/domains/novel.dart';
import 'package:jygf/ui_layer/const.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/acg/comic/card/comic_ad_card.dart';
import 'package:jygf/ui_layer/screens/acg/novel/card/novel_item_card.dart';
import 'package:jygf/ui_layer/screens/acg/novel/card/novel_re_item_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/general_banner.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';

class NovelRecContent extends StatefulWidget {
  const NovelRecContent({super.key, required this.id});

  final int id;

  @override
  State<NovelRecContent> createState() => _NovelRecContentState();
}

class _NovelRecContentState extends State<NovelRecContent> {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  final ValueNotifier<List<BannerModel>> _bannersNotifier = ValueNotifier([]);
  final ValueNotifier<List<TipModel>> _tipsNotifier = ValueNotifier([]);
  final ValueNotifier<List<PartModel>> _partNotifier = ValueNotifier([]);
  final ValueNotifier<List<NovelItemsModel>> _likesNotifier = ValueNotifier([]);
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

  Future<List<RecNovelModel>?> _getData(
      {required int page, required int pageSize}) async {
    final result = await _domain.novelReComment(
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
      if (result.data?.nav case final data?
      when data.isNotEmpty && _partNotifier.value.isEmpty) {
        _partNotifier.value = data;
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
    return MyListView.list(
      contentPadding: MyTheme.pagePadding,
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      header: _Header(
        bannersNotifier: _bannersNotifier,
        tipsNotifier: _tipsNotifier,
        partNotifier: _partNotifier,
      ),
      itemBuilder: (context, item, index) {
        if (item.url != null && item.url!.isNotEmpty) {
          return ComicAdCard(data: RecComicModel.fromJson(item.toJson()));
        } else {
          return NovelReItemCard(data: item);
        }
      },
      onFetchingMore: (currentPage, pageSize) =>
          _getData(page: currentPage, pageSize: pageSize),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(
      {required this.bannersNotifier,
        required this.tipsNotifier,
        required this.partNotifier,
      });

  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final ValueNotifier<List<TipModel>> tipsNotifier;
  final ValueNotifier<List<PartModel>> partNotifier;

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
        ValueListenableBuilder(
          valueListenable: tipsNotifier,
          builder: (context, tips, child) {
            if (tips.isEmpty) return const SizedBox.shrink();
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
                      //漫画分类，最新，完结，排行榜点击
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
      ],
    );
  }
}
