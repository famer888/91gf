import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/model/video_comment_model.dart';
import 'package:jygf/domain/remote_domain/domains/novel.dart';
import 'package:jygf/ui_layer/const.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/post/comment_input.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/screens/video_detail/widgets/comment_view.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';

class NovelCommentContent extends StatefulWidget {
  const NovelCommentContent({super.key, required this.id});

  final int id;

  @override
  State<NovelCommentContent> createState() => _NovelCommentContentState();
}

class _NovelCommentContentState extends State<NovelCommentContent> {
  late final _domain = context.read<NovelDomain>();
  List<VideoCommentListModel> array = [];

  /// 文本框控制器
  final textEditingController = TextEditingController();

  /// 文本框焦点
  final inputFocusNode = FocusNode();
  final hintNotifier = ValueNotifier('wyddxf'.tr());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<VideoCommentListModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await _domain.novelCommentList(
        id: widget.id, page: page, limit: pageSize);
    if (result.isValid) {
      List<VideoCommentListModel> tp = List.from(result.data ?? []);
      if (page == 1) {
        array = tp;
      } else {
        array.addAll(tp);
      }
      return tp;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        inputFocusNode.unfocus();
      },
      child: Column(
        children: [
          Expanded(
            child: MyListView.list(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              itemBuilder: (context, item, index) =>
                  // CommentTile(data: item, type: 11),
                  CommentTile(data: item),
              onFetchingMore: (currentPage, pageSize) =>
                  _getData(page: currentPage, pageSize: pageSize),
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
    late final domain = context.read<NovelDomain>();
    if (text.trim().isEmpty) {
      MyToast.showText(text: 'qsrnr'.tr(context: context));
      return;
    }
    MyToast.showLoading(text: 'fbioz'.tr(context: context));
    final result = await domain.novelComment(
      id: widget.id,
      text: text,
    );
    MyToast.closeAllLoading();
    MyToast.showText(text: result.msg ?? '');

    textEditingController.clear();
    inputFocusNode.unfocus();
  }
}
