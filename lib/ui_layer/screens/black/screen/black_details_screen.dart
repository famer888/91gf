import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/async_value.dart';
import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/remote_domain/domains/black_domain.dart';
import 'package:jygf/domain/remote_domain/domains/user.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/black/model/black_model.dart';
import 'package:jygf/ui_layer/screens/black/vip_pay_dialog.dart';
import 'package:jygf/ui_layer/screens/black/widgets/black_detail_content_view.dart';
import 'package:jygf/ui_layer/screens/black/widgets/comment.dart';
import 'package:jygf/ui_layer/screens/black/widgets/html_body_widget.dart';
import 'package:jygf/ui_layer/screens/black/widgets/icon_text_series_of_widget.dart';
import 'package:jygf/ui_layer/screens/black/widgets/index_key.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/post/card/card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/network_error.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';import 'package:jygf/report/ui_layer/report_general_banner.dart';




class BlackDetailsScreen extends StatefulWidget {
  final int id;

  const BlackDetailsScreen({super.key, required this.id});

  @override
  State<BlackDetailsScreen> createState() => _BlackDetailsScreenState();
}

class _BlackDetailsScreenState extends State<BlackDetailsScreen> {
  late final _blackDomain = context.read<BlackDomain>();
  late final _userDomain = context.read<UserDomain>();
  AsyncValue<BlackDetailModel> _asyncValue = const AsyncInit();
  final ValueNotifier<String> _titleNotifier = ValueNotifier('');
  final hintNotifier = ValueNotifier('wyddxf'.tr());

  dynamic selectedId; // 当前 帖子 ID
  CommentModel? replyItemModel;
  final FocusNode _inputFocusNode = FocusNode();

  /// 文本框控制器
  final inputController = TextEditingController(); // 评论 VC
  final controller = ScrollController();

  Future<void> _getBlockDetail() async {
    if (_asyncValue.isLoading) return;

    setState(() {
      _asyncValue = const AsyncLoading();
    });


    final result = await _blackDomain.getBlackDetail(id: selectedId);
    if (result.status == 1) {
      if (result.data != null) {
        if (context.mounted) {
          final blackDetailModel = result.data;
          final curBlackDetailsModel = blackDetailModel!.cur;
          _titleNotifier.value = curBlackDetailsModel != null && curBlackDetailsModel.category.isNotEmpty ? curBlackDetailsModel.category[0].name : 'hlxq'.tr();

          _asyncValue = AsyncData(blackDetailModel);
        }
      } else {
        _asyncValue = const AsyncError();
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
      _asyncValue = const AsyncError();
    }
    if (context.mounted) {
      setState(() {});
    }
  }

  Future<List<CommentModel>> _getBlockComment({int page = 1, int limit = 15}) async {
    final result = await _blackDomain.getBlackCommentList(id: widget.id, page: page, limit: limit);
    if (result.status == 1) {
      if (result.data != null && result.data?.list.isNotEmpty == true) {
        return result.data!.list;
      } else {
        CommonUtils.log('没有评论数据...');
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return [];
  }

  void onSendMessage() async {
    if (inputController.text.trim().isEmpty) {
      MyToast.showText(text: 'qspl'.tr(context: context));
      return;
    }
    Map<String, dynamic> tempParams = {
      'content': inputController.text.trim(),
    };

    ///
    if (replyItemModel?.id == null) {
      tempParams['cid'] = selectedId;
    } else {
      tempParams['comment_id'] = replyItemModel?.id;
    }

    final result = await _blackDomain.publishBlackComment(
        cid: (replyItemModel?.id == null) ? selectedId : replyItemModel?.id, content: inputController.text.trim());
    if (result.status == 1) {
      BotToast.showText(text: result.msg ?? '');
      onDismissFocus();
    } else {
      BotToast.showText(text: result.msg ?? '');
      onDismissFocus(); // 收回键盘
    }
  }

  Future<bool> _changeCommentLike(int id) async {
    final likeResult = await _userDomain.userCommentLike(type: 8, id: id);
    final res = await _blackDomain.getBlackLike(id: id);
    return likeResult.status == 1;
  }

  _showMoreReview(CommentModel comment) async {
    if (_inputFocusNode.hasFocus) {
      onDismissFocus();
    }
    if (!mounted) {
      return;
    }

    // showModalBottomSheet(
    //   backgroundColor: Colors.transparent,
    //   isScrollControlled: true,
    //   context: context,
    //   builder: (_) => BlackRepliesSheetView(
    //     comment: comment,
    //     onLikeChange: (id) => _changeCommentLike(id),
    //     commentsAsyncGetter: (int currentPage, int limit) {// 获取二级评论
    //      return _blackDomain.communityPostCommentsSecond(commentId: '${comment.id}', page: currentPage, limit: limit);
    //     },
    //     onCommentInputSubmitted: (String value) {
    //       inputController.text = value;
    //       onSendMessage;
    //     },
    //   ),
    // );
  }

  void onReplyAReview(CommentModel item) {
    replyItemModel = item;
    _inputFocusNode.requestFocus();
  }

  /// 失去焦点
  void onDismissFocus() {
    inputController.clear();
    replyItemModel = null;
    _inputFocusNode.unfocus();
  }

  @override
  void initState() {
    selectedId = widget.id;
    _getBlockDetail();
    super.initState();
  }

  @override
  void dispose() {
    _titleNotifier.dispose();
    _inputFocusNode.dispose();
    inputController.dispose();
    hintNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          titleWidget: ValueListenableBuilder(
              valueListenable: _titleNotifier,
              builder: (context, title, child) {
                return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                  child: Text('hlxq'.tr(), style: MyTheme.white255_18_B),
                );
              }),
        ),
        body: _asyncValue.maybeWhen(
          data: (data) {
            return ReportGestureDetector(
              onTap: () {
                onDismissFocus();
              },
              child: Column(
                children: [
                  Expanded(
                    child: MyListView.list(
                      header: BlackDetailContentView(
                          data: data,
                          goNewBlackDetailCallback: (id) {
                            selectedId = id;
                            _getBlockDetail();
                          }),
                      padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: MyTheme.pagePadding),
                      itemBuilder: (context, item, index) {
                        return BlackCommentView(
                          type: CommunityType.community,
                          commentData: item,
                          onReply: () {
                            replyItemModel = item;
                            hintNotifier.value = '${'hf'.tr()}@${item.user.nickname}';
                            _inputFocusNode.requestFocus();
                          },
                          onMoreCommentTap: () => _showMoreReview(item),
                          changeLike: () => _changeCommentLike(item.id),
                        );
                      },
                      onFetchingMore: (currentPage, pageSize) => _getBlockComment(page: currentPage, limit: pageSize),
                    ),
                  ),
                  _buildBottomActionWidget(data),
                ],
              ),
            );
          },
          error: (error, __) => NetworkErrorView(text: error is String? ? error : null, onTap: _getBlockDetail),
          orElse: () => const LoadingView(),
        ),
      ),
    );
  }

  Widget _buildCategoryWidget(CurDetailsModel? cur) {
    if (cur == null) return const SizedBox();
    return Padding(
      padding: EdgeInsets.fromLTRB(12.5.w, 3.w, 12.5.w, 0),
      child: Text(
          '${cur.author.nickname}'
          ' · ${cur.createdAt}'
          ' · ${cur.category.map((i) => i.name).join(' · ')}'
          ' · ${CommonUtils.formatNumber(cur.viewNum)}浏览',
          style: MyTheme.white04_12.white25506,
          maxLines: 2),
    );
  }

  Widget _buildTopAdsWidget(List<dynamic> topAds) {
    if (topAds.isEmpty) return const SizedBox.shrink();
    try {
      if (topAds case final List data when data.isNotEmpty) {
        final banner = topAds.map((x) => BannerModel.fromJson(x)).toList();
        return Padding(
          padding: EdgeInsets.only(left: MyTheme.pagePadding, right: MyTheme.pagePadding, top: MyTheme.pagePadding),
          child: ReportGeneralAppsListVidget(data: banner),
        );
      }
    } catch (e) {
      CommonUtils.log('转换banner出错:$e');
    }
    return const SizedBox.shrink();
  }

  Widget _buildTagsWidget(CurDetailsModel? cur) {
    if (cur == null || cur.tags.isEmpty == true) {
      return const SizedBox();
    }
    Widget current = Wrap(
      spacing: 10.w,
      runSpacing: 10.w,
      children: cur.tags.split(',').map<Widget>((i) {
        return ReportGestureDetector(
          onTap: () {
            BlockTagListRoute(tag: i).push(context);
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(5.5.w, 2.w, 5.5.w, 2.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.w),
              gradient: MyTheme.tagBgGradient,
            ),
            child: Text(
              '#$i',
              textAlign: TextAlign.right,
              style: MyTheme.white255_13.s12,
            ),
          ),
        );
      }).toList(),
    );
    return Container(padding: EdgeInsets.fromLTRB(12.5.w, 10.w, 12.5.w, 0), width: double.infinity, child: current);
  }

  Widget _buildStatisticsWidget(CurDetailsModel? cur) {
    if (cur == null) return const SizedBox();
    CurDetailsModel item = cur;
    Widget current = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ViewIconTextWidget(
          indexKey: IndexKey.black,
          count: cur.viewNum,
        ),
        LikeIconTextWidget(
          indexKey: IndexKey.black,
          params: {'id': item.id},
          urlPath: '/api/user/likes',
          likeNum: item.likeNum,
          isLiked: item.isLike,
          valueCallback: (isLike) {
            item.isLike = isLike;
            item.likeNum += (isLike ? 1 : -1);
            if (item.likeNum < 0) item.likeNum = 0;
            item.isLike = isLike;
            // if (mounted) setState(() {});
          },
        ),
        CommentIconTextWidget(indexKey: IndexKey.black, count: item.commentNum),
        const ShareIconTextWidget(indexKey: IndexKey.black),
      ],
    );
    return Container(
      height: 40.w,
      margin: EdgeInsets.symmetric(vertical: 2.5.w),
      padding: EdgeInsets.symmetric(horizontal: 12.5.w),
      width: double.infinity,
      child: current,
    );
  }

  Widget _buildEmptyCommentWidget(CurDetailsModel? cur) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        decoration: const BoxDecoration(color: Color.fromRGBO(10, 0, 10, 1)),
        margin: EdgeInsets.only(top: 10.w),
        padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 10.w),
        width: double.infinity,
        child: Text('${'pl'.tr(context: context)}（${CommonUtils.formatNumber(cur?.commentNum ?? 0)}）', style: MyTheme.white255_13.s15),
      ),
      if ((cur?.commentNum ?? 0) <= 0)
        Container(
          padding: EdgeInsets.fromLTRB(15.w, 20.w, 15.w, 10.w),
          child: Text(
            'gjplb'.tr(context: context),
            style: MyTheme.white255_13.white25506.s14,
          ),
        ),
    ]);
  }

  Widget _buildCommentItemWidget(CommentModel item, [bool isRoot = true]) {
    Widget current = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyImage.network(
          item.user.thumb,
          borderRadius: isRoot ? 17.5.w : 10.w,
          height: isRoot ? 35.w : 20.w,
          width: isRoot ? 35.w : 20.w,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              Expanded(child: Text('@${item.user.nickname}', style: MyTheme.white255_13.s12)),
              SizedBox(width: 3.w),
              SizedBox(height: 18.w),
              // _buildViPIconWidget(item.user),
            ]),
            SizedBox(height: 2.w),
            ReportGestureDetector(
              onTap: () => isRoot ? onReplyAReview(item) : null,
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  item.comment,
                  style: MyTheme.white08_12.s13.h1_5,
                ),
              ),
            ),
            SizedBox(height: 2.w),
            _buildRowDateWidget(item, isRoot),
            isRoot ? buildCommentListWidget(item.comments, false) : const SizedBox(),
          ]),
        ),
        SizedBox(width: 15.w),
      ],
    );

    return Container(padding: EdgeInsets.only(top: isRoot ? 0.w : 5.w, bottom: 8.w), child: current);
  }

  Widget buildCommentListWidget(List<CommentModel> dataList, [bool isRoot = true]) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: isRoot ? 10.w : 0),
      itemCount: dataList.length,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final CommentModel item = dataList[index];
        return _buildCommentItemWidget(item, isRoot);
      },
    );
  }

  Widget _buildRowDateWidget(CommentModel item, bool isRoot) {
    Widget current = Text(item.createdAt, style: MyTheme.white04_12.h1_5);
    if (isRoot == false) {
      return SizedBox(width: double.infinity, child: current);
    } else {
      return Row(children: [
        current,
        SizedBox(width: item.createdAt.isEmpty ? 0 : 15.w),
        ReportGestureDetector(
          onTap: () => onReplyAReview(item),
          child: Text(
            'hf'.tr(context: context),
            style: MyTheme.white04_12.h1_5.s13.blueColor63,
          ),
        ),
      ]);
    }
  }

  /// 推荐
  Widget _buildRecommendWidget(List<RecommendModel>? recommends) {
    if (recommends == null || recommends.isEmpty) return const SizedBox();
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        padding: EdgeInsets.fromLTRB(12.5.w, 12.5.w, 12.5.w, 0),
        width: double.infinity,
        child: Text('xgtj'.tr(context: context), style: MyTheme.white255_13.s15),
      ),
      SizedBox(
        height: 100.w,
        width: double.infinity,
        child: GridView.builder(
          itemCount: recommends.length,
          padding: EdgeInsets.fromLTRB(12.5, 10.w, 12.5, 0),
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 90 / (recommends.length <= 2 ? 170 : 150),
            crossAxisCount: 1,
            mainAxisSpacing: 6.w,
          ),
          itemBuilder: (context, index) => _buildItemBuilder(context, recommends[index]),
        ),
      ),
    ]);
  }

  Widget _buildItemBuilder(context, RecommendModel recommend) {
    Widget current = Stack(fit: StackFit.expand, children: [
      MyImage.network(recommend.thumb),
      Container(
        color: const Color.fromRGBO(0, 0, 0, 0.4),
        padding: EdgeInsets.symmetric(horizontal: 8.5.w),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Text(recommend.category.isNotEmpty ? recommend.category[0].name : 'hlcg'.tr(context: context), style: MyTheme.white255_13.s14),
          SizedBox(height: 5.w),
          Text(recommend.title, style: MyTheme.white255_13.s12, maxLines: 2),
        ]),
      ),
    ]);

    return ReportGestureDetector(
      onTap: () {
        if (recommend.needVip) {
          VipPayDialog.showVipDialog(context);
        } else {
          selectedId = recommend.id;
          _getBlockDetail();
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.w),
        clipBehavior: Clip.hardEdge,
        child: current,
      ),
    );
  }

  /// 滑动区域
  Widget _buildContainerWidget(BlackDetailModel? data) {
    if (data == null) return NetworkErrorView(text: null, onTap: _getBlockDetail);

    final cur = data.cur;
    Widget current = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(12.5.w, 5.w, 12.5.w, 0),
          child: Text(cur?.title ?? '', style: MyTheme.white255_13_M.s16.w500, maxLines: 2),
        ),
        _buildCategoryWidget(cur),
        _buildTopAdsWidget(data.topBanner),
        Padding(
          padding: EdgeInsets.fromLTRB(12.5.w, 10.w, 12.5.w, 0),
          child: HtmlBodyWidget(cur, width: 375.w, callback: (type) {
            if (type == 1) {
              VipPayDialog.showVipDialog(context);
            }
            if (type == 2) {
              //   VipPayDialog.showCoinsDialog(context, _userNotifier.member, () async {
              //     final result = await _blackDomain.getBlackBuy(id: selectedId);
              //     if (result.status == 1) {
              //       MyToast.showText(text: result.msg ?? '');
              //       // todo 这里测试的时候看看，因为没有实际支付过
              //     }
              //   });
            }
          }),
        ),
        _buildTagsWidget(cur),
        _buildStatisticsWidget(cur),
        Container(color: MyTheme.white25501Color, height: 0.5.w, width: double.infinity),
        _buildRecommendWidget(data.recommend),
        _buildTopAdsWidget(data.botBanner),
        _buildEmptyCommentWidget(cur),
      ],
    );

    return MyListView.list(
      header: current,
      itemBuilder: (context, item, index) {
        return _buildCommentItemWidget(item);
      },
      onFetchingMore: (currentPage, pageSize) => _getBlockComment(page: currentPage, limit: pageSize),
    );
  }

  /// 评论
  Widget _buildBottomActionWidget(BlackDetailModel? data) {
    Widget current = Row(children: [
      SizedBox(width: 10.w),
      // Container(
      //   height: 40.w,
      //   alignment: Alignment.centerLeft,
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(20.w),
      //     color: MyTheme.white25501Color,
      //   ),
      // ),
      Expanded(
        child: Container(
          height: 36.w,
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.symmetric(horizontal: 13.w),
          padding: EdgeInsets.only(top: 5.w, left: 4.w, right: 4.w, bottom: 5.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.w),
            color: MyTheme.white25501Color,
          ),
          child: TextField(
            focusNode: _inputFocusNode,
            controller: inputController,
            style: MyTheme.white255_13_M.white25508.w500.s15.h1_5,
            maxLines: 10,
            cursorHeight: 23,
            textAlign: TextAlign.start,
            cursorColor: MyTheme.blueColor63,
            decoration: InputDecoration(
              hintText: replyItemModel != null ? '@${replyItemModel?.user.nickname}' : '善语结善缘，恶言伤人心',
              hintStyle: MyTheme.white255_13_M.white25506.w500.s15,
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 8.w, top: 6.5.w, right: 8.w, bottom: kIsWeb ? 6.5.w : 0.w),
            ),
          ),
        ),
      ),
      SizedBox(width: 1.w),
      CletIconTextWidget(
        indexKey: IndexKey.black,
        style: 3,
        urlPath: '/api/user/favorites',
        params: {'id': data?.cur?.id},
        isFavorited: data?.cur?.isFavorite ?? false,
        valueCallback: (isCollected) {
          data?.cur?.isFavorite = isCollected;
          data?.cur?.favoriteNum += isCollected ? 1 : -1;
        },
      ),
      SizedBox(width: 8.w),
      _buildActionItemWidget(MyImagePaths.appCustomSend, 'fasong'.tr(context: context), onSendMessage),
      SizedBox(width: 12.w),
    ]);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 15.w, top: 8.w),
      constraints: BoxConstraints(minHeight: 56.w),
      color: const Color.fromRGBO(22, 22, 34, 1),
      child: current,
    );
  }

  Widget _buildActionItemWidget(iconName, title, void Function()? onTap) {
    return ReportGestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 3.w),
          SizedBox(height: 20.w, width: 20.w, child: Image.asset(iconName)),
          SizedBox(height: 6.w),
          Text(title, style: MyTheme.white255_13.s12.white),
        ],
      ),
    );
  }
}
