import 'dart:async';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/model/voice_model.dart';
import 'package:jygf/domain/remote_domain/domains/asmr.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/router/approute_observer.dart';
import 'package:jygf/ui_layer/router/routes.dart';
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

class VioicPlayerContentView extends StatefulWidget {
  VioicPlayerContentView({super.key, this.data});

  VoiceModel? data;

  @override
  State<VioicPlayerContentView> createState() => _VioicPlayerContentViewState();
}

class _VioicPlayerContentViewState extends State<VioicPlayerContentView>
    with TickerProviderStateMixin, RouteAware {
  late final _domain = context.read<ASMRDomain>();
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late Animation<double> recordAnimation;
  late AnimationController recordController;

  //点赞
  ValueNotifier<bool> isLike = ValueNotifier(false);

  //收藏
  ValueNotifier<bool> isFavorite = ValueNotifier(false);

  late StreamSubscription<MyEvent> _subscription;

  @override
  void initState() {
    super.initState();

    // 订阅播放完毕后自动切换音频后刷新界面
    _subscription = eventBus.on<MyEvent>().listen((event) {
      debugPrint('Received event: ${event.message}');
      if (event.message == 'RefreshVoicePayerUI') {
        widget.data = VoicePlayerManager.instance.data;
        setState(() {});
      }
    });

    //圆盘动画
    recordController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    recordAnimation = Tween<double>(begin: 0, end: 1).animate(recordController);

    if (widget.data != null) {
      isFavorite.value = (widget.data?.isFavorite == 1);

      if (VoicePlayerManager.instance.currentId == widget.data?.id && mounted) {
        //播放同一个ID音频数据时，直接播放即可
        VoicePlayerManager.instance.audioController?.play();
        //添加监听器来响应isPlay值的变化
        VoicePlayerManager.instance.isPlay.addListener(_isPlayerListen);
        VoicePlayerManager.instance.reportPlayVoice();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          recordController.repeat();
          VoicePlayerManager.instance.isPlay.value = true;

          if (VoicePlayerManager.instance.minutes != null) {
            VoicePlayerManager.instance.startTimer();
          }

          //如果数据是当前播放数据直接加入列表即可
          int index = VoicePlayerManager.instance.voices
              .indexWhere((model) => model.id == widget.data?.id);
          if (index == -1) {
            //防止重复添加
            VoicePlayerManager.instance.addVoiceList();
          }
        });
        return;
      }

      VoicePlayerManager.instance.initVideoPlayer(widget.data!, context);
      //添加监听器来响应isPlay值的变化
      VoicePlayerManager.instance.isPlay.addListener(_isPlayerListen);
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
      if (VoicePlayerManager.instance.isPlay.value) {
        recordController.repeat();
        if (VoicePlayerManager.instance.minutes != null) {
          VoicePlayerManager.instance.startTimer();
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
    isLike.dispose();
    isFavorite.dispose();
    VoicePlayerManager.instance.isPlay.removeListener(_isPlayerListen);
    super.dispose();
  }

  //播放/暂停
  _togglePlay() {
    if (VoicePlayerManager.instance.isPlay.value) {
      VoicePlayerManager.instance.audioController?.pause();
      VoicePlayerManager.instance.isPlay.value = false;
    } else {
      VoicePlayerManager.instance.audioController?.play();
      VoicePlayerManager.instance.isPlay.value = true;
    }
  }

  /// 当前的页面被push显示到用户面前 viewWillAppear.
  @override
  void didPush() {
    VoicePlayerManager.instance.removeFloatPayer();
  }

  /// 当前的页面被pop viewWillDisappear.
  @override
  void didPop() {
    if (VoicePlayerManager.instance.isPlay.value) {
      VoicePlayerManager.instance.showFloatPayer();
    } else {
      VoicePlayerManager.instance.disposes();
    }
  }

  /// 上面的页面被pop后当前页面被显示时 viewWillAppear.
  @override
  void didPopNext() {
    // VoicePlayerManager.instance.removeFloatPayer();
  }

  /// 从当前页面push到另一个页面 viewWillDisappear.
  @override
  void didPushNext() {
    // if (VoicePlayerManager.instance.isPlay.value) {
    //   VoicePlayerManager.instance.showFloatPayer();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: widget.data?.title ?? '',
        rightWidget: GestureDetector(
          onTap: () {
            const MineShareToUserRoute().push(context);
          },
          child:
              MyImage.asset(MyImagePaths.appShareOn, width: 20.w, height: 20.w),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 30.w, right: 30.w, bottom: 80.w),
        child: Column(
          children: [
            Expanded(
                child: Container(
                    padding: EdgeInsets.only(bottom: 60.w),
                    alignment: Alignment.center,
                    child: RotationTransition(
                        turns: recordAnimation,
                        child: SizedBox(
                          width: 345.w,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              const MyImage.asset(MyImagePaths.appAsmrRecord,
                                  width: double.infinity),
                              Positioned.fill(
                                  child: Center(
                                child: SizedBox(
                                  width: 240.w,
                                  height: 240.w,
                                  child: ClipRRect(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      borderRadius:
                                          BorderRadius.circular(120.w),
                                      child: MyImage.network(
                                          widget.data?.smallCover ?? '')),
                                ),
                              )),
                            ],
                          ),
                        )))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // _btnItem(
                //     icon: MyImagePaths.appThumbsIcon,
                //     name: 'dz'.tr(context: context),
                //     onTap: () {
                //       //点赞
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
                kIsWeb
                    ? Container(padding: EdgeInsets.symmetric(horizontal: 40.w))
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 80.w),
                        child: _btnItem(
                            icon: MyImagePaths.appAsmrDown,
                            name: 'xz'.tr(context: context),
                            onTap: () {
                              //下载
                              VoicePlayerManager.instance.downVoice();
                            }),
                      ),
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
            SizedBox(height: 20.w),
            SizedBox(
              height: 44.w,
              child: ValueListenableBuilder(
                valueListenable: VoicePlayerManager.instance.progress,
                builder: (context, Duration value, child) {
                  return ProgressBar(
                    timeLabelPadding: 5.w,
                    progress: value,
                    buffered: VoicePlayerManager.instance.buffered,
                    total: VoicePlayerManager.instance.total,
                    progressBarColor: Colors.white,
                    baseBarColor: Colors.white.withOpacity(0.24),
                    bufferedBarColor: Colors.white.withOpacity(0.24),
                    thumbColor: Colors.white,
                    barHeight: 3.0,
                    thumbRadius: 5.0,
                    timeLabelTextStyle: MyTheme.white14,
                    onSeek: (duration) {
                      if (VoicePlayerManager.instance.isErr) {
                        MyToast.showText(text: '加载错误,请重试');
                        return;
                      }
                      if (!VoicePlayerManager.instance.isInit.value) {
                        MyToast.showText(text: '正在等待音频加载完成');
                        return;
                      }
                      VoicePlayerManager.instance.audioController
                          ?.seekTo(duration);
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 25.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ValueListenableBuilder(
                    valueListenable: VoicePlayerManager.instance.isCircuit,
                    builder: (context, bool value, child) {
                      return _btnImgItem(
                          icon: value
                              ? MyImagePaths.appAsmrXh
                              : MyImagePaths.appAsmrSj,
                          width: 28.w,
                          height: 22.w,
                          onTap: () {
                            //循环/随机播放
                            VoicePlayerManager.instance.isCircuit.value =
                                !VoicePlayerManager.instance.isCircuit.value;
                          });
                    }),
                _btnImgItem(
                    icon: MyImagePaths.appAsmrLeft,
                    width: 20.w,
                    height: 20.w,
                    onTap: () {
                      //上一首
                      VoicePlayerManager.instance.preVoice(isClicke: true);
                    }),
                ValueListenableBuilder(
                    valueListenable: VoicePlayerManager.instance.isPlay,
                    builder: (context, bool value, child) {
                      return _btnImgItem(
                          icon: value
                              ? MyImagePaths.appAsmrPauseBig
                              : MyImagePaths.appAsmrPlaySmall,
                          width: 36.w,
                          height: 36.w,
                          onTap: () {
                            //播放/暂停
                            _togglePlay();
                          });
                    }),
                _btnImgItem(
                    icon: MyImagePaths.appAsmrRight,
                    width: 20.w,
                    height: 20.w,
                    onTap: () {
                      //下一首
                      VoicePlayerManager.instance.nextVoice(isClicke: true);
                    }),
                _btnImgItem(
                    icon: MyImagePaths.appAsmrList,
                    width: 20.w,
                    height: 18.w,
                    onTap: () {
                      //播放列表
                      showAudioPlayerSheet();
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _btnItem(
      {required String icon, required String name, Function()? onTap}) {
    return GestureDetector(
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
    return GestureDetector(
      onTap: onTap,
      child: MyImage.asset(icon, width: width, height: height),
    );
  }

  //点赞暂时不做
  Future<void> likeVoice() async {}

  //收藏
  Future<void> collectionVoice() async {
    final domain = context.read<ASMRDomain>();
    final res = await domain.favoriteVoice(id: widget.data?.id ?? 0);
    if (res.isValid) {
      widget.data?.isFavorite = res.data['is_favorite'];
      isFavorite.value = (widget.data?.isFavorite == 1);
      VoicePlayerManager.instance.data?.isFavorite = widget.data?.isFavorite;

      //更新播放列表中对应位置数据收藏状态
      var list = VoicePlayerManager.instance.voices;
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
            widget.data = VoicePlayerManager.instance.data;
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
}
