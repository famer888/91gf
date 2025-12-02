import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/home_data_model.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/common_widgets/general_banner.dart';
import 'package:provider/provider.dart';
import '../../../../domain/api_validator.dart';
import '../../../router/routes.dart';
import '../../../utils/common_utils.dart';
import '../../common_widgets/post/content/like_collect_share_area.dart';

import '../../../../domain/domain.dart';
import '../../../../domain/enum.dart';
import '../../../../domain/model/topic_detail_model.dart';
import '../../../../domain/type_def.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/post/content/comment_count.dart';
import '../../common_widgets/post/content/content.dart';
import '../../common_widgets/post/content/media.dart';
import '../../common_widgets/post/content/title.dart';
import '../../theme.dart';

class CommunityDetailContentView extends StatefulWidget {
  const CommunityDetailContentView({super.key, required this.data});
  final TopicDetail data;

  @override
  State<CommunityDetailContentView> createState() =>
      _CommunityDetailContentViewState();
}

class _CommunityDetailContentViewState
    extends State<CommunityDetailContentView> {
  late final homeConfigNotifier = context.read<HomeConfigNotifier>();

  @override
  Widget build(BuildContext context) {
    final apps = homeConfigNotifier.homeData.config.postDetailAds;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (apps case final List<BannerModel> appAds when appAds.isNotEmpty)
            GeneralBannerAppsListWidget(
              data: appAds,
            ),
          PostTitleView(
            topicTitle: widget.data.title,
            viewCount: widget.data.viewNum,
            createdAt: widget.data.createdAt,
          ),
          PostContentView(
            content: widget.data.content,
            textStyle: MyTheme.white07_14,
          ),
          SizedBox(height: 10.w),
          PostMediaView(
            medias: widget.data.medias ?? [],
            unlockCoins: widget.data.unlockCoins ?? 0,
          ),
          _ContactView(
            data: widget.data,
          ),
          _LikeCollectShareArea(
            data: widget.data,
          ),
          Divider(
            height: 1,
            thickness: 0.5.w,
            color: const Color(0xFF2a2a33),
          ),
          SizedBox(height: 20.w),
          PostCommentCountView(commentCount: widget.data.commentNum ?? 0),
        ],
      ),
    );
  }
}

class _ContactView extends StatefulWidget {
  const _ContactView({required this.data});
  final TopicDetail data;

  @override
  State<_ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<_ContactView> {
  late final _domain = context.read<CommunityDomain>();

  Future<void> _pay() async {
    MyToast.showLoading();
    final result = await _domain.reqGetPostURL(id: widget.data.id ?? 0);
    MyToast.closeAllLoading();
    if (result.isValid) {
      if (mounted) {
        setState(() {
          widget.data.contact = result.data['contact'] ?? '';
          widget.data.isPay = 1;
        });
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    if (data.contact case final contact? when contact.isNotEmpty) {
      final unlockCoins = data.unlockCoins ?? 0;
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10.w,
        ),
        child: unlockCoins > 0 && contact.contains('***')
            ? Column(
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
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: _pay,
                    child: Container(
                      height: 40.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: MyTheme.gradient_90_114,
                        borderRadius: BorderRadius.circular(4.w),
                      ),
                      child: Text(
                        '$unlockCoins${tr('jbjs')}',
                        style: MyTheme.white14Medium,
                      ),
                    ),
                  )
                ],
              )
            : contact.contains('111111')
                ? const SizedBox.shrink()
                : GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      CommonUtils.copyToClipboard(
                        text: contact,
                      );
                      MyToast.showText(text: tr('fzcglx'));
                    },
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            children: [
                              TextSpan(
                                text: tr('sjlxfs'),
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14.sp,
                                ),
                              ),
                              TextSpan(
                                text: contact,
                                style: TextStyle(
                                  color: MyTheme.cyanColor00edfd,
                                  fontSize: 14.sp,
                                ),
                              ),
                              TextSpan(
                                text: "【${tr('dwfz')}】",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
      );
    }
    return const SizedBox.shrink();
  }
}

class _LikeCollectShareArea extends StatefulWidget {
  const _LikeCollectShareArea({required this.data});
  final TopicDetail data;

  @override
  State<_LikeCollectShareArea> createState() => _LikeCollectShareAreaState();
}

class _LikeCollectShareAreaState extends State<_LikeCollectShareArea> {
  late final _domain = context.read<CommunityDomain>();
  bool _isChangeLikeLoading = false;
  bool _isChangeCollectLoading = false;

  Future<void> _changeLike() async {
    if (_isChangeLikeLoading) return;
    _isChangeLikeLoading = true;

    try {
      final result = await _domain.communityTopicLike(
          id: '${widget.data.id}', type: MyLikeType.post);
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
      final result =
          await _domain.communityTopicFavorite(id: '${widget.data.id}');
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
      padding:
          EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PostLikeButton(isLiked: widget.data.isLike == 1, onTap: _changeLike),
          SizedBox(width: 20.w),
          PostCollectButton(
              isCollected: widget.data.isFavorite == 1, onTap: _changeCollect),
          SizedBox(width: 20.w),
          PostShareButton(onTap: () {
            const MineShareToUserRoute().push(context);
          }),
        ],
      ),
    );
  }
}
