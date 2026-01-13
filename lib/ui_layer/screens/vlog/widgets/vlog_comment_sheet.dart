import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/vlog/widgets/comment_widget.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/model/video_comment_model.dart';
import 'package:jygf/domain/remote_domain/domains/vlog.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/post/comment_input.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class VlogCommentSheet extends StatefulWidget {
  const VlogCommentSheet({super.key, this.id = 0, this.onClose});
  final int id;
  final Function? onClose;

  @override
  State<VlogCommentSheet> createState() => VlogCommentSheetState();
}

class VlogCommentSheetState extends State<VlogCommentSheet> {
  /// 文本框控制器
  final textEditingController = TextEditingController();

  /// 文本框焦点
  final inputFocusNode = FocusNode();
  final hintNotifier = ValueNotifier('wyddxf'.tr());

  late final domain = context.read<VlogDomain>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didUpdateWidget(covariant VlogCommentSheet oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (MediaQuery.of(context).viewInsets.bottom == 0) {
        inputFocusNode.unfocus();
      } else {}
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<VideoCommentListModel>?> _getData({
    required int currentPage,
    required int limit,
  }) async {
    final result = await domain.vlogCommentList(
      id: widget.id,
      page: currentPage,
      limit: limit,
    );
    if (result.msg case final msg? when !result.isValid) {
      MyToast.showText(text: msg);
    }
    return result.data;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        // padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 100),
        width: double.infinity,
        child: Container(
            width: double.infinity,
            height: ScreenUtil().screenHeight * 0.6,
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
                Navigator.pop(context);
              },
              child: configContentView(),
            )));
  }

  Widget configContentView() {
    return ReportGestureDetector(
      onTap: () {
        inputFocusNode.unfocus();
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.w),
            child:
                Text('pl'.tr(context: context), style: MyTheme.white255_16_M),
          ),
          Expanded(
            child: MyListView.list(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              itemBuilder: (context, item, index) =>
                  CommentTile(data: item, type: 2),
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
            },
          ),
        ],
      ),
    );
  }

  Future<void> _sendComment({required String text}) async {
    if (text.trim().isEmpty) {
      MyToast.showText(text: 'qsrnr'.tr(context: context));
      return;
    }
    MyToast.showLoading(text: 'fbioz'.tr(context: context));
    final result = await domain.vlogComment(
      id: widget.id,
      text: text,
    );
    MyToast.closeAllLoading();
    MyToast.showText(text: result.msg ?? '');

    textEditingController.clear();
    inputFocusNode.unfocus();
    Navigator.pop(context);
  }
}
