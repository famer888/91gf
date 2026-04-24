// ignore_for_file: non_constant_identifier_names
import 'dart:math';
import 'package:analytics_sdk/enum/video_content_type_enum.dart';
import 'package:analytics_sdk/enum/video_event_enum.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/report/analytics/analytics_report.dart';
import 'package:jygf/report/event_tracking.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/domain.dart';
import 'package:jygf/domain/model/member_model.dart';
import 'package:jygf/domain/model/vlog_model.dart';
import 'package:jygf/domain/type_def.dart';
import 'package:jygf/ui_layer/notifiers/user_notifier.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/asmr/voice_player/voice_player_manager.dart';
import 'package:jygf/ui_layer/screens/common_widgets/dialog/widgets/regular_dialog.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/video_player/utils/nvideourl_minxin.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/vlog/widgets/vlog_comment_sheet.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';

import '../../../../report/ui_layer/report_gesture_detector.dart';

class ShortVPlayer extends StatefulWidget {
  const ShortVPlayer({
    super.key,
    this.info,
    this.keepBottomBlank = false,
  });

  final VlogModel? info;
  final bool keepBottomBlank; // 底部要不要留白

  @override
  State<ShortVPlayer> createState() => _ShortVPlayerState();
}

class _ShortVPlayerState extends State<ShortVPlayer> with NVideoURLMinxin {
  VideoPlayerController? cr;
  FlickManager? flickManager;
  bool isPreview = false;
  bool isDone = false;

  late final vlogDomain = context.read<VlogDomain>();
  late final userDomain = context.read<UserDomain>();
  late final communityDomain = context.read<CommunityDomain>();

  int _lastPosition = 0;
  bool _wasPlaying = false;
  bool _isCompleted = false;

  //用来防止一次拖动触发多次快进/快退
  bool _seekLocked = false;
  final int _seekThresholdSec = 5; // 超过多少秒跳变算快进/快退
  final Duration _seekCooldown = const Duration(milliseconds: 500);

  @override
  void didUpdateWidget(ShortVPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.info != oldWidget.info) {
      initURL();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initURL();
  }

  void initURL() async {
    if (widget.info == null) return;
    String source_240 = widget.info?.source_240 ?? '';
    String preview_url = widget.info?.previewUrl ?? '';

    if (source_240.isNotEmpty) {
      isPreview = false;
      cr = await initController(source240: source_240, isShort: 1);
    } else {
      isPreview = true;
      cr = await initController(source240: preview_url, isShort: 1);
    }

    vlogDomain.reportVlogPlay(id: widget.info?.id ?? 0);

    if (cr == null) return;
    flickManager = FlickManager(
        videoPlayerController: cr!,
        autoPlay: !kIsWeb,
        onVideoEnd: () {
          isDone = true;
          if (mounted) setState(() {});
          // 预览视频播放完成后直接弹出购买弹窗
          if (isPreview && mounted) {
            showAlertVp();
          }
        });

    // flickManager?.flickVideoManager?.videoPlayerController
    //     ?.addListener(_videoListener);
    if (mounted) setState(() {});

    VoicePlayerManager.instance.audioController?.pause();
    VoicePlayerManager.instance.isPlay.value = false;
    VoicePlayerManager.instance.removeFloatPayer();
    VoicePlayerManager.instance.disposes();
  }
  //
  // void _videoListener() {
  //   final value = flickManager?.flickVideoManager?.videoPlayerController?.value;
  //   if (value == null) return;
  //
  //   final currentSec = value.position.inSeconds;
  //   final totalSec = value.duration.inSeconds;
  //
  //   // ===== 播放 / 暂停 =====
  //
  //   // 开始播放（从不播放 -> 播放）
  //   if (value.isPlaying && !_wasPlaying) {
  //     reportVideo(video_behavior_key: "video_play", video_behavior_name: "播放");
  //     _wasPlaying = true;
  //     _isCompleted = false; // 重新播放时重置完成标记
  //   }
  //
  //   // 暂停（从播放 -> 不播放，且未到结尾）
  //   if (!value.isPlaying && _wasPlaying && currentSec < totalSec) {
  //     reportVideo(video_behavior_key: "video_pause", video_behavior_name: "暂停");
  //     _wasPlaying = false;
  //   }
  //
  //   // ===== 播放完成 =====
  //   if (!_isCompleted &&
  //       totalSec > 0 &&
  //       currentSec >= totalSec &&
  //       !value.isPlaying) {
  //     reportVideo(
  //         video_behavior_key: "video_complete", video_behavior_name: "播放完成");
  //     _isCompleted = true;
  //     _wasPlaying = false;
  //   }
  //
  //   // ===== 快进 / 快退（通过 position 跳变检测）=====
  //
  //   final diff = currentSec - _lastPosition;
  //
  //   // 已经完成的就不再判定快进快退了
  //   if (!_isCompleted && !_seekLocked) {
  //     // 快进：位置跳到更靠后的时间点（超过阈值）
  //     if (diff >= _seekThresholdSec) {
  //       reportVideo(
  //           video_behavior_key: "video_forward", video_behavior_name: "快进");
  //       _seekLocked = true;
  //       Future.delayed(_seekCooldown, () {
  //         _seekLocked = false;
  //       });
  //     }
  //
  //     // 快退：位置跳到更靠前的时间点（超过阈值）
  //     if (diff <= -_seekThresholdSec) {
  //       reportVideo(
  //           video_behavior_key: "video_rewind", video_behavior_name: "快退");
  //       _seekLocked = true;
  //       Future.delayed(_seekCooldown, () {
  //         _seekLocked = false;
  //       });
  //     }
  //   }
  //
  //   // ===== 缓冲（看你要不要上报）=====
  //   if (value.isBuffering) {
  //     // 需要的话在这里加一个缓冲埋点
  //     // reportVideo(video_behavior_key: "video_buffer", video_behavior_name: "缓冲");
  //   }
  //
  //   // 最后一定要更新 _lastPosition
  //   _lastPosition = currentSec;
  // }
  //
  // void reportVideo({
  //   String video_behavior_key = "video_play",
  //   String video_behavior_name = "",
  // }) {
  //   // String type = widget.errIds.split("_")[1];
  //
  //   int play_duration =
  //       flickManager?.flickVideoManager?.videoPlayerValue?.position.inSeconds ??
  //           0;
  //   int video_duration =
  //       flickManager?.flickVideoManager?.videoPlayerValue?.duration.inSeconds ??
  //           0;
  //   int progress = (play_duration / video_duration * 100).round().clamp(0, 100);
  //
  //   List<Map> tags = [];
  //   List<Map> categories = [];
  //   String video_title = "";
  //   int video_type_id = widget.info?.videoTypeId ?? 0;
  //   String video_type_name = widget.info?.videoTypeName ?? "";
  //   int id = 0;
  //
  //   String tagsString = widget.info?.tags ?? '';
  //   video_title = widget.info?.title ?? '';
  //   id = widget.info?.id ?? 0;
  //   // if (type == "1") {
  //   //文章
  //   // tags = List.from(CacheManager.instance.mediaMap["tags"] ?? []);
  //   // categories = List.from(CacheManager.instance.mediaMap["category"] ?? []);
  //   // video_title = CacheManager.instance.mediaMap["title"];
  //   // video_type_id = categories.first["mid"];
  //   // video_type_name = categories.first["name"];
  //   // id = CacheManager.instance.mediaMap["cid"];
  //
  //   // if (type == "2") {
  //   //帖子
  //   // video_title = CacheManager.instance.mediaMap["title"];
  //   // video_type_id = CacheManager.instance.mediaMap["topic"]["id"];
  //   // video_type_name = CacheManager.instance.mediaMap["topic"]["name"];
  //   // id = CacheManager.instance.mediaMap["id"];
  //
  //   EventTracking().reportSingle({
  //     "event": "video_event",
  //     "video_id": id,
  //     "video_title": video_title,
  //     "video_type_id": widget.info?.videoTypeId ?? 0,
  //     "video_type_name": widget.info?.videoTypeName ?? '',
  //     "video_tag_key": widget.info?.videoTagKey ?? '',
  //     "video_tag_name": widget.info?.videoTagName ?? '',
  //     "video_content_type": widget.info?.videoContentType ?? '',
  //     "recommend_trace_id": widget.info?.recommendTraceId ?? '',
  //     "video_duration": video_duration,
  //     "play_duration": play_duration,
  //     "play_progress": progress,
  //     "video_behavior_key": video_behavior_key,
  //     "video_behavior_name": video_behavior_name,
  //   });
  //
  //   if (widget.info != null) {
  //     analyticsVideo(
  //       flickManager: flickManager,
  //       data: widget.info,
  //       videoEvent: videoBehaviorFromHttpKey(video_behavior_key),
  //       videoContentType: VideoContentTypeEnum.shortVideo,
  //     );
  //   }
  // }

  @override
  void dispose() {
    flickManager?.dispose();
    flickManager = null;
    cr = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return flickManager == null
        ? Container()
        : VisibilityDetector(
            key: ObjectKey(flickManager),
            onVisibilityChanged: (visibility) async {
              if (visibility.visibleFraction == 0 && mounted) {
                if (cr?.value.isInitialized == true) {
                  await flickManager?.flickControlManager?.autoPause();
                }
              } else if (visibility.visibleFraction == 1 && mounted) {
                if (cr?.value.isInitialized == true) {
                  flickManager?.flickControlManager?.autoResume();
                }
              }
            },
            child: FlickVideoPlayer(
              flickManager: flickManager!,
              flickVideoWithControls: FlickVideoWithControls(
                videoFit: BoxFit.contain,
                backgroundColor: MyTheme.bgColor,
                playerErrorFallback: Container(),
                playerLoadingFallback: Stack(
                  children: [
                    Positioned.fill(
                        child: MyImage.network(widget.info?.coverVertical ?? '',
                            fit: BoxFit.contain,
                            backgroundColor: MyTheme.bgColor)),
                    Center(
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.grey[400],
                          valueColor: const AlwaysStoppedAnimation(
                            MyTheme.blueColor64,
                          ),
                          strokeWidth: 1.5,
                        ),
                      ),
                    )
                  ],
                ),
                controls: SinkPortraitWidget(
                  flickManager: flickManager!,
                  isBack: true,
                  isDone: isDone,
                  info: widget.info,
                  isPreview: isPreview,
                  skiPreview: () {
                    showAlertVp();
                  },
                  likeAct: () {
                    likeVideoRes();
                  },
                  collectAct: () {
                    collectVideoRes();
                  },
                  commentAct: () {
                    showMoreVideoComment(
                        context: context, data: widget.info?.id);
                  },
                  followAct: () {
                    followUserRes();
                  },
                  enterUserCenterAct: () {
                    if (widget.info?.member != null) {
                      //跳转到个人中心
                      UserCenterRoute('${widget.info?.member?.aff}')
                          .push(context);
                    }
                  },
                  keepBottomBlank: widget.keepBottomBlank,
                ),
              ),
              flickVideoWithControlsFullscreen: FlickVideoWithControls(
                playerErrorFallback: Container(),
                videoFit: BoxFit.contain,
                backgroundColor: MyTheme.bgColor,
                controls: SinkPortraitWidget(
                  flickManager: flickManager!,
                  info: widget.info,
                ),
              ),
            ),
          );
  }

  showMoreVideoComment({required BuildContext context, dynamic data}) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        useRootNavigator: true,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (ctx, setBottomSheetState) {
            //评论弹窗
            return VlogCommentSheet(id: data);
          });
        });
  }

  void showAlertVp({bool goby = false}) {
    final userNotifier = context.read<UserNotifier>();
    Member user = userNotifier.member;
    int money = user.money ?? 0;
    int needmoney = widget.info?.coins ?? 0;
    bool isInsufficient = money < needmoney;
    if (goby && !isInsufficient) {
      byVideoRes(money - needmoney); //直接购买
      return;
    }
    if (widget.info?.isFree == 2) {
      CommonUtils.showDialog(
        context: context,
        builder: (context) => RegularDialog(
          cancelText: 'qx'.tr(context: context),
          buttonText: isInsufficient
              ? 'qwcz'.tr(context: context)
              : 'gmgk'.tr(context: context),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('gmspkwz'.tr(context: context),
                  style: MyTheme.white13,
                  maxLines: 3,
                  textAlign: TextAlign.center),
              SizedBox(height: 15.w),
              Text("$needmoney${'jb'.tr(context: context)}",
                  style: MyTheme.jellyCyan_15, textAlign: TextAlign.center),
              SizedBox(height: 15.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${'ktvpzk'.tr(context: context)}：$money",
                      style: MyTheme.white13),
                ],
              ),
            ],
          ),
          cancelOnTap: () {
            context.pop();
          },
          confirmOnTap: () {
            context.pop();
            if (isInsufficient) {
              const CoinRechargeRoute().push(context);
            } else {
              byVideoRes(money - needmoney); //直接购买
            }
          },
        ),
      );
    } else {
      CommonUtils.showDialog(
        context: context,
        builder: (context) => RegularDialog(
          cancelText: 'fxlvip'.tr(context: context),
          buttonText: 'czvip'.tr(context: context),
          content: Text('gmvkwz'.tr(context: context),
              style: MyTheme.white13,
              maxLines: 3,
              textAlign: TextAlign.center),
          cancelOnTap: () {
            context.pop();
            const MineShareToUserRoute().push(context);
          },
          confirmOnTap: () {
            context.pop();
            const VipCenterRoute().push(context);
          },
        ),
      );
    }
  }

  Future<void> byVideoRes(int money) async {
    MyToast.showLoading(text: 'gmzz'.tr(context: context));
    final userNotifier = context.read<UserNotifier>();
    final res = await vlogDomain.vlogBuy(id: widget.info?.id ?? 0);
    MyToast.closeAllLoading();
    if (res.isValid) {
      userNotifier.setMoney(money: money);
      widget.info?.source_240 = res.data["url"] ?? '';
      await CommonUtils.clearPassiveCache(
          videoUrl: widget.info?.source_240 ?? '');
      initURL();
    } else {
      MyToast.showText(text: res.msg ?? '');
    }
  }

  Future<void> collectVideoRes() async {
    final res = await vlogDomain.vlogFavorite(id: widget.info?.id ?? 0);
    if (res.isValid) {
      widget.info?.isFavorite = res.data['is_favorite'];
      int count = widget.info?.favorites ?? 0;
      count = widget.info?.isFavorite == 1 ? count + 1 : count - 1;
      widget.info?.favorites = max(count, 0);
      if (mounted) setState(() {});
    } else {
      MyToast.showText(text: res.msg ?? '');
    }
  }

  Future<void> likeVideoRes() async {
    final res = await vlogDomain.vlogLike(id: widget.info?.id ?? 0);
    if (res.isValid) {
      widget.info?.isLike = res.data['is_like'];
      int count = widget.info?.countLike ?? 0;
      count = widget.info?.isLike == 1 ? count + 1 : count - 1;
      widget.info?.countLike = max(count, 0);
      if (mounted) setState(() {});
    } else {
      MyToast.showText(text: res.msg ?? '');
    }
  }

  Future<void> followUserRes() async {
    final res = await userDomain.communityFollowUser(
        aff: '${widget.info?.member?.aff}');
    if (res.isValid) {
      widget.info?.member?.isFollow =
          widget.info?.member?.isFollow == 1 ? 0 : 1;
      if (mounted) setState(() {});
    } else {
      MyToast.showText(text: res.msg ?? '');
    }
  }
}

//横屏
class SinkPortraitWidget extends StatefulWidget {
  const SinkPortraitWidget({
    super.key,
    this.flickManager,
    this.isBack = false,
    this.isPreview = false,
    this.isDone = false,
    this.info,
    this.skiPreview,
    this.collectAct,
    this.commentAct,
    this.followAct,
    this.enterUserCenterAct,
    this.likeAct,
    this.keepBottomBlank = false,
  });

  final FlickManager? flickManager;
  final bool isBack;
  final bool isPreview;
  final bool isDone;
  final VlogModel? info;
  final Function? skiPreview; //跳过预览
  final Function? collectAct; //收藏
  final Function? commentAct; //评论
  final Function? followAct; //关注
  final Function? likeAct; //点赞
  final Function? enterUserCenterAct; //
  final bool keepBottomBlank;

  @override
  State<SinkPortraitWidget> createState() => _SinkPortraitWidgetState();
}

class _SinkPortraitWidgetState extends State<SinkPortraitWidget> {
  FlickManager? get flickManager => widget.flickManager;

  Duration _duration = const Duration();
  Duration _currentPos = const Duration();

  // 滑动后值
  Duration _dargPos = const Duration();
  double updatePrevDx = 0.0;
  int updatePosX = 0;

  bool _isTouch = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  _onHorizontalDragStart(DragStartDetails details) {
    _currentPos = flickManager?.flickVideoManager?.videoPlayerValue?.position ??
        const Duration(seconds: 0);
    _duration = flickManager?.flickVideoManager?.videoPlayerValue?.duration ??
        const Duration(seconds: 0);

    setState(() {
      updatePrevDx = details.globalPosition.dx;
      updatePosX = _currentPos.inMilliseconds;
    });
  }

  _onHorizontalDragUpdate(DragUpdateDetails details) {
    double curDragDx = details.globalPosition.dx;
    // 确定当前是前进或者后退
    int cdx = curDragDx.toInt();
    int pdx = updatePrevDx.toInt();
    bool isBefore = cdx > pdx;

    // 计算手指滑动的比例
    int newInterval = pdx - cdx;
    double playerW = MediaQuery.of(context).size.width;
    int curIntervalAbs = newInterval.abs();
    double movePropCheck = (curIntervalAbs / playerW) * 100;

    // 计算进度条的比例
    double durProgCheck = _duration.inMilliseconds.toDouble() / 100;
    int checkTransfrom = (movePropCheck * durProgCheck).toInt();
    int dragRange =
        isBefore ? updatePosX + checkTransfrom : updatePosX - checkTransfrom;

    // 是否溢出 最大
    int lastSecond = _duration.inMilliseconds;
    if (dragRange >= _duration.inMilliseconds) {
      dragRange = lastSecond;
    }
    // 是否溢出 最小
    if (dragRange <= 0) {
      dragRange = 0;
    }
    //
    setState(() {
      _isTouch = true;
      // 更新下上一次存的滑动位置
      updatePrevDx = curDragDx;
      // 更新时间
      updatePosX = dragRange.toInt();
      _dargPos = Duration(milliseconds: updatePosX.toInt());
    });
  }

  _onHorizontalDragEnd(DragEndDetails details) {
    flickManager?.flickControlManager?.seekTo(_dargPos);
    setState(() {
      _isTouch = false;
      _currentPos = _dargPos;
    });
  }

  Widget _buildDargProgressTime() {
    return _isTouch
        ? Container(
            height: 40,
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text(
                '${_duration2String(_dargPos)}  /  ${_duration2String(_duration)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          )
        : Container();
  }

  String _duration2String(Duration duration) {
    if (duration.inMilliseconds < 0) return "-: negtive";

    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    int inHours = duration.inHours;
    return inHours > 0
        ? "$inHours:$twoDigitMinutes:$twoDigitSeconds"
        : "$twoDigitMinutes:$twoDigitSeconds";
  }

  Widget _buildLinearProgress() {
    return _isTouch
        ? Container(
            height: 10.0.w,
            alignment: Alignment.bottomCenter,
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: LinearProgressIndicator(
                minHeight: 10.0.w,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation(MyTheme.blueColor64),
                value: _dargPos.inMilliseconds / _duration.inMilliseconds,
              ),
            ),
          )
        : Container();
  }

  Widget _buildGestureDetector() {
    if (!flickManager!.flickVideoManager!.videoPlayerValue!.isInitialized) {
      return Container();
    }
    return Positioned(
      right: 0,
      left: 0,
      bottom: 0,
      child: ReportGestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragStart: _onHorizontalDragStart,
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        child: SizedBox(
          height: 60.w,
          child: Column(
            children: <Widget>[
              _buildDargProgressTime(),
              const Spacer(),
              _buildLinearProgress(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentWidget() {
    return !_isTouch
        ? CommonUtils.contentWidget(context, widget.info!, showAlert: () {
            widget.skiPreview?.call();
          }, like: () {
            widget.likeAct?.call();
          }, collect: () {
            widget.collectAct?.call();
          }, comment: () {
            widget.commentAct?.call();
          }, follow: () {
            widget.followAct?.call();
          }, enterUserCenter: () {
            widget.enterUserCenterAct?.call();
          }, cleanView: () {
            //清屏
            _isTouch = !_isTouch;
            setState(() {});
          }, keepBottomBlank: widget.keepBottomBlank)
        : Container();
  }

  Widget _buildProgressWidget() {
    if (!(flickManager!.flickVideoManager?.videoPlayerValue?.isInitialized ??
        false)) {
      return Container();
    }

    Duration currentPos =
        flickManager?.flickVideoManager?.videoPlayerValue?.position ??
            const Duration(seconds: 0);
    Duration duration =
        flickManager?.flickVideoManager?.videoPlayerValue?.duration ??
            const Duration(seconds: 0);
    return Positioned(
      right: 0,
      left: 0,
      bottom: 0,
      child: kIsWeb
          ? Container(
              height: 2.0.w,
              alignment: Alignment.bottomCenter,
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: LinearProgressIndicator(
                  minHeight: 2.0.w,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation(MyTheme.blueColor64),
                  value: currentPos.inMilliseconds / duration.inMilliseconds,
                ),
              ),
            )
          : FlickVideoProgressBar(
              flickProgressBarSettings: FlickProgressBarSettings(
                padding: const EdgeInsets.only(bottom: 0),
                height: 2,
                handleRadius: 0,
                curveRadius: 0,
                backgroundColor: Colors.white24,
                bufferedColor: Colors.transparent,
                playedColor: MyTheme.blueColor64,
                handleColor: Colors.transparent,
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FlickVideoManager flickVideoManager =
        Provider.of<FlickVideoManager>(context);
    bool flag = (flickVideoManager.videoPlayerValue!.isBuffering &&
            flickVideoManager.videoPlayerValue!.isPlaying) ||
        !flickVideoManager.videoPlayerValue!.isInitialized;

    FlickControlManager controlManager =
        Provider.of<FlickControlManager>(context);
    FlickVideoManager videoManager = Provider.of<FlickVideoManager>(context);
    return Stack(
      children: [
        FlickShowControlsAction(
          child: Center(
            child: flag
                ? Center(
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.grey[400],
                        valueColor:
                            const AlwaysStoppedAnimation(MyTheme.blueColor64),
                        strokeWidth: 1.5,
                      ),
                    ),
                  )
                : FlickAutoHideChild(
                    showIfVideoNotInitialized: false,
                    child: FlickPlayToggle(
                        replayChild: MyImage.asset(
                          MyImagePaths.appVPlayN,
                          width: 55.w,
                          height: 55.w,
                        ),
                        playChild: MyImage.asset(
                          MyImagePaths.appVPlayN,
                          width: 55.w,
                          height: 55.w,
                        ),
                        pauseChild: Container()),
                  ),
          ),
        ),
        Positioned.fill(
          child: ReportGestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              try {
                videoManager.isVideoEnded
                    ? controlManager.replay()
                    : controlManager.togglePlay();
              } catch (e) {
                CommonUtils.log(e);
              }
            },
            child: Container(),
          ),
        ),
        _buildProgressWidget(),
        _buildGestureDetector(),
        _buildContentWidget(),
      ],
    );
  }
}
