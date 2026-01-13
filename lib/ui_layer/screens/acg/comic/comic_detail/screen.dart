import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/async_value.dart';
import 'package:jygf/domain/domain.dart';
import 'package:jygf/domain/model/comic_model.dart';
import 'package:jygf/domain/remote_domain/domains/comic.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/acg/comic/comic_detail/comic_chapert_rec_content.dart';
import 'package:jygf/ui_layer/screens/acg/comic/comic_detail/comic_comment_content.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/network_error.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';import 'package:jygf/report/ui_layer/report_general_banner.dart';




///漫画详情界面
class ComicDetalScreen extends StatefulWidget {
  const ComicDetalScreen({super.key, required this.id});

  final String id;

  @override
  State<ComicDetalScreen> createState() => _ComicDetalScreenState();
}

class _ComicDetalScreenState extends State<ComicDetalScreen> {
  late final _domain = context.read<ComicDomain>();

  AsyncValue<ComicDetailWithBannersModel> _asyncValue = const AsyncInit();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    PaintingBinding.instance.imageCache.clear();
    super.dispose();
  }

  _getData() async {
    if (_asyncValue.isLoading) return;
    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final res = await _domain.comicDetail(id: int.parse(widget.id));
    if (res.data case final data?) {
      _asyncValue = AsyncData(data);
    } else {
      if (res.msg case final msg? when msg.isNotEmpty) {
        MyToast.showText(text: msg);
      }
      _asyncValue = const AsyncError();
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
          appBar: MyAppBar(
            rightWidget: ReportGestureDetector(
              onTap: () {
                const MineShareToUserRoute().push(context);
              },
              child: MyImage.asset(MyImagePaths.appNavShare,
                  width: 25.w, height: 25.w),
            ),
          ),
          body: _asyncValue.maybeWhen(
            orElse: () => const LoadingView(),
            error: (_, __) => NetworkErrorView(onTap: _getData),
            data: (data) => cofigContentView(data),
          )),
    );
  }

  Widget cofigContentView(ComicDetailWithBannersModel data) {
    return NestedScrollView(
      headerSliverBuilder: (_, __) => [
        SliverToBoxAdapter(
          child: _Header(data: data, favoriteSucsess: (data) {
            setState(() {
              _asyncValue = AsyncData(data);
            });
          }),
        ),
      ],
      body: TabBarWithView.fillColor(
        tabBarPadding: EdgeInsets.symmetric(vertical: 5.w),
        tabBarHeight: 32.w,
        labelStyle: MyTheme.white255_16_M,
        unselectedLabelStyle: MyTheme.white08_15,
        // isCenter: true,
        isScrollable: false,
        titles: [
          'jj'.tr(context: context),
          '${'pl'.tr(context: context)}(${data.detail?.commentCt ?? 0})'
        ],
        views: [
          ComicChapertRecView(data: data, favoriteSucsess: (data) {
            setState(() {
              _asyncValue = AsyncData(data);
            });
          }),
          KeepAliveWrapper(child: ComicCommentView(id: data.detail?.id ?? 0))
        ],
      ),
    );
  }
}

class _Header extends StatefulWidget {
  const _Header({required this.data, this.favoriteSucsess});

  final ComicDetailWithBannersModel data;

  final Function(ComicDetailWithBannersModel data)? favoriteSucsess; //收藏成功回调刷新详情界面的收藏状态

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 150.w,
            child: Row(
              children: [
                SizedBox(
                    width: 100.w,
                    height: 137.w,
                    child: MyImage.network(
                      widget.data.detail?.cover ?? '',
                      borderRadius: 5.w,
                    )),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                    child: SizedBox(
                  height: 137.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.data.detail?.title ?? '',
                        style: MyTheme.white14,
                        maxLines: 3,
                      ),
                      Text(
                        '${'gkl'.tr(context: context)}: ${CommonUtils.renderFixedNumber(widget.data.detail?.viewFct ?? 0)}',
                        style: MyTheme.white04_12,
                      ),
                      Text(
                        (widget.data.detail?.isEnd == 1
                            ? "wj".tr(context: context)
                            : "lzz".tr(context: context)),
                        style: MyTheme.white04_12,
                      ),
                      Text(
                        '${'zhgx'.tr(context: context)}: ${widget.data.detail?.renewedAt}',
                        style: MyTheme.white04_12,
                        maxLines: 5,
                      ),
                      Builder(builder: (context) {
                        if ((widget.data.detail?.tag ?? '')
                            .toString()
                            .isEmpty) {
                          return Container();
                        }
                        List tags = '${widget.data.detail?.tag}'.split(',');
                        if (tags.length > 3) {
                          tags = tags.sublist(0, 3);
                        }
                        return Wrap(
                          runSpacing: 10.w,
                          spacing: 10.w,
                          children: tags
                              .map(
                                (tag) => InkWell(
                                  onTap: () {
                                    CommonUtils.log('点击标签：$tag');
                                    // Utils.navTo(context, "/homesearchpage?searchStr=$tag&index=7");
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.5.w, vertical: 2.w),
                                    decoration: BoxDecoration(
                                      color: MyTheme.white008Color,
                                      borderRadius: BorderRadius.circular(2.w),
                                    ),
                                    child: Text(
                                      tag,
                                      style: MyTheme.white09_10,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      }),
                    ],
                  ),
                ))
              ],
            ),
          ),
          (widget.data.detail?.intro?.isEmpty ?? false) ? SizedBox(height: MyTheme.pagePadding) :
          Padding(
            padding: EdgeInsets.only(top: 10.w, bottom: MyTheme.pagePadding),
            child: Text(
              widget.data.detail?.intro ?? '',
              style: MyTheme.white07_14,
              maxLines: 100,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: MyTheme.pagePadding),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    MyImage.asset(MyImagePaths.appViewIcon,
                        width: 20.w, height: 20.w),
                    SizedBox(width: 3.w),
                    Text(
                      '${CommonUtils.renderEnFixedNumber(widget.data.detail?.viewFct ?? 0)}',
                      style: MyTheme.white04_12,
                      maxLines: 1,
                    )
                  ]),
                  Row(children: [
                    MyImage.asset(MyImagePaths.appComicComment,
                        width: 20.w, height: 20.w),
                    SizedBox(width: 3.w),
                    Text(
                      '${CommonUtils.renderEnFixedNumber(widget.data.detail?.commentCt ?? 0)}',
                      style: MyTheme.white04_12,
                      maxLines: 1,
                    )
                  ]),
                  ReportGestureDetector(
                    onTap: _changeLike, //点赞
                    child: Row(children: [
                      MyImage.asset(
                          widget.data.detail?.isLike == 1
                              ? MyImagePaths.appCommReviewH
                              : MyImagePaths.appCommReviewN,
                          width: 21.w,
                          height: 21.w),
                      SizedBox(width: 3.w),
                      Text(
                        '${CommonUtils.renderEnFixedNumber(widget.data.detail?.likeFct ?? 0)}',
                        style: MyTheme.white04_12,
                        maxLines: 1,
                      )
                    ]),
                  ),
                  ReportGestureDetector(
                    onTap: _changeFavorite, //收藏
                    child: Row(children: [
                      MyImage.asset(
                          widget.data.detail?.isFavorite == 1
                              ? MyImagePaths.appCollectOn
                              : MyImagePaths.appCollectOff,
                          width: 18.w,
                          height: 18.w),
                      SizedBox(width: 3.w),
                      Text(
                        '${CommonUtils.renderEnFixedNumber(widget.data.detail?.favoriteFct ?? 0)}',
                        style: MyTheme.white04_12,
                        maxLines: 1,
                      )
                    ]),
                  ),
                ]),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5.w),
            child: ReportGeneralAppsListVidget(
                data: widget.data.banner ?? [], aspectRatio: 7 / 2),
          ),
        ],
      ),
    );
  }

  Future<void> _changeLike() async {
    final domain = context.read<UserDomain>();

    final result =
        await domain.userLike(type: 3, id: widget.data.detail?.id ?? 0);
    if (result.status == 1) {
      final oldValue = widget.data.detail?.isLike ?? 0;
      final newValue = oldValue == 0 ? 1 : 0;
      widget.data.detail?.isLike = newValue;
      if (newValue == 1) {
        widget.data.detail?.likeFct = (widget.data.detail?.likeFct ?? 0) + 1;
      } else {
        widget.data.detail?.likeFct = (widget.data.detail?.likeFct ?? 0) - 1;
      }
      if (mounted) {
        setState(() {

        });
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
  }

  Future<void> _changeFavorite() async {
    final domain = context.read<UserDomain>();

    final result =
        await domain.userFavorite(type: 3, id: widget.data.detail?.id ?? 0);
    if (result.status == 1) {
      final oldValue = widget.data.detail?.isFavorite ?? 0;
      final newValue = oldValue == 0 ? 1 : 0;
      widget.data.detail?.isFavorite = newValue;
      if (newValue == 1) {
        widget.data.detail?.favoriteFct =
            (widget.data.detail?.favoriteFct ?? 0) + 1;
      } else {
        widget.data.detail?.favoriteFct =
            (widget.data.detail?.favoriteFct ?? 0) - 1;
      }
      if (mounted) {
        setState(() {});
      }
      widget.favoriteSucsess?.call(widget.data);
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
  }
}
