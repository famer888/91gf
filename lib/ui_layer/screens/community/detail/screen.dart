import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';
import 'package:jygf/ui_layer/screens/common_widgets/post/card/card.dart';
import 'package:provider/provider.dart';

import '../../../../domain/api_validator.dart';
import '../../../../domain/async_value.dart';
import '../../../../domain/domain.dart';
import '../../../../domain/enum.dart';
import '../../../../domain/model/review_data_model.dart';
import '../../../../domain/model/topic_detail_model.dart';
import '../../../../domain/model/user_model.dart';
import '../../../../domain/type_def.dart';
import '../../../router/routes.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/my_image.dart';
import '../../common_widgets/my_list_view.dart';
import '../../common_widgets/post/comment.dart';
import '../../common_widgets/post/comment_input.dart';
import '../../common_widgets/post/replies_sheet_view.dart';
import '../../common_widgets/screen_background.dart';
import '../../common_widgets/status/loading.dart';
import '../../common_widgets/status/network_error.dart';
import '../../image_paths.dart';
import '../../theme.dart';
import 'content.dart';

class CommunityPostDetailScreen extends StatefulWidget {
  const CommunityPostDetailScreen({super.key, required this.id});

  final String id;

  @override
  State<CommunityPostDetailScreen> createState() => _CommunityPostDetailScreenState();
}

class _CommunityPostDetailScreenState extends State<CommunityPostDetailScreen> with WidgetsBindingObserver {
  late final _domain = context.read<CommunityDomain>();

  AsyncValue<TopicDetail> _asyncValue = const AsyncInit();

  /// 文本框控制器
  final textEditingController = TextEditingController();

  /// 文本框焦点
  final inputFocusNode = FocusNode();

  final hintNotifier = ValueNotifier('wyddxf'.tr());

  ReviewData? currentReply;

  final double _viewBottom = 0;

  @override
  void didChangeMetrics() {
    // final newBottom = View.of(context).viewInsets.bottom;
    // if (newBottom == 0 && newBottom < _viewBottom) {
    //   unfocus();
    // }
    // _viewBottom = newBottom;

    super.didChangeMetrics();
  }

  @override
  void initState() {
    _init();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    textEditingController.dispose();
    inputFocusNode.dispose();
    super.dispose();
  }

  void resetInput() {
    currentReply = null;
    hintNotifier.value = 'wyddxf'.tr();
    textEditingController.clear();
  }

  void unfocus() {
    inputFocusNode.unfocus();
    resetInput();
  }

  /// 取得社区详情
  Future<void> _init() async {
    if (_asyncValue.isLoading) return;
    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final result = await _domain.communityTopicDetail(id: widget.id);
    if (mounted) {
      setState(() {
        if (result.data case final data?) {
          _asyncValue = AsyncData(data);
        } else {
          _asyncValue = AsyncError(error: result.msg);
        }
      });
    }
  }

  /// 取得评论
  Future<List<ReviewData>?> getReviewData({required int currentPage, required int pageSize}) async {
    final result = await _domain.communityPostComments(id: widget.id, page: currentPage, limit: pageSize);

    if (result.data case final data?) {
      return data;
    }
    MyToast.showText(text: result.msg ?? '');

    return null;
  }

  Future<void> _sendComment({ReviewData? target, required String text}) async {
    if (_asyncValue case AsyncData<TopicDetail> data) {
      if (text.trim().isEmpty) {
        MyToast.showText(text: 'qsrnr'.tr(context: context));
        return;
      }
      MyToast.showLoading(text: 'fbioz'.tr(context: context));
      late final String postId;
      late final String commentId;

      if (target?.id case final id?) {
        postId = '0';
        commentId = id.toString();
      } else {
        postId = '${data.value.id}';
        commentId = '0';
      }
      final result = await _domain.communityPostComment(
        postId: postId,
        commentId: commentId,
        content: text,
      );

      BotToast.closeAllLoading();
      MyToast.showText(text: result.msg ?? '');

      unfocus();
    }
  }

  Future<bool> _changeCommentLike(String id) async {
    final res = await _domain.communityTopicLike(type: MyLikeType.comment, id: id);
    return res.isValid;
  }

  _showMoreReview(ReviewData comment) async {
    if (inputFocusNode.hasFocus) {
      unfocus();
    }
    if (!mounted) {
      return;
    }

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (_) => RepliesSheetView(
        comment: comment,
        onLikeChange: (id) => _changeCommentLike(id),
        commentsAsyncGetter: (int currentPage, int limit) => _domain.communityPostCommentsSecond(
          commentId: '${comment.id}',
          page: currentPage,
          limit: limit,
        ),
        onCommentInputSubmitted: (String value) {
          _sendComment(target: comment, text: value);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _asyncValue.maybeWhen(
      data: (data) {
        return ScreenBackground(
          child: Scaffold(
            appBar: MyAppBar(
              leftWidget: ReportGestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  context.pop();
                },
                child: SizedBox(
                  height: double.infinity,
                  child: MyImage.asset(MyImagePaths.appBackIcon, width: 20.w, height: 20.w, fit: BoxFit.contain),
                ),
              ),
              // _AvatarWithNickName(user: data.user),
              title: 'tiezixq'.tr(),
              // rightWidget: Selector<UserNotifier, bool>(
              //   selector: (_, notifier) => notifier.userFollowingStatus.contains('${data.user?.aff}'),
              //   builder: (_, isFollowed, __) => FollowButton(
              //     isFollowed: isFollowed,
              //     onTap: () => context.read<UserNotifier>().changeUserFollow('${data.user?.aff}'),
              //   ),
              // ),
            ),
            body: ReportGestureDetector(
              onTap: () {
                unfocus();
              },
              child: Column(
                children: [
                  Expanded(
                    child: MyListView.list(
                      header: CommunityDetailContentView(data: data),
                      padding: EdgeInsets.symmetric(
                        vertical: 5.w,
                        horizontal: MyTheme.pagePadding,
                      ),
                      itemBuilder: (context, item, index) {
                        return PostCommentView(
                          type: CommunityType.community,
                          commentData: item,
                          onReply: () {
                            currentReply = item;
                            hintNotifier.value = '${'hf'.tr()}@${item.user?.nickname ?? ""}';
                            inputFocusNode.requestFocus();
                          },
                          onMoreCommentTap: () => _showMoreReview(item),
                          changeLike: () => _changeCommentLike('${item.id}'),
                        );
                      },
                      onFetchingMore: (currentPage, pageSize) => getReviewData(currentPage: currentPage, pageSize: pageSize),
                    ),
                  ),
                  CommentInput(
                    controller: textEditingController,
                    focusNode: inputFocusNode,
                    hintNotifier: hintNotifier,
                    onSubmitted: () async {
                      await _sendComment(target: currentReply, text: textEditingController.text);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
      error: (error, __) {
        return NetworkErrorView(
          text: error is String? ? error : null,
          onTap: _init,
        );
      },
      orElse: () {
        return const ScreenBackground(
          child: Scaffold(
            appBar: MyAppBar(),
            body: LoadingView(),
          ),
        );
      },
    );
  }
}

class _AvatarWithNickName extends StatelessWidget {
  const _AvatarWithNickName({this.user});

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ReportGestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            context.pop();
          },
          child: SizedBox(
            height: double.infinity,
            child: MyImage.asset(MyImagePaths.appBackIcon, width: 20.w, height: 20.w, fit: BoxFit.contain),
          ),
        ),
        SizedBox(width: 10.w),
        ReportGestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            UserCenterRoute('${user?.aff}').push(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 30.w,
                width: 30.w,
                child: MyImage.network(user?.thumb ?? '', borderRadius: 15.w, fit: BoxFit.cover),
              ),
              SizedBox(width: 10.w),
              Text(user?.nickname ?? '', style: MyTheme.white255_15_M),
              SizedBox(width: 2.w),
              if (user?.agent == 1) Icon(Icons.verified_sharp, size: 14.w, color: const Color.fromRGBO(247, 208, 93, 1))
            ],
          ),
        ),
      ],
    );
  }
}
