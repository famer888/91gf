import 'dart:async';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/domain.dart';
import 'package:jygf/domain/model/voice_model.dart';
import 'package:jygf/ui_layer/router/approute_observer.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/acg/novel/novel_voice_player/novel_voice_player_manager.dart';
import 'package:jygf/ui_layer/screens/acg/novel/novel_voice_player/widget/novel_voice_ai_sheet.dart';
import 'package:jygf/ui_layer/screens/asmr/voice_player/voice_player_manager.dart';
import 'package:jygf/ui_layer/screens/asmr/widgets/voice_player_sheet.dart';
import 'package:jygf/ui_layer/screens/asmr/widgets/voice_player_time_sheet.dart';
import 'package:jygf/ui_layer/screens/common_widgets/event_bus/event_bus.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class NovelVoicePlayerContent extends StatefulWidget {
  NovelVoicePlayerContent({super.key, this.data});

  VoiceModel? data;

  @override
  State<NovelVoicePlayerContent> createState() =>
      _NovelVoicePlayerContentState();
}

class _NovelVoicePlayerContentState extends State<NovelVoicePlayerContent>
    with TickerProviderStateMixin, RouteAware {
  //圆盘动画
  late Animation<double> recordAnimation;
  late AnimationController recordController;

  //杆子动画
  late AnimationController stickController;
  late Animation<double> stickAnimation;

  //点赞
  ValueNotifier<bool> isLike = ValueNotifier(false);

  //收藏
  ValueNotifier<bool> isFavorite = ValueNotifier(false);

  late StreamSubscription<MyEvent> _subscription;

  @override
  void initState() {
    super.initState();

    //先暂停有声播放器
    VoicePlayerManager.instance.audioController?.pause();
    VoicePlayerManager.instance.isPlay.value = false;
    VoicePlayerManager.instance.removeFloatPayer();
    VoicePlayerManager.instance.disposes();

    //订阅播放完毕后自动切换音频后刷新界面
    _subscription = eventBus.on<MyEvent>().listen((event) {
      debugPrint('Received event: ${event.message}');
      if (event.message == 'RefreshNovelVoicePayerUI') {
        widget.data = NovelVoicePlayerManager.instance.data;
        setState(() {});
      }
    });

    //圆盘动画
    recordController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    recordAnimation = Tween<double>(begin: 0, end: 1).animate(recordController);

    //杆子动画
    stickController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    stickAnimation =
        Tween<double>(begin: -40, end: -7).animate(stickController);

    if (widget.data != null) {
      isFavorite.value = (widget.data?.isFavorite == 1);

      if (NovelVoicePlayerManager.instance.currentId == widget.data?.id &&
          mounted) {
        //播放同一个ID音频数据时，直接播放即可
        NovelVoicePlayerManager.instance.audioController?.play();
        //添加监听器来响应isPlay值的变化
        NovelVoicePlayerManager.instance.isPlay.addListener(_isPlayerListen);
        NovelVoicePlayerManager.instance.reportPlayVoice();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          stickController.forward().then((value) {
            recordController.repeat();
          });
          NovelVoicePlayerManager.instance.isPlay.value = true;

          if (NovelVoicePlayerManager.instance.minutes != null) {
            NovelVoicePlayerManager.instance.startTimer();
          }

          //如果数据是当前播放数据直接加入列表即可
          int index = NovelVoicePlayerManager.instance.voices
              .indexWhere((model) => model.id == widget.data?.id);
          if (index == -1) {
            //防止重复添加
            NovelVoicePlayerManager.instance.addVoiceList();
          }
        });
        return;
      }

      NovelVoicePlayerManager.instance.initVideoPlayer(widget.data!, context);
      //添加监听器来响应isPlay值的变化
      NovelVoicePlayerManager.instance.isPlay.addListener(_isPlayerListen);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ModalRoute<dynamic>? route = ModalRoute.of<dynamic>(context);
    if (route != null) {
      //路由订阅
      AppRouteObserver().routeObserver.subscribe(this, route);
    }
  }

  _isPlayerListen() {
    if (mounted) {
      if (NovelVoicePlayerManager.instance.isPlay.value) {
        stickController.forward().then((value) {
          recordController.repeat();
        });
        if (NovelVoicePlayerManager.instance.minutes != null) {
          NovelVoicePlayerManager.instance.startTimer();
        }
      } else {
        recordController.stop();
      }
    }
  }

  @override
  void dispose() {
    _subscription.cancel(); // 取消订阅
    recordController.dispose();
    stickController.dispose();
    isLike.dispose();
    isFavorite.dispose();
    NovelVoicePlayerManager.instance.isPlay.removeListener(_isPlayerListen);
    super.dispose();
  }

  //播放/暂停
  _togglePlay() {
    if (NovelVoicePlayerManager.instance.isPlay.value) {
      stickController.reverse().then((value) {
        NovelVoicePlayerManager.instance.audioController?.pause();
        NovelVoicePlayerManager.instance.isPlay.value = false;
      });
    } else {
      stickController.forward().then((value) {
        NovelVoicePlayerManager.instance.audioController?.play();
        NovelVoicePlayerManager.instance.isPlay.value = true;
      });
    }
  }

  /// 当前的页面被push显示到用户面前 viewWillAppear.
  @override
  void didPush() {
    NovelVoicePlayerManager.instance.removeFloatPayer();
  }

  /// 当前的页面被pop viewWillDisappear.
  @override
  void didPop() {
    if (NovelVoicePlayerManager.instance.isPlay.value) {
      NovelVoicePlayerManager.instance.showFloatPayer();
    } else {
      NovelVoicePlayerManager.instance.disposes();
    }
  }

  /// 上面的页面被pop后当前页面被显示时 viewWillAppear.
  @override
  void didPopNext() {
    // NovelVoicePlayerManager.instance.removeFloatPayer();
  }

  /// 从当前页面push到另一个页面 viewWillDisappear.
  @override
  void didPushNext() {
    // if (NovelVoicePlayerManager.instance.isPlay.value) {
    //   NovelVoicePlayerManager.instance.showFloatPayer();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MyImage.asset(MyImagePaths.appAsmrPlayerBg,
            width: 1.sw, height: 1.sh, fit: BoxFit.fill),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: MyAppBar(
            title: widget.data?.title ?? '',
            rightWidget: ReportGestureDetector(
              onTap: () {
                const MineShareToUserRoute().push(context);
              },
              child: MyImage.asset(MyImagePaths.appNavShare,
                  width: 22.w, height: 22.w),
            ),
          ),
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 13.w, top: 60.w, right: 13.w, bottom: 80.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.only(
                              left: 30.w, right: 30.w, bottom: 30.w),
                          alignment: Alignment.center,
                          child: RotationTransition(
                              turns: recordAnimation,
                              child: SizedBox(
                                width: 345.w,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    const MyImage.asset(
                                        MyImagePaths.appAsmrRecord,
                                        width: double.infinity),
                                    Positioned.fill(
                                        child: Center(
                                      child: SizedBox(
                                        width: 240.w,
                                        height: 240.w,
                                        child: ClipRRect(
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            borderRadius:
                                                BorderRadius.circular(120.w),
                                            child: MyImage.network(
                                                widget.data?.smallCover ?? '')),
                                      ),
                                    )),
                                  ],
                                ),
                              ))),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // _btnItem(
                            //     icon: MyImagePaths.appAsmrLikeNor,
                            //     name: 'dz'.tr(context: context),
                            //     onTap: () {
                            //       //点赞
                            //
                            //     }),
                            ValueListenableBuilder(
                                valueListenable: isFavorite,
                                builder: (context, bool value, child) {
                                  return _btnItem(
                                      icon: value
                                          ? MyImagePaths.appCollectOn
                                          : MyImagePaths.appAsmrCollectionN,
                                      name: 'sc'.tr(context: context),
                                      onTap: () {
                                        //收藏
                                        collectionVoice();
                                      });
                                }),
                            if (!kIsWeb)
                              _btnItem(
                                  icon: MyImagePaths.appAsmrDown,
                                  name: 'xz'.tr(context: context),
                                  onTap: () {
                                    //下载
                                    NovelVoicePlayerManager.instance
                                        .downVoice();
                                  }),
                            _btnItem(
                                icon: MyImagePaths.appAsmrTime,
                                name: 'dingshi'.tr(context: context),
                                onTap: () {
                                  //定时
                                  showAudioPlayerTimeSheet();
                                }),
                            // _btnItem(
                            //     icon: MyImagePaths.appAsmrQueBig,
                            //     name: 'jrdl'.tr(context: context),
                            //     onTap: () {
                            //       //加入队列
                            //     }),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.w),
                      SizedBox(
                        height: 44.w,
                        child: ValueListenableBuilder(
                          valueListenable:
                              NovelVoicePlayerManager.instance.progress,
                          builder: (context, Duration value, child) {
                            return ProgressBar(
                              timeLabelPadding: 5.w,
                              progress: value,
                              buffered:
                                  NovelVoicePlayerManager.instance.buffered,
                              total: NovelVoicePlayerManager.instance.total,
                              progressBarColor: Colors.white,
                              baseBarColor: Colors.white.withOpacity(0.24),
                              bufferedBarColor: Colors.white.withOpacity(0.24),
                              thumbColor: Colors.white,
                              barHeight: 3.0,
                              thumbRadius: 5.0,
                              timeLabelTextStyle: MyTheme.white14,
                              onSeek: (duration) {
                                if (NovelVoicePlayerManager.instance.isErr) {
                                  MyToast.showText(text: '加载错误,请重试');
                                  return;
                                }
                                if (!NovelVoicePlayerManager
                                    .instance.isInit.value) {
                                  MyToast.showText(text: '正在等待音频加载完成');
                                  return;
                                }
                                NovelVoicePlayerManager.instance.audioController
                                    ?.seekTo(duration);
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20.w),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 13.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ValueListenableBuilder(
                                valueListenable:
                                    NovelVoicePlayerManager.instance.isCircuit,
                                builder: (context, bool value, child) {
                                  return _btnImgItem(
                                      icon: value
                                          ? MyImagePaths.appAsmrXh
                                          : MyImagePaths.appAsmrSj,
                                      width: 30.w,
                                      height: 30.w,
                                      onTap: () {
                                        //循环/随机播放
                                        NovelVoicePlayerManager
                                                .instance.isCircuit.value =
                                            !NovelVoicePlayerManager
                                                .instance.isCircuit.value;
                                      });
                                }),
                            _btnImgItem(
                                icon: MyImagePaths.appAsmrLeft,
                                width: 30.w,
                                height: 30.w,
                                onTap: () {
                                  //上一首
                                  NovelVoicePlayerManager.instance
                                      .preVoice(isClicke: true);
                                }),
                            ValueListenableBuilder(
                                valueListenable:
                                    NovelVoicePlayerManager.instance.isPlay,
                                builder: (context, bool value, child) {
                                  return _btnImgItem(
                                      icon: value
                                          ? MyImagePaths.appAsmrPause
                                          : MyImagePaths.appAsmrPlay,
                                      width: 36.w,
                                      height: 36.w,
                                      onTap: () {
                                        //播放/暂停
                                        _togglePlay();
                                      });
                                }),
                            _btnImgItem(
                                icon: MyImagePaths.appAsmrRight,
                                width: 30.w,
                                height: 30.w,
                                onTap: () {
                                  //下一首
                                  NovelVoicePlayerManager.instance
                                      .nextVoice(isClicke: true);
                                }),
                            _btnImgItem(
                                icon: MyImagePaths.appAsmrList,
                                width: 30.w,
                                height: 30.w,
                                onTap: () {
                                  //播放列表
                                  showAudioPlayerSheet();
                                }),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.w),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ReportGestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              width: 90.w,
                              height: 26.w,
                              decoration: BoxDecoration(
                                  color: MyTheme.white008Color,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(13.w))),
                              child: Text('朗读声：御姐 >', style: MyTheme.white11),
                            ),
                            onTap: () {
                              //切换AI声音
                              showVoiceAISheet();
                            },
                          ),
                          SizedBox(width: 60.w),
                          ReportGestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              width: 90.w,
                              height: 26.w,
                              decoration: BoxDecoration(
                                  color: MyTheme.white008Color,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(13.w))),
                              child: Text('ydyw'.tr(context: context), style: MyTheme.white11),
                            ),
                            onTap: () {
                              //阅读原文

                            },
                          )
                        ],
                      ),
                      SizedBox(height: 20.w),
                      const Divider(
                          thickness: 0.5,
                          height: 0.5,
                          color: MyTheme.white02Color),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.w),
                        child: Text('cnxht'.tr(context: context), style: MyTheme.white15,),
                      ),
                      ///todo:猜你喜欢听列表
                      SizedBox(height: 220.w),
                    ],
                  ),
                ),
                Positioned(
                  top: 10.w,
                  right: 80.w,
                  child: AnimatedBuilder(
                    animation: stickAnimation,
                    child: MyImage.asset(
                      MyImagePaths.appAsmrGan,
                      width: 120.w,
                      height: 170.w,
                    ),
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: stickAnimation.value * math.pi / 200,
                        alignment: Alignment.topLeft,
                        origin: Offset(0.w, 0.w),
                        child: child,
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _btnItem(
      {required String icon, required String name, Function()? onTap}) {
    return ReportGestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyImage.asset(
            icon,
            width: 27.w,
            height: 23.w,
          ),
          SizedBox(height: 6.w),
          Text(
            name,
            style: MyTheme.white11,
          )
        ],
      ),
    );
  }

  Widget _btnImgItem(
      {required String icon,
      required double width,
      required double height,
      Function()? onTap}) {
    return ReportGestureDetector(
      onTap: onTap,
      child: MyImage.asset(icon, width: width, height: height),
    );
  }

  //点赞暂时不做
  Future<void> likeVoice() async {
    // final domain = context.read<UserDomain>();
    // final res = await domain.userLike(id: widget.data?.id ?? 0, type: 6);
    // if (res.isValid) {
    //   widget.data?.isLike = res.data['is_like'];
    //   isFavorite.value = (widget.data?.isFavorite == 1);
    //   NovelVoicePlayerManager.instance.data?.isFavorite = widget.data?.isFavorite;
    //
    //   //更新播放列表中对应位置数据收藏状态
    //   var list = NovelVoicePlayerManager.instance.voices;
    //   int index = list.indexWhere((model) => model.id == widget.data?.id);
    //   if (index != -1) {
    //     var model = list[index];
    //     model.isFavorite = widget.data?.isFavorite;
    //   }
    // } else if (res.msg case final msg?) {
    //   MyToast.showText(text: msg);
    // }
  }

  //收藏
  Future<void> collectionVoice() async {
    final domain = context.read<UserDomain>();
    final res = await domain.userFavorite(id: widget.data?.id ?? 0, type: 6);
    if (res.isValid) {
      widget.data?.isFavorite = res.data['is_favorite'];
      isFavorite.value = (widget.data?.isFavorite == 1);
      NovelVoicePlayerManager.instance.data?.isFavorite =
          widget.data?.isFavorite;

      //更新播放列表中对应位置数据收藏状态
      var list = NovelVoicePlayerManager.instance.voices;
      int index = list.indexWhere((model) => model.id == widget.data?.id);
      if (index != -1) {
        var model = list[index];
        model.isFavorite = widget.data?.isFavorite;
      }
    } else if (res.msg case final msg?) {
      MyToast.showText(text: msg);
    }
  }

  showAudioPlayerSheet() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return VoicePlayerSheet(complete: () {
            //播放列表切换播放成功后刷新界面
            widget.data = NovelVoicePlayerManager.instance.data;
            isFavorite.value = (widget.data?.isFavorite == 1);
            setState(() {});
          });
        });
  }

  showAudioPlayerTimeSheet() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return const VoicePlayerTimeSheet();
        });
  }

  showVoiceAISheet() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return const NovelVoiceAISheet();
        });
  }
}
