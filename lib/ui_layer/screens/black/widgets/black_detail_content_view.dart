import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/home_data_model.dart';
import 'package:jygf/domain/remote_domain/domains/black_domain.dart';
import 'package:jygf/report/ui_layer/report_general_banner.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/notifiers/user_notifier.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/black/model/black_model.dart';
import 'package:jygf/ui_layer/screens/black/vip_pay_dialog.dart';
import 'package:jygf/ui_layer/screens/black/widgets/black_title.dart';
import 'package:jygf/ui_layer/screens/black/widgets/html_body_widget.dart';
import 'package:jygf/ui_layer/screens/black/widgets/icon_text_series_of_widget.dart';
import 'package:jygf/ui_layer/screens/black/widgets/index_key.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/post/content/comment_count.dart';
import 'package:jygf/ui_layer/screens/common_widgets/post/content/like_collect_share_area.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';


typedef GoNewBlackDetailCallback = void Function(int id);

class BlackDetailContentView extends StatefulWidget {
  final GoNewBlackDetailCallback goNewBlackDetailCallback;

  const BlackDetailContentView({super.key, required this.data, required this.goNewBlackDetailCallback});

  final BlackDetailModel data;

  @override
  State<BlackDetailContentView> createState() => _BlackDetailContentViewState();
}

class _BlackDetailContentViewState extends State<BlackDetailContentView> {
  late final _screenUtil = ScreenUtil();
  late final _userNotifier = context.read<UserNotifier>();
  late final homeConfigNotifier = context.read<HomeConfigNotifier>();
  late final _blackDomain = context.read<BlackDomain>();

  @override
  Widget build(BuildContext context) {
    if (widget.data.cur == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          BlackTitleView(topicTitle: widget.data.cur!.title, viewCount: widget.data.cur!.viewNum, createdAt: widget.data.cur!.createdAt),
          _buildTopAdsWidget(widget.data.topBanner),
          _buildHtmlContent(context),
          // PostContentView(content: widget.data.cur!.content, textStyle: MyTheme.white07_14),
          _buildTagsWidget(widget.data.cur!),
          _buildStatisticsWidget(widget.data.cur!),
          _buildRecommendWidget(widget.data.recommend),
          _buildTopAdsWidget(widget.data.botBanner),
          SizedBox(height: 10.w),
          // PostMediaView(medias: widget.data.cur!.medias ?? [], unlockCoins: widget.data.cur!.unlockCoins ?? 0),
          // _ContactView(data: widget.data),
          // _LikeCollectShareArea(data: widget.data.cur!),
          Container(color: MyTheme.white25501Color, height: 0.5.w, width: double.infinity),
          SizedBox(height: 20.w),
          PostCommentCountView(commentCount: widget.data.cur!.commentNum),
        ],
      ),
    );
  }

  Widget _buildTagsWidget(CurDetailsModel cur) {
    Widget current = Wrap(
      spacing: 10.w,
      runSpacing: 10.w,
      children: cur.tags.split(',').map<Widget>((i) {
        return buildChildActionWidget(
          onTap: () {
            BlockTagListRoute(tag: i).push(context);
          },
          padding: EdgeInsets.fromLTRB(5.5.w, 2.w, 5.5.w, 2.w),
          borderRadius: BorderRadius.circular(2.w),
          gradient: MyTheme.tagBgGradient,
          text: '#$i',
          textAlign: TextAlign.right,
          style: MyTheme.white255_13.s12,
        );
      }).toList(),
    );
    return Container(padding: EdgeInsets.fromLTRB(0.w, 10.w, 0.w, 0), width: double.infinity, child: current);
  }

  Widget _buildStatisticsWidget(CurDetailsModel cur) {
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
    return buildContainerWidget(
      height: 40.w,
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 10.w),
      padding: EdgeInsets.symmetric(horizontal: 0.w),
      width: double.infinity,
      child: current,
    );
  }

  Widget _buildHtmlContent(BuildContext context) {
    return HtmlBodyWidget(widget.data.cur, width: _screenUtil.screenWidth, callback: (type) {
      if (type == 1) {
        VipPayDialog.showVipDialog(context);
      }
      if (type == 2) {
        VipPayDialog.showCoinsDialog(
            context: context,
            barrierDismissible: false,
            member: _userNotifier.member,
            coins: widget.data.cur!.coins.toDouble(),
            onPay: () async {
              final member = context.read<UserNotifier>().member;
              final adequate = member.money >= widget.data.cur!.coins;

              if (!adequate) {
                MyToast.showText(text: 'ndyebz'.tr(context: context));
                return;
              }

              final result = await _blackDomain.getBlackBuy(id: widget.data.cur!.id);
              if (result.status == 1) {
                MyToast.showText(text: result.msg ?? '');
                widget.data.cur?.isPay = true;

                if (context.mounted) {
                  final currentMoney = member.money - widget.data.cur!.coins;
                  context.read<UserNotifier>().setMoney(money: currentMoney);
                  context.pop();
                }
                setState(() {});
              } else {
                if (context.mounted) {
                  context.pop();
                }
                MyToast.showText(text: result.msg ?? '');
              }
            });
      }
    });
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
          SizedBox(height: 5.w),
          Text(recommend.title, style: MyTheme.white255_13.s12, maxLines: 2),
        ]),
      ),
    ]);

    return buildChildActionWidget(
      onTap: () {
        if (recommend.needVip) {
          VipPayDialog.showVipDialog(context);
        } else {
          widget.goNewBlackDetailCallback.call(recommend.id);
        }
      },
      child: ClipRRect(borderRadius: BorderRadius.circular(5.w), clipBehavior: Clip.hardEdge, child: current),
    );
  }

  Widget _buildTopAdsWidget(List<Notice> topAds) {
    if (topAds.isEmpty) return const SizedBox.shrink();
    final List<BannerModel> dataList = topAds
        .map(
          (e) => BannerModel(
            id: e.id,
            name: e.title,
            title: e.title,
            linkUrl: e.linkUrl ?? '',
            resourceUrl: e.resourceUrl ?? '',
            redirectType: e.redirectType ?? 0,
            router: e.router ?? '',
            reportId: e.reportId,
            reportType: e.reportType,
            urlStr: e.urlStr,
            imgUrl: e.imgUrl,
            adType: e.adType,
            adSlotName: e.adSlotName,
            advertiseCode: e.advertiseCode,
            advertiseLocationCode: e.advertiseLocationCode,
          ),
        )
        .toList();
    return Padding(padding: EdgeInsets.only(top: 5.w, bottom: 10.w), child: ReportGeneralAppsListVidget(data: dataList));
  }

  Widget buildChildActionWidget({
    TextStyle? style,
    String? text,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    Widget? child,
    /* container param */
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    double? height,
    double? width,
    BoxConstraints? constraints,
    // required Widget child,
    AlignmentGeometry? alignment,
    /* decoration param */
    DecorationImage? image,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    Gradient? gradient,
    BoxShadow? boxShadow,
    void Function()? onTap,
  }) {
    child ??= Text(
      text ?? '---',
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );

    if ((width != null || height != null || color != null) ||
        (padding != null || alignment != null) ||
        (border != null || borderRadius != null || gradient != null)) {
      child = buildContainerWidget(
        padding: padding,
        // margin: margin,
        color: color,
        height: height,
        width: width,
        constraints: constraints,
        alignment: alignment,
        image: image,
        border: border,
        borderRadius: borderRadius,
        gradient: gradient,
        boxShadow: boxShadow,
        child: child,
      );
    }

    if (onTap != null) {
      child = ReportGestureDetector(onTap: onTap, child: child);
    }

    if (margin != null) {
      child = Padding(padding: margin, child: child);
    }

    return child;
  }

  Widget buildContainerWidget(
      {EdgeInsetsGeometry? padding,
      EdgeInsetsGeometry? margin,
      Color? color,
      double? height,
      double? width,
      BoxConstraints? constraints,
      AlignmentGeometry? alignment,
      Widget? child,
      DecorationImage? image,
      BoxBorder? border,
      BorderRadiusGeometry? borderRadius,
      Gradient? gradient,
      BoxShadow? boxShadow,
      Clip clipBehavior = Clip.none}) {
    BoxDecoration? decoration;
    if (border != null || image != null || gradient != null || boxShadow != null || borderRadius != null) {
      decoration = BoxDecoration(
        boxShadow: boxShadow != null ? [boxShadow] : null,
        image: image,
        color: color,
        border: border,
        borderRadius: borderRadius,
        gradient: gradient,
      );
    }
    return Container(
      padding: padding,
      margin: margin,
      color: decoration == null ? color : null,
      height: height,
      width: width,
      constraints: constraints,
      decoration: decoration,
      alignment: alignment,
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}

class _LikeCollectShareArea extends StatefulWidget {
  const _LikeCollectShareArea({required this.data});

  final CurDetailsModel data;

  @override
  State<_LikeCollectShareArea> createState() => _LikeCollectShareAreaState();
}

class _LikeCollectShareAreaState extends State<_LikeCollectShareArea> {
  late final _blackDomain = context.read<BlackDomain>();
  bool _isChangeLikeLoading = false;
  bool _isChangeCollectLoading = false;

  Future<void> _changeLike() async {
    if (_isChangeLikeLoading) return;
    _isChangeLikeLoading = true;

    try {
      final result = await _blackDomain.getBlackLike(id: widget.data.id);
      if (result.status == 1) {
        final isLike = widget.data.isLike;
        widget.data.isLike = isLike;
        widget.data.likeNum += (isLike ? 1 : -1);
        if (widget.data.likeNum < 0) widget.data.likeNum = 0;

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
      final result = await _blackDomain.getBlackCollect(id: widget.data.id);
      if (result.status == 1) {
        final isFavorite = widget.data.isFavorite;
        widget.data.isFavorite = isFavorite;
        widget.data.favoriteNum += (isFavorite ? 1 : -1);
        if (widget.data.favoriteNum < 0) widget.data.favoriteNum = 0;

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
          PostLikeButton(isLiked: widget.data.isLike, onTap: _changeLike),
          SizedBox(width: 20.w),
          PostCollectButton(isCollected: widget.data.isFavorite, onTap: _changeCollect),
          SizedBox(width: 20.w),
          PostShareButton(onTap: () {
            const MineShareToUserRoute().push(context);
          }),
        ],
      ),
    );
  }
}
