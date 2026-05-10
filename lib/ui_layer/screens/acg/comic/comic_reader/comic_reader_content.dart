import 'dart:async';

import 'package:analytics_sdk/enum/read_behavior_enum.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/report/analytics/analytics_report.dart';
import 'package:jygf/ui_layer/screens/common_widgets/rainbow_loader.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/domain.dart';
import 'package:jygf/domain/model/comic_model.dart';
import 'package:jygf/domain/model/member_model.dart';
import 'package:jygf/domain/remote_domain/domains/comic.dart';
import 'package:jygf/ui_layer/notifiers/user_notifier.dart';
import 'package:jygf/ui_layer/router/approute_observer.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/acg/comic/comic_reader/comic_catelog_sheet.dart';
import 'package:jygf/ui_layer/screens/common_widgets/dialog/widgets/regular_dialog.dart';
import 'package:jygf/ui_layer/screens/common_widgets/event_bus/event_bus.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';

///漫画阅读界面
class ComicReaderContent extends StatefulWidget {
  const ComicReaderContent(
      {super.key, required this.chapterIndex, required this.data});

  final ComicDetailModel data;
  final int chapterIndex;

  @override
  State<ComicReaderContent> createState() => _ComicReaderContentState();
}

class _ComicReaderContentState extends State<ComicReaderContent>
    with RouteAware {
  late final _domain = context.read<ComicDomain>();
  bool _isLoading = false;

  List<ChaptersModel> chapters = []; //全部章节
  List<ChaptersModel> chapterPics = []; //章节详情图片数据
  ChaptersModel? currentChapter; //当前章节
  int chapterIndex = -1; //当前章节位置
  late final cacheDomain = context.read<CacheDomain>();

  bool _isShowSetting = false;
  bool _isAutoScroll = false;
  bool _hasReachedBottom = false;
  int _autoScrollSpeed = 5;
  int speedMin = 3;
  int speedMax = 10;
  final ScrollController _scrollController = ScrollController();
  Timer? _autoScrollTimer;

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    PaintingBinding.instance.imageCache.clear();
    super.dispose();
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

  /// 当前的页面被pop viewWillDisappear.
  @override
  void didPop() {
    BotToast.cleanAll();
  }

  @override
  void initState() {
    super.initState();

    //获取缓存阅读到的章节
    chapters = widget.data.chapters ?? [];
    chapterIndex = widget.chapterIndex;
    currentChapter = chapters[chapterIndex];

    if (currentChapter?.isPay != 1) {
      //没有查看权限弹窗
      // 使用 WidgetsBinding 来在下一帧展示弹窗
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showAlertVp();
      });
      return;
    }

    saveReaderChapterIndex();

    getCurrentChapterData();

    analyticsComicEvent(
      ReadBehaviorEnum.VIEW,
      currentChapter,
      model: widget.data, readProgress: 0,
      pageNo: chapterIndex, //下标从0开始
    );
  }

  //获取当前章节详情数据
  Future<void> getCurrentChapterData() async {
    setState(() {
      _isLoading = true;
    });
    final result =
        await _domain.comicChapterDetail(id: currentChapter?.id ?? 0);
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result.status == 1) {
          chapterPics = result.data?.pics ?? [];
        } else {
          MyToast.showText(text: result.msg ?? '');
        }
      });
    }
  }

  //记录阅读章节
  Future<void> saveReaderChapterIndex() async {
    await cacheDomain.upsertComicReaderChapterIndex(
        comicIdkey: '${widget.data.id}', chapterIndex: chapterIndex);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
          appBar: MyAppBar(title: chapters[chapterIndex].title),
          body: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Expanded(
                    child: Listener(
                      onPointerDown: (_) {
                        if (_isShowSetting) {
                          setState(() {
                            _isShowSetting = false;
                          });
                          return;
                        }
                        if (_isAutoScroll) {
                          setState(() {
                            _isAutoScroll = false;
                          });
                          stopAutoScroll();
                        }
                      },
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification.metrics.pixels >=
                              notification.metrics.maxScrollExtent) {
                            onReadCompleted();
                          }
                          return false;
                        },
                        child: ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.zero,
                            itemCount: chapterPics.length,
                            itemBuilder: (context, index) {
                              ChaptersModel e = chapterPics[index];
                              double w = ScreenUtil().screenWidth;
                              double h = w;
                              num heightInt = w.toInt();
                              try {
                                h = w * (e.thumbH ?? 0) / (e.thumbW ?? 0);
                                heightInt = numberWith(
                                    number: h,
                                    intNumber: screenNeededMultipleNumber);
                                CommonUtils.log(
                                    'h = $h \nheightInt = $heightInt');
                              } catch (e) {
                                CommonUtils.log(e);
                              }
                              return SizedBox(
                                width: w,
                                height: heightInt.toDouble(),
                                child: Builder(builder: (context) {
                                  Widget ww = ReportGestureDetector(
                                    child: MyImage.network(e.thumb ?? ''),
                                  );
                                  return ww;
                                }),
                              );
                            }),
                      ),
                    ),
                  ),
                ],
              ),
              if (!_isLoading)
                Align(alignment: Alignment.bottomCenter, child: bottomView()),
              if (_isShowSetting && !_isLoading)
                Positioned(
                    bottom: 60.w, left: 0, right: 0, child: settingView()),
              if (_isLoading)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '稍等片刻，正在努力加载漫画中',
                      style: MyTheme.white14,
                    ),
                    SizedBox(height: 10.w),
                    AdvancedRainbowLoader(
                        width: 1.sw - MyTheme.pagePadding * 2, height: 6.w),
                    SizedBox(height: 10.w),
                    Text(
                      '正在读取中...',
                      style: MyTheme.white06_12,
                    ),
                  ],
                ),
            ],
          )),
    );
  }

  dynamic numberWith({double number = 1, int intNumber = 1}) {
    dynamic dad = (number ~/ intNumber);
    dynamic dd = dad.roundToDouble() * intNumber;
    return dd;
  }

  /// 当前漫画阅读进度，返回 0 ~ 100 的百分比。
  int getReadProgress() {
    if (!_scrollController.hasClients) {
      return 0;
    }

    final position = _scrollController.position;
    final maxScrollExtent = position.maxScrollExtent;

    if (maxScrollExtent <= 0) {
      return 100;
    }

    final progress = (_scrollController.offset / maxScrollExtent) * 100;
    return progress.clamp(0, 100).round();
  }

  /// 是否已经滚动到最底部。
  bool get isReachedBottom {
    if (!_scrollController.hasClients) {
      return false;
    }

    final position = _scrollController.position;
    return position.pixels >= position.maxScrollExtent;
  }

  /// 观看完成时触发的回调，适合做埋点上传。
  void onReadCompleted() {
    if (_hasReachedBottom) {
      return;
    }

    _hasReachedBottom = true;

    analyticsComicEvent(
      ReadBehaviorEnum.COMPLETE,
      currentChapter,
      model: widget.data,
      readProgress: 100,
      pageNo: chapterIndex,
    );
  }

  int screenNeededMultipleNumber = 1;
  // 屏幕需要的倍数 比如 2 3倍屏幕就是1 2.75倍屏幕就要让0.75乘之后为整数的最小数 4
  caculateScreenNeededMultiple() {
    final double scale = ScreenUtil().pixelRatio ?? 1;
    int intNumber = 1;
    if (scale - scale.floor() == 0) {
    } else {
      double lastDouble = scale - scale.floor();
      for (int i = 1; i < 5; i++) {
        double res = (lastDouble * i);
        if (res == res.toInt()) {
          intNumber = i;
          break;
        }
      }
    }
    screenNeededMultipleNumber = intNumber;
  }

  Widget bottomView() {
    return Container(
      width: 1.sw,
      height: 70.w,
      color: const Color.fromRGBO(0, 0, 0, 0.9),
      // padding: EdgeInsets.only(bottom: MyTheme.bottom),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 7.5.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            iconButton(
                imageName: MyImagePaths.appNovelMl,
                title: 'ml'.tr(context: context),
                func: () {
                  //目录
                  showComicCatelogSheet();
                }),
            iconButton(
                imageName: MyImagePaths.appComicPrevious,
                title: 'syyh'.tr(context: context),
                func: () {
                  //上一话
                  jumpToChater(chapterIndex - 1, false);
                }),
            iconButton(
                imageName: MyImagePaths.appComicNext,
                title: 'xyyh'.tr(context: context),
                func: () {
                  //下一话
                  jumpToChater(chapterIndex + 1, true);
                }),
            iconButton(
                imageName: MyImagePaths.appComicSet,
                title: 'sz'.tr(context: context),
                func: () {
                  setState(() {
                    _isShowSetting = !_isShowSetting;
                  });
                }),
          ],
        ),
      ),
    );
  }

  void showComicCatelogSheet() {
    showModalBottomSheet(
        backgroundColor: MyTheme.bgColor,
        isScrollControlled: true,
        constraints: BoxConstraints(maxHeight: 0.8.sh),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (ctx, setBottomSheetState) {
            return ComicCatelogSheet(
                data: widget.data,
                onTap: (index) {
                  //点击目录章节跳转章节详情
                  jumpToChater(index, false);
                });
          });
        });
  }

  jumpToChater(int index, bool next) {
    if (index < 0) {
      MyToast.showText(text: 'yjdyh'.tr(context: context));
      return;
    }
    if (index > chapters.length - 1) {
      MyToast.showText(text: 'yjzhh'.tr(context: context));
      return;
    }

    analyticsComicEvent(
      !next ? ReadBehaviorEnum.PAGE_PREV : ReadBehaviorEnum.PAGE_NEXT,
      currentChapter,
      model: widget.data,
      readProgress: getReadProgress(),
      pageNo: chapterIndex, //下标从0开始
    );

    ComicReaderRoute(chapterIndex: index, $extra: widget.data)
        .pushReplacement(context);
  }

  Widget iconButton(
      {String imageName = '', String title = '', Function? func}) {
    return ReportGestureDetector(
      onTap: () {
        func?.call();
      },
      child: Column(
        children: [
          MyImage.asset(
            imageName,
            width: 25.w,
            height: 25.w,
          ),
          Text(
            title,
            style: MyTheme.white12,
          )
        ],
      ),
    );
  }

  //没有漫画查看权限弹窗提示
  void showAlertVp() {
    final userNotifier = context.read<UserNotifier>();
    Member user = userNotifier.member;
    int money = user.money;
    int needmoney = currentChapter?.coins ?? 0;
    bool isInsufficient = money < needmoney;
    if (currentChapter?.type == 2) {
      CommonUtils.showDialog(
        context: context,
        builder: (context) => RegularDialog(
          title: 'wxts'.tr(context: context),
          cancelText: 'qx'.tr(context: context),
          buttonText: isInsufficient
              ? 'qwcz'.tr(context: context)
              : 'gmgk'.tr(context: context),
          content: Column(
            children: [
              Text(
                  'dqtjxhfajb'
                      .tr(context: context)
                      .replaceAll('a', '$needmoney'),
                  style: MyTheme.white15,
                  maxLines: 10,
                  textAlign: TextAlign.center),
              SizedBox(height: 15.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${'ktvpzk'.tr(context: context)}：$money",
                      style: MyTheme.white15, textAlign: TextAlign.center),
                ],
              ),
            ],
          ),
          confirmOnTap: () {
            Navigator.pop(context, true);
            if (isInsufficient) {
              const CoinRechargeRoute().replace(context);
            } else {
              byVideoRes(money - needmoney); //直接购买
            }
          },
          cancelOnTap: () {
            context.pop();
          },
        ),
        onBarrierDismiss: () {
          context.pop();
        },
      );
    } else {
      CommonUtils.showDialog(
        context: context,
        builder: (context) => RegularDialog(
          title: 'wxts'.tr(context: context),
          cancelText: 'fxlvip'.tr(context: context),
          buttonText: 'czvip'.tr(context: context),
          content: Text('gmvkwz'.tr(context: context),
              style: MyTheme.white15,
              maxLines: 10,
              textAlign: TextAlign.center),
          cancelOnTap: () {
            Navigator.pop(context, true);
            const MineShareToUserRoute().replace(context);
          },
          confirmOnTap: () {
            Navigator.pop(context, true);
            const VipCenterRoute().replace(context);
          },
        ),
        onBarrierDismiss: () {
          context.pop();
        },
      );
    }
  }

  Future<void> byVideoRes(int money) async {
    MyToast.showLoading(text: 'gmzz'.tr(context: context));
    final userNotifier = context.read<UserNotifier>();
    final res = await _domain.comicBuy(id: currentChapter?.id ?? 0);
    MyToast.closeAllLoading();
    if (res.isValid) {
      userNotifier.setMoney(money: money);
      currentChapter?.isPay = 1; //更改章节权限
      widget.data.chapters?[chapterIndex] = currentChapter!;
      //发通知去刷新数据源中的章节权限数据
      eventBus.fire(
          MyEvent('ComicIsPaySuccess', param: {'chapterIndex': chapterIndex}));
      getCurrentChapterData(); //请求章节详情数据
    } else {
      MyToast.showText(text: res.msg ?? '');
    }
  }

  Widget settingView() {
    return Container(
      width: 1.sw,
      color: const Color.fromRGBO(0, 0, 0, 0.9),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
      child: Stack(children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('阅读方式', style: MyTheme.white16),
            SizedBox(height: 25.w),
            Text('${_autoScrollSpeed}s', style: MyTheme.white14),
            Row(
              children: [
                ReportGestureDetector(
                    onTap: () {
                      if (_autoScrollSpeed > speedMin) {
                        setState(() {
                          _autoScrollSpeed--;
                        });
                        if (_isAutoScroll) startAutoScroll();
                      }
                    },
                    child: Container(
                      width: 24.w,
                      height: 24.w,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child:
                          Icon(Icons.remove, size: 16.w, color: Colors.black),
                    )),
                Expanded(
                    child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 2,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6),
                          overlayShape:
                              const RoundSliderOverlayShape(overlayRadius: 10),
                          activeTrackColor: MyTheme.primaryColor,
                          inactiveTrackColor: MyTheme.white05Color,
                          thumbColor: MyTheme.primaryColor,
                        ),
                        child: Slider(
                          value: _autoScrollSpeed.toDouble(),
                          min: speedMin.toDouble(),
                          max: speedMax.toDouble(),
                          divisions: speedMax - speedMin,
                          onChanged: (v) {
                            setState(() {
                              _autoScrollSpeed = v.toInt();
                            });
                            if (_isAutoScroll) startAutoScroll();
                          },
                        ))),
                ReportGestureDetector(
                    onTap: () {
                      if (_autoScrollSpeed < speedMax) {
                        setState(() {
                          _autoScrollSpeed++;
                        });
                        if (_isAutoScroll) startAutoScroll();
                      }
                    },
                    child: Container(
                      width: 24.w,
                      height: 24.w,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: Icon(Icons.add, size: 16.w, color: Colors.black),
                    )),
              ],
            )
          ],
        ),
        Positioned(
          top: 3.w,
          right: 0,
          child: ReportGestureDetector(
              onTap: toggleAutoScroll,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 74.w,
                height: 22.w,
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.w),
                    border: Border.all(
                        color: _isAutoScroll
                            ? const Color(0xFFE94079)
                            : const Color(0xFF657EF6),
                        width: 1),
                    color: Colors.transparent),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      alignment: _isAutoScroll
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: 34.w,
                        height: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.w),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: _isAutoScroll
                                    ? MyTheme.gradient_90_114_colors
                                    : MyTheme.gradient_90_118_colors_blue)),
                        child: Text(
                          _isAutoScroll ? '自动' : '手动',
                          style:
                              TextStyle(color: Colors.white, fontSize: 11.sp),
                        ),
                      ),
                    )
                  ],
                ),
              )),
        )
      ]),
    );
  }

  void toggleAutoScroll() {
    setState(() {
      _isAutoScroll = !_isAutoScroll;
      if (_isAutoScroll) {
        startAutoScroll();
      } else {
        stopAutoScroll();
      }
    });
  }

  void startAutoScroll() {
    stopAutoScroll();
    double pixelsPerTick =
        (1.sh / (speedMax + speedMin - _autoScrollSpeed)) / 20;

    _autoScrollTimer =
        Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_scrollController.hasClients) {
        if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent) {
          stopAutoScroll();
          setState(() {
            _isAutoScroll = false;
          });
          return;
        }
        _scrollController.jumpTo(_scrollController.offset + pixelsPerTick);
      }
    });
  }

  void stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }
}
