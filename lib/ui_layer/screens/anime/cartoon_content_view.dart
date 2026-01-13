import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/bit_nav_model.dart';
import 'package:jygf/domain/model/cartoon/cartoon_model.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/model/nav_model.dart';
import 'package:jygf/domain/model/part_nav_model.dart';
import 'package:jygf/domain/remote_domain/domains/cartoon.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/cartoon/card/video_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';import 'package:jygf/report/ui_layer/report_general_banner.dart';




class CartoonContentView extends StatefulWidget {
  const CartoonContentView(
      {super.key, required this.linkModel, required this.onLinkNavTap});

  final BitNavModel linkModel;
  final ValueChanged<String> onLinkNavTap;

  @override
  State<CartoonContentView> createState() => _CartoonContentViewState();
}

class _CartoonContentViewState extends State<CartoonContentView> {
  late final _appDomain = context.read<CartoonDomain>();
  late final _homeConfig = context.read<HomeConfigNotifier>();
  final ValueNotifier<List<BannerModel>> bannersNotifier = ValueNotifier([]);
  final ValueNotifier<List<TipModel>> tipsNotifier = ValueNotifier([]);
  final ValueNotifier<List<PartModel>> partNotifier = ValueNotifier([]);
  late final List<BitNavModel> titles = _homeConfig.config.cartoonSortNav ?? [];

  bool isInit = false;
  List<TipModel> tips = [];

  @override
  void initState() {
    super.initState();
  }

  Future<List<CartoonModel>?> _getData({
    required String sort,
    required int page,
    required int pageSize,
  }) async {
    final result = await _appDomain.cartoonTheme(
        id: widget.linkModel.id ?? 0, sort: sort, page: page);

    if (!isInit) {
      setState(() {
        isInit = true;
      });
    }

    if (result.status == 1) {
      if (result.data['banner'] case final List data
          when data.isNotEmpty && bannersNotifier.value.isEmpty) {
        final banner = data.map((x) => BannerModel.fromJson(x)).toList();
        bannersNotifier.value = banner;
      }

      if (result.data['tips'] case final List data
          when data.isNotEmpty && tipsNotifier.value.isEmpty) {
        final tipss = data.map((x) => TipModel.fromJson(x)).toList();
        tipsNotifier.value = tipss;
      }

      // if (result.data['part'] case final List data
      //     when data.isNotEmpty && partNotifier.value.isEmpty) {
      //   final part = data.map((x) => PartModel.fromJson(x)).toList();
      //   partNotifier.value = part;
      // }
      return result.data['cartoons']
          ?.map<CartoonModel>((x) => CartoonModel.fromJson(x))
          .toList();
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (_, __) => [
        SliverToBoxAdapter(
          child: _Header(
            bannersNotifier: bannersNotifier,
            partNotifier: partNotifier,
            tipsNotifier: tipsNotifier,
            onLinkNavTap: widget.onLinkNavTap,
          ),
        ),
      ],
      body:
        TabBarWithView.fillColor(
        tabBarPadding: EdgeInsets.only(
            left: 13.w, right: 13.w, bottom: 5.w),
        titles: isInit ? [for (final title in titles) title.title ?? ''] : [],
        views: [
          for (final BitNavModel nav in titles)
            KeepAliveWrapper(
                child: MyListView.grid(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              childAspectRatio: CartoonVideoCard.aspectRatio,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 5.w,
              itemBuilder: (context, item, index) =>
                  CartoonVideoCard(data: item),
              onFetchingMore: (currentPage, pageSize) => _getData(
                sort: nav.sort ?? '0',
                page: currentPage,
                pageSize: pageSize,
              ),
            ))
        ],
      ),
    );
  }
}

class _Header extends StatefulWidget {
  const _Header({
    required this.bannersNotifier,
    required this.partNotifier,
    required this.tipsNotifier,
    required this.onLinkNavTap,
  });

  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final ValueNotifier<List<PartModel>> partNotifier;
  final ValueNotifier<List<TipModel>> tipsNotifier;
  final ValueChanged<String> onLinkNavTap;

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  List<NavModel> contentTopics = [];
  bool isShowAllTopics = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // SizedBox(height: 6.w),
        ValueListenableBuilder(
          valueListenable: widget.bannersNotifier,
          builder: (context, banners, child) {
            if (banners.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: ReportGeneralAppsListVidget(data: banners),
            );
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: 5.w, bottom: 10.w),
          child: CommonUtils.buildNotifyWidget(widget.tipsNotifier.value),
        ),
        ValueListenableBuilder(
          valueListenable: widget.partNotifier,
          builder: (context, parts, child) {
            if (parts.isEmpty) return const SizedBox.shrink();
            return Stack(
              children: [
                // Padding(
                //   padding: EdgeInsets.all(MyTheme.pagePadding),
                //   child: const MyImage.asset(MyImagePaths.appHomeBtnBg,
                //       fit: BoxFit.fill),
                // ),
                GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: parts.length,
                    padding:
                        EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 80.w / 70.w,
                      mainAxisSpacing: 10.w,
                      crossAxisSpacing: 10.w,
                    ),
                    itemBuilder: (context, index) {
                      final partsItem = parts[index];
                      return ReportGestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          final linkUrl = partsItem.urlStr;
                          final redirectType = partsItem.redirectType;
                          if (linkUrl.isEmpty) {
                            return;
                          }
                          if (redirectType < 3) {
                            CommonUtils.openRoute(context, partsItem.toJson());
                          } else {
                            if (partsItem.type == '0') {
                              widget.onLinkNavTap(linkUrl);
                            } else if (partsItem.type == '1') {
                              MoreVideoRoute(name: partsItem.title, id: linkUrl)
                                  .push(context);
                            }
                          }
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
                                partsItem.title,
                                style: MyTheme.white13,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ],
            );
          },
        ),
        // SizedBox(height: 5.w),
      ],
    );
  }
}
