import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/domain.dart';
import 'package:jygf/domain/model/member_model.dart';
import 'package:jygf/domain/model/voice_model.dart';
import 'package:jygf/domain/remote_domain/domains/asmr.dart';
import 'package:jygf/ui_layer/notifiers/user_notifier.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/common_widgets/dialog/widgets/regular_dialog.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/asmr/widgets/coins_dialog.dart';
import 'package:jygf/ui_layer/screens/asmr/widgets/custom_draggable.dart';
import 'package:jygf/ui_layer/screens/common_widgets/event_bus/event_bus.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/download_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

///创建单例持有播放器，方便全局监听播放器及对播放器操作，初始化方法：VoicePlayerManager.instance

class VoicePlayerManager {
  VideoPlayerController? audioController; //播放器控制器
  VoiceModel? data;
  BuildContext? context; //initVideoPlayer方法中必须传过来
  bool isLocal = false;

  //播放音频是悬浮按钮层
  OverlayEntry? overlayEntry;

  // 私有构造函数，防止外部直接创建实例
  VoicePlayerManager._privateConstructor();

  // 0:循环播放 1:随机播放 2:单曲循环
  ValueNotifier<int> isCircuit = ValueNotifier(0);

  //播放器是否初始化
  ValueNotifier<bool> isInit = ValueNotifier(false);

  //是否播放状态
  ValueNotifier<bool> isPlay = ValueNotifier(false);

  //进度
  ValueNotifier<Duration> progress =
      ValueNotifier<Duration>(const Duration(seconds: 0));

  //进度条缓冲区
  Duration buffered = const Duration(seconds: 0);
  Duration total = const Duration(seconds: 0);
  bool isErr = false;
  int currentId = -99;
  BuildContext? topContext; //获取顶层context，否则界面跳转后会被遮挡，在BottomNaviBar组件中传过来

  List<VoiceModel> voices = []; //播放列表数据

  Timer? _timer; //定时结束
  int? minutes; //定时几分钟

  bool needCoinsTip = true; //金币充足情况下，购买时否需要弹窗提示用户需要多少金币购买

  // 唯一实例
  static final VoicePlayerManager _instance =
      VoicePlayerManager._privateConstructor();

  // 获取唯一实例的公共静态方法
  static VoicePlayerManager get instance => _instance;

  void disposes() {
    currentId = -99;
    audioController?.removeListener(addListenerAudio);
    audioController?.dispose();
    isInit.value = false;
    isPlay.value = false;
    progress.value = const Duration(seconds: 0);
    buffered = const Duration(seconds: 0);
    total = const Duration(seconds: 0);
  }

  void showFloatPayer() {
    //不可播放时不显示
    if (data?.voice?.isEmpty ?? false) {
      return;
    }
    // 创建并插入悬浮按钮
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlay = Overlay.of(topContext!);
      if (overlayEntry != null) {
        overlayEntry?.remove();
        overlayEntry = null;
      }
      overlayEntry = _createOverlayEntry();
      overlay.insert(overlayEntry!);
    });
  }

  void removeFloatPayer() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      overlayEntry?.remove();
      overlayEntry = null;
    });
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(builder: (context) => const DraggableFloatingButton());
  }

  Future<void> initVideoPlayer(
      VoiceModel model, BuildContext buildContext) async {
    data = model;
    context = buildContext;

    getVoiceDataList(); //每次点击播放时一次性先拉去播放列表数据

    if (minutes != null) {
      startTimer();
    }

    //判断是否可以播放，弹窗提示
    if (data?.voice?.isEmpty ?? false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        VoicePlayerManager.instance.removeFloatPayer();
        disposes(); //暂停当前播放
        dialogPrompt(model); //传入数据，购买成功后改变voice字段数据
      });
      return;
    }

    if (currentId == data?.id && audioController != null) {
      //如果播放的是同一个id的音频数据则不做任何实例化操作
      reportPlayVoice();
      return;
    }

    if (overlayEntry == null) {//如果不在播放器界面内部则不显示菊花
      MyToast.showLoading();
    }

    // 释放旧的播放控制器（如果存在）
    if (audioController != null) {
      disposes(); //暂停当前播放
    }
    audioController = await initVideoPlayerService(data?.voice ?? '')
      ..initialize().then((_) {
        isInit.value = true;
        total = audioController?.value.duration ?? const Duration(seconds: 0);
        // if (!kIsWeb) {
        audioController?.play();
        reportPlayVoice();
        isPlay.value = true;
        currentId = data?.id ?? 0;
        // }
        addVoiceList(); //添加到播放列表
        audioController?.addListener(addListenerAudio);
        MyToast.closeAllLoading();
      }).onError((error, stackTrace) {
        MyToast.closeAllLoading();
        isErr = true;
        MyToast.showText(text: '初始化错误:$error');
        VoicePlayerManager.instance.removeFloatPayer();
      });
  }

  Future<VideoPlayerController> initVideoPlayerService(String purl) {
      return Future(() {
        return VideoPlayerController.network(purl);
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
      nextVoice();
    }
  }

  //生成随机索引
  int _getRandomIndex() {
    final list = VoicePlayerManager.instance.voices;
    final random = Random();
    return random.nextInt(list.length);
  }

  //会员/金币购买弹窗
  // void dialogPrompt(VoiceModel model) {
  //   Member member = context!.read<UserNotifier>().member;
  //   bool sufficient = member.money >= (data?.coins ?? 0);
  //   //如果用户开启了后续不再提醒，直接购买且余额充足，则直接购买
  //   if (!needCoinsTip && sufficient && data?.type == 2) {
  //     buyVoice(model);
  //     return;
  //   } else if (!needCoinsTip && !sufficient && data?.type == 2) {
  //     //如何余额不足则直接提示去充值操作
  //     CommonUtils.showDialog(
  //       barrierDismissible: false,
  //       context: context!,
  //       builder: (ctx) => const Material(
  //         type: MaterialType.transparency,
  //         child: PopScope(
  //             canPop: false, //禁止弹窗通过滑动隐藏
  //             child: CoinsNotEnoughDialog()),
  //       ),
  //     );
  //     return;
  //   }
  //   CommonUtils.showDialog(
  //     barrierDismissible: false,
  //     context: context!,
  //     builder: (ctx) => Material(
  //       type: MaterialType.transparency,
  //       child: PopScope(
  //           canPop: false, //禁止弹窗通过滑动隐藏
  //           child: CoinsDialog(data: model)),
  //     ),
  //   );
  // }

  //会员/金币购买弹窗
  void dialogPrompt(VoiceModel model) {
    Member member = context!.read<UserNotifier>().member;
    bool sufficient = member.money >= (data?.coins ?? 0);
    //如果用户开启了后续不再提醒，直接购买且余额充足，则直接购买
    if (!needCoinsTip && sufficient && data?.type == 2) {
      buyVoice(model);
      return;
    } else if (!needCoinsTip && !sufficient && data?.type == 2) {
      //如何余额不足则直接提示去充值操作
      _showCoinsNotEnoughDialog();
      return;
    }
    CommonUtils.showDialog(
      barrierDismissible: false,
      context: context!,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          List<TextSpan> textSpans = [];
          if (data?.type == 1) {
            textSpans = [TextSpan(text: data?.payTip ?? '', style: MyTheme.white15)];
          } else if (data?.type == 2) {
            textSpans = [
              TextSpan(text: 'dqyp'.tr(context: context), style: MyTheme.white15),
              TextSpan(
                  text: '${data?.coins}${'jb'.tr(context: context)}',
                  style: MyTheme.jellyCyan_15_M),
              TextSpan(text: 'gmbf'.tr(context: context), style: MyTheme.white15),
            ];
          }
          return RegularDialog(
            title: 'wxts'.tr(context: context),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(textAlign: TextAlign.center, text: TextSpan(children: textSpans)),
                if (data?.type == 2)
                  InkWell(
                    onTap: () {
                      //后续不再提醒，直接购买
                      VoicePlayerManager.instance.needCoinsTip = !VoicePlayerManager.instance.needCoinsTip;
                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 20.w),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyImage.asset(VoicePlayerManager.instance.needCoinsTip ? MyImagePaths.appAsmrOpenNor : MyImagePaths.appAsmrOpenSel,
                                width: 10.w, height: 10.w),
                            SizedBox(width: 5.w),
                            Text('zjgm'.tr(context: context),
                                style: MyTheme.jellyCyan_11_M)
                          ]),
                    ),
                  )
              ],
            ),
            cancelText: 'qx'.tr(context: context),
            buttonText: 'qd'.tr(context: context),
            cancelOnTap: () {
              context.pop(); //隐藏弹窗
              final canpop = GoRouter.of(context).routerDelegate.canPop();
              if (canpop) {
                context.pop(); //退出播放器界面
              }
            },
            confirmOnTap: () {
              if (data?.type == 1) {
                //需要开通会员
                const VipCenterRoute().push(context);
              } else if (data?.type == 2) {
                //需要金币购买
                Member member = this.context!.read<UserNotifier>().member;
                bool sufficient = member.money >= (data?.coins ?? 0);
                if (sufficient) {
                  //用户余额足够直接购买
                  buyVoice(model, popDialog: true);
                } else {
                  //弹窗提示余额不足，去充值
                  context.pop(); //隐藏弹窗
                  _showCoinsNotEnoughDialog();
                }
              }
            },
          );
        },
      ),
    );
  }

  void _showCoinsNotEnoughDialog() {
    CommonUtils.showDialog(
      barrierDismissible: false,
      context: context!,
      builder: (ctx) => RegularDialog(
        title: 'wxts'.tr(context: context),
        content: Text(
          'jbbzqcz'.tr(context: context),
          style: MyTheme.white15,
          textAlign: TextAlign.center,
        ),
        cancelText: 'qx'.tr(context: context),
        buttonText: 'qd'.tr(context: context),
        cancelOnTap: () {
          context!.pop(); //隐藏弹窗
          final canpop = GoRouter.of(context!).routerDelegate.canPop();
          if (canpop) {
            context!.pop(); //退出播放器界面
          }
        },
        confirmOnTap: () {
          const CoinRechargeRoute().push(context!);
        },
      ),
    );
  }

  Future<void> buyVoice(VoiceModel model, {bool popDialog = false}) async {

    MyToast.showLoading(text: 'gmdd'.tr(context: context));

    final userNotifier = context!.read<UserNotifier>();
    Member member = context!.read<UserNotifier>().member;

    final domain = context!.read<ASMRDomain>();
    final res = await domain.buyVoice(id: model.id ?? 0);
    if (res.isValid) {
      userNotifier.setMoney(money: member.money - (data?.coins ?? 0));
      model.voice = res.data['voice'];

      WidgetsBinding.instance.addPostFrameCallback((_) {
        VoicePlayerManager.instance.initVideoPlayer(model, context!);
        // VoicePlayerManager.instance.showFloatPayer();
        if (popDialog) context!.pop(); //隐藏弹窗
      });
      MyToast.closeAllLoading();
    } else if (res.msg case final msg?) {
      MyToast.showText(text: msg);
    }
  }

  //购买金币不足弹窗
  void coinsInsufficientDialog() {}

  //获取播放列表数据
  Future<void> getVoiceDataList() async {
    final domain = topContext!.read<ASMRDomain>();
    final res = await domain.voiceListQueue(page: 1, limit: 1000);
    if (res.isValid) {
      voices = res.data ?? [];
    } else if (res.msg case final msg?) {
      MyToast.showText(text: msg);
    }
  }

  //加入播放队列 --- 播放时默认直接加入到播放列表
  Future<void> addVoiceList() async {
    final domain = topContext!.read<ASMRDomain>();
    final res = await domain.addVoiceQueue(id: data?.id ?? 0);
    if (res.isValid) {
      getVoiceDataList();
    } else if (res.msg case final msg?) {
      MyToast.showText(text: msg);
    }
  }

  //下一首, isClicke: 用户主动在播放器界面操作的，播放列表为空或只有1条数据时需要提示用户
  void nextVoice({bool isClicke = false}) {
    //播放列表为空或者只有一个数据时循环播放即可
    if (voices.isEmpty) {
      if (isClicke) {
        MyToast.showText(text: 'noasmr'.tr(context: context)); //播放列表无音频数据
        return;
      }
      //播放完后自动从头播放
      audioController!.seekTo(const Duration(milliseconds: 0));
      audioController!.play();
      reportPlayVoice();
      isPlay.value = true;
      return;
    }

    if (voices.length == 1) {
      if (voices.first.id == data?.id) {
        if (isClicke) {
          MyToast.showText(text: 'oneasmr'.tr(context: context)); //当前只有一条音频数据
          return;
        }
        //播放完后自动从头播放
        audioController!.seekTo(const Duration(milliseconds: 0));
        audioController!.play();
        reportPlayVoice();
        isPlay.value = true;
        return;
      } else {
        VoicePlayerManager.instance.data = voices.first;
        initVideoPlayer(voices.first, context!);
        eventBus.fire(MyEvent('RefreshVoicePayerUI')); //发通知去播放界面/播放列表界面刷新数据
        return;
      }
    }

    if (isCircuit.value == 2 && !isClicke) {
      //单曲循环且不是用户主动点击下一首，则重新播放当前音频
      audioController!.seekTo(const Duration(milliseconds: 0));
      audioController!.play();
      reportPlayVoice();
      isPlay.value = true;
      return;
    }

    if (isCircuit.value == 0 || isCircuit.value == 2) {
      //循环播放

      int currentIndex = voices.indexWhere((model) => model.id == data?.id);
      if (currentIndex != -1) {
        //找到当前播放数据在列表中的位置
        if (currentIndex < voices.length - 1) {
          currentIndex++;
        } else {
          currentIndex = 0; // 循环到第一首
        }

        final currentData = voices[currentIndex];

        VoicePlayerManager.instance.data = currentData;
        initVideoPlayer(currentData, context!);
        eventBus.fire(MyEvent('RefreshVoicePayerUI')); //发通知去播放界面/播放列表界面刷新数据
      } else {
        if (voices.isNotEmpty) {
          //如果当前数据正好被删除了，找不到位置但是列表中还有数据则播放第一个
          VoicePlayerManager.instance.data = voices.first;
          initVideoPlayer(voices.first, context!);
          eventBus.fire(MyEvent('RefreshVoicePayerUI')); //发通知去播放界面/播放列表界面刷新数据
          return;
        }
        MyToast.showText(
            text: 'overend'.tr(context: context)); //当前音频播放结束，循环播放下一首错误
      }
    } else {
      //随机播放

      int currentIndex = _getRandomIndex();
      final currentData = voices[currentIndex];

      VoicePlayerManager.instance.data = currentData;
      initVideoPlayer(currentData, context!);
      eventBus.fire(MyEvent('RefreshVoicePayerUI')); //发通知去播放界面/播放列表界面刷新数据
    }
  }

  //上一首，isClicke: 用户主动在播放器界面操作的，播放列表为空或只有1条数据时需要提示用户
  void preVoice({bool isClicke = false}) {
    //播放列表为空或者只有一个数据时循环播放即可
    if (voices.isEmpty) {
      if (isClicke) {
        MyToast.showText(text: 'noasmr'.tr(context: context)); //播放列表无音频数据
        return;
      }
      //播放完后自动从头播放
      audioController!.seekTo(const Duration(milliseconds: 0));
      audioController!.play();
      reportPlayVoice();
      isPlay.value = true;
      return;
    }

    if (voices.length == 1) {
      if (voices.first.id == data?.id) {
        if (isClicke) {
          MyToast.showText(text: 'oneasmr'.tr(context: context)); //当前只有一条音频数据
          return;
        }

        //播放完后自动从头播放
        audioController!.seekTo(const Duration(milliseconds: 0));
        audioController!.play();
        reportPlayVoice();
        isPlay.value = true;
        return;
      } else {
        VoicePlayerManager.instance.data = voices.first;
        initVideoPlayer(voices.first, context!);
        eventBus.fire(MyEvent('RefreshVoicePayerUI')); //发通知去播放界面/播放列表界面刷新数据
        return;
      }
    }

    if (isCircuit.value == 0 || isCircuit.value == 2) {
      //循环播放
      int currentIndex = voices.indexWhere((model) => model.id == data?.id);
      if (currentIndex != -1) {
        //找到当前播放数据在列表中的位置
        if (currentIndex > 0) {
          currentIndex--;
        } else {
          currentIndex = voices.length - 1; // 循环到最后一首
        }

        final currentData = voices[currentIndex];

        VoicePlayerManager.instance.data = currentData;
        initVideoPlayer(currentData, context!);
        eventBus.fire(MyEvent('RefreshVoicePayerUI')); //发通知去播放界面/播放列表界面刷新数据
      } else {
        if (voices.isNotEmpty) {
          //如果当前数据正好被删除了，找不到位置但是列表中还有数据则播放第一个
          VoicePlayerManager.instance.data = voices.first;
          initVideoPlayer(voices.first, context!);
          eventBus.fire(MyEvent('RefreshVoicePayerUI')); //发通知去播放界面/播放列表界面刷新数据
          return;
        }
        MyToast.showText(
            text: 'overend'.tr(context: context)); //当前音频播放结束，循环播放下一首错误
      }
    } else {
      //随机播放

      int currentIndex = _getRandomIndex();
      final currentData = voices[currentIndex];

      VoicePlayerManager.instance.data = currentData;
      initVideoPlayer(currentData, context!);
      eventBus.fire(MyEvent('RefreshVoicePayerUI')); //发通知去播放界面/播放列表界面刷新数据
    }
  }

  void startTimer() {
    disposeTimer();
    _timer = Timer(Duration(minutes: minutes ?? 0), () {
      if (isPlay.value) {
        //如果正在播放中则停止播放
        audioController?.pause();
        isPlay.value = false;
        removeFloatPayer();
        disposeTimer();
      }
    });
  }

  void disposeTimer() {
    _timer?.cancel();
    _timer = null;
  }

  //播放上报
  Future<void> reportPlayVoice() async {
    final domain = topContext!.read<ASMRDomain>();
    domain.reportVoicePlay(id: data?.id ?? 0);
  }

  //语音下载
  Future<void> downVoice() async {
    final domain = topContext!.read<ASMRDomain>();
    final res = await domain.downloadVoice(id: data?.id ?? 0);
    if (res.isValid) {
      final url = res.data['url']; //获取下载地址
      downVoiceTaskOptional(url);
    } else if (res.msg case final msg?) {
      MyToast.showText(text: msg);
    }
  }

  //下载任务操作
  Future<void> downVoiceTaskOptional(String url) async {
    final cache = topContext!.read<CacheDomain>();
    final downloadUtil = topContext!.read<DownloadUtil>();

    final taskInfo = {
      'id': '${data?.id}',
      'urlPath': url,
      'title': data?.title,
      'thumbCover': data?.smallCover,
      'contentType': 2,
      'downloading': false,
      'isWaiting': true,

      //传入音频数据
      'smallCover': data?.smallCover,
      'bigCover': data?.bigCover,
      'viewFct': data?.viewFct,
      'favoriteFct': data?.favoriteFct,
      'isFavorite': data?.isFavorite,
      'playFct': data?.playFct,
      'type': data?.type,
      'coins': data?.coins,
      'duration': data?.duration,
      'voice': data?.voice,
      'payTip': data?.payTip,
      'createdAt': data?.createdAt,
    };

    final tasks = await cache.readDownloadVideoTasks();
    final existTaskIndex = tasks.indexWhere((e) => e['id'] == taskInfo['id']);
    if (tasks.isNotEmpty && existTaskIndex != -1) {
      final info = tasks[existTaskIndex];
      if (info['progress'] == 1) {
        MyToast.showText(text: 'voiceyxz'.tr()); //当前音频已下载，请去我的下载缓存查看吧
      } else {
        MyToast.showText(text: 'dqrwcz'.tr()); //当前任务已经存在,请勿重复操作！
      }
      return;
    }

    downloadUtil.createDownloadTask(taskInfo: taskInfo);
  }
}
