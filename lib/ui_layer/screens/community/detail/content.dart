import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/user_model.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/notifiers/user_notifier.dart';
import 'package:jygf/ui_layer/screens/common_widgets/follow_button.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:provider/provider.dart';

import '../../../../domain/api_validator.dart';
import '../../../../domain/domain.dart';
import '../../../../domain/enum.dart';
import '../../../../domain/model/topic_detail_model.dart';
import '../../../../domain/type_def.dart';
import '../../../router/routes.dart';
import '../../../utils/common_utils.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/post/content/comment_count.dart';
import '../../common_widgets/post/content/content.dart';
import '../../common_widgets/post/content/like_collect_share_area.dart';
import '../../common_widgets/post/content/media.dart';
import '../../common_widgets/post/content/title.dart';
import '../../theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';import 'package:jygf/report/ui_layer/report_general_banner.dart';




class CommunityDetailContentView extends StatefulWidget {
  const CommunityDetailContentView({super.key, required this.data});

  final TopicDetail data;

  @override
  State<CommunityDetailContentView> createState() => _CommunityDetailContentViewState();
}

class _CommunityDetailContentViewState extends State<CommunityDetailContentView> {
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
          _AvatarWithNickName(user: widget.data.user, createdAt: widget.data.createdAt ?? ''),
          SizedBox(height: 10.w),
          if (apps case final List<BannerModel> appAds when appAds.isNotEmpty) ReportGeneralAppsListVidget(data: appAds),
          PostTitleView(topicTitle: widget.data.title, viewCount: widget.data.viewNum, createdAt: widget.data.createdAt),
          PostContentView(content: widget.data.content, textStyle: MyTheme.white07_14),
          SizedBox(height: 10.w),
          PostMediaView(medias: widget.data.medias ?? [], unlockCoins: widget.data.unlockCoins ?? 0),
          _ContactView(data: widget.data),
          _LikeCollectShareArea(data: widget.data),
          Divider(height: 1, thickness: 0.5.w, color: const Color(0xFF2a2a33)),
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
                  ReportGestureDetector(
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
                : ReportGestureDetector(
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
      final result = await _domain.communityTopicLike(id: '${widget.data.id}', type: MyLikeType.post);
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
      final result = await _domain.communityTopicFavorite(id: '${widget.data.id}', type: 14, requestType: 1);
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
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PostLikeButton(isLiked: widget.data.isLike == 1, onTap: _changeLike),
          SizedBox(width: 16.w),
          PostCollectButton(isCollected: widget.data.isFavorite == 1, onTap: _changeCollect),
          SizedBox(width: 16.w),
          PostShareButton(onTap: () {
            const MineShareToUserRoute().push(context);
          }),
        ],
      ),
    );
  }
}

class _AvatarWithNickName extends StatelessWidget {
  const _AvatarWithNickName({this.user, this.createdAt = ''});

  final UserModel? user;
  final String createdAt;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 13.w),
        ReportGestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            UserCenterRoute('${user?.aff}').push(context);
          },
          child: SizedBox(
            height: 40.w,
            width: 40.w,
            child: MyImage.network(user?.thumb ?? '', borderRadius: 20.w, fit: BoxFit.cover),
          ),
        ),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user?.nickname ?? '', style: MyTheme.white255_15_M),
            SizedBox(height: 3.w),
            Text(RelativeDateFormat.format(date: DateTime.tryParse(createdAt ?? '')), style: MyTheme.white255_15_M.s12.w400),
          ],
        ),
        SizedBox(width: 2.w),
        if (user?.agent == 1) Icon(Icons.verified_sharp, size: 14.w, color: const Color.fromRGBO(247, 208, 93, 1)),
        const Spacer(),
        Selector<UserNotifier, bool>(
          selector: (_, notifier) => notifier.userFollowingStatus.contains('${user?.aff}'),
          builder: (_, isFollowed, __) => FollowButton(
            isFollowed: isFollowed,
            onTap: () => context.read<UserNotifier>().changeUserFollow('${user?.aff}'),
          ),
        ),
        SizedBox(width: 13.w),
      ],
    );
  }
}
