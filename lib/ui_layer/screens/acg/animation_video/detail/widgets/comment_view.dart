import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/domain.dart';
import 'package:jygf/domain/model/cartoon/cartoon_comment_model.dart';
import 'package:jygf/domain/remote_domain/domains/cartoon.dart';
import 'package:jygf/ui_layer/notifiers/user_notifier.dart';
import 'package:jygf/ui_layer/router/routes.dart';

import '../../../../../../domain/api_validator.dart';
import '../../../../../const.dart';
import '../../../../../utils/common_utils.dart';
import '../../../../../utils/my_toast.dart';
import '../../../../common_widgets/member_vip.dart';
import '../../../../common_widgets/my_avatar.dart';
import '../../../../common_widgets/my_image.dart';
import '../../../../common_widgets/my_list_view.dart';
import '../../../../common_widgets/post/comment_input.dart';
import '../../../../image_paths.dart';
import '../../../../theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class CartoonCommentView extends StatefulWidget {
  const CartoonCommentView({super.key, required this.id});
  final String id;
  @override
  State<CartoonCommentView> createState() => _CartoonCommentViewState();
}

class _CartoonCommentViewState extends State<CartoonCommentView> {
  /// 文本框控制器
  final textEditingController = TextEditingController();

  /// 文本框焦点
  final inputFocusNode = FocusNode();

  final hintNotifier = ValueNotifier('wyddxf'.tr());

  // String _lastIx = '';

  late final domain = context.read<CartoonDomain>();

  Future<List<CartoonCommentListModel>> _getData({
    required int currentPage,
    required int limit,
  }) async {
    final result = await domain.cartoonCommentList(
      id: widget.id,
      page: currentPage,
      limit: limit,
    );

    // _lastIx = result.data?.lastIx ?? '';

    if (result.msg case final msg? when !result.isValid) {
      MyToast.showText(text: msg);
    }
    return result.data ?? [];
  }

  Future<void> _sendComment({required String text}) async {
    if (text.trim().isEmpty) {
      MyToast.showText(text: 'qsrnr'.tr(context: context));
      return;
    }
    MyToast.showLoading(text: 'fbioz'.tr(context: context));
    final result = await domain.cartoonComment(
      text: text,
      id: widget.id,
    );

    BotToast.closeAllLoading();
    MyToast.showText(text: result.msg ?? '');
    inputFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return ReportGestureDetector(
      onTap: () {
        inputFocusNode.unfocus();
      },
      child: Column(
        children: [
          Expanded(
            child: MyListView.list(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              itemBuilder: (context, item, index) => _CommentTile(data: item),
              onFetchingMore: (currentPage, pageSize) =>
                  _getData(currentPage: currentPage, limit: pageSize),
            ),
          ),
          CommentInput(
            controller: textEditingController,
            focusNode: inputFocusNode,
            hintNotifier: hintNotifier,
            onSubmitted: () async {
              await _sendComment(text: textEditingController.text);
              textEditingController.clear();
            },
          ),
        ],
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({super.key, required this.data});
  final CartoonCommentListModel data;

  @override
  Widget build(BuildContext context) {
    final user = data.member;
    final member = context.read<UserNotifier>().member;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 15.w),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReportGestureDetector(
            onTap: () {
              UserCenterRoute('${user?.aff}').push(context);
              // UserCenterRoute(aff: '${user?.aff}', index: 0).push(context);
            },
            child: MyAvatar(
              size: 30.w,
              thumb: user?.thumb ?? '',
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
                    Flexible(
                      child: Text(
                        user?.nickname ?? '',
                        style: MyTheme.white23_12,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    if (user?.agent == 1)
                      Icon(Icons.verified_sharp,
                          size: 11.w,
                          color: const Color.fromRGBO(247, 208, 93, 1)),
                    if (member.uuid != user?.uuid)
                      ReportGestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          if (member.username?.isEmpty == true) {
                            MyToast.showText(
                                text: 'zcyhcz'.tr(context: context));
                            return;
                          }

                          final uuid = user?.uuid ?? '';
                          final nick = user?.nickname;
                          final url = user?.thumb;
                          ChatMessageRoute(
                            nickName: Uri.encodeComponent(nick ?? ''),
                            thumb: Uri.encodeComponent(url ?? ''),
                            toUuid: uuid,
                          ).push(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 5.w, top: 2.w),
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: MyTheme.cyanColor00edfd, // 设置边框颜色
                                width: 0.5, // 设置边框宽度
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(2.w))),
                          child: Text(
                            'sxt'.tr(context: context),
                            style: MyTheme.jellyCyan_11,
                          ),
                        ),
                      ),
                    // if (user.authStatus == 1)
                    //   Container(
                    //     padding: EdgeInsets.symmetric(horizontal: 7.w),
                    //     height: 13.w,
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(6.5.w),
                    //         gradient: const LinearGradient(
                    //           colors: [Color(0xFFffca43), Color(0xFFff7d3e)],
                    //           begin: Alignment.centerLeft,
                    //           end: Alignment.centerRight,
                    //         )),
                    //     child: Center(
                    //       child: Text(
                    //         'cuangz'.tr(context: context),
                    //         style: MyTheme.white255_8,
                    //       ),
                    //     ),
                    //   )
                  ],
                ),
                SizedBox(height: 4.w),
                Row(
                  children: [
                    MemberVipWidget(
                      vipImage: user?.vipImg,
                      height: 14,
                      margin: 5.w,
                    ),
                    Text(
                      RelativeDateFormat.format(
                          date: DateTime.parse(data.createdAt ?? '')),
                      style: MyTheme.gray163_11,
                    ),
                  ],
                )
              ],
            ),
          ),
          StatefulBuilder(builder: (_, setState) {
            final isLike = data.isLike == 1;
            return ReportGestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                if (data.id case final id?) {
                  final domain = context.read<UserDomain>();
                  final res = await domain.userCommentLike(type: 8, id: id);
                  if (res.isValid) {
                    data.isLike = isLike ? 0 : 1;
                    int likeCount = data.likeFct ?? 0;
                    isLike ? likeCount-- : likeCount++;
                    data.likeFct = likeCount;
                    setState(() {});
                  } else if (res.msg case final msg?) {
                    MyToast.showText(text: msg);
                  }
                }
              },
              child: SizedBox(
                width: 40.w,
                child: Column(
                  children: [
                    MyImage.asset(
                      isLike
                          ? MyImagePaths.appCommReviewH
                          : MyImagePaths.appCommReviewN,
                      width: 20.w,
                      height: 20.w,
                    ),
                    SizedBox(height: 1.w),
                    Text(
                      CommonUtils.renderFixedNumber(CommonUtils.renderFixedLikeCount(data.likeFct ?? 0,
                          data.isLike ?? 0)),
                      style: MyTheme.gray203_12,
                    )
                  ],
                ),
              ),
            );
          })
        ],
      ),
      SizedBox(height: 13.w),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 40.w),
            child: Text(
              CommonUtils.convertEmojiAndHtml(data.text ?? ''),
              style: MyTheme.gray208_13,
              textAlign: TextAlign.left,
              maxLines: UILayerConst.maxLine,
            ),
          ),
        ],
      ),
      SizedBox(height: 15.w),
      Container(
        height: 0.5.w,
        color: MyTheme.white008Color,
      )
    ]);
  }
}
