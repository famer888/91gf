import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/game/game_comment_model.dart';
import 'package:jygf/domain/model/game/game_detail_model.dart';
import 'package:jygf/domain/remote_domain/domains/game.dart';
import 'package:jygf/ui_layer/const.dart';
import 'package:jygf/ui_layer/notifiers/user_notifier.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/member_vip.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_avatar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:provider/provider.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';

import '../../../../../domain/api_validator.dart';
import '../../../../../domain/async_value.dart';
import '../../../../../domain/domain.dart';
import '../../../../../domain/model/review_data_model.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_app_bar.dart';
import '../../../common_widgets/my_list_view.dart';
import '../../../common_widgets/post/comment_input.dart';
import '../../../common_widgets/screen_background.dart';
import '../../../common_widgets/status/loading.dart';
import '../../../common_widgets/status/network_error.dart';
import '../../../theme.dart';
import 'content.dart';

class GameDetailScreen extends StatefulWidget {
  const GameDetailScreen({super.key, required this.id});
  final String id;

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  GameDetailModel? _detailModel;
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: _detailModel == null ? '' : _detailModel?.detail.title,
        ),
        body: _Body(
          id: widget.id,
          whenLoadedInfo: (model) {
            _detailModel = model;
            setState(() {});
          },
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({required this.id, this.whenLoadedInfo});
  final String id;
  final Function(GameDetailModel model)? whenLoadedInfo;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with WidgetsBindingObserver {
  late final _domain = context.read<GameDomain>();

  AsyncValue<GameDetailModel> _asyncValue = const AsyncInit();

  /// 文本框控制器
  final textEditingController = TextEditingController();

  /// 文本框焦点
  final inputFocusNode = FocusNode();

  final hintNotifier = ValueNotifier('wyddxf'.tr());

  ReviewData? currentReply;

  double _viewBottom = 0;

  @override
  void initState() {
    _init();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

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
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void resetInput() {
    // currentReply = null;
    hintNotifier.value = 'wyddxf'.tr();
    textEditingController.clear();
  }

  void unfocus() {
    inputFocusNode.unfocus();
    resetInput();
  }

  /// 取得种子详情
  Future<void> _init() async {
    if (_asyncValue.isLoading) return;
    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final result = await _domain.gameDetail(id: widget.id);

    if (result.data case final data?) {
      // result.data
      // GameDetailModel model = GameDetailModel.fromJson(result.data);
      widget.whenLoadedInfo?.call(data);
      _asyncValue = AsyncData(data);
    } else {
      _asyncValue = AsyncError(error: result.msg);
    }

    if (mounted) {
      setState(() {});
    }
  }

  /// 取得评论
  Future<List<GameCommentListModel>?> getReviewData(
      {required int currentPage, required int pageSize}) async {
    final result = await _domain.gameCommentList(
        id: widget.id, page: currentPage, limit: pageSize);

    if (result.data case final data?) {
      return data;
    }
    MyToast.showText(text: result.msg ?? '');

    return null;
  }

  Future<void> _sendComment({ReviewData? target, required String text}) async {
    if (_asyncValue case AsyncData<GameDetailModel> data) {
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
        postId = '${data.value.detail.id}';
        commentId = '0';
      }
      final result = await _domain.gameComment(
        id: postId,
        text: text,
      );

      BotToast.closeAllLoading();
      MyToast.showText(text: result.msg ?? '');

      unfocus();
    }
  }

  Future<bool> _changeCommentLike(String id) async {
    late final domain = context.read<UserDomain>();
    final res = await domain.userCommentLike(type: 5, id: int.parse(id));
    return res.isValid;
  }

  @override
  Widget build(BuildContext context) {
    return _asyncValue.maybeWhen(
      data: (data) {
        return GestureDetector(
          onTap: () {
            unfocus();
          },
          child: Column(
            children: [
              // Banner(message: message, location: location)

              Expanded(
                child: MyListView.list(
                  header: GameDetailContentView(fullData: data),
                  padding:
                      EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                  itemBuilder: (context, item, index) =>
                      _CommentTile(data: item),
                  onFetchingMore: (currentPage, pageSize) =>
                      _getData(currentPage: currentPage, limit: pageSize),
                ),
              ),
              CommentInput(
                controller: textEditingController,
                focusNode: inputFocusNode,
                hintNotifier: hintNotifier,
                onSubmitted: () async {
                  await _sendComment(
                      target: currentReply, text: textEditingController.text);
                },
              ),
            ],
          ),
        );
      },
      error: (error, __) => NetworkErrorView(
        text: error is String? ? error : null,
        onTap: _init,
      ),
      orElse: () => const LoadingView(),
    );
  }

  // String _lastIx = '';

  late final domain = context.read<GameDomain>();

  Future<List<GameCommentListModel>> _getData({
    required int currentPage,
    required int limit,
  }) async {
    final result = await domain.gameCommentList(
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
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({super.key, required this.data});
  final GameCommentListModel data;

  @override
  Widget build(BuildContext context) {
    final user = data.member;
    final member = context.read<UserNotifier>().member;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 15.w),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              // UserCenterRoute(aff: '${user?.aff}', index: 0).push(context);
              UserCenterRoute('${user?.aff}').push(context);
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
                      GestureDetector(
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
                                color: MyTheme.jellyCyanColor, // 设置边框颜色
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
                      vipImage: user?.vipStr ?? '',
                      height: 14,
                      margin: 5,
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
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                if (data.id case final id?) {
                  final domain = context.read<UserDomain>();
                  final res = await domain.userCommentLike(type: 9, id: id);
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
