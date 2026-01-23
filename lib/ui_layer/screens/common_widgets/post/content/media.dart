import 'dart:math';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/model/member_model.dart';
import 'package:jygf/domain/remote_domain/domains/community.dart';
import 'package:jygf/domain/type_def.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';
import 'package:jygf/ui_layer/notifiers/user_notifier.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/community/coins_dialog.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/enum.dart';
import '../../../../../domain/model/media_model.dart';
import '../../../../utils/common_utils.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';
import '../../my_image.dart';

class PostMediaView extends StatefulWidget {
  final List<MediaModel> medias;
  final int unlockCoins;

  const PostMediaView({super.key, required this.medias, required this.unlockCoins});

  @override
  State<PostMediaView> createState() => _PostMediaViewState();
}

class _PostMediaViewState extends State<PostMediaView> {
  late final _domain = context.read<CommunityDomain>();
  int _currentUnlockCoins = 0;

  //会员/金币购买弹窗
  void dialogPrompt(BuildContext context, int index) {
    if (widget.medias.isEmpty) return;

    final videoMedias = widget.medias.where((m) => m.type == MyMediaType.video).toList();
    if (videoMedias.isNotEmpty) {
      Member member = context.read<UserNotifier>().member;
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => Material(
          type: MaterialType.transparency,
          child: PopScope(
            canPop: false,
            child: CoinsDialog(
              unlockCoins: _currentUnlockCoins,
              money: member.money,
              actionCallback: () {
                // 取第一个元素解锁
                final data = videoMedias.first;
                _pay(data, index, _currentUnlockCoins);
              },
            ),
          ),
        ),
      );
    } else {
      // 直接跳转
      MediaViewerRoute({'resources': widget.medias, 'index': index}).push(context);
    }
  }

  Future<void> _pay(MediaModel data, int index, int unlockCoins) async {
    MyToast.showLoading();
    final result = await _domain.reqGetPostURL(id: data.pid ?? 0, requestType: 1);
    MyToast.closeAllLoading();
    if (result.isValid) {
      if (mounted) {
        setState(() {
          data.mediaUrl = result.data['url'] ?? '';
          _currentUnlockCoins = 0;
        });
        final currentMoney = context.read<UserNotifier>().member.money - unlockCoins;
        context.read<UserNotifier>().setMoney(money: currentMoney);
        MediaViewerRoute({'resources': widget.medias, 'index': index}).push(context);
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
  }

  @override
  void initState() {
    _currentUnlockCoins = widget.unlockCoins;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// 前往图片/影片浏览页
    void goPictureView(int index) {
      if (_currentUnlockCoins > 0) {
        dialogPrompt(context, index);
      } else {
        MediaViewerRoute({'resources': widget.medias, 'index': index}).push(context);
      }
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: 10.w),
      itemCount: widget.medias.length,
      itemBuilder: (context, index) {
        final media = widget.medias[index];
        if (media.type == MyMediaType.video) {
          media.unlockCoins = _currentUnlockCoins;
        }
        double width = 1.sw - MyTheme.pagePadding * 2;
        final thumbWidth = media.thumbWidth.toDouble();
        final w = thumbWidth == 0.0 ? width : thumbWidth;
        final thumbHeight = media.thumbHeight.toDouble();
        final h = thumbHeight == 0.0 ? (width / 2) : thumbHeight;
        width = min(w, width);

        return widget.medias[index].type == MyMediaType.image
            ? Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: width,
                  height: width / w * h,
                  child: ReportGestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => goPictureView(index),
                    child: MyImage.network(CommonUtils.getThumb(widget.medias[index].toJson()), borderRadius: 5.w, fit: BoxFit.contain),
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.w),
                  _currentUnlockCoins > 0 && widget.medias[index].mediaUrl.isEmpty
                      ? Text(
                          "$_currentUnlockCoins${'jbjsgk'.tr(context: context)}:",
                          style: TextStyle(
                            color: MyTheme.cyanColor00edfd,
                            fontSize: 14.sp,
                          ),
                        )
                      : Text(
                          "${'shp'.tr(context: context)}:",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14.sp,
                          ),
                        ),
                  SizedBox(height: 5.w),
                  ReportGestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => goPictureView(index),
                    child: SizedBox(
                      width: 1.sw - MyTheme.pagePadding * 2,
                      height: (1.sw - MyTheme.pagePadding * 2) / 16 * 9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.w)),
                        child: Stack(
                          children: [
                            // // 图片在最底层
                            Positioned.fill(
                              child: MyImage.network(media.cover, borderRadius: 5.w, fit: BoxFit.cover),
                            ),
                            if (_currentUnlockCoins > 0 && widget.medias[index].mediaUrl.isEmpty)
                              ClipRRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                  child: Container(color: const Color.fromRGBO(176, 66, 255, 0.15)),
                                ),
                              ),
                            const Center(child: MyImage.asset(MyImagePaths.appVPlayN, width: 40, height: 40))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
      },
    );
  }
}
