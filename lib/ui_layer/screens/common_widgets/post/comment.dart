import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/common_widgets/post/card/card.dart';
import 'package:provider/provider.dart';

import '../../../../domain/model/review_data_model.dart';
import '../../../const.dart';
import '../../../notifiers/user_notifier.dart';
import '../../../router/routes.dart';
import '../../../utils/common_utils.dart';
import '../../../utils/my_toast.dart';
import '../member_vip.dart';
import '../my_avatar.dart';
import '../my_image.dart';
import '../../image_paths.dart';
import '../../theme.dart';
import '../../../../domain/type_def.dart';

class PostCommentView extends StatelessWidget {
  const PostCommentView({
    super.key,
    required this.commentData,
    required this.onReply,
    this.onMoreCommentTap,
    required this.changeLike,
    required this.type,
  });

  final ReviewData commentData;
  final VoidCallback onReply;
  final VoidCallback? onMoreCommentTap;
  final AsyncValueGetter<bool> changeLike;
  final CommunityType type;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 15.w),
        _Header(
          commentData: commentData,
          changeLike: changeLike,
        ),
        SizedBox(height: 13.w),
        GestureDetector(
          onTap: onReply,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 40.w),
                child: Text(
                  CommonUtils.convertEmojiAndHtml(
                      type == CommunityType.community
                          ? commentData.comment
                          : commentData.text ?? ''),
                  style: MyTheme.gray208_13,
                  textAlign: TextAlign.left,
                  maxLines: UILayerConst.maxLine,
                ),
              ),
              onMoreCommentTap != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MyImage.asset(
                          MyImagePaths.appReplyIcon,
                          width: 18.w,
                          height: 18.w,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'hf'.tr(context: context),
                          style: MyTheme.gray203_13,
                        )
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
        SizedBox(height: 15.w),
        onMoreCommentTap != null
            ? _RepliesView(
                comments: commentData.comments ?? [],
                onMoreCommentTap: onMoreCommentTap,
              )
            : Container(),
      ],
    );
  }
}

class SheetReplyView extends StatelessWidget {
  const SheetReplyView({
    super.key,
    required this.commentData,
    required this.changeLike,
  });

  final ReviewData commentData;
  final AsyncValueGetter<bool> changeLike;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15.w),
        _Header(
          commentData: commentData,
          changeLike: changeLike,
        ),
        SizedBox(height: 13.w),
        Padding(
          padding: EdgeInsets.only(left: 40.w),
          child: Text(
            CommonUtils.convertEmojiAndHtml(commentData.comment),
            style: MyTheme.gray208_13,
            textAlign: TextAlign.left,
            maxLines: UILayerConst.maxLine,
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.commentData, required this.changeLike});

  final ReviewData commentData;
  final AsyncValueGetter<bool> changeLike;

  @override
  Widget build(BuildContext context) {
    if (commentData.user case final user?) {
      final member = context.read<UserNotifier>().member;
      return Row(
        children: [
          GestureDetector(
            onTap: () {
              UserCenterRoute('${user.aff}').push(context);
            },
            child: MyAvatar(
              size: 30.w,
              thumb: user.thumb ?? '',
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      user.nickname ?? '',
                      style: MyTheme.white23_12,
                    ),

                    GestureDetector(
                      onTap: () {
                        if ((member.username ?? '').isEmpty) {
                          MyToast.showText(text: 'zcyhcz'.tr(context: context));
                          return;
                        }
                        final uuid = user.uuid!;
                        final nick = user.nickname!;
                        final url =
                            user.thumb?.isNotEmpty == true ? user.thumb! : ' ';
                        ChatMessageRoute(
                          nickName: Uri.encodeComponent(nick),
                          thumb: Uri.encodeComponent(url),
                          toUuid: uuid,
                        ).push(context);
                      },
                      child: Container(
                          width: 40.w,
                          height: 17.w,
                          margin: EdgeInsets.only(left: 8.w),
                          decoration: BoxDecoration(
                            gradient: MyTheme.gradient_61_87,
                            borderRadius: BorderRadius.circular(8.5.w),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'six'.tr(context: context),
                            style: MyTheme.white255_10,
                          )),
                    ),
                    SizedBox(width: 2.w),
                    if (user.authStatus == 1)
                      Icon(Icons.verified_sharp,
                          size: 11.w,
                          color: const Color.fromRGBO(247, 208, 93, 1)),
                    // if (member.uuid != user.uuid)
                    //   GestureDetector(
                    //     behavior: HitTestBehavior.translucent,
                    //     onTap: () {
                    //       if (member.username?.isEmpty == true) {
                    //         MyToast.showText(
                    //             text: 'zcyhcz'.tr(context: context));
                    //         return;
                    //       }
                    //
                    //       final uuid = user.uuid ?? '';
                    //       final nick = user.nickname;
                    //       final url = Uri.encodeComponent(
                    //         user.thumb?.isEmpty == true ? '' : user.thumb!,
                    //       );
                    //       ChatMessageRoute(
                    //         nickName: nick ?? '',
                    //         thumb: url,
                    //         toUuid: uuid,
                    //       ).push(context);
                    //     },
                    //     child: Container(
                    //       margin: EdgeInsets.only(left: 2.w),
                    //       alignment: Alignment.center,
                    //       height: 15.w,
                    //       width: 40.w,
                    //       decoration: BoxDecoration(
                    //           border: Border.all(
                    //               color: MyTheme.cyanColor00edfd, width: 0.5.w),
                    //           borderRadius:
                    //               BorderRadius.all(Radius.circular(2.w))),
                    //       child: Text(
                    //         'sxta'.tr(context: context),
                    //         style: MyTheme.blue80_09,
                    //       ),
                    //     ),
                    //   ),
                    if (user.authStatus == 1)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 7.w),
                        height: 13.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.5.w),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFffca43), Color(0xFFff7d3e)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )),
                        child: Center(
                          child: Text(
                            'cuangz'.tr(context: context),
                            style: MyTheme.white255_8,
                          ),
                        ),
                      )
                  ],
                ),
                SizedBox(height: 4.w),
                Row(
                  children: [
                    if (user.vipLevel.isVip())
                      Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: MemberVipWidget(vipImage: member.vipImg),
                      ),
                    Text(
                      RelativeDateFormat.format(
                          date: DateTime.parse(commentData.createdAt ?? '')),
                      // "${commentData.cityname ?? "csxq".tr(context: context)}·${RelativeDateFormat.format(date: DateTime.parse(commentData.createdAt ?? ""))}",
                      style: MyTheme.gray163_11,
                    )
                  ],
                )
              ],
            ),
          ),
          _LikeButton(
            commentData: commentData,
            changeLike: changeLike,
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}

class _LikeButton extends StatefulWidget {
  const _LikeButton({required this.commentData, required this.changeLike});

  final ReviewData commentData;
  final AsyncValueGetter<bool> changeLike;

  @override
  State<_LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<_LikeButton> {
  bool _loading = false;

  Future<void> _changeLike() async {
    if (_loading) return;
    _loading = true;
    try {
      final isSuccessful = await widget.changeLike();
      if (isSuccessful) {
        final oldLike = widget.commentData.isLike ?? 0;
        final newLike = oldLike == 0 ? 1 : 0;
        widget.commentData.isLike = newLike;
        if (mounted) {
          setState(() {});
        }
      }
    } catch (_) {}
    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _changeLike,
      child: SizedBox(
        width: 40.w,
        child: Column(
          children: [
            MyImage.asset(
              widget.commentData.isLike == 1
                  ? MyImagePaths.appCommReviewH
                  : MyImagePaths.appCommReviewN,
              width: 20.w,
              height: 20.w,
            ),
            SizedBox(height: 1.w),
            Text(
              CommonUtils.renderFixedNumber((widget.commentData.likeNum ?? 0) +
                  (widget.commentData.isLike ?? 0)),
              style: MyTheme.gray203_12,
            )
          ],
        ),
      ),
    );
  }
}

class _RepliesView extends StatelessWidget {
  const _RepliesView({required this.comments, this.onMoreCommentTap});

  final VoidCallback? onMoreCommentTap;
  final List<ReviewData> comments;
  final int max = 5;

  WidgetSpan landlordSpan() => WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Padding(
          padding: EdgeInsets.only(right: 6.w),
          child: Container(
            height: 16.w,
            width: 40.w,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFdf6b04), Color(0xFFdd952f)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(8.w),
            ),
            child: Center(
              child: Text('楼主', style: MyTheme.white255_11),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return comments.isEmpty
        ? SizedBox(height: 15.w)
        : ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: min(comments.length, max),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final data = comments[index];
              return Container(
                margin: EdgeInsets.only(left: 40.w),
                padding: EdgeInsets.all(10.w),
                width: double.infinity,
                color: const Color(0xFF15152a),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          if (data.isLandlord == 1) landlordSpan(),
                          TextSpan(
                            text:
                                "${data.user?.nickname ?? ""} ${'hf'.tr(context: context)}：",
                            style: MyTheme.greent113_12,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10.w),
                    Text(
                      CommonUtils.convertEmojiAndHtml(data.comment),
                      style: MyTheme.gray208_13,
                      maxLines: UILayerConst.maxLine,
                    ),
                    if (index == max - 1 && comments.length > max)
                      GestureDetector(
                        onTap: onMoreCommentTap,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.w),
                          child: Container(
                            height: 30.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFF464952),
                              borderRadius: BorderRadius.circular(2.w),
                            ),
                            child: Center(
                              child: Text(
                                'gdhf'.tr(context: context),
                                style: MyTheme.white255_12,
                              ),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              );
            },
          );
  }
}
