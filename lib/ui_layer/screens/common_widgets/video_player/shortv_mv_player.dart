import 'package:analytics_sdk/enum/video_content_type_enum.dart';
import 'package:analytics_sdk/enum/video_event_enum.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/remote_domain/domains/cartoon.dart';
import 'package:jygf/report/analytics/analytics_report.dart';
import 'package:jygf/report/event_tracking.dart';
import 'package:jygf/ui_layer/screens/asmr/voice_player/voice_player_manager.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../domain/api_validator.dart';
import '../../../../domain/model/member_model.dart';
import '../../../../domain/model/video_detail_model.dart';
import '../../../../domain/remote_domain/domains/mv.dart';
import '../../../notifiers/home_config_notifier.dart';
import '../../../notifiers/user_notifier.dart';
import '../../../router/routes.dart';
import 'package:universal_html/html.dart' as html;

import '../../../utils/my_toast.dart';
import '../../image_paths.dart';
import '../../theme.dart';
import '../dialog/my_dialog.dart';
import '../dialog/widgets/png_dialog.dart';
import '../dialog/widgets/regular_dialog.dart';
import '../my_image.dart';
import 'utils/nvideourl_minxin.dart';

import '../../../../report/ui_layer/report_gesture_detector.dart';

class ShortvMvPlayer extends StatefulWidget {
  const ShortvMvPlayer({
    super.key,
    required this.info,
    this.isLocal = false,
    this.noBack = false,
    this.isLive = false,
    this.isCartoon = false,
    this.needCheckAspectRatio = false,
    this.needSlide = true,
  });
  final VideoData info;
  final bool isLocal;
  final bool noBack;
  final bool isLive;
  final bool isCartoon; // 动漫走另一个购买接口

  /// 显示全屏按钮是否判断视频长宽比
  final bool needCheckAspectRatio;
  final bool needSlide; //是否需要滑动快进，默认需要
  @override
  State<ShortvMvPlayer> createState() => _ShortvMvPlayerState();
}

class _ShortvMvPlayerState extends State<ShortvMvPlayer> with NVideoURLMinxin {
  FlickManager? flickManager;
  bool opened = true;
  bool isPreview = false;
  bool isDone = false;

  int _lastPosition = 0;
  bool _wasPlaying = false;
  bool _isCompleted = false;
  VideoPlayerController? _listeningController;

  //用来防止一次拖动触发多次快进/快退
  bool _seekLocked = false;
  final int _seekThresholdSec = 5; // 超过多少秒跳变算快进/快退
  final Duration _seekCooldown = const Duration(milliseconds: 500);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initURL();
  }

  initURL() async {
    String source_240 = widget.info.source240 ?? '';
    String previewUrl = widget.info.previewUrl ?? '';
    VideoPlayerController? cr;
    if (source_240.isNotEmpty) {
      isPreview = false;
      cr = await initController(source240: source_240, isLocal: widget.isLocal);
    } else {
      isPreview = true;
      cr = await initController(source240: previewUrl, isLocal: widget.isLocal);
    }
    if (cr == null) return;
    flickManager = FlickManager(
        videoPlayerController: cr,
        autoPlay: !kIsWeb,
        onVideoEnd: () {
          isDone = true;
          analyticsVideo(
            flickManager: flickManager,
            data: widget.info,
            videoEvent: VideoEventEnum.VIDEO_COMPLETE,
            videoContentType: VideoContentTypeEnum.video,
          );
          if (mounted) setState(() {});
        });

    // 移除旧监听，绑定新 controller
    _listeningController?.removeListener(_onVideoPlayerStateChanged);
    _listeningController = cr;
    cr.addListener(_onVideoPlayerStateChanged);

    // VIDEO_VIEW 埋点：视频资源就绪
    analyticsVideo(
      flickManager: flickManager,
      data: widget.info,
      videoEvent: VideoEventEnum.VIDEO_VIEW,
      videoContentType: VideoContentTypeEnum.video,
    );

    if (mounted) setState(() {});

    VoicePlayerManager.instance.audioController?.pause();
    VoicePlayerManager.instance.isPlay.value = false;
    VoicePlayerManager.instance.removeFloatPayer();
  }

  void _onVideoPlayerStateChanged() {
    if (!mounted) return;
    final isPlaying = _listeningController?.value.isPlaying ?? false;
    if (isPlaying && !_wasPlaying) {
      analyticsVideo(
        flickManager: flickManager,
        data: widget.info,
        videoEvent: VideoEventEnum.VIDEO_PLAY,
        videoContentType: VideoContentTypeEnum.video,
      );
    } else if (!isPlaying && _wasPlaying && !isDone) {
      analyticsVideo(
        flickManager: flickManager,
        data: widget.info,
        videoEvent: VideoEventEnum.VIDEO_PAUSE,
        videoContentType: VideoContentTypeEnum.video,
      );
    }
    _wasPlaying = isPlaying;
  }

  @override
  void dispose() {
    //显式停止播放器,防止视频格式异常导致播放器一直在播放错误无法释放
    flickManager?.flickVideoManager?.videoPlayerController?.pause();
    flickManager?.dispose();
    flickManager = null;

    // 释放 mixin 中创建的 Blob URL
    revokePreviousBlobUrl();
    _listeningController?.removeListener(_onVideoPlayerStateChanged);
    _listeningController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return flickManager == null
        ? Container()
        : VisibilityDetector(
            key: ObjectKey(flickManager),
            onVisibilityChanged: (visibility) {
              if (visibility.visibleFraction == 0 && mounted) {
                flickManager?.flickControlManager?.autoPause();
              } else if (visibility.visibleFraction == 1) {
                flickManager?.flickControlManager?.autoResume();
              }
            },
            child: FlickVideoPlayer(
              flickManager: flickManager!,
              flickVideoWithControls: FlickVideoWithControls(
                videoFit: BoxFit.contain,
                playerErrorFallback: Container(),
                playerLoadingFallback: Stack(
                  children: [
                    Positioned.fill(
                      child: MyImage.network(
                        widget.info.coverThumbHorizontal ??
                            widget.info.coverThumbVerticle ??
                            '',
                      ),
                    ),
                    Container(color: Colors.black87),
                  ],
                ),
                controls: SinkPortraitLandWidget(
                  needSlide: widget.needSlide,
                  isBack: true,
                  isDone: isDone,
                  isLive: widget.isLive,
                  info: widget.info,
                  isPreview: isPreview,
                  noBack: widget.noBack,
                  needCheckAspectRatio: widget.needCheckAspectRatio,
                  shareVp: () {
                    const MineWelfareRoute(index: 1).push(context);
                  },
                  skiPreview: () {
                    showAlertVp();
                  },
                  nowToVp: () {
                    const VipCenterRoute().push(context);
                  },
                  nowByKb: () {
                    showAlertVp(goby: true);
                  },
                  closeBarrage: (flag) {
                    opened = flag;
                    if (mounted) setState(() {});
                  },
                ),
              ),
              flickVideoWithControlsFullscreen: FlickVideoWithControls(
                playerErrorFallback: Container(),
                videoFit: BoxFit.contain,
                controls: SinkPortraitLandWidget(
                  needSlide: widget.needSlide,
                  info: widget.info,
                  noBack: false,
                  closeBarrage: (flag) {
                    opened = flag;
                    if (mounted) setState(() {});
                  },
                ),
              ),
            ),
          );
  }

  showAlertVp({bool goby = false}) {
    Member member = context.read<UserNotifier>().member;
    bool isInsufficient = member.money < (widget.info.coins!);
    if (goby && !isInsufficient) {
      byVideoRes(member.money - widget.info.coins!, goby); //直接购买
      return;
    }
    if (widget.info.isfree == 2) {
      MyDialog.showDialog(
          context: context,
          child: RegularDialog(
            title: tr('ts'),
            cancelText: isInsufficient ? tr('qwcz') : tr('gmgk'),
            buttonText: tr('fxdv'),
            confirmOnTap: () {
              const MineWelfareRoute(index: 1).push(context);
            },
            cancelOnTap: () {
              if (isInsufficient) {
                const CoinRechargeRoute().push(context);
              } else {
                byVideoRes(member.money - widget.info.coins!, goby);
              }
            },
            content: DefaultTextStyle(
              style: MyTheme.gray203_13,
              child: Column(
                children: [
                  Text(tr('gmspkwz'), style: MyTheme.gray203_13, maxLines: 3),
                  SizedBox(height: 15.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${widget.info.coins}${tr('jb')}',
                          style: MyTheme.blue80_13_M),
                    ],
                  ),
                  SizedBox(height: 15.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${tr('kyje')}：${member.money}${tr('jb')}",
                          style: MyTheme.gray203_13),
                    ],
                  ),
                ],
              ),
            ),
          ));
    } else {
      MyDialog.showDialog(
          context: context,
          child: PNGDialog(
            title: tr('ts'),
            cancelText: tr('cv'),
            buttonText: tr('fxdv'),
            cancelOnTap: () {
              const VipCenterRoute().push(context);
            },
            confirmOnTap: () {
              const MineWelfareRoute(index: 1).push(context);
            },
            content: DefaultTextStyle(
              style: MyTheme.gray203_13,
              child: Column(
                children: [
                  Text(tr('gmvkwz'), style: MyTheme.gray203_13),
                  SizedBox(height: 15.w),
                  Text(
                    context.read<HomeConfigNotifier>().config.tipsShareText ??
                        '',
                    style: MyTheme.gray203_13,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ));
    }
  }

  Future byVideoRes(int money, bool goby) async {
    MyToast.showLoading(text: tr('gmzz'));
    final userNotifier = context.read<UserNotifier>();
    final res = widget.isCartoon
        ? await context
            .read<CartoonDomain>()
            .cartoonBuy(id: widget.info.id ?? 0)
        : await context.read<MvDomain>().buyVideo(id: widget.info.id ?? 0);
    MyToast.closeAllLoading();
    if (mounted && !goby) {
      context.pop();
    }
    if (res.isValid) {
      userNotifier.setMoney(money: money);
      widget.info.source240 = res.data['url'];
      if (flickManager != null) {
        final newVideoUrl = widget.info.source240!;
        final newController = await initController(
            source240: newVideoUrl, isLocal: widget.isLocal);
        if (newController != null) {
          flickManager!.handleChangeVideo(newController);
          isPreview = false;
          if (mounted) {
            flickManager!.flickControlManager?.autoResume();
            setState(() {});
          }
        }
      } else {
        initURL();
      }
    } else {
      MyToast.showText(text: res.msg ?? '');
    }
  }
}

//横屏
class SinkPortraitLandWidget extends StatefulWidget {
  const SinkPortraitLandWidget({
    super.key,
    this.isBack = false,
    this.isPreview = false,
    this.isDone = false,
    this.isLive = false,
    this.info,
    this.skiPreview,
    this.shareVp,
    this.nowToVp,
    this.nowByKb,
    this.closeBarrage,
    this.needCheckAspectRatio = false,
    this.needSlide = true,
    required this.noBack,
  });
  final bool isBack;
  final bool isPreview;
  final bool isDone;
  final bool isLive;
  final VideoData? info;
  final Function? skiPreview; //跳过预览
  final Function? shareVp; //分享得VIP
  final Function? nowToVp; //立即开通
  final Function? nowByKb; //钻石购买
  final Function(bool)? closeBarrage;
  final bool noBack;

  /// 显示全屏按钮是否判断视频长宽比
  final bool needCheckAspectRatio;
  final bool needSlide; //是否需要滑动快进，默认需要
  @override
  State<SinkPortraitLandWidget> createState() => _SinkPortraitLandWidgetState();
}

class _SinkPortraitLandWidgetState extends State<SinkPortraitLandWidget> {
  double _speed = 1.0;
  Map<String, double> speedList = {
    '2.0': 2.0,
    '1.8': 1.8,
    '1.5': 1.5,
    '1.2': 1.2,
    '1.0': 1.0,
  };
  bool _hideSpeedStu = true;

  // build 倍数列表
  List<Widget> _buildSpeedListWidget() {
    FlickVideoManager flickVideoManager =
        Provider.of<FlickVideoManager>(context);
    List<Widget> columnChild = [];
    speedList.forEach((String mapKey, double speedVals) {
      columnChild.add(
        Ink(
          child: InkWell(
            onTap: () {
              if (_speed == speedVals) return;
              _speed = speedVals;
              _hideSpeedStu = true;
              flickVideoManager.videoPlayerController?.setPlaybackSpeed(_speed);
              setState(() {});
            },
            child: Container(
              alignment: Alignment.center,
              width: 50,
              height: 30,
              child: Text(
                '$mapKey X',
                style: TextStyle(
                  color: _speed == speedVals
                      ? MyTheme.jellyCyanColor103224185
                      : Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      );
      columnChild.add(
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Container(
            width: 50,
            height: 1,
            color: Colors.white54,
          ),
        ),
      );
    });
    columnChild.removeAt(columnChild.length - 1);
    return columnChild;
  }

  Widget _noConditionWidget(context) {
    FlickVideoManager flickVideoManager =
        Provider.of<FlickVideoManager>(context);
    FlickControlManager controlManager =
        Provider.of<FlickControlManager>(context);
    FlickDisplayManager flickDisplayManager =
        Provider.of<FlickDisplayManager>(context);

    bool flag = (flickVideoManager.videoPlayerValue!.isBuffering &&
            flickVideoManager.videoPlayerValue!.isPlaying) ||
        !flickVideoManager.videoPlayerValue!.isInitialized;

    double rate = flickVideoManager.videoPlayerValue?.aspectRatio ?? 0.0;

    return Stack(
      children: [
        Positioned.fill(
          child: FlickShowControlsAction(
            child: widget.needSlide
                ? FlickSlideVideoAction(
                    fontSize: 16,
                    child: Center(
                      child: flag
                          ? Center(
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.grey[400],
                                  strokeWidth: 1.5,
                                ),
                              ),
                            )
                          : const FlickAutoHideChild(
                              showIfVideoNotInitialized: false,
                              child: FlickPlayToggle(
                                replayChild: MyImage.asset(
                                  MyImagePaths.appVReplayN,
                                  width: 40,
                                  height: 40,
                                ),
                                playChild: MyImage.asset(
                                  MyImagePaths.appVPlayN,
                                  width: 40,
                                  height: 40,
                                ),
                                pauseChild: MyImage.asset(
                                  MyImagePaths.appVPauseN,
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            ),
                    ),
                  )
                : FlickAutoHideChild(
                    child: Center(
                      child: flag
                          ? Center(
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.grey[400],
                                  strokeWidth: 1.5,
                                ),
                              ),
                            )
                          : const FlickAutoHideChild(
                              showIfVideoNotInitialized: false,
                              child: FlickPlayToggle(
                                replayChild: MyImage.asset(
                                  MyImagePaths.appVReplayN,
                                  width: 40,
                                  height: 40,
                                ),
                                playChild: MyImage.asset(
                                  MyImagePaths.appVPlayN,
                                  width: 40,
                                  height: 40,
                                ),
                                pauseChild: MyImage.asset(
                                  MyImagePaths.appVPauseN,
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            ),
                    ),
                  ),
          ),
        ),
        FlickAutoHideChild(
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: IgnorePointer(
                  child: Container(
                    height: 55,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(0, 0, 0, 0.0),
                          Color.fromRGBO(0, 0, 0, 0.1),
                          Color.fromRGBO(0, 0, 0, 0.3),
                          Color.fromRGBO(0, 0, 0, 0.9),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ),
              if (!widget.isLive)
                Positioned(
                  left: MyTheme.pagePadding,
                  right: MyTheme.pagePadding,
                  bottom: 15,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              FlickCurrentPosition(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              Text(
                                ' / ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              FlickTotalDuration(
                                color: Colors.white,
                                fontSize: 16,
                              )
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              widget.info?.isSpeed == 1
                                  ? FlickSetPlayBack(
                                      speed: _speed,
                                      setPlayBack: () {
                                        _hideSpeedStu = !_hideSpeedStu;
                                        setState(() {});
                                      },
                                      playBackChild: Text(
                                        "${_speed == 1.0 ? '1.0' : _speed == 2.0 ? '2.0' : _speed} X",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    )
                                  : Container(),
                              (rate > 1 || !widget.needCheckAspectRatio) &&
                                          !widget.isPreview ||
                                      kIsWeb && !widget.isPreview
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: FlickFullScreenToggle(
                                        enterFullScreenChild: const Icon(
                                            Icons.fullscreen,
                                            size: 25,
                                            color: Colors.white),
                                        exitFullScreenChild: const Icon(
                                            Icons.fullscreen_exit,
                                            size: 25,
                                            color: Colors.white),
                                        toggleFullscreen: () {
                                          if (kIsWeb) {
                                            List<html.VideoElement> elements =
                                                html.document
                                                    .querySelectorAll('video');
                                            if (elements.isEmpty) return;

                                            html.VideoElement video =
                                                elements.last;
                                            video.muted = false;
                                            video.volume = 1;
                                            video.setAttribute(
                                                'playsinline', 'true');
                                            video.setAttribute(
                                                'autoplay', 'true');
                                            if (html.document
                                                    .fullscreenElement ==
                                                null) {
                                              video.enterFullscreen();
                                            } else {
                                              html.document.exitFullscreen();
                                            }
                                          } else {
                                            controlManager.toggleFullscreen();
                                          }
                                        },
                                      ),
                                    )
                                  : Container()
                            ],
                          )
                        ],
                      ),
                      !flickVideoManager.videoPlayerValue!.isInitialized ||
                              flickDisplayManager.showPlayerControls
                          ? FlickVideoProgressBar(
                              flickProgressBarSettings:
                                  FlickProgressBarSettings(
                                padding: const EdgeInsets.only(top: 10),
                                height: 3,
                                handleRadius: 6,
                                curveRadius: 4,
                                backgroundColor: Colors.white24,
                                bufferedColor: Colors.white38,
                                playedColor: MyTheme.jellyCyanColor103224185,
                                handleColor: Colors.transparent,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              widget.isPreview
                  ? Positioned(
                      right: 0,
                      bottom: 40.w,
                      child: ReportGestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          widget.skiPreview?.call();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          height: 30.w,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                MyTheme.jellyCyanColor103224185
                                    .withAlpha((0.6 * 255).toInt()),
                                MyTheme.jellyCyanColor103224185
                                    .withAlpha((0.6 * 255).toInt()),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.w),
                              bottomLeft: Radius.circular(15.w),
                            ),
                          ),
                          child: Center(
                            child: Text.rich(
                              TextSpan(
                                  text: widget.info?.isfree == 2
                                      ? '${widget.info?.coins}${tr('kbtgyl')}'
                                      : tr('ktvptgyl'),
                                  style: MyTheme.white255_12_B),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              // 倍数选择
              Positioned(
                right: controlManager.isFullscreen == false
                    ? (rate > 1 ? 39 : 3)
                    : (rate > 1 ? 50 : 3),
                bottom: 55,
                child: !_hideSpeedStu
                    ? FlickAutoHideChild(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              children: _buildSpeedListWidget(),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 2,
          child: Builder(builder: (context) {
            if (widget.noBack) {
              return const SizedBox.shrink();
            }
            return ReportGestureDetector(
              behavior: HitTestBehavior.translucent,
              child: SafeArea(
                top: false,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        offset: Offset(0, 0),
                        spreadRadius: 5,
                        blurRadius: 5,
                      )
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const MyImage.asset(
                    MyImagePaths.appNavBackWN,
                    width: 18,
                    height: 18,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              onTap: () {
                if (widget.isBack) {
                  context.pop();
                } else {
                  controlManager.toggleFullscreen();
                }
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _conditionWidget(BuildContext context) {
    Widget dgt = Container();
    var vflag = false;
    Member user = context.read<UserNotifier>().member;
    if (user.vipLevel < 1 && widget.info?.isfree == 1) {
      //需要VIP
      dgt = Text(tr('kvbw'), style: MyTheme.white255_14_M, maxLines: 2);
      vflag = false;
    } else if (widget.info?.isfree == 2) {
      dgt = DefaultTextStyle(
        style: MyTheme.white255_14_N,
        child: Text.rich(
          TextSpan(children: [
            TextSpan(
                text: '${widget.info?.coins ?? 0}', style: MyTheme.blue80_14_M),
            TextSpan(text: '${tr('jbjsw')}，'),
            TextSpan(text: '${tr('ktvpzk')}${user.money}')
          ]),
        ),
      );
      vflag = true;
    }
    return Container(
      color: Colors.black87,
      child: Column(children: [
        Padding(
          padding: EdgeInsets.all(8.w),
          child: Container(
            alignment: Alignment.centerLeft,
            height: 22,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.2),
                          offset: Offset(0, 0),
                          blurRadius: 11)
                    ],
                  ),
                  alignment: Alignment.center,
                  child: ReportGestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: const MyImage.asset(
                      MyImagePaths.appNavBackWN,
                      width: 18,
                      height: 18,
                      fit: BoxFit.contain,
                    ),
                    onTap: () {
                      context.pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 50,
            right: 50,
          ),
          child: Column(
            children: [
              Text(tr('skjs'), style: MyTheme.white255_14_M),
              const SizedBox(height: 10),
              dgt,
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ReportGestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (vflag) {
                    widget.nowByKb?.call();
                  } else {
                    widget.nowToVp?.call();
                  }
                },
                child: Container(
                  height: 32.w,
                  width: 110.w,
                  decoration: const BoxDecoration(
                    gradient: MyTheme.gradient_90_114,
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  child: Center(
                    child: Text(vflag ? tr('gmgk') : tr('ljkv'),
                        style: MyTheme.white13),
                  ),
                ),
              ),
              const SizedBox(width: 37),
              ReportGestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  widget.shareVp?.call();
                },
                child: Container(
                  height: 32.w,
                  width: 110.w,
                  decoration: const BoxDecoration(
                    gradient: MyTheme.gradient_90_114,
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  child: Center(
                    child: Text(tr('fxdv'), style: MyTheme.white13),
                  ),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.isDone && widget.isPreview
        ? _conditionWidget(context)
        : _noConditionWidget(context);
  }
}
