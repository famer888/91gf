import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:provider/provider.dart';
import '../../../notifiers/home_config_notifier.dart';
import '../../common_widgets/post/content/like_collect_share_area.dart';

import '../../../../domain/domain.dart';
import '../../../../domain/type_def.dart';
import '../../../../domain/model/bit_detail_model.dart';

import '../../../notifiers/user_notifier.dart';
import '../../../router/routes.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/post/content/comment_count.dart';
import '../../common_widgets/post/content/content.dart';
import '../../common_widgets/post/content/media.dart';
import '../../common_widgets/post/content/title.dart';
import '../../theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class BitDetailContentView extends StatelessWidget {
  const BitDetailContentView({super.key, required this.data});
  final BitDetail data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          PostTitleView(
            topicTitle: data.title,
            viewCount: data.viewFct,
            createdAt: data.createdAt,
          ),
          PostMediaView(
            medias: data.medias ?? [],
            unlockCoins: data.unlockCoins ?? 0,
          ),
          PostContentView(
            content: data.content,
            textStyle: TextStyle(
                color: MyTheme.jellyCyanColor103224185, fontSize: 14.sp),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.w),
            child: _SourceArea(data: data),
          ),
          _LikeCollectShareArea(data: data),
          Divider(
            height: 1,
            thickness: 0.5.w,
            color: const Color(0xFF2a2a33),
          ),
          SizedBox(height: 20.w),
          PostCommentCountView(commentCount: data.commentCt ?? 0),
        ],
      ),
    );
  }
}

class _SourceArea extends StatefulWidget {
  const _SourceArea({this.data});
  final BitDetail? data;

  @override
  State<_SourceArea> createState() => _SourceAreaState();
}

class _SourceAreaState extends State<_SourceArea> {
  bool get showSecret => widget.data?.secret?.isNotEmpty == true;
  String get secret => widget.data?.secret ?? '';
  int get coins => widget.data?.coins ?? 0;
  String get link => widget.data?.link ?? '';

  late ValueNotifier<String> linkNotifier = ValueNotifier(link);
  late final _domain = context.read<SeedDomain>();
  late final _userNotifier = context.read<UserNotifier>();
  late final config = context.read<HomeConfigNotifier>().config;
  Future<void> _buyBit() async {
    MyToast.showLoading(text: 'dhz'.tr(context: context));
    final result = await _domain.buyBit(id: widget.data?.id ?? 0);
    MyToast.closeAllLoading();

    if (result.status != 0) {
      widget.data?.link = result.data['url'] ?? '';
      linkNotifier.value = result.data['url'] ?? '';
      _userNotifier.setMoney(money: _userNotifier.member.money - coins);
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
  }

  int getType() {
    if (widget.data?.type == 1) {
      if ((_userNotifier.member.vipSeedPrivilege ?? 0) > 0) {
        return 0;
      } else {
        // vip
        return 1;
      }
    } else if (widget.data?.type == 2) {
      if ((_userNotifier.member.coinsSeedPrivilege ?? 0) > 0) {
        return 0;
      } else {
        // 金币
        return 2;
      }
    } else {
      // 免费
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: linkNotifier,
      builder: (context, currentLink, child) {
        if (currentLink.isEmpty) {
          final type = getType();
          switch (type) {
            case 1:
              return Column(
                children: [
                  Container(
                    height: 75.w,
                    decoration: DottedDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4.w)),
                        shape: Shape.box,
                        color: MyTheme.cyanColor00edfd,
                        strokeWidth: 1.w),
                    alignment: Alignment.center,
                    child: Text(tr('nrycjsck'), style: MyTheme.blue80_14_M),
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
                        gradient: MyTheme.gradient_90_114,
                        borderRadius: BorderRadius.all(Radius.circular(4.w)),
                      ),
                      child: Text(
                          widget.data?.payTip ?? 'ktvkpyp'.tr(context: context),
                          style: MyTheme.white14Medium),
                    ),
                  ),
                ],
              );
            case 2:
              return Column(
                children: [
                  Container(
                    height: 75.w,
                    decoration: DottedDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4.w)),
                        shape: Shape.box,
                        color: MyTheme.cyanColor00edfd,
                        strokeWidth: 1.w),
                    alignment: Alignment.center,
                    child: Text(tr('nrycjsck'), style: MyTheme.blue80_14_M),
                  ),
                  SizedBox(height: 10.w),
                  ReportGestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: _buyBit,
                    child: Container(
                      height: 40.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          gradient: MyTheme.gradient_90_114,
                          borderRadius: BorderRadius.all(Radius.circular(4.w))),
                      child: Text(widget.data?.payTip ?? '$coins金币解锁',
                          style: MyTheme.white14Medium),
                    ),
                  )
                ],
              );
          }
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReportGestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                CommonUtils.copyToClipboard(text: secret);
                MyToast.showText(text: 'fzcgqxz'.tr(context: context));
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'jymm'.tr(context: context),
                        style:
                            TextStyle(color: Colors.white70, fontSize: 14.sp)),
                    TextSpan(
                        text: showSecret ? secret : 'ptjc'.tr(context: context),
                        style: TextStyle(
                            color: MyTheme.cyanColor00edfd, fontSize: 14.sp)),
                    if (showSecret)
                      TextSpan(
                          text: " [${'dwfz'.tr(context: context)}]",
                          style: TextStyle(color: Colors.red, fontSize: 14.sp)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.w),
            ReportGestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                CommonUtils.copyToClipboard(text: currentLink);
                MyToast.showText(text: 'fzcgqxz'.tr(context: context));
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'xzlj'.tr(context: context),
                        style:
                            TextStyle(color: Colors.white70, fontSize: 14.sp)),
                    TextSpan(
                        text: currentLink.replaceAll(',', '\n'),
                        style: TextStyle(
                            color: MyTheme.cyanColor00edfd, fontSize: 14.sp)),
                    TextSpan(
                        text: " [${'dwfz'.tr(context: context)}]",
                        style: TextStyle(color: Colors.red, fontSize: 14.sp)),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

class _LikeCollectShareArea extends StatefulWidget {
  const _LikeCollectShareArea({required this.data});
  final BitDetail data;

  @override
  State<_LikeCollectShareArea> createState() => _LikeCollectShareAreaState();
}

class _LikeCollectShareAreaState extends State<_LikeCollectShareArea> {
  late final _domain = context.read<SeedDomain>();
  late final _userDomain = context.read<UserDomain>();
  bool _isChangeLikeLoading = false;
  bool _isChangeCollectLoading = false;

  Future<void> _changeLike() async {
    if (_isChangeLikeLoading) return;
    _isChangeLikeLoading = true;

    try {
      final result = await _domain.bitCommentLike(id: '${widget.data.id}');
      if (result.status == 1) {
        final oldValue = widget.data.isLike ?? 0;
        final newValue = oldValue == 0 ? 1 : 0;
        widget.data.isLike = newValue;
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
      final result = await _userDomain.favorites(id: widget.data.id ?? 0, type: 17);
      if (result.status == 1) {
        final oldValue = widget.data.isFavorite ?? 0;
        final newValue = oldValue == 0 ? 1 : 0;

        widget.data.isFavorite = newValue;
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Row(children: [
          //     MyImage.asset(
          //       MyImagePaths.app2024ComBofangliangBig1,
          //       width: 20.w,
          //       height: 20.w,
          //     ),
          //     SizedBox(width: 5.w),
          //     Text(
          //        CommonUtils.renderFixedNumber(widget.data.viewNum ?? 0),
          //       style: MyTheme.gray190_12,
          //     ),
          //   ],
          // ),
          SizedBox(width: 30.w),
          // PostLikeButton(isLiked: widget.data.isLike == 1, onTap: _changeLike),
          PostCollectButton(
              isCollected: widget.data.isFavorite == 1, onTap: _changeCollect),
          SizedBox(width: 25.w),
          PostShareButton(onTap: () {
            const MineShareToUserRoute().push(context);
          }),
        ],
      ),
    );
  }
}
