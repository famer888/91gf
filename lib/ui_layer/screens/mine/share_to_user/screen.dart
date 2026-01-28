import 'dart:io';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../domain/api_validator.dart';
import '../../../../domain/async_value.dart';
import '../../../../domain/domain.dart';
import '../../../../domain/model/member_model.dart';
import '../../../../domain/model/proxy_detail_model.dart';
import '../../../notifiers/home_config_notifier.dart';
import '../../../notifiers/user_notifier.dart';
import '../../../router/routes.dart';
import '../../../utils/common_utils.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/my_button.dart';
import '../../common_widgets/my_image.dart';
import '../../common_widgets/screen_background.dart';
import '../../common_widgets/status/loading.dart';
import '../../common_widgets/status/network_error.dart';
import '../../image_paths.dart';
import '../../theme.dart';
import '../widgets/mine_agent_apply.dart';
import 'widgets/jelly_share.dart';
import 'widgets/share_tips.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class MineShareToUserScreen extends StatefulWidget {
  const MineShareToUserScreen({super.key});

  @override
  State<MineShareToUserScreen> createState() => _MineShareToUserScreenState();
}

class _MineShareToUserScreenState extends State<MineShareToUserScreen> {
  late final proxyDomain = context.read<ProxyDomain>();
  late Member member;

  AsyncValue<ProxyDetail?> _asyncValue = const AsyncInit();

  /// 是否显示申请页面
  bool showApplyPage = false;

  @override
  void initState() {
    _loadUserAgentData();
    super.initState();
  }

  Future _loadUserAgentData() async {
    member = context.read<UserNotifier>().member;

    if (_asyncValue.isLoading) return;

    setState(() {
      _asyncValue = const AsyncLoading();
    });
    if (!member.isSelf) {
      showApplyPage = true;
      setState(() {
        _asyncValue = const AsyncData(null);
      });
      return;
    }

    final res = await proxyDomain.getProxyDetail();

    if (!res.isValid) {
      if ((res.msg ?? '').contains('请先申请成为代理')) {
        showApplyPage = true;
        _asyncValue = const AsyncData(null);
      } else {
        MyToast.showText(text: res.msg ?? '');
        _asyncValue = const AsyncError();
      }
    } else {
      _asyncValue = AsyncData(res.data);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return _asyncValue.maybeWhen(
      error: (_, __) => ScreenBackground(
        child: Scaffold(
          body: NetworkErrorView(onTap: _loadUserAgentData),
        ),
      ),
      orElse: () => const ScreenBackground(
        child: Scaffold(
          body: LoadingView(),
        ),
      ),
      data: (data) => showApplyPage
          ? ScreenBackground(
            child: Scaffold(
                appBar: MyAppBar(
                  title: 'fxtg'.tr(context: context),
                  rightWidget: ReportGestureDetector(
                    onTap: () => const MineShareToUserRecordRoute().push(context),
                    child: Text(
                      'yqjl'.tr(context: context),
                      style: MyTheme.graya3a2a2_15,
                    ),
                  ),
                ),
                body: MineAgentApplyView(
                  applySuccess: () {
                    showApplyPage = false;
                    _loadUserAgentData();
                  },
                ),
              ),
          )
          : Scaffold(body: _Body(proxyDetail: data)),
    );
  }
}

class _SnapShotView extends StatelessWidget {
  const _SnapShotView({this.affUrl, this.affCode, this.officeSite});

  final String? affUrl;
  final String? affCode;
  final String? officeSite;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: MyTheme.bgColor),
        Positioned(
          left: MyTheme.pagePadding,
          right: MyTheme.pagePadding,
          child: Column(
            children: [
              SizedBox(height: 30.w),
              SizedBox(
                width: 344.w,
                height: 467.w,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: 344.w,
                        height: 428.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.w),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 90.w),
                            SizedBox(
                              // color: Colors.red,
                              height: 45.w,
                              child: Center(
                                child: Text(
                                  'Hey bro，我在${'yybt'.tr(context: context)}，来免费看原创乱伦视频',
                                  style: MyTheme.black13,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 198.w,
                              height: 198.w,
                              child: Stack(
                                children: [
                                  const Positioned.fill(
                                    child: MyImage.asset(
                                        MyImagePaths.appMineShareQrcodeBg),
                                  ),
                                  Center(
                                    child: SizedBox(
                                      width: 154.w,
                                      height: 154.w,
                                      child: QrImageView(
                                        data: '$affUrl',
                                        version: 3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 26.5.w),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(22.5.w),
                              child: Container(
                                width: 185.w,
                                height: 45.w,
                                decoration: const BoxDecoration(
                                  gradient: MyTheme.gradient_90_114,
                                ),
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                        text: '${'tgm'.tr(context: context)}:',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        children: <TextSpan>[
                                          const TextSpan(text: '  '),
                                          TextSpan(
                                            text: '$affCode',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ]),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: MyImage.asset(
                        MyImagePaths.appMineJellyShareIconTitle,
                        width: 95.w,
                        height: 118.w,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.w),
              Text(
                '${'gwdz'.tr(context: context)}：$officeSite',
                style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 11.w),
              Text(
                'qwsy'.tr(context: context),
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  height: 1.4,
                  fontWeight: FontWeight.normal,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    this.proxyDetail,
  });
  final ProxyDetail? proxyDetail;
  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final snapShotViewKey = GlobalKey();
  late final config = context.read<HomeConfigNotifier>().config;
  late final member = context.read<UserNotifier>().member;
  ProxyDetail? get proxyDetail => widget.proxyDetail;
  int? get directProxyNum => proxyDetail?.directProxyNum;

  /// 复制链接分享
  Future<void> _copyLinkShare() async {
    CommonUtils.copyToClipboard(text: '${member.share?.affUrlCopy?.url}');
    MyToast.showText(text: 'fzcg'.tr());
  }

  Future _saveImageToGallery(BuildContext context) async {
    if (kIsWeb) {
      MyToast.showText(text: 'zxjt'.tr());
    } else {
      final statuses = await [
        Permission.storage,
        Permission.camera,
      ].request();

      if (!context.mounted) return;

      if (statuses[Permission.storage] == PermissionStatus.granted &&
          statuses[Permission.camera] == PermissionStatus.granted) {
        await _localStorageImage(context);
      } else {
        MyToast.showText(text: 'wfbc'.tr());
        return;
      }
    }
  }

  Future _localStorageImage(BuildContext context) async {
    if (context.findRenderObject() case final RenderRepaintBoundary boundary) {
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      if (await image.toByteData(format: ui.ImageByteFormat.png)
          case final byteData?) {
        final pngBytes = byteData.buffer.asUint8List();

        /// 这个是核心的保存图片的插件
        final result = await ImageGallerySaverPlus.saveImage(pngBytes);
        if (!context.mounted) return;

        if (result['isSuccess']) {
          MyToast.showText(text: 'xxcgwd'.tr(context: context));
        } else if (Platform.isAndroid) {
          if (result.length > 0) {
            MyToast.showText(text: 'xxcgwd'.tr(context: context));
          }
        }
      }
    }
  }

  Widget _buildActionView() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MyButton.gradient(
          minimumSize: Size(150.w, 38.5.w),
          text: 'bczshb'.tr(context: context),
          gradient: MyTheme.shareButtonGradient,
          onPressed: () async {
            if (snapShotViewKey.currentContext case final context?) {
              await _saveImageToGallery(context);
            }
          },
        ),
        SizedBox(width: 15.w),
        MyButton.gradient(
          minimumSize: Size(150.w, 38.5.w),
          text: 'fztglj'.tr(context: context),
          gradient: MyTheme.gradient_90_114,
          onPressed: () async {
            _copyLinkShare();
          },
        ),
      ],
    );
  }

  List textsWithMiddleKey({required String text, required String key}) {
    var results = text.split(key);
    final list = [];
    for (var i = 0; i < results.length; i++) {
      list.add({'type': 0, 'word': results[i]});
      if (i != results.length - 1) {
        list.add({'type': 1, 'word': key});
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 1.sw,
          height: 667.w,
          child: RepaintBoundary(
            key: snapShotViewKey,
            child: _SnapShotView(
              affUrl: member.share?.affUrl,
              affCode: member.share?.affCode,
              officeSite: config.officeSite,
            ),
          ),
        ),
        ScreenBackground(
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: MyAppBar(
              title: '分享推广',
              rightWidget: ReportGestureDetector(
                onTap: () => const MineShareToUserRecordRoute().push(context),
                child: Text(
                  'yqjl'.tr(context: context),
                  style: MyTheme.graya3a2a2_15,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  SafeArea(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 16.5.w), child: JellyShareCard(proxyDetail: proxyDetail)),
                        SizedBox(height: 20.w),
                        _buildActionView(),
                        SizedBox(height: 20.w),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.5.w),
                          child: MineShareToUserTips(
                            proxyDetail: proxyDetail,
                          ),
                        ),
                        SizedBox(height: 30.w),
                        Text(
                          'yqbz'.tr(context: context),
                          style: MyTheme.white255_24_B,
                        ),
                        SizedBox(height: 10.w),
                        Text(
                          config.tipsShareText ?? 'loading',
                          style: MyTheme.white255_15,
                        ),
                        SizedBox(height: 50.w),
                        Stack(
                          children: [
                            MyImage.asset(
                              MyImagePaths.appWdFxbotmbgN,
                              height: 500.w,
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 20.w,
                              child: ReportGestureDetector(
                                onTap: () => const MineAgentRoute().push(context),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 50.w),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
