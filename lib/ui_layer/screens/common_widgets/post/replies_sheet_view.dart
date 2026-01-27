import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/model/review_data_model.dart';
import '../../../../domain/type_def.dart';
import '../../../utils/my_toast.dart';
import '../../image_paths.dart';
import '../../theme.dart';
import '../my_image.dart';
import '../my_list_view.dart';
import 'comment.dart';
import 'comment_input.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


typedef CommentsAsyncGetter = AsyncResult<List<ReviewData>> Function(int, int);
typedef LikeAsyncSetter = Future<bool> Function(int id);

class RepliesSheetView extends StatefulWidget {
  const RepliesSheetView({
    super.key,
    required this.comment,
    required this.commentsAsyncGetter,
    required this.onCommentInputSubmitted,
    required this.onLikeChange,
  });
  final ReviewData comment;

  final ValueChanged<String> onCommentInputSubmitted;

  /// 取得二级评论
  final CommentsAsyncGetter commentsAsyncGetter;

  final LikeAsyncSetter onLikeChange;

  @override
  State<RepliesSheetView> createState() => _RepliesSheetViewState();
}

class _RepliesSheetViewState extends State<RepliesSheetView> {
  /// 文本框控制器
  final textEditingController = TextEditingController();

  /// 文本框焦点
  final inputFocusNode = FocusNode();

  late final hintNotifier =
      ValueNotifier('${'hf'.tr()}@${widget.comment.user?.nickname ?? ""}');

  Future<List<ReviewData>?> getComments(
      {required int currentPage, required int pageSize}) async {
    final result = await widget.commentsAsyncGetter(currentPage, pageSize);
    if (result.data case final data?) {
      return data;
    }
    MyToast.showText(text: result.msg ?? '');

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.viewInsetsOf(context),
      duration: const Duration(milliseconds: 100),
      child: Container(
        height: 1.sh * 0.6,
        decoration: BoxDecoration(
          color: MyTheme.bgColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.w),
            topRight: Radius.circular(20.w),
          ),
        ),
        child: ReportGestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            inputFocusNode.unfocus();
          },
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                    left: 20.w, right: 20.w, top: 20.w, bottom: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReportGestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: MyImage.asset(
                        MyImagePaths.appIssueClose,
                        width: 11.w,
                        height: 11.w,
                      ),
                    ),
                    Text(
                      "${widget.comment.comments?.length}${tr('taoi')}${tr('hf')}",
                      style: MyTheme.white255_18_M,
                    ),
                    const SizedBox.shrink()
                  ],
                ),
              ),
              Expanded(
                child: ReportGestureDetector(
                  child: MyListView.list(
                    itemBuilder: (context, item, index) => SheetReplyView(
                      commentData: item,
                      changeLike: () => widget.onLikeChange(item.id ?? 0),
                    ),
                    onFetchingMore: (currentPage, pageSize) => getComments(
                        currentPage: currentPage, pageSize: pageSize),
                  ),
                ),
              ),
              CommentInput(
                controller: textEditingController,
                focusNode: inputFocusNode,
                hintNotifier: hintNotifier,
                onSubmitted: () {
                  widget.onCommentInputSubmitted(textEditingController.text);
                  textEditingController.clear();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
