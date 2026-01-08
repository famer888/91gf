import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/black/widgets/index_key.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

import '../../../../domain/remote_domain/domains/black_domain.dart';
import '../../../utils/common_utils.dart';
import '../../theme.dart';

/// 左图 + 间距 + 统计数字
class IconTextWidget extends StatelessWidget {
  final String iconName;
  final double? width;
  final double? height;
  final double spacing;
  final dynamic count;
  final String? text;

  const IconTextWidget({
    super.key,
    required this.iconName,
    this.width,
    this.height,
    this.spacing = 0,
    this.count,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(width: width ?? 25.w, height: height, child: Image.asset(iconName)),
      SizedBox(width: spacing),
      Text(count != null ? CommonUtils.formatNumber(count) : '$text', style: MyTheme.white08_12),
    ]);
  }
}

/// 帖子-观看/阅读数
class ViewIconTextWidget extends StatelessWidget {
  final IndexKey? indexKey;
  final int style;
  final int count;

  const ViewIconTextWidget({
    super.key,
    this.indexKey,
    this.style = 0,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return IconTextWidget(iconName: MyImagePaths.appView25, count: count);
  }
}

/// 帖子-时间
class DateIconTextWidget extends StatelessWidget {
  final IndexKey? indexKey;
  final int style;
  final String date;

  const DateIconTextWidget({
    super.key,
    this.indexKey,
    this.style = 0,
    this.date = '',
  });

  @override
  Widget build(BuildContext context) {
    switch (indexKey) {
      case IndexKey.post:
      case IndexKey.seed:
        return _buildHorLayoutWidget();
      default:
        return const SizedBox();
    }
  }

  Widget _buildHorLayoutWidget() {
    var dateTime = DateTime.parse(date); // 时间格式化
    return Row(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(height: 25.w, width: 25.w, child: Image.asset(MyImagePaths.appDate25)),
      // SizedBox(width: 4.w),
      Text(
        '${dateTime.month.toString().padLeft(2, '0')}'
        '-${dateTime.day.toString().padLeft(2, '0')}',
        // date.length > 10 ? date.substring(0, 10) : date,
        style: MyTheme.white08_12,
      ),
    ]);
  }
}

/// 评论
class CommentIconTextWidget extends StatelessWidget {
  final IndexKey? indexKey;
  final int style;
  final int count;
  final void Function()? callback;

  ///
  /// @param style
  ///
  const CommentIconTextWidget({
    super.key,
    this.indexKey,
    this.style = 0,
    required this.count,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    switch (indexKey) {
      case IndexKey.post:
      case IndexKey.seed:
      case IndexKey.black:
      case IndexKey.novel:
        return _buildHorLayoutWidget();
      case IndexKey.graph:
        return _buildGraphCletWidget(context);
      case IndexKey.short:
        return _buildVerTiktokWidget();
      default:
        return const SizedBox();
    }
  }

  Widget _buildHorLayoutWidget() {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(height: 25.w, width: 25.w, child: Image.asset(MyImagePaths.appComment25)),
      Text(CommonUtils.formatNumber(count), style: MyTheme.white25508_16_M.s13),
    ]);
  }

  Widget _buildGraphCletWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callback?.call();
      },
      child: Container(
        width: 75.w,
        height: 38.w,
        padding: EdgeInsets.all(1.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.w),
          color: MyTheme.blueColor63,
        ),
        child: IconTextWidget(iconName: MyImagePaths.appComment25, text: 'pl'.tr(context: context)),
      ),
    );
  }

  Widget _buildVerTiktokWidget() {
    Widget current = Column(children: [
      SizedBox(height: 34.w, width: 34.w, child: Image.asset(MyImagePaths.appComment35)),
      SizedBox(height: 2.w),
      Text(CommonUtils.formatNumber(count), style: MyTheme.white255_13.s12),
    ]);
    return GestureDetector(
      onTap: () {
        callback?.call();
      },
      child: Container(
        width: 43.w,
        margin: EdgeInsets.only(top: 15.w),
        child: current,
      ),
    );
  }
}

/// 分享
class ShareIconTextWidget extends StatelessWidget {
  final IndexKey? indexKey;
  final int style;

  const ShareIconTextWidget({
    super.key,
    this.indexKey,
    this.style = 0,
  });

  @override
  Widget build(BuildContext context) {
    switch (indexKey) {
      case IndexKey.chat:
      case IndexKey.date:
      case IndexKey.long:
      case IndexKey.video:
      case IndexKey.seed:
      case IndexKey.game:
      case IndexKey.live:
      case IndexKey.black:
        return _buildHorLayoutWidget(context);
      case IndexKey.short:
        return _buildVerTiktokWidget(context);
      default:
        return const SizedBox();
    }
  }

  Widget _buildHorLayoutWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        const MineShareToUserRoute().push(context);
      },
      child: SizedBox(
        height: 30.w,
        child: IconTextWidget(iconName: MyImagePaths.appShare25, text: 'fx'.tr(context: context)),
      ),
    );
  }

  Widget _buildVerTiktokWidget(BuildContext context) {
    Widget current = Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(height: 34.w, width: 34.w, child: Image.asset(MyImagePaths.appShare35)),
      SizedBox(height: 2.w),
      Text('fx'.tr(context: context), style: MyTheme.white255_13.s12),
    ]);
    return GestureDetector(
      onTap: () {
        const MineShareToUserRoute().push(context);
      },
      child: Container(
        width: 43.w,
        margin: EdgeInsets.only(top: 15.w),
        child: IconTextWidget(iconName: MyImagePaths.appShare25, text: 'fx'.tr(context: context)),
      ),
    );
  }
}

/// 点赞
class LikeIconTextWidget extends StatefulWidget {
  final IndexKey? indexKey; // 来源-日
  final int style; // 0 - item list, 1 - detail bottom bar
  final String urlPath;
  final Map<String, dynamic> params;
  final bool isLiked;
  final int likeNum;
  final void Function(bool)? valueCallback;

  const LikeIconTextWidget({
    super.key,
    this.indexKey,
    this.style = 0,
    required this.urlPath,
    this.params = const {},
    this.likeNum = 0,
    required this.isLiked,
    this.valueCallback,
  });

  @override
  State createState() => _LikeIconTextWidgetState();
}

class _LikeIconTextWidgetState extends State<LikeIconTextWidget> {
  late final _blockDomain = context.read<BlackDomain>();
  bool isLiked = false;
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked;
    likeCount = widget.likeNum;
  }

  @override
  void didUpdateWidget(covariant LikeIconTextWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    isLiked = widget.isLiked;
    likeCount = widget.likeNum;
  }

  void onTap() async {
    final id = widget.params['id'] ?? 0;
    final likeModel = await _blockDomain.getBlackLike(id: id);
    if (likeModel.status == 1) {
      isLiked = !isLiked;
      if (isLiked) {
        likeCount += 1;
      } else {
        likeCount -= 1;
      }
      widget.valueCallback?.call(isLiked);
      if (mounted) setState(() {});
    } else {
      MyToast.showText(text: likeModel.msg ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.indexKey) {
      case IndexKey.chat:
      case IndexKey.post:
      case IndexKey.seed:
      case IndexKey.game:
      case IndexKey.novel:
      case IndexKey.long:
      case IndexKey.video:
      case IndexKey.live:
      case IndexKey.black:
        return _buildHorLikeWidget(context);
      case IndexKey.date:
        if (widget.style == 1) {
          return _buildHorLikeWidget(context);
        } else {
          return _buildMeetLikeWidget(context);
        }
      case IndexKey.graph:
        return _buildGraphLikeWidget(context);
      case IndexKey.short:
        return _buildVerTiktokWidget();
      default:
        return const SizedBox();
    }
  }

  Widget _buildHorLikeWidget(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: SizedBox(
        height: 30.w,
        child: IconTextWidget(
          iconName: isLiked ? MyImagePaths.appLike251 : MyImagePaths.appLike250,
          text: likeCount > 0 ? null : 'dz'.tr(context: context),
          count: likeCount > 0 ? likeCount : null,
        ),
      ),
    );
  }

  Widget _buildMeetLikeWidget(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: SizedBox(
        height: widget.style == 1 ? 30.w : 20.w,
        child: IconTextWidget(
          iconName: isLiked ? MyImagePaths.appLike251 : MyImagePaths.appLike250,
          text: likeCount > 0 ? null : 'dz'.tr(context: context),
          count: likeCount > 0 ? likeCount : null,
        ),
      ),
    );
  }

  Widget _buildGraphLikeWidget(BuildContext context) {
    Widget current = IconTextWidget(
      iconName: isLiked ? MyImagePaths.appLike251 : MyImagePaths.appLike250,
      text: likeCount > 0 ? null : 'dz'.tr(context: context),
      count: likeCount > 0 ? likeCount : 'dz'.tr(context: context),
    );
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.all(1.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.w),
          color: MyTheme.blueColor63,
        ),
        child: Container(
          width: 75.w,
          height: 38.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.w),
            color: const Color.fromRGBO(24, 26, 36, 1),
          ),
          alignment: Alignment.center,
          child: current,
        ),
      ),
    );
  }

  Widget _buildVerTiktokWidget() {
    var iconName = isLiked ? MyImagePaths.appLike352 : MyImagePaths.appLike351;
    Widget current = Column(children: [
      SizedBox(height: 36.w, width: 36.w, child: Image.asset(iconName)),
      SizedBox(height: 2.w),
      Text(CommonUtils.formatNumber(likeCount), style: MyTheme.white255_13.s12),
    ]);
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(margin: EdgeInsets.only(top: 15.w), width: 43.w, child: current),
    );
  }
}

/// 收藏
class CletIconTextWidget extends StatefulWidget {
  final IndexKey? indexKey;
  final int style; // 0 item, 1 detail 3 左图右字
  final String urlPath;
  final Map<String, dynamic> params;
  final bool isFavorited;
  final int favoriteNum;
  final void Function(bool)? valueCallback;

  const CletIconTextWidget({
    super.key,
    this.indexKey,
    this.style = 0,
    required this.urlPath,
    this.params = const {},
    this.favoriteNum = 0,
    required this.isFavorited,
    this.valueCallback,
  });

  @override
  State createState() => _CletIconTextWidgetState();
}

class _CletIconTextWidgetState extends State<CletIconTextWidget> {
  late final _blockDomain = context.read<BlackDomain>();
  bool isCollected = false;
  int collectCount = 0;

  @override
  void initState() {
    super.initState();
    isCollected = widget.isFavorited;
    collectCount = widget.favoriteNum;
  }

  @override
  void didUpdateWidget(covariant CletIconTextWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    isCollected = widget.isFavorited;
    collectCount = widget.favoriteNum;
  }

  void onTap() async {
    final postId = widget.params['id'];
    final result = await _blockDomain.getBlackCollect(id: postId);
    if (result.status == 1) {
      isCollected = !isCollected;
      if (isCollected) {
        collectCount += 1;
      } else {
        collectCount -= 1;
      }
      widget.valueCallback?.call(isCollected);
      if (mounted) setState(() {});
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    // 底部
    if (widget.style == 3) {
      return _buildBotLayoutWidget();
    }
    // style == 0 -> item
    switch (widget.indexKey) {
      case IndexKey.chat:
      case IndexKey.date:
      case IndexKey.game:
      case IndexKey.novel:
      case IndexKey.long:
      case IndexKey.video:
      case IndexKey.live:
        return _buildHorLayoutWidget();
      case IndexKey.graph:
        return _buildGraphCletWidget(context);
      case IndexKey.short:
        return _buildVerTiktokWidget();
      default:
        return const SizedBox();
    }
  }

  Widget _buildHorLayoutWidget() {
    Widget current = const SizedBox();
    var iconName = isCollected ? MyImagePaths.appClet251 : MyImagePaths.appClet250;
    current = Row(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(height: 25.w, width: 25.w, child: Image.asset(iconName)),
      // SizedBox(width: 3.5.w),
      Text(collectCount > 0 ? CommonUtils.formatNumber(collectCount) : (isCollected ? 'ysc'.tr(context: context) : 'sc'.tr(context: context)),
          style: MyTheme.white07_12.s13),
    ]);

    return GestureDetector(
      onTap: () => onTap(),
      child: SizedBox(height: 30.w, child: current),
    );
  }

  Widget _buildBotLayoutWidget() {
    String iconName = isCollected ? MyImagePaths.appClet251 : MyImagePaths.appClet250;
    switch (widget.indexKey) {
      case IndexKey.novel:
        Widget current = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 30.w, width: 30.w, child: Image.asset(iconName)),
            SizedBox(width: 5.w),
            Text(isCollected ? '已收藏' : '收藏', style: MyTheme.white255_13.s15),
          ],
        );
        return GestureDetector(
          onTap: () => onTap(),
          child: SizedBox(
            height: 30.w,
            child: current,
          ),
        );
      case IndexKey.post:
      case IndexKey.seed:
      case IndexKey.game:
      case IndexKey.black:
        // Widget current = Stack(
        //   alignment: AlignmentDirectional.center,
        //   children: [
        //     Positioned(top: 0, child: SizedBox(height: 30.w, width: 30.w, child: Image.asset(iconName))),
        //     Positioned(bottom: 0.w, child: Text(isCollected ? '已收藏' : '收藏', style: MyTheme.white255_13)),
        //   ],
        // );
        // return Convenience.buildChildActionWidget(
        //   onTap: () => onTap(),
        //   width: 45.w,
        //   height: 40.w,
        //   child: current,
        // );
        return GestureDetector(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30.w, width: 30.w, child: Image.asset(iconName)),
              SizedBox(height: 1.w),
              Text(isCollected ? '已收藏' : '收藏', style: MyTheme.white255_12),
            ],
          ),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildGraphCletWidget(BuildContext context) {
    Widget current = IconTextWidget(
      width: 25.w,
      iconName: isCollected ? MyImagePaths.appClet251 : MyImagePaths.appClet250,
      text: collectCount > 0 ? null : 'sc'.tr(context: context),
      count: collectCount > 0 ? collectCount : null,
    );

    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: 75.w,
        height: 38.w,
        padding: EdgeInsets.all(1.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.w),
          color: MyTheme.blueColor63,
        ),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.w),
            color: const Color.fromRGBO(24, 26, 36, 1),
          ),
          child: current,
        ),
      ),
    );
  }

  Widget _buildVerTiktokWidget() {
    String iconName = isCollected ? MyImagePaths.appClet352 : MyImagePaths.appClet351;
    Widget current = Column(children: [
      SizedBox(height: 36.w, width: 36.w, child: Image.asset(iconName)),
      SizedBox(height: 2.w),
      Text(CommonUtils.formatNumber(collectCount), style: MyTheme.white255_13),
    ]);
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(margin: EdgeInsets.only(top: 15.w), width: 43.w, child: current),
    );
  }
}
