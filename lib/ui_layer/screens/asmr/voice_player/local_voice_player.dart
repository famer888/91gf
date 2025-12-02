import 'dart:async';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/model/voice_model.dart';
import 'package:jygf/domain/remote_domain/domains/asmr.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/router/approute_observer.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/video_player/utils/shelf_proxy.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class LocalVoicePlayer extends StatefulWidget {
  const LocalVoicePlayer({super.key, required this.data});

  final VoiceModel data;

  @override
  State<LocalVoicePlayer> createState() => _LocalVoicePlayerState();
}

class _LocalVoicePlayerState extends State<LocalVoicePlayer>
    with TickerProviderStateMixin, RouteAware {
  late final _domain = context.read<ASMRDomain>();
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late Animation<double> recordAnimation;
  late AnimationController recordController;

  //进度条缓冲区
  Duration buffered = const Duration(seconds: 0);
  Duration total = const Duration(seconds: 0);
  bool isErr = false;

  VideoPlayerController? audioController; //播放器控制器

  //播放器是否初始化
  ValueNotifier<bool> isInit = ValueNotifier(false);

  //是否播放状态
  ValueNotifier<bool> isPlay = ValueNotifier(false);

  //进度
  ValueNotifier<Duration> progress =
      ValueNotifier<Duration>(const Duration(seconds: 0));

  //收藏
  ValueNotifier<bool> isFavorite = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    //圆盘动画
    recordController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    recordAnimation = Tween<double>(begin: 0, end: 1).animate(recordController);


    //添加监听器来响应isPlay值的变化
    isPlay.addListener(_isPlayerListen);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initVideoPlayer(widget.data);
    });

  }

  Future<void> initVideoPlayer(VoiceModel model) async {
    MyToast.showLoading();

    String url = widget.data.voice ?? '';
    createStaticServer(url).then((value) {
      audioController = VideoPlayerController.network(value)
        ..setLooping(true)
        ..initialize().then((_) {
          isInit.value = true;
          total = audioController?.value.duration ?? const Duration(seconds: 0);
          audioController?.play();
          isPlay.value = true;
          MyToast.closeAllLoading();
          audioController?.addListener(addListenerAudio);
        }).onError((error, stackTrace) {
          MyToast.closeAllLoading();
          isErr = true;
          MyToast.showText(text: '初始化错误:$error');
        });
    });
  }

  addListenerAudio() {
    if (audioController == null || !audioController!.value.isInitialized) {
      return;
    }
    if (audioController!.value.buffered.isNotEmpty) {
      buffered = audioController!.value.buffered.last.end;
    }
    progress.value = audioController!.value.position;

    //有声播放完毕
    if (audioController!.value.position >= audioController!.value.duration) {
      //播放完后自动从头播放
      audioController!.seekTo(const Duration(milliseconds: 0));
      audioController!.play();
      isPlay.value = true;
    }
  }

  _isPlayerListen() {
    if (mounted) {
      if (isPlay.value) {
        recordController.repeat();
      } else {
        recordController.stop();
      }
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

  @override
  void dispose() {
    isPlay.removeListener(_isPlayerListen);
    audioController?.dispose();
    recordController.dispose();
    isFavorite.dispose();
    super.dispose();
  }

  //播放/暂停
  _togglePlay() {
    if (isPlay.value) {
      audioController?.pause();
      isPlay.value = false;
    } else {
      audioController?.play();
      isPlay.value = true;
    }
  }

  /// 当前的页面被push显示到用户面前 viewWillAppear.
  @override
  void didPush() {}

  /// 当前的页面被pop viewWillDisappear.
  @override
  void didPop() {}

  /// 上面的页面被pop后当前页面被显示时 viewWillAppear.
  @override
  void didPopNext() {}

  /// 从当前页面push到另一个页面 viewWillDisappear.
  @override
  void didPushNext() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: widget.data.title ?? '',
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
                                          widget.data.smallCover ?? '')),
                                ),
                              )),
                            ],
                          ),
                        )))),
            SizedBox(height: 20.w),
            SizedBox(
              height: 44.w,
              child: ValueListenableBuilder(
                valueListenable: progress,
                builder: (context, Duration value, child) {
                  return ProgressBar(
                    timeLabelPadding: 5.w,
                    progress: value,
                    buffered: buffered,
                    total: total,
                    progressBarColor: Colors.white,
                    baseBarColor: Colors.white.withOpacity(0.24),
                    bufferedBarColor: Colors.white.withOpacity(0.24),
                    thumbColor: Colors.white,
                    barHeight: 3.0,
                    thumbRadius: 5.0,
                    timeLabelTextStyle: MyTheme.white14,
                    onSeek: (duration) {
                      if (isErr) {
                        MyToast.showText(text: '加载错误,请重试');
                        return;
                      }
                      if (!isInit.value) {
                        MyToast.showText(text: '正在等待音频加载完成');
                        return;
                      }
                      audioController?.seekTo(duration);
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 15.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder(
                    valueListenable: isPlay,
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

  //收藏
  Future<void> collectionVoice() async {
    final domain = context.read<ASMRDomain>();
    final res = await domain.favoriteVoice(id: widget.data.id ?? 0);
    if (res.isValid) {
      widget.data.isFavorite = res.data['is_favorite'];
      isFavorite.value = (widget.data.isFavorite == 1);
    } else if (res.msg case final msg?) {
      MyToast.showText(text: msg);
    }
  }
}
