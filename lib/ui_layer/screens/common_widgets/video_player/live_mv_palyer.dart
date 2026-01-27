
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/ui_layer/screens/asmr/voice_player/voice_player_manager.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:video_player/video_player.dart';
import '../../../../domain/api_validator.dart';
import '../../../../domain/domain.dart';
import '../../../../domain/model/live_model.dart';
import '../../../../domain/model/member_model.dart';
import '../../../../domain/remote_domain/domains/live.dart';
import '../../../notifiers/home_config_notifier.dart';
import '../../../notifiers/user_notifier.dart';
import '../../../router/routes.dart';
import '../../../utils/common_utils.dart';
import '../../../utils/my_toast.dart';
import '../../image_paths.dart';
import '../../theme.dart';
import '../dialog/my_dialog.dart';
import '../dialog/widgets/dansan_dialog.dart';
import '../dialog/widgets/dasan_h_dialog.dart';
import '../dialog/widgets/png_dialog.dart';
import '../dialog/widgets/regular_dialog.dart';
import '../my_image.dart';
import '../player_barrage_widget.dart';
import 'utils/nvideourl_minxin.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';



//先判断show的值 != “public” 直接显示已下线
//判断hls.length > 0 直接播放
//hls.length = 0 则判断type值
//type = 1 显示pay_tip 按钮跳转VIP购买
//type = 2 显示pay_tip 按钮金币购买 金币数conis

class LiveMvPlayer extends StatefulWidget {
  const LiveMvPlayer({
    super.key,
    required this.info,
    this.isLocal = false,
    this.noBack = false,
    this.needCheckAspectRatio = false,
  });

  final LiveModel info;
  final bool isLocal;
  final bool noBack;

  /// 显示全屏按钮是否判断视频长宽比
  final bool needCheckAspectRatio;

  @override
  State<LiveMvPlayer> createState() => _LiveMvPlayerState();
}

class _LiveMvPlayerState extends State<LiveMvPlayer> with NVideoURLMinxin {
  FlickManager? flickManager;
  String playerStr = '';
  int chanelIndex = 0; //播放线路

  final TextEditingController _textFieldController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final TextEditingController _dsTextFieldController = TextEditingController();
  final FocusNode _dsFocusNode = FocusNode();

  bool isbarrage = true;

  final _barrageKey = GlobalKey<BarrageState>();

  bool isShowChangeLine = false; //是否显示切换线路弹窗

  final GlobalKey<_SinkPortraitLandWidgetState> _sinkPortraitLandWidgetGlobalKey = GlobalKey(); //通过全局key

  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    initializeData();
    initURL();

    VoicePlayerManager.instance.audioController?.pause();
    VoicePlayerManager.instance.isPlay.value = false;
    VoicePlayerManager.instance.removeFloatPayer();
  }

  @override
  void didUpdateWidget(LiveMvPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    initializeData();
  }

  Future<void> initializeData() async {
    isbarrage = await getIsbarrage();
    if (mounted) setState(() {});
  }

  initURL({bool isChangeLine = false}) async {
    if (widget.info.show != 'public') {
      //show的值 != “public” 直接显示已下线
      widget.info.hls = []; //防止以下线用户存有播放链接导致继续播放
    }

    //筛选出低分辨率播放链接优化播放；如果是切换线路重新构建播放器则无需下面处理
    if (!isChangeLine) {
      if (widget.info.hls?.isNotEmpty ?? false) {
        playerStr = widget.info.hls?.last.url ?? '';
        final hlsLeght = widget.info.hls?.length ?? 0;
        chanelIndex = hlsLeght - 1; //记录播放的是哪条线路
      }
    } else {
      flickManager?.handleChangeVideo(
        VideoPlayerController.network(playerStr),
      );
      _openWebVioce();
      return;
    }

    VideoPlayerController? cr =
        await initController(source240: playerStr, isLocal: widget.isLocal);
    flickManager = FlickManager(
        videoPlayerController: cr!,
        autoPlay: true,
        onVideoEnd: () {
          flickManager?.flickControlManager?.replay();
          if (mounted) setState(() {});
        });
    if (mounted) setState(() {});

    _openWebVioce();

  }

  //禁止web播放时默认静音
  void _openWebVioce() {
    if (kIsWeb) {
      flickManager?.flickVideoManager?.videoPlayerController?.addListener(() {
        if (flickManager?.flickVideoManager?.videoPlayerController?.value.isInitialized ?? false) {
          // 视频初始化完成后取消静音
          List<html.VideoElement> elements = html.document.getElementsByTagName('video').cast<html.VideoElement>();
          if (elements.isNotEmpty) {
            html.VideoElement videoElement = elements.first;
            videoElement.muted = false;
            videoElement.volume = 1.0;
          }
          if (mounted) setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    flickManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Column(
            children: [
              Expanded(child: flickManager == null
                  ? Container()
                  : FlickVideoPlayer(
                flickManager: flickManager!,
                flickVideoWithControls: FlickVideoWithControls(
                  videoFit: BoxFit.contain,
                  playerErrorFallback: Container(),
                  playerLoadingFallback: Stack(
                    children: [
                      Positioned.fill(
                        child: MyImage.network(
                          widget.info.cover ?? '',
                        ),
                      ),
                      Container(color: Colors.black87),
                    ],
                  ),
                  controls: _SinkPortraitLandWidget(
                    key: _sinkPortraitLandWidgetGlobalKey,
                    isBack: true,
                    info: widget.info,
                    noBack: widget.noBack,
                    needCheckAspectRatio: widget.needCheckAspectRatio,
                    chanelIndex: chanelIndex,
                    shareVp: () {
                      const MineWelfareRoute(index: 1).push(context);
                    },
                    nowToVp: () {
                      const VipCenterRoute().push(context);
                    },
                    nowByKb: () {
                      showAlertVp(goby: true);
                    },
                    changeLine: (index) {
                      chanelIndex = index;
                      final hls = widget.info.hls?[index];
                      playerStr = hls?.url ?? '';
                      initURL(isChangeLine: true);
                    },
                  ),
                ),
                flickVideoWithControlsFullscreen: FlickVideoWithControls(
                  playerErrorFallback: Container(),
                  videoFit: BoxFit.contain,
                  controls: _SinkPortraitLandWidget(
                    info: widget.info,
                    noBack: false,
                    chanelIndex: chanelIndex,
                    changeLine: (index) {
                      chanelIndex = index;
                      final hls = widget.info.hls?[index];
                      playerStr = hls?.url ?? '';
                      initURL(isChangeLine: true);
                    },
                  ),
                ),
              )),
              _optinalContent() //播放器底部操作布局
            ],
          ),
        ),
        Positioned(
          bottom: 5.w,
          right: 2.w,
          child: isShowChangeLine ? Container(
            width: 85.w,
            height: (widget.info.hls?.length ?? 0) * 28 + 30,
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children:
                _buildChangeLineListWidget(85.w),
              ),
            ),
          ) : const SizedBox.shrink(),
        ),//切换线路按钮
        Positioned( // 切换线路弹窗选择列表
          bottom: 0,
          right: 10.w,
          child:
        Visibility(
          visible: widget.info?.hls?.isNotEmpty ?? false,
          child: ReportGestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (widget.info.hls?.isEmpty ?? false) {
                  // MyToast.showText(text: tr('yhyxx'));
                  return;
                }
                //切换路线
                isShowChangeLine = !isShowChangeLine;
                if (mounted) setState(() {});
              },
              child: SizedBox(
                height: 40.w,
                child: Row(
                  children: [
                    const MyImage.asset(MyImagePaths.appChangeLine,
                        width: 25, height: 25, fit: BoxFit.contain),
                    Text(tr('qhxl'), style: MyTheme.white08_12)
                  ],
                ),
              )),
        ),
        ),
      ],
    );
  }

  //播放器底部操作按钮，发弹幕/打赏/切换链路
  Widget _optinalContent() {
    return Container(
        height: 40.w,
        color: MyTheme.bgColor,
        child: _danMuWidget(context),
    );
  }

  //打赏
  showDaSanDialog() {
    Member member = context.read<UserNotifier>().member;
    MyDialog.showDialog(
        context: context,
        child: DanSanDialog(
          title: tr('wxts'),
          content: Column(
            children: [
              Text(tr('dxds'), style: MyTheme.gray203_16), //多谢金主爸爸的打赏哦～
              SizedBox(height: 15.w),
              //输入框
              Container(
                height: 30.w,
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(23.w),
                  border: Border.all(
                    color: MyTheme.grayColor180, // 设置边框颜色
                    // width: 0.5, // 设置边框宽度
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  SizedBox(width: 20.w),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: const TextStyle(
                          color: MyTheme.white08Color,
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                          decoration: TextDecoration.none),
                      controller: _dsTextFieldController,
                      focusNode: _dsFocusNode,
                      decoration: InputDecoration(
                        isCollapsed: true,
                        hintText: tr('srdsje'),
                        hintStyle: const TextStyle(
                            color: MyTheme.grayColor180,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                            decoration: TextDecoration.none),
                        contentPadding: EdgeInsets.zero,
                        // 确保内容填充足够
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      //立即打赏
                      if (_dsTextFieldController.text.isEmpty) {
                        MyToast.showText(text: tr('srdsje'));
                        return;
                      }
                      context.pop();
                      var payMoney =
                          int.parse(_dsTextFieldController.text) ?? 0;
                      bool isSufficient = member.money > payMoney;
                      if (isSufficient) {
                        //足够余额打赏
                        dasanOptional(payMoney);
                      } else {
                        MyToast.showText(text: tr('ybzcz'));
                      }
                    },
                    child: Container(
                        // width: 95.w,
                        height: 46.w,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(23.w), // 右上角圆角
                              bottomRight: Radius.circular(23.w), // 右下角圆角
                            ),
                           gradient: MyTheme.gradient_90_114,),
                        child:
                        Text(tr('ljds'), style: MyTheme.white14)),
                  )
                ]),
              ),
              SizedBox(height: 30.w),
              Row(
                children: [
                  Text('${tr('dqye')}: ', style: MyTheme.gray203_13), //当前余额
                  Text("${member.money}${tr('jb')}",
                      style: MyTheme.orange247_13), //金币
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      context.pop();
                      const CoinRechargeRoute().push(context);
                    },
                    child: Text(
                      '${tr('qwcz')} >',
                      style: MyTheme.blue80_13_M_Line,
                    ),
                  ), //前往充值
                ],
              ),
            ],
          ),
        ));
  }

  //获取弹幕开关状态
  Future<bool> getIsbarrage() async {
    final cacheDomain = context.read<CacheDomain>();
    try {
      bool isBarrage = await cacheDomain.readIsBarrage();
      return isBarrage;
    } catch (e) {
      return false; // 返回默认值
    }
  }

  //打赏操作
  Future dasanOptional(int money) async {
    MyToast.showLoading(text: tr('dasz'));
    final userNotifier = context.read<UserNotifier>();
    final liverDomain = context.read<LiveDomain>();
    final res =
    await liverDomain.getLiveReward(id: widget.info.id ?? 0, coins: money);
    MyToast.closeAllLoading();
    if (res.isValid) {
      userNotifier.setMoney(money: userNotifier.member.money - money);
      MyToast.showText(text: res.msg ?? '');
      _overlayEntry?.remove();
      _overlayEntry = null;
    } else {
      MyToast.showText(text: res.msg ?? '');
    }
  }

  //弹幕相关布局
  Widget _danMuWidget(BuildContext context) {
    return Row(children: [
            SizedBox(width: 10.w),
            // 弹幕输入框 + 弹幕开关
            Container(
              height: 25.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.w),
                color: MyTheme.white02Color,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 10.w),
                  Container(
                    alignment: Alignment.center,
                    width: 85.w,
                    height: 25.w,
                    child: TextField(
                      style: TextStyle(
                          color: MyTheme.white08Color,
                          fontSize: 12.sp,
                          overflow: TextOverflow.ellipsis,
                          decoration: TextDecoration.none),
                      controller: _textFieldController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        isCollapsed: true,
                        hintText: tr('dwfsdm'),
                        hintStyle: MyTheme.white08_12,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  // 弹幕开关按钮
                   Visibility(
                    visible: widget.info.hls?.isNotEmpty ?? false,
                    child: ReportGestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async {
                        await _sinkPortraitLandWidgetGlobalKey.currentState?.optionalDanMu();
                        await initializeData();
                        _hideKeyboard(context);
                      },
                      child: Container(
                        width: 25.w,
                        height: 25.w,
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: MyTheme.white02Color,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(14.w),
                            bottomRight: Radius.circular(14.w),
                          ),
                        ),
                        child: isbarrage
                            ? MyImage.asset(MyImagePaths.appOndm,
                                width: 20.w, height: 20.w, fit: BoxFit.contain)
                            : MyImage.asset(MyImagePaths.appOffdm,
                                width: 20.w, height: 20.w, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            // 发送按钮
            ReportGestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                _sinkPortraitLandWidgetGlobalKey.currentState?.sendComment(text: _textFieldController.text);
                _hideKeyboard(context);
              },
              child: Container(
                alignment: Alignment.center,
                height: 25.w,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.w),
                  color: const Color.fromRGBO(94, 180, 255, 0.3),
                ),
                child: Text(tr('fasong'),
                    style: TextStyle(
                        color: MyTheme.white08Color,
                        fontSize: 12.sp,
                        overflow: TextOverflow.ellipsis,
                        decoration: TextDecoration.none)),
              ),
            ),
            SizedBox(width: 8.w),
            // 打赏按钮
            ReportGestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                _hideKeyboard(context);
                showDaSanDialog();
              },
              child: Container(
                height: 25.w,
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 211, 123, 0.3),
                  borderRadius: BorderRadius.circular(14.w),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(tr('das'), style: TextStyle(
                        color: MyTheme.white08Color,
                        fontSize: 12.sp,
                        overflow: TextOverflow.ellipsis,
                        decoration: TextDecoration.none)),
                    SizedBox(width: 4.w),
                    MyImage.asset(MyImagePaths.appDs,
                        width: 18.w, height: 18.w, fit: BoxFit.contain),
                  ],
                ),
              ),
            ),
          ]);
  }

  List<Widget> _buildChangeLineListWidget(double width) {
    List<Widget> columnChild = [];
    widget.info.hls?.asMap().forEach((index, e) {
      columnChild.add(
        InkWell(
            onTap: () {
              isShowChangeLine = !isShowChangeLine;
              if (chanelIndex == index) {
                if (mounted) setState(() {});
                return;
              }
              chanelIndex = index;
              final hls = widget.info.hls?[index];
              playerStr = hls?.url ?? '';
              initURL(isChangeLine: true);
              if (mounted) setState(() {});
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  width: width - 35,
                  height: 28,
                  child: Text(
                    e.label,
                    style: MyTheme.white12,
                  ),
                ),
                (index == chanelIndex)
                    ? const MyImage.asset(MyImagePaths.appGouWhite,
                    width: 20, height: 20)
                    : const SizedBox.shrink()
              ],
            ),
          ),
      );
      columnChild.add(Container(
        width: width - 10,
        height: 0.5,
        color: Colors.white10,
      ));
    });
    if (columnChild.isNotEmpty) {
      columnChild.removeAt(columnChild.length - 1);
      columnChild.add(const SizedBox(height: 15));
    }
    return columnChild;
  }

  showAlertVp({bool goby = false}) {
    Member member = context.read<UserNotifier>().member;
    bool isInsufficient = member.money < (widget.info.coins!);
    if (goby && !isInsufficient) {
      byVideoRes(member.money - widget.info.coins!); //直接购买
      return;
    }
    if (widget.info.type == 2) {
      MyDialog.showDialog(
          context: context,
          child: RegularDialog(
            title: tr('ts'),
            cancelText: isInsufficient ? tr('qwcz') : tr('gmgk'),
            //前往充值 - 立即购买
            buttonText: tr('fxdv'),
            //做任务得VIP
            confirmOnTap: () {
              const MineWelfareRoute(index: 1).push(context);
            },
            cancelOnTap: () {
              if (isInsufficient) {
                const CoinRechargeRoute().push(context);
              } else {
                byVideoRes(member.money - widget.info.coins!);
              }
            },
            content: DefaultTextStyle(
              style: MyTheme.gray203_13,
              child: Column(
                children: [
                  Text(tr('gmspkwz'), style: MyTheme.gray203_13, maxLines: 3),
                  //金币购买本视频解锁精彩完整版！
                  SizedBox(height: 15.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${widget.info.coins}${tr('jb')}', //金币
                          style: MyTheme.blue80_13_M),
                    ],
                  ),
                  SizedBox(height: 15.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${tr('kyje')}：${member.money}${tr('jb')}", //可用金币
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
            //提示
            cancelText: tr('cv'),
            //充值VI
            buttonText: tr('fxdv'),
            //做任务得VIP
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
                  //购买VIP或做任务获取VIP解锁精彩完整版！
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

  Future byVideoRes(int money) async {
    MyToast.showLoading(text: tr('gmzz'));
    final userNotifier = context.read<UserNotifier>();
    final liverDomain = context.read<LiveDomain>();
    final res = await liverDomain.getLiveBuy(id: widget.info.id ?? 0);
    MyToast.closeAllLoading();
    if (res.isValid) {
      userNotifier.setMoney(money: money);
      List<HlsModel> hls = res.data['hls'];
      if (hls.isNotEmpty) {
        widget.info.hls = hls;
      }
      initURL();
    } else {
      MyToast.showText(text: res.msg ?? '');
    }
  }

  void _hideKeyboard(BuildContext context) {
    isShowChangeLine = false;
    _textFieldController.text = '';
    _focusNode.unfocus();
    _dsTextFieldController.text = '';
    _dsFocusNode.unfocus();
    if (mounted) setState(() {});
  }
}

//横屏
class _SinkPortraitLandWidget extends StatefulWidget {
  const _SinkPortraitLandWidget({
    super.key,
    this.isBack = false,
    this.info,
    this.shareVp,
    this.nowToVp,
    this.nowByKb,
    this.changeLine,
    this.needCheckAspectRatio = false,
    required this.noBack,
    required this.chanelIndex,
  });

  final bool isBack;
  final LiveModel? info;
  final Function? shareVp; //分享得VIP
  final Function? nowToVp; //立即开通
  final Function? nowByKb; //钻石购买
  final Function(int)? changeLine; //切换线路
  final bool noBack;
  final int? chanelIndex; //播放线路
  /// 显示全屏按钮是否判断视频长宽比
  final bool needCheckAspectRatio;

  @override
  State<_SinkPortraitLandWidget> createState() =>
      _SinkPortraitLandWidgetState();
}

class _SinkPortraitLandWidgetState extends State<_SinkPortraitLandWidget> {
  final TextEditingController _textFieldController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final TextEditingController _dsTextFieldController = TextEditingController();
  final FocusNode _dsFocusNode = FocusNode();

  bool isbarrage = true;

  List<CommentItemModel> commentItems = []; //弹幕数据

  final _barrageKey = GlobalKey<BarrageState>();

  bool isShowChangeLine = false; //是否显示切换线路弹窗
  int _chanelIndex = 0; //播放线路

  final GlobalKey _globalKey = GlobalKey(); //通过全局key，获取切换线路位置及尺寸，方便线路弹窗定位
  Offset _offset = Offset.zero;
  Size _size = Size.zero;

  OverlayEntry? _overlayEntry;

  void _hideKeyboard(BuildContext context) {
    isShowChangeLine = false;
    _textFieldController.text = '';
    _focusNode.unfocus();
    _dsTextFieldController.text = '';
    _dsFocusNode.unfocus();
  }

  @override
  void initState() {
    super.initState();
    _chanelIndex = widget.chanelIndex ?? 0;
    initializeData();
  }

  Future<void> initializeData() async {
    // 执行异步初始化逻辑
    _getCommentData();
    isbarrage = await getIsbarrage();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    _focusNode.dispose();
    _dsTextFieldController.dispose();
    _dsFocusNode.dispose();
    super.dispose();
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
    // 获取屏幕方向
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Stack(
      children: [
        Positioned.fill(
          child: FlickShowControlsAction(
            child: FlickSeekVideoAction(
              duration: const Duration(seconds: 60),
              child: Center(
                  child: flag && (widget.info?.hls?.length ?? 0) > 0
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
                      : Container()),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: FlickAutoHideChild(
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
        ),
        Positioned(
            top: MediaQuery.of(context).padding.top + (isPortrait ? 8.w : 13.w),
            right: 10.w,
            child: FlickAutoHideChild(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 3, right: 6),
                    height: 18,
                    decoration: const BoxDecoration(
                      color: MyTheme.blackColor25505,
                      borderRadius: BorderRadius.all(Radius.circular(9)),
                    ),
                    child: SizedBox(
                      height: 18,
                      child: Center(
                        child: Row(
                          children: [
                            const MyImage.asset(
                              MyImagePaths.appHots,
                              height: 18,
                              width: 18,
                            ),
                            Text(
                                '${CommonUtils.renderEnFixedNumber(widget.info?.viewFct ?? 0)}${'gzong'.tr()}',
                                style: const TextStyle(
                                    color: MyTheme.white09Color,
                                    fontSize: 10,
                                    overflow: TextOverflow.ellipsis,
                                    decoration: TextDecoration.none)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
        Positioned(
          top: isPortrait ? 5 : 20,
          left: 10,
          child: Builder(builder: (context) {
            if (widget.noBack) {
              return const SizedBox.shrink();
            }
            return SafeArea(
              child: SizedBox(height: 30,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ReportGestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: const MyImage.asset(
                            MyImagePaths.appNavBackWN,
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                          ),
                        onTap: () {
                          _hideKeyboard(context);
                          if (widget.isBack) {
                            context.pop();
                          } else {
                            controlManager.toggleFullscreen();
                          }
                        },
                      ),
                      FlickAutoHideChild(
                        child: Text(isPortrait ? '' : (widget.info?.username ?? ''),
                              style: const TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  fontSize: 20))),
                    ],
                  ),
              ),
            );
          }),
        ),
        Positioned(
            bottom: widget.isBack ? 10 : (rate < 1 ? 10 : 20),//rate < 1: 全屏如果还是竖屏时位置调整
            left: _offset.dx - 26,
            child: isShowChangeLine
                ? FlickAutoHideChild(
                    child: Container(
                      width: _size.width + 35,
                      height: (widget.info?.hls?.length ?? 0) * 25 + 30,
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          children:
                              _buildChangeLineListWidget(_size.width + 35),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink()),
        Positioned(
          bottom: 10.w,
          left: 13.w,
          child: widget.isBack ? Container() : FlickAutoHideChild(child: _danMuWidget(context, controlManager)),//全屏才会显示弹幕相关
        ),
        Positioned(
          bottom: 10.w,
          right: 13.w,
          child: FlickAutoHideChild(
            child: Row(
              children: [
                kIsWeb ? Container() :
                Row(children: [
                  SizedBox(width: 10.w),
                  FlickFullScreenToggle(
                    enterFullScreenChild: const MyImage.asset(
                      MyImagePaths.appFullscreen,
                      width: 25,
                      height: 25,
                      fit: BoxFit.contain,
                    ),
                    exitFullScreenChild: const MyImage.asset(
                      MyImagePaths.appFullscreen,
                      width: 25,
                      height: 25,
                      fit: BoxFit.contain,
                    ),
                    toggleFullscreen: () {
                      _changeFullScreen(controlManager);
                    },
                  )
                ]),
              ],
            ),
          ),
        ),
        Positioned.fill(
            child: isbarrage && commentItems.isNotEmpty
              ? IgnorePointer(
                child: PlayerBarrageWidget(
                    globalKey: _barrageKey,
                    dataList: commentItems,
                    isOpen: true,
                  ),
              )
              : Container(),
        )
      ],
    );
  }

  void _changeFullScreen(FlickControlManager controlManager) {
    _hideKeyboard(context);
    if (kIsWeb) {
      List<html.VideoElement> elements =
          html.document.querySelectorAll('video');
      if (elements.isEmpty) return;

      html.VideoElement video = elements.last;
      video.muted = false;
      video.volume = 1;
      video.setAttribute('playsinline', 'true');
      video.setAttribute('autoplay', 'true');

      if (html.document.fullscreenElement == null) {
        // Enter full screen
        video.enterFullscreen();
        video.controls = false; // hidden native controls
      } else {
        // Exit full screen
        video.exitFullscreen();
        video.controls = false; // hidden native controls
      }
    } else {
      controlManager.toggleFullscreen();
    }
  }

  //横屏时打赏弹窗布局
  void showFullScreenDialog(BuildContext wcontext, FlickControlManager controlManager) {
    Member member = wcontext.read<UserNotifier>().member;

    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: SingleChildScrollView(
          child: DanSanHDialog(
                  title: tr('das'),
                  closeCall: () {
                    _overlayEntry?.remove();
                    _overlayEntry = null;
                  },
                  content: Column(
                    children: [
                      Text(tr('dxds'), style: const TextStyle(
                          color: Color.fromRGBO(190, 189, 194, 1),
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                          decoration: TextDecoration.none)), //多谢金主爸爸的打赏哦～
                      const SizedBox(height: 15),
                      //输入框
                      Container(
                        height: 46,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(23.w),
                          border: Border.all(
                            color: MyTheme.grayColor180, // 设置边框颜色
                            width: 0.5, // 设置边框宽度
                          ),
                        ),
                        child: Row(children: [
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: const TextStyle(
                                  color: MyTheme.white08Color,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                  decoration: TextDecoration.none),
                              controller: _dsTextFieldController,
                              focusNode: _dsFocusNode,
                              decoration: InputDecoration(
                                isCollapsed: true,
                                hintText: tr('srdsje'),
                                hintStyle: const TextStyle(
                                    color: MyTheme.grayColor180,
                                    fontSize: 16,
                                    overflow: TextOverflow.ellipsis,
                                    decoration: TextDecoration.none),
                                contentPadding: EdgeInsets.zero,
                                // 确保内容填充足够
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              //立即打赏
                              if (_dsTextFieldController.text.isEmpty) {
                                MyToast.showText(text: tr('srdsje'));
                                return;
                              }
                              var payMoney =
                                  int.parse(_dsTextFieldController.text);
                              bool isSufficient = member.money > payMoney;
                              if (isSufficient) {
                                //足够余额打赏
                                dasanOptional(payMoney);
                              } else {
                                MyToast.showText(text: tr('ybzcz'));
                              }
                            },
                            child: Container(
                                width: 95,
                                height: 46,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(23), // 右上角圆角
                                      bottomRight: Radius.circular(23), // 右下角圆角
                                    ),
                                    color: MyTheme.jellyCyanColor103224185),
                                child:
                                Text(tr('ljds'), style: const TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    overflow: TextOverflow.ellipsis,
                                    decoration: TextDecoration.none))),
                          )
                        ]),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Text('${tr('dqye')}: ', style: const TextStyle(
                              color: Color.fromRGBO(190, 189, 194, 1),
                              fontSize: 13,
                              overflow: TextOverflow.ellipsis,
                              decoration: TextDecoration.none)), //当前余额
                          Text("${member.money}${tr('jb')}",
                              style: const TextStyle(
                                  color: MyTheme.orange24718713,
                                  fontSize: 13,
                                  overflow: TextOverflow.ellipsis,
                                  decoration: TextDecoration.none)), //金币
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
    overlay.insert(_overlayEntry!);
  }

  //打赏
  showDaSanDialog() {
    Member member = context.read<UserNotifier>().member;
    MyDialog.showDialog(
        context: context,
        child: DanSanDialog(
          title: tr('das'),
          content: Column(
            children: [
              Text(tr('dxds'), style: MyTheme.gray203_16), //多谢金主爸爸的打赏哦～
              SizedBox(height: 15.w),
              //输入框
              Container(
                height: 46.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(23.w),
                  border: Border.all(
                    color: MyTheme.grayColor180, // 设置边框颜色
                    width: 0.5, // 设置边框宽度
                  ),
                ),
                child: Row(children: [
                  SizedBox(width: 20.w),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: const TextStyle(
                          color: MyTheme.white08Color,
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                          decoration: TextDecoration.none),
                      controller: _dsTextFieldController,
                      focusNode: _dsFocusNode,
                      decoration: InputDecoration(
                        isCollapsed: true,
                        hintText: tr('srdsje'),
                        hintStyle: const TextStyle(
                            color: MyTheme.grayColor180,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                            decoration: TextDecoration.none),
                        contentPadding: EdgeInsets.zero,
                        // 确保内容填充足够
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      //立即打赏
                      if (_dsTextFieldController.text.isEmpty) {
                        MyToast.showText(text: tr('srdsje'));
                        return;
                      }
                      context.pop();
                      var payMoney =
                          int.parse(_dsTextFieldController.text) ?? 0;
                      bool isSufficient = member.money > payMoney;
                      if (isSufficient) {
                        //足够余额打赏
                        dasanOptional(payMoney);
                      } else {
                        MyToast.showText(text: tr('ybzcz'));
                      }
                    },
                    child: Container(
                        width: 95.w,
                        height: 46.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(23.w), // 右上角圆角
                              bottomRight: Radius.circular(23.w), // 右下角圆角
                            ),
                            color: MyTheme.jellyCyanColor103224185),
                        child:
                            Text(tr('ljds'), style: MyTheme.white15semibold)),
                  )
                ]),
              ),
              SizedBox(height: 30.w),
              Row(
                children: [
                  Text('${tr('dqye')}: ', style: MyTheme.gray203_13), //当前余额
                  Text("${member.money}${tr('jb')}",
                      style: MyTheme.orange247_13), //金币
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      context.pop();
                      const CoinRechargeRoute().push(context);
                    },
                    child: Text(
                      '${tr('qwcz')} >',
                      style: MyTheme.blue80_13_M_Line,
                    ),
                  ), //前往充值
                ],
              ),
            ],
          ),
        ));
  }

  //获取弹幕--使用直播评论数据
  void _getCommentData() async {
    final lviveDomain = context.read<LiveDomain>();
    final result = await lviveDomain.getLiveListComment(
        id: widget.info?.id ?? 0, page: 1, limit: 100);

    if (result.msg case final msg? when !result.isValid) {
      MyToast.showText(text: msg);
    }

    result.data?.forEach((m) {
      commentItems.add(CommentItemModel(comment: m.text));
    });

    if (mounted) setState(() {});
  }

  //发送弹幕 -- 直接使用直播评论接口
  Future<void> sendComment({required String text}) async {
    final lviveDomain = context.read<LiveDomain>();
    if (text.trim().isEmpty) {
      MyToast.showText(text: 'qsrdm'.tr(context: context));
      return;
    }
    final result = await lviveDomain.getLiveComment(
      text: text,
      id: widget.info?.id ?? 0,
    );
    if (result.isValid) {
      //弹幕发送成功后直接显示再屏幕上
      final m = CommentItemModel(comment: text);
      commentItems.insert(0, m);
      //单独播放这条弹幕
      _barrageKey.currentState?.addTask(m);
      setState(() {});
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
  }

  //获取弹幕开关状态
  Future<bool> getIsbarrage() async {
    final cacheDomain = context.read<CacheDomain>();
    try {
      bool isBarrage = await cacheDomain.readIsBarrage();
      return isBarrage;
    } catch (e) {
      return false; // 返回默认值
    }
  }

  //打赏操作
  Future dasanOptional(int money) async {
    MyToast.showLoading(text: tr('dasz'));
    final userNotifier = context.read<UserNotifier>();
    final liverDomain = context.read<LiveDomain>();
    final res =
        await liverDomain.getLiveReward(id: widget.info?.id ?? 0, coins: money);
    MyToast.closeAllLoading();
    if (res.isValid) {
      userNotifier.setMoney(money: userNotifier.member.money - money);
      MyToast.showText(text: res.msg ?? '');
      _overlayEntry?.remove();
      _overlayEntry = null;
    } else {
      MyToast.showText(text: res.msg ?? '');
    }
  }

  //弹幕相关
  Widget _danMuWidget(BuildContext context, FlickControlManager controlManager) {
    return Row(children: [
      Container(
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: MyTheme.white02Color,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 5.w),
            Container(
              alignment: Alignment.center,
              width: 70,
              height: 28,
              child: TextField(
                style: const TextStyle(
                    color: MyTheme.white08Color,
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                    decoration: TextDecoration.none),
                controller: _textFieldController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  isCollapsed: true,
                  hintText: tr('dwfsdm'),
                  hintStyle: const TextStyle(
                      color: MyTheme.white08Color,
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                      decoration: TextDecoration.none),
                  contentPadding: EdgeInsets.zero,
                  // 确保内容填充足够
                  border: InputBorder.none,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0, right: 5),
              child: ReportGestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Container(
                  alignment: Alignment.center,
                  height: 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    gradient: MyTheme.gradient_90_114,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(tr('fasong'),
                        style: const TextStyle(
                            color: MyTheme.white08Color,
                            fontSize: 12,
                            overflow: TextOverflow.ellipsis,
                            decoration: TextDecoration.none)),
                  ),
                ),
                onTap: () {
                  //发送弹幕
                  sendComment(text: _textFieldController.text);
                  _hideKeyboard(context);
                },
              ),
            ),
          ],
        ),
      ),
      const SizedBox(width: 13),
      Visibility(
        visible: widget.info?.hls?.isNotEmpty ?? false,
        child: ReportGestureDetector(
          behavior: HitTestBehavior.translucent,
          child: isbarrage
              ? const MyImage.asset(MyImagePaths.appOndm,
              width: 25, height: 25, fit: BoxFit.contain)
              : const MyImage.asset(MyImagePaths.appOffdm,
              width: 25, height: 25, fit: BoxFit.contain),
          onTap: () {
            optionalDanMu();
          },
        ),
      ),
      const SizedBox(width: 13),
      ReportGestureDetector(//打赏
        behavior: HitTestBehavior.translucent,
        child: const MyImage.asset(MyImagePaths.appDs,
            width: 60, height: 25, fit: BoxFit.contain),
        onTap: () {
          _hideKeyboard(context);
          if (widget.isBack) {
            showDaSanDialog();
          } else {
            //横屏时适配有问题，分开布局处理
            showFullScreenDialog(context, controlManager);
          }
        },
      ),
      const SizedBox(width: 13),
      Visibility(
        visible: widget.info?.hls?.isNotEmpty ?? false,
        child: ReportGestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              _getWidgetInfo();
              //切换路线
              isShowChangeLine = !isShowChangeLine;
              if (mounted) setState(() {});
            },
            child: Row(
              children: [
                const MyImage.asset(MyImagePaths.appChangeLine,
                    width: 25, height: 25, fit: BoxFit.contain),
                Text(key: _globalKey, tr('qhxl'), style: MyTheme.white08_12)
              ],
            )),
      ),
    ]);
  }

  void _getWidgetInfo() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? renderBox =
      _globalKey.currentContext?.findRenderObject() as RenderBox?;
      _offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
      _size = renderBox?.size ?? Size.zero;
    });
  }

  //弹幕打开关闭操作
  Future<void> optionalDanMu() async {
//弹幕开关
    isbarrage = await getIsbarrage();
    final cacheDomain = context.read<CacheDomain>();
    if (isbarrage) {
      await cacheDomain.upsertIsBarrage(false);
      isbarrage = false;
    } else {
      await cacheDomain.upsertIsBarrage(true);
      isbarrage = true;
    }
    _showDMTipsToast(isbarrage);

    if (mounted) setState(() {});
  }

  void _showDMTipsToast(bool isOpen) {
    _hideKeyboard(context);
    BotToast.cleanAll();
    BotToast.showCustomText(
      toastBuilder: (_) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black45, // 背景颜色
          borderRadius: BorderRadius.circular(15), // 圆角
        ),
        width: 90,
        height: 30,
        alignment: Alignment.center,
        child: Text(
          isOpen ? tr('dmydk') : tr('dmygb'),
          style: const TextStyle(
              color: Color.fromRGBO(255, 255, 255, 1),
              fontSize: 12,
              overflow: TextOverflow.ellipsis,
              decoration: TextDecoration.none),
          textAlign: TextAlign.center,
        ),
      ),
      duration: const Duration(seconds: 2), // 显示时长
      align: Alignment(0.0, widget.isBack ? -0.8 : -0.2), // 位置
    );
  }

  List<Widget> _buildChangeLineListWidget(double width) {
    List<Widget> columnChild = [];
    widget.info?.hls?.asMap().forEach((index, e) {
      columnChild.add(
        Ink(
          child: InkWell(
            onTap: () {
              isShowChangeLine = !isShowChangeLine;
              if (_chanelIndex == index) {
                return;
              }
              _chanelIndex = index;
              widget.changeLine?.call(_chanelIndex); //回传播放器组件中取播放相应链接
              if (mounted) setState(() {});
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  width: width - 35,
                  height: 25,
                  child: Text(
                    e.label,
                    style: MyTheme.white12,
                  ),
                ),
                (index == _chanelIndex)
                    ? const MyImage.asset(MyImagePaths.appGouWhite,
                        width: 20, height: 20)
                    : const SizedBox.shrink()
              ],
            ),
          ),
        ),
      );
      columnChild.add(Container(
        width: width - 10,
        height: 0.5,
        color: Colors.white10,
      ));
    });
    if (columnChild.isNotEmpty) {
      columnChild.removeAt(columnChild.length - 1);
      columnChild.add(const SizedBox(height: 15));
    }
    return columnChild;
  }

  Widget _conditionWidget(BuildContext context) {
    Widget dgt = Container();
    var vflag = false;
    Member user = context.read<UserNotifier>().member;
    if (widget.info?.type == 1) {
      //需要VIP
      dgt = Text(widget.info?.payTip ?? tr('kvbw'),
          style: MyTheme.white255_14_M, maxLines: 2); //开通VIP或做任务获取VIP解锁精彩完整版！
      vflag = false;
    } else if (widget.info?.type == 2) {
      dgt = DefaultTextStyle(
        style: MyTheme.white255_14_N,
        child: Text.rich(
          TextSpan(children: [
            TextSpan(
                text: '${widget.info?.coins ?? 0}', style: MyTheme.blue80_14_M),
            TextSpan(text: '${tr('jbjsw')}，'), //金币解锁完整版
            TextSpan(text: '${tr('ktvpzk')}${user.money}') //剩余可用金币
          ]),
        ),
      );
      vflag = true;
    }
    return Stack(
      children: [
        Positioned.fill(child: MyImage.network(widget.info?.cover ?? '')),
        // 毛玻璃效果
        // Positioned.fill(
        //   child: CommonUtils.blurCover(),
        // ),
        Positioned.fill(
            child: Container(
          color: Colors.transparent,
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
                top: 15,
                left: 50,
                right: 50,
              ),
              child: Column(
                children: [
                  // Text(widget.info?.payTip ?? '', style: MyTheme.white255_14_M),
                  const SizedBox(height: 15),
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
                        gradient: MyTheme.gradient_90_118,
                        borderRadius: BorderRadius.all(Radius.circular(32)),
                      ),
                      child: Center(
                        child: Text(vflag ? tr('gmgk') : tr('ljkv'),
                            //立即购买 - 立即开通VIP
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
                        borderRadius: BorderRadius.all(Radius.circular(32)),
                      ),
                      child: Center(
                        child:
                            Text(tr('fxdv'), style: MyTheme.white13), // 做任务得VIP
                      ),
                    ),
                  )
                ],
              ),
            )
          ]),
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.info?.show != 'public') {
      return Stack(
        children: [
          Positioned.fill(child: MyImage.network(widget.info?.cover ?? '')),
          Positioned.fill(child: CommonUtils.blurCover()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child:
                Center(child: Text(tr('yhyxx'), style: MyTheme.white09_15_M)),
          ),
          Positioned(
              top: 10.w,
              left: 10.w,
              child: ReportGestureDetector(
                behavior: HitTestBehavior.translucent,
                child: const MyImage.asset(
                  MyImagePaths.appNavBackWN,
                  width: 22,
                  height: 22,
                  fit: BoxFit.contain,
                ),
                onTap: () {
                  context.pop();
                },
              ))
        ],
      );
    }

    return (widget.info?.hls?.isNotEmpty ?? false)
        ? _noConditionWidget(context)
        : _conditionWidget(context);
  }
}
