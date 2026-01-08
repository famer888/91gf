import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/black/model/black_model.dart';
import 'package:jygf/ui_layer/screens/black/widgets/network_image_container.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:provider/provider.dart';

import '../../../../domain/enum.dart';
import '../../../../domain/model/media_model.dart';
import '../../../notifiers/user_notifier.dart';
import '../../../router/routes.dart';
import '../../../utils/common_utils.dart';

typedef PayViewCallback = Function(int type);

class HtmlBodyWidget extends StatefulWidget {
  final CurDetailsModel? blk;
  final PayViewCallback? callback;
  final double width;

  const HtmlBodyWidget(this.blk, {super.key, this.callback, required this.width});

  @override
  State createState() => _HtmlBodyWidgetState();
}

class _HtmlBodyWidgetState extends State<HtmlBodyWidget> {
  late final _screenUtil = ScreenUtil();
  late final _userNotifier = context.read<UserNotifier>();

  int getType() {
    if (widget.blk?.type == 1) {
      // vip
      if ((_userNotifier.member.vipHlPrivilege ?? 0) > 0) {
       return 0;
      } else {
        // 金币
        return 1;
      }
    } else if (widget.blk?.type == 2) {
      if ((_userNotifier.member.coinsHlPrivilege ?? 0) > 0) {
        return 0;
      } else {
        return 2;
      }
    } else {
      // 免费
      return 0;
    }
  }

  void onTap() {
    switch (widget.blk?.type) {
      case 1:
        widget.callback?.call(1);
        break;
      case 2:
        widget.callback?.call(2);
        break;
      default:
        widget.callback?.call(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    String html = widget.blk?.content ?? '';
    // html = kIsWeb
    //     ? html.replaceAll("</br>", "")
    //     : html.replaceAll("<br>", "").replaceAll("</br>", "");
    /// 注 PWA 真机问题 s+ 1个或多个空格
    html = html.replaceAll(RegExp(r'>\s+<'), '><');
    html = html.replaceAll("<br><img", "<img"); // 排版间距
    html = html.replaceAll("▶️ 点击播放", "");
    html = html.replaceAll("<hr>", ""); // 排版 ----------
    // html = html.replaceAll('\\', '');
    return Builder(
      builder: (context) => Html(
        shrinkWrap: true,
        // data: html.replaceAll('span', 'p'),
        data: html,
        style: {
          "*": Style(
            color: MyTheme.whiteColor,
            lineHeight: LineHeight.rem(1.2),
            margin: Margins.zero,
            padding: const EdgeInsets.all(0),
            fontSize: FontSize(12),
          ),
          "a": Style(color: MyTheme.blueColor63)
        },
        customRenders: {
          tagMatcher('img'): CustomRender.widget(widget: (renderContext, child) {
            String image = renderContext.tree.element?.attributes["src"] ?? "";
            if (image.isNotEmpty) {
              return _buildSingleImageWidget(image);
            } else {
              return Text.rich(TextSpan(children: child()));
            }
          }),
          tagMatcher('br'): CustomRender.widget(
            widget: (p0, p1) {
              return const SizedBox(width: double.infinity, height: 0.5);
            },
          ),
          tagMatcher('video'): CustomRender.widget(widget: (renderContext, child) {
            String video = renderContext.tree.element?.attributes["src"] ?? "";
            String image = renderContext.tree.element?.attributes["pic"] ?? "";
            if (image.isNotEmpty) {
              return _buildSingleVideoWidget(image, video);
            } else {
              return _buildSingleVideoWidget(widget.blk?.thumb ?? '', video);
            }
          }),
        },
        onLinkTap: (url, context, attributes, element) {
          CommonUtils.log('html action url ---> $url');
          CommonUtils.launchUrl(url ?? '');
        },
        onAnchorTap: (url, context, attributes, element) {},
      ),
    );
  }

  Widget _buildSingleImageWidget(String image) {
    Widget current = NetworkImageWidget(url: image);
    current = ClipRRect(
      borderRadius: BorderRadius.circular(5.w),
      clipBehavior: Clip.hardEdge,
      child: current,
    );

    Widget? maskLayer;
    if (widget.blk?.isPay != true) {
      if (getType() == 1) {
        maskLayer = GestureDetector(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            width: _screenUtil.screenWidth - 6 * MyTheme.pagePadding,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.w), gradient: MyTheme.gradient_90_114),
            padding: EdgeInsets.symmetric(vertical: 10.w),
            child: Text('开通VIP观看完整黑料', style: MyTheme.white255_13),
          ),
        );
      }
      if (getType() == 2) {
        maskLayer = GestureDetector(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            width: _screenUtil.screenWidth - 6 * MyTheme.pagePadding,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.w), gradient: MyTheme.gradient_90_114),
            padding: EdgeInsets.symmetric(vertical: 10.w),
            child: Text('支付${widget.blk?.coins}金币解锁完整黑料', style: MyTheme.white255_13),
          ),
        );
      }

      if (getType() == 1 || getType() == 2) {
        maskLayer = BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Stack(
            children: [
              Align(alignment: Alignment.center, child: maskLayer!),
              Transform.scale(scale: 0.3, child: Container(color: Colors.transparent)),
            ],
          ),
        );
      }

    }
    if (maskLayer != null) {
      current = Stack(
        alignment: AlignmentDirectional.center,
        children: [current, maskLayer],
      );
      current = ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(5.w),
        child: current,
      );
    }

    return Container(
      constraints: BoxConstraints(minHeight: 100.w), // 寬度
      width: _screenUtil.screenWidth,
      margin: EdgeInsets.only(top: 5.w, bottom: 5.w),
      child: current,
    );
  }

  Widget _buildSingleVideoWidget(String image, String video) {
    Widget current = NetworkImageWidget(url: image);
    current = ClipRRect(borderRadius: BorderRadius.circular(5.w), clipBehavior: Clip.hardEdge, child: current);

    Widget? maskLayer;
    if (widget.blk?.isPay != true) {
      if (getType() == 1) {
        maskLayer = GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Expanded(child: Text('开通VIP观看完整黑料', style: MyTheme.white255_13)),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.w), gradient: MyTheme.gradient_90_114),
                padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 15.w),
                child: Text('立即开通', style: MyTheme.white255_13),
              ),
            ],
          ),
        );
      }
      if (getType() == 2) {
        maskLayer = GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Expanded(child: Text('支付${widget.blk?.coins}金币解锁完整黑料', style: MyTheme.white255_13)),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.w), gradient: MyTheme.gradient_90_114),
                padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 15.w),
                child: Text('立即支付', style: MyTheme.white255_13),
              ),
            ],
          ),
        );
      }
    }

    if (maskLayer != null) {
      maskLayer = Column(children: [
        Expanded(child: Image.asset(MyImagePaths.appPostPlay, width: 35.w)),
        Container(
          height: 35.w,
          decoration:
          BoxDecoration(borderRadius: BorderRadius.vertical(bottom: Radius.circular(5.w)), color: const Color.fromRGBO(0, 0, 0, 0.5)),
          child: maskLayer,
        ),
      ]);

      if (getType() == 1 || getType() == 2) {
        maskLayer = BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Stack(
            children: [
              Positioned.fill(child: maskLayer),
              Transform.scale(scale: 0.1, child: Container(color: Colors.transparent)),
            ],
          ),
        );
      }
      current = Stack(
        fit: StackFit.expand,
        alignment: AlignmentDirectional.center,
        children: [current, maskLayer],
      );
      current = GestureDetector(
        onTap: onTap,
        child: ClipRect(clipBehavior: Clip.hardEdge, child: current),
      );
    } else {
      current = Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.expand,
        children: [
          current,
          Center(child: Image.asset(MyImagePaths.appPostPlay, width: 35.w)),
        ],
      );
      current = GestureDetector(
        onTap: () {
          List<MediaModel> medias = [MediaModel(mediaUrl: video, cover: image, type: MyMediaType.video, thumbWidth: 375, thumbHeight: 667)];
          MediaViewerRoute({'resources': medias, 'index': 0}).push(context);
        },
        child: current,
      );
    }

    return Container(
      margin: EdgeInsets.only(top: 5.w, bottom: 5.w),
      width: _screenUtil.screenWidth,
      height: _screenUtil.screenWidth * 9 / 16,
      child: current,
    );
  }
}
