import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/async_value.dart';
import 'package:jygf/domain/domain.dart';
import 'package:jygf/domain/model/novel_model.dart';
import 'package:jygf/domain/remote_domain/domains/novel.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/acg/novel/novel_detail/novel_comment_content.dart';
import 'package:jygf/ui_layer/screens/acg/novel/novel_detail/novel_intro_content.dart';
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




///小说详情界面
class NovelDetalScreen extends StatefulWidget {
  const NovelDetalScreen({super.key, required this.id});

  final String id;

  @override
  State<NovelDetalScreen> createState() => _NovelDetalScreenState();
}

class _NovelDetalScreenState extends State<NovelDetalScreen> {
  late final _domain = context.read<NovelDomain>();

  AsyncValue<NovelDetailWithBannersModel> _asyncValue = const AsyncInit();

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

    final res = await _domain.novelDetail(id: int.parse(widget.id));
    if (res.data case final data?) {
      if ((data.detail?.likeCt == 0 && data.detail?.isLike == 1)) {
        data.detail?.likeCt = 1;
      }
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

  Widget cofigContentView(NovelDetailWithBannersModel data) {
    return NestedScrollView(
      headerSliverBuilder: (_, __) => [
        SliverToBoxAdapter(
          child: _Header(
              data: data,
              favoriteSucsess: (data) {
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
          NovelIntroContent(
              data: data,
              favoriteSucsess: (data) {
                setState(() {
                  _asyncValue = AsyncData(data);
                });
              }),
          KeepAliveWrapper(child: NovelCommentContent(id: data.detail?.id ?? 0))
        ],
      ),
    );
  }
}

class _Header extends StatefulWidget {
  const _Header({required this.data, this.favoriteSucsess});

  final NovelDetailWithBannersModel data;

  final Function(NovelDetailWithBannersModel data)?
      favoriteSucsess; //收藏成功回调刷新详情界面的收藏状态

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
                        maxLines: 2,
                      ),
                      widget.data.detail?.isEnd == 1
                          ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(255, 46, 49, 0.3),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2.w)),
                              ),
                              child: Text(
                                ("wj".tr(context: context)),
                                style: MyTheme.white08_15,
                              ))
                          : Container(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(0, 157, 255, 0.3),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2.w)),
                              ),
                              child: Text(
                                ("lzz".tr(context: context)),
                                style: MyTheme.jellyCyan_11,
                              )),
                      Text(
                        '${CommonUtils.renderFixedNumber(widget.data.detail?.fontCt ?? 0)}字',
                        style: MyTheme.white14,
                      ),
                      Text(
                        '${'zhgx'.tr(context: context)}: ${widget.data.detail?.renewedAt}',
                        style: MyTheme.white04_12,
                        maxLines: 5,
                      ),
                      Text(
                        '${'zuoz'.tr(context: context)}: ${widget.data.detail?.author}',
                        style: MyTheme.white07_12,
                        maxLines: 5,
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: MyTheme.pagePadding, top: 8.w),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    MyImage.asset(MyImagePaths.appNovelViewCount,
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
                              ? MyImagePaths.appThumbUpOnIcon
                              : MyImagePaths.appThumbUpOffIcon,
                          iconColor: widget.data.detail?.isLike == 1 ? MyTheme.primaryColor : null,
                          width: 21.w,
                          height: 21.w,),
                      SizedBox(width: 3.w),
                      Text(
                        '${CommonUtils.renderEnFixedNumber(widget.data.detail?.likeCt ?? 0)}',
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
                              ? MyImagePaths.appGameCollectOn
                              : MyImagePaths.appCollectOff,
                          iconColor: widget.data.detail?.isFavorite == 1 ? MyTheme.primaryColor : null,
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
          (widget.data.banner?.isEmpty ?? false)
              ? Container()
              : Padding(
                  padding: EdgeInsets.only(bottom: 5.w),
                  child: ReportGeneralAppsListVidget(
                      data: widget.data.banner ?? [], aspectRatio: 7 / 2),
                ),
        ],
      ),
    );
  }

  Future<void> _changeLike() async {
    final domain = context.read<NovelDomain>();

    final result =
        await domain.novelLike(id: widget.data.detail?.id ?? 0);
    if (result.status == 1) {
      final oldValue = widget.data.detail?.isLike ?? 0;
      final newValue = oldValue == 0 ? 1 : 0;
      widget.data.detail?.isLike = newValue;
      if (newValue == 1) {
        widget.data.detail?.likeCt = (widget.data.detail?.likeCt ?? 0) + 1;
      } else {
        widget.data.detail?.likeCt = (widget.data.detail?.likeCt ?? 0) - 1;
      }
      if (mounted) {
        setState(() {});
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
  }

  Future<void> _changeFavorite() async {
    final domain = context.read<NovelDomain>();

    final result = await domain.novelFavorite(id: widget.data.detail?.id ?? 0);
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
