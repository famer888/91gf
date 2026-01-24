import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/model/game/game_detail_model.dart';
import 'package:jygf/domain/model/game/game_model.dart';
import 'package:jygf/domain/remote_domain/domains/game.dart';
import 'package:jygf/report/ui_layer/report_general_banner.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';
import 'package:jygf/ui_layer/screens/black/widgets/black_regular_dialog.dart';
import 'package:jygf/ui_layer/screens/common_widgets/dialog/my_dialog.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/game/detail/like_collect_unlock.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:provider/provider.dart';

import '../../.././notifiers/user_notifier.dart';
import '../../../notifiers/home_config_notifier.dart';
import '../../../router/routes.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/post/content/comment_count.dart';
import '../../common_widgets/post/content/content.dart';
import '../../common_widgets/post/content/media.dart';
import '../../theme.dart';

class GameDetailContentView extends StatelessWidget {
  const GameDetailContentView({super.key, required this.fullData});

  final GameDetailModel fullData;

  @override
  Widget build(BuildContext context) {
    GameDetailInfoModel data = fullData.detail;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // PostTitleView(
          //   topicTitle: data.title,
          //   viewCount: data.viewFct,
          //   createdAt: data.createdAt,
          // ),
          PostMediaView(
            medias: data.images ?? [],
            unlockCoins: 0,
          ),
          PostMediaView(
            medias: data.videos ?? [],
            unlockCoins: 0,
          ),
          PostContentView(
            content: data.playIntro,
            textStyle: TextStyle(color: MyTheme.white07Color, fontSize: 14.sp),
          ),
          PostContentView(
            content: data.desc,
            textStyle: TextStyle(color: MyTheme.white07Color, fontSize: 14.sp),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.w),
            child: _SourceArea(data: data),
          ),

          PostContentView(
            content: data.intro,
            textStyle: TextStyle(color: MyTheme.white07Color, fontSize: 14.sp),
          ),
          const _EndView(),
          _TagsView(
            tagFullString: data.tags ?? '',
          ),
          PostContentView(
            content: 'xhjzc'.tr(),
            textStyle: TextStyle(color: MyTheme.whiteColor, fontSize: 14.sp),
          ),
          // Text(
          //   'xhjzc'.tr(),
          //   style: MyTheme.white255_14,
          // ),
          _LikeCollectShareArea(data: data),
          (fullData.banner ?? []).isEmpty
              ? const SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.only(bottom: 5.w),
                  child: ReportGeneralAppsListVidget(data: fullData.banner ?? [], aspectRatio: 7 / 2),
                ),
          _PrevAndNextView(data: fullData),
          Divider(
            height: 1,
            thickness: 0.5.w,
            color: MyTheme.white008Color,
          ),
          _RecommendArea(
            datas: fullData.recommend ?? [],
          ),
          SizedBox(height: 20.w),
          PostCommentCountView(commentCount: data.commentCt ?? 0),
        ],
      ),
    );
  }
}

class _EndView extends StatelessWidget {
  const _EndView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyImage.asset(
                MyImagePaths.appGameContentEndLeft,
                width: 87.w,
                height: 6.w,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  "THE END",
                  style: MyTheme.white07_12,
                ),
              ),
              MyImage.asset(
                MyImagePaths.appGameContentEndRight,
                width: 87.w,
                height: 6.w,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TagsView extends StatelessWidget {
  _TagsView({this.tagFullString = ''});

  String tagFullString;

  @override
  Widget build(BuildContext context) {
    return tagFullString.isEmpty
        ? const SizedBox.shrink()
        : Padding(
            padding: EdgeInsets.only(bottom: 15.w),
            child: Wrap(
              spacing: 10.w,
              runSpacing: 10.w,
              children: tagFullString.split(',').where((element) => element.isNotEmpty).toList().map((e) {
                return ReportGestureDetector(
                  onTap: () {
                    GameTagRoute(e).push(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(color: MyTheme.white008Color, borderRadius: BorderRadius.circular(10.w)),
                    child: Text(
                      '#$e',
                      style: MyTheme.white07_10,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
  }
}

class _PrevAndNextView extends StatelessWidget {
  const _PrevAndNextView({
    required this.data,
  });

  final GameDetailModel data;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (data.prev != null || data.next != null)
          ? Container(
              margin: EdgeInsets.symmetric(vertical: 10.w),
              child: Row(
                children: [
                  data.prev == null
                      ? const SizedBox.shrink()
                      : Expanded(
                          child: ReportGestureDetector(
                          onTap: () {
                            GameDetailRoute('${data.prev?.id}').push(context);
                          },
                          child: Container(
                            height: 80.w,
                            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding / 2, vertical: 0),
                            decoration: BoxDecoration(color: MyTheme.white008Color, borderRadius: BorderRadius.circular(10.w)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    MyImage.asset(
                                      MyImagePaths.appGamePrev,
                                      height: 12.w,
                                      width: 12.w,
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      'syp'.tr(),
                                      style: MyTheme.white255_12,
                                    )
                                  ],
                                ),
                                Text(
                                  data.prev?.title ?? '',
                                  style: MyTheme.white255_12,
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        )),
                  (data.prev != null && data.next != null) ? SizedBox(width: 10.w) : const SizedBox.shrink(),
                  data.next == null
                      ? const SizedBox.shrink()
                      : Expanded(
                          child: ReportGestureDetector(
                          onTap: () {
                            GameDetailRoute('${data.next?.id}').push(context);
                          },
                          child: Container(
                            height: 80.w,
                            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding / 2, vertical: 0),
                            decoration: BoxDecoration(color: MyTheme.white008Color, borderRadius: BorderRadius.circular(10.w)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    const Spacer(),
                                    Text(
                                      'xyp'.tr(),
                                      style: MyTheme.white255_12,
                                    ),
                                    SizedBox(width: 10.w),
                                    MyImage.asset(
                                      MyImagePaths.appGameNext,
                                      height: 12.w,
                                      width: 12.w,
                                    ),
                                  ],
                                ),
                                Text(
                                  data.next?.title ?? '',
                                  style: MyTheme.white255_12,
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ))
                ],
              ),
            )
          : Container(),
    );
  }
}

class _SourceArea extends StatefulWidget {
  const _SourceArea({this.data});

  final GameDetailInfoModel? data;

  @override
  State<_SourceArea> createState() => _SourceAreaState();
}

class _SourceAreaState extends State<_SourceArea> {
  bool get showSecret => widget.data?.password?.isNotEmpty == true;

  String get secret => widget.data?.password ?? '';

  int get coins => widget.data?.coins ?? 0;

  List<GameDetailUrlModel> get links => widget.data?.downloadUrls ?? [];

  late ValueNotifier<List<GameDetailUrlModel>> linkNotifier = ValueNotifier(links);
  late final _domain = context.read<GameDomain>();
  late final _userNotifier = context.read<UserNotifier>();
  late final config = context.read<HomeConfigNotifier>().config;

  Future<void> _buyGame() async {
    if (_userNotifier.member.money >= coins) {
      // 支付确认弹窗
      MyDialog.showDialog(
        context: context,
        child: BlackRegularDialog(
          leftPadding: 0,
          rightPadding: 0,
          topPadding: 0,
          bottomPadding: 0,
          content: Container(
            padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 20.w, bottom: 15.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.w)),
              image: const DecorationImage(image: AssetImage(MyImagePaths.appMineRuleBg), fit: BoxFit.fill),
            ),
            child: Stack(
              children: [
                Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Text('wxts'.tr(context: context), style: MyTheme.white255_13_M.s18),
                  SizedBox(height: 28.w),
                  Text('xyzfxjb'.tr(context: context, namedArgs: {'x': '$coins'}), style: MyTheme.white255_13.s14.w400),
                  SizedBox(height: 40.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ReportGestureDetector(
                        onTap: () {
                          context.pop();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 10.w),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(49, 21, 47, 1),
                            borderRadius: BorderRadius.all(Radius.circular(25.w)),
                          ),
                          child: Text(tr('qx'), style: MyTheme.white255_13.s14.w400),
                        ),
                      ),
                      SizedBox(width: 42.w),
                      ReportGestureDetector(
                        onTap: () async {
                          context.pop();
                          MyToast.showLoading(text: 'dhz'.tr(context: context));
                          final result = await _domain.gameBuy(id: widget.data?.id ?? 0);
                          MyToast.closeAllLoading();

                          if (result.status != 0) {
                            // widget.data?.payTip = result.data['url'] ?? '';
                            linkNotifier.value = List.from(result.data['url']).map((e) => GameDetailUrlModel.fromJson(e)).toList();
                            _userNotifier.setMoney(money: _userNotifier.member.money - coins);
                          } else {
                            MyToast.showText(text: result.msg ?? '');
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 10.w),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: MyTheme.gradient_90_114_colors),
                            borderRadius: BorderRadius.all(Radius.circular(25.w)),
                          ),
                          child: Text(tr('qd'), style: MyTheme.white255_13.s14.w400),
                        ),
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          ),
        ),
      );
    } else {
      // 充值、VIP弹窗
      MyDialog.showDialog(
        context: context,
        child: BlackRegularDialog(
          leftPadding: 0,
          rightPadding: 0,
          topPadding: 0,
          bottomPadding: 0,
          content: Container(
            padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 20.w, bottom: 15.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.w)),
              image: const DecorationImage(image: AssetImage(MyImagePaths.appMineRuleBg), fit: BoxFit.fill),
            ),
            child: Stack(
              children: [
                Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Text('wxts'.tr(context: context), style: MyTheme.white255_13_M.s18),
                  SizedBox(height: 28.w),
                  Text('yebzjssb'.tr(context: context), style: MyTheme.white255_13.s14.w400),
                  SizedBox(height: 40.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ReportGestureDetector(
                        onTap: () {
                          context.pop();
                          const VipCenterRoute().push(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 10.w),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: MyTheme.gradient_90_118_colors_blue),
                            borderRadius: BorderRadius.all(Radius.circular(25.w)),
                          ),
                          child: Text(tr('cv'), style: MyTheme.white255_13.s14.w400),
                        ),
                      ),
                      SizedBox(width: 42.w),
                      ReportGestureDetector(
                        onTap: () async {
                          context.pop();
                          const CoinRechargeRoute().push(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 10.w),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: MyTheme.gradient_90_114_colors),
                            borderRadius: BorderRadius.all(Radius.circular(25.w)),
                          ),
                          child: Text(tr('qcz1'), style: MyTheme.white255_13.s14.w400),
                        ),
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    return Column(
      children: [
        SizedBox(
          height: 42.w,
          child: Row(
            children: [
              Text(
                'yxxz'.tr(),
                style: MyTheme.white255_15_M,
              ),
            ],
          ),
        ),
        ValueListenableBuilder(
          valueListenable: linkNotifier,
          builder: (context, currentLinks, child) {
            if (currentLinks.isEmpty) {
              switch (widget.data?.type ?? 0) {
                case 1:
                  return Column(
                    children: [
                      Container(
                        height: 100.w,
                        decoration: DottedDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4.w)),
                          shape: Shape.box,
                          color: MyTheme.white08Color,
                          strokeWidth: 1.w,
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MyImage.asset(MyImagePaths.appGameWarning, width: 15.w),
                            SizedBox(width: 5.w),
                            Text(tr('nrycjsck'), style: TextStyle(color: MyTheme.blueColor64, fontSize: 14.sp)),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.w),
                      ReportGestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          const VipCenterRoute().push(context);
                        },
                        child: Container(
                          height: 40.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: MyTheme.shareButtonGradient,
                            borderRadius: BorderRadius.all(Radius.circular(20.w)),
                          ),
                          child: Text(widget.data?.payTip ?? 'ktvkpyp'.tr(context: context), style: MyTheme.white14Medium),
                        ),
                      ),
                    ],
                  );
                case 2:
                  return Column(
                    children: [
                      Container(
                        decoration: DottedDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4.w)),
                          shape: Shape.box,
                          strokeWidth: 0.5.w,
                          color: MyTheme.primaryColor,
                        ),
                        child: Container(
                          height: 100.w,
                          decoration: BoxDecoration(
                            color: MyTheme.primaryColor_01,
                            borderRadius: BorderRadius.all(Radius.circular(4.w)),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MyImage.asset(
                                MyImagePaths.appGameWarning,
                                width: 15.w,
                                iconColor: const Color.fromRGBO(255, 46, 0, 1),
                              ),
                              SizedBox(width: 5.w),
                              Text(tr('nrycjsck'), style: TextStyle(color: MyTheme.whiteColor, fontSize: 14.sp)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.w),
                      ReportGestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: _buyGame,
                        child: Container(
                          height: 40.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: MyTheme.dhButtonGradient,
                            borderRadius: BorderRadius.all(Radius.circular(20.w)),
                          ),
                          child: Text(
                            (widget.data?.payTip ?? '').isNotEmpty ? (widget.data?.payTip ?? '') : '$coins金币解锁',
                            style: MyTheme.white14Medium,
                          ),
                        ),
                      )
                    ],
                  );
              }
            }
            return Container(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 20.w),
              decoration: DottedDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.w)),
                shape: Shape.box,
                color: MyTheme.white08Color,
                strokeWidth: 1.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: currentLinks.map((link) {
                      return ReportGestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          CommonUtils.copyToClipboard(text: link.archiveUrl ?? '');
                          MyToast.showText(text: 'fzcgqxz'.tr(context: context));
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              // TextSpan(
                              //     text: 'xzdz'.tr(context: context),
                              //     style: TextStyle(
                              //         color: Colors.white, fontSize: 14.sp)),
                              TextSpan(
                                  text: (ensureEndsWithColon(link.label ?? '')).replaceAll(',', '\n'),
                                  style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                              TextSpan(text: link.archiveUrl?.replaceAll(',', '\n'), style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                              TextSpan(text: " [${'dwfz'.tr(context: context)}]", style: TextStyle(color: MyTheme.blueColor64, fontSize: 14.sp)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10.w),
                  ReportGestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      CommonUtils.copyToClipboard(text: secret);
                      MyToast.showText(text: 'fzcgqxz'.tr(context: context));
                    },
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: 'jymm'.tr(context: context), style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                          TextSpan(
                              text: showSecret ? secret : 'ptjc'.tr(context: context), style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                          if (showSecret)
                            TextSpan(text: " [${'dwfz'.tr(context: context)}]", style: TextStyle(color: MyTheme.blueColor64, fontSize: 14.sp)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  String ensureEndsWithColon(String input) {
    // 检查字符串是否为空
    if (input.isEmpty) return 'xzdz'.tr(context: context);
    // 检查最后一个字符是否是 ':'
    if (input.endsWith(':') || input.endsWith('：')) {
      return input;
    } else {
      return '$input: ';
    }
  }
}

class _LikeCollectShareArea extends StatefulWidget {
  const _LikeCollectShareArea({required this.data});

  final GameDetailInfoModel data;

  @override
  State<_LikeCollectShareArea> createState() => _LikeCollectShareAreaState();
}

class _LikeCollectShareAreaState extends State<_LikeCollectShareArea> {
  late final _domain = context.read<GameDomain>();
  bool _isChangeLikeLoading = false;
  bool _isChangeCollectLoading = false;

  Future<void> _changeLike() async {
    if (_isChangeLikeLoading) return;
    _isChangeLikeLoading = true;

    try {
      final result = await _domain.like(id: widget.data.id ?? 0);
      if (result.status == 1) {
        final oldValue = widget.data.isLike ?? 0;
        final newValue = oldValue == 0 ? 1 : 0;
        widget.data.isLike = newValue;

        if (newValue == 1) {
          widget.data.likeFct = (widget.data.likeFct ?? 0) + 1;
        } else {
          widget.data.likeFct = (widget.data.likeFct ?? 0) - 1;
        }
        if ((widget.data.likeFct ?? 0) < 0) {
          widget.data.likeFct = 0;
        }

        if (mounted) {
          setState(() {});
        }
      } else {
        MyToast.showText(text: result.msg ?? '');
      }
    } catch (_) {}

    _isChangeLikeLoading = false;
  }

  Future<void> _changeCollect() async {
    if (_isChangeCollectLoading) return;
    _isChangeCollectLoading = true;

    try {
      final result = await _domain.favorite(id: widget.data.id ?? 0);
      if (result.status == 1) {
        final oldValue = widget.data.isFavorite ?? 0;
        final newValue = oldValue == 0 ? 1 : 0;

        widget.data.isFavorite = newValue;

        if (newValue == 1) {
          widget.data.favoriteFct = (widget.data.favoriteFct ?? 0) + 1;
        } else {
          widget.data.favoriteFct = (widget.data.favoriteFct ?? 0) - 1;
        }
        if ((widget.data.favoriteFct ?? 0) < 0) {
          widget.data.favoriteFct = 0;
        }
        if (mounted) {
          setState(() {});
        }
      } else {
        MyToast.showText(text: result.msg ?? '');
      }
    } catch (_) {}

    _isChangeCollectLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10.w),
      child: Center(
        child: SizedBox(
          width: 200.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GameLikeButton(isLiked: widget.data.isLike == 1, likeNum: widget.data.likeFct ?? 0, onTap: _changeLike),
              GameCollectButton(isCollected: widget.data.isFavorite == 1, collectNum: widget.data.favoriteFct ?? 0, onTap: _changeCollect),
              GameUnlockButton(data: widget.data)
            ],
          ),
        ),
      ),
    );
  }
}

class _RecommendArea extends StatelessWidget {
  _RecommendArea({required this.datas});

  List<GameModel> datas;

  @override
  Widget build(BuildContext context) {
    return datas.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.w),
                child: Text(
                  'xgtj'.tr(),
                  style: MyTheme.white15,
                ),
              ),
              SizedBox(
                  height: 96.w,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: datas
                        .map((e) => Padding(
                              padding: EdgeInsets.only(right: 10.w),
                              child: SizedBox(
                                width: 172.w,
                                height: 96.w,
                                child: _GameRecoomendCard(
                                  data: e,
                                ),
                              ),
                            ))
                        .toList(),
                  )

                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   physics: AlwaysScrollableScrollPhysics(),
                  //   child: Row(
                  //     children: datas
                  //         .map((e) => Padding(
                  //               padding: EdgeInsets.only(right: 10.w),
                  //               child: _GameRecoomendCard(
                  //                 data: e,
                  //               ),
                  //             ))
                  //         .toList(),
                  //   ),
                  // ),
                  )
            ],
          );
  }
}

class _GameRecoomendCard extends StatelessWidget {
  const _GameRecoomendCard({
    required this.data,
  });

  final GameModel data;

  // final double imageRatio;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      return ReportGestureDetector(
        onTap: () {
          GameDetailRoute('${data.id}').push(context);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: 172.w,
                  height: 96.w,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      MyImage.network(
                        CommonUtils.clipImageUrl(
                          CommonUtils.getThumb(data.toJson()),
                          inputWidth: 175.w,
                        ),
                        borderRadius: 5.w,
                        fit: BoxFit.cover,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.only(right: 4.w),
                          child: Text(data.title ?? '', style: MyTheme.white12medium),
                        ),
                      ),
                      SizedBox(
                        height: 2.w,
                      ),
                    ],
                  )),
            ],
          ),
        ),
      );
    });
  }
}
