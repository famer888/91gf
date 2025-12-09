import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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
import 'package:jygf/ui_layer/screens/common_widgets/dialog/my_dialog.dart';
import 'package:jygf/ui_layer/screens/common_widgets/event_bus/event_bus.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';

///漫画阅读界面
class ComicReaderContent extends StatefulWidget {
  const ComicReaderContent(
      {super.key, required this.chapterIndex, required this.data});

  final ComicDetailModel data;
  final int chapterIndex;

  @override
  State<ComicReaderContent> createState() => _ComicReaderContentState();
}

class _ComicReaderContentState extends State<ComicReaderContent> with RouteAware{
  late final _domain = context.read<ComicDomain>();

  List<ChaptersModel> chapters = []; //全部章节
  List<ChaptersModel> chapterPics = []; //章节详情图片数据
  ChaptersModel? currentChapter; //当前章节
  int chapterIndex = -1; //当前章节位置
  late final cacheDomain = context.read<CacheDomain>();

  @override
  void dispose() {
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
  }

  //获取当前章节详情数据
  Future<void> getCurrentChapterData() async {
    MyToast.showLoading();
    final result =
        await _domain.comicChapterDetail(id: currentChapter?.id ?? 0);
    MyToast.closeAllLoading();
    if (result.status == 1) {
      chapterPics = result.data?.pics ?? [];
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    if (mounted) setState(() {});
  }

  //记录阅读章节
  Future<void> saveReaderChapterIndex() async {
    await cacheDomain.upsertComicReaderChapterIndex(
        comicIdkey: '${widget.data.id}', chapterIndex: chapterIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(title: chapters[chapterIndex].title),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
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
                      CommonUtils.log('h = $h \nheightInt = $heightInt');
                    } catch (e) {
                      CommonUtils.log(e);
                    }
                    return SizedBox(
                      width: w,
                      height: heightInt.toDouble(),
                      child: Builder(builder: (context) {
                        Widget ww = GestureDetector(
                          child: MyImage.network(e.thumb ?? ''),
                        );
                        return ww;
                      }),
                    );
                  }),
            ),
            bottomView(),
          ],
        ));
  }

  dynamic numberWith({double number = 1, int intNumber = 1}) {
    dynamic dad = (number ~/ intNumber);
    dynamic dd = dad.roundToDouble() * intNumber;
    return dd;
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
      color: MyTheme.white008Color,
      padding: EdgeInsets.only(bottom: MyTheme.bottom),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 7.5.w),
        // height: 60.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            iconButton(
                imageName: MyImagePaths.appComicPrevious,
                title: 'syyh'.tr(context: context),
                func: () {
                  //上一话
                  jumpToChater(chapterIndex - 1);
                }),
            iconButton(
                imageName: MyImagePaths.appNovelMl,
                title: 'ml'.tr(context: context),
                func: () {
                  //目录
                  showComicCatelogSheet();
                }),
            iconButton(
                imageName: MyImagePaths.appComicNext,
                title: 'xyyh'.tr(context: context),
                func: () {
                  //下一话
                  jumpToChater(chapterIndex + 1);
                }),
          ],
        ),
      ),
    );
  }

  void showComicCatelogSheet(){
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (ctx, setBottomSheetState) {
            return ComicCatelogSheet(data: widget.data, onTap: (index) {//点击目录章节跳转章节详情
              jumpToChater(index);
            });
          });
        });
  }

  jumpToChater(int index) {
    if (index < 0) {
      MyToast.showText(text: 'yjdyh'.tr(context: context));
      return;
    }
    if (index > chapters.length - 1) {
      MyToast.showText(text: 'yjzhh'.tr(context: context));
      return;
    }
    ComicReaderRoute(chapterIndex: index, $extra: widget.data).pushReplacement(context);
  }

  Widget iconButton(
      {String imageName = '', String title = '', Function? func}) {
    return GestureDetector(
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
    int money = user.money ?? 0;
    int needmoney = currentChapter?.coins ?? 0;
    bool isInsufficient = money < needmoney;
    if (currentChapter?.type == 2) {
      MyDialog.showAnimationDialog(
          cancelTxt: 'qx'.tr(context: context),
          confirmTxt: isInsufficient
              ? 'qwcz'.tr(context: context)
              : 'gmgk'.tr(context: context),
          setContent: () {
            return Column(
              children: [
                Text(
                    'dqtjxhfajb'
                        .tr(context: context)
                        .replaceAll('a', '$needmoney'),
                    style: MyTheme.black15,
                    maxLines: 10,
                    textAlign: TextAlign.center),
                SizedBox(height: 15.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${'ktvpzk'.tr(context: context)}：$money",
                        style: MyTheme.black15, textAlign: TextAlign.center),
                  ],
                ),
              ],
            );
          },
          confirm: () {
            if (isInsufficient) {
              const CoinRechargeRoute().replace(context);
            } else {
              byVideoRes(money - needmoney); //直接购买
            }
          },
          cancel: () {
            context.pop();
          },
          backgroundReturn: () {
            context.pop();
          });
    } else {
      MyDialog.showAnimationDialog(
          cancelTxt: 'fxlvip'.tr(context: context),
          confirmTxt: 'czvip'.tr(context: context),
          setContent: () {
            return Text(currentChapter?.payTip ?? 'gmvkwz'.tr(context: context),
                style: MyTheme.black15,
                maxLines: 10,
                textAlign: TextAlign.center);
          },
          cancel: () {
            const MineShareToUserRoute().replace(context);
          },
          backgroundReturn: () {
            context.pop();
          },
          confirm: () {
            const VipCenterRoute().replace(context);
          });
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
      eventBus.fire(MyEvent('ComicIsPaySuccess', param: {'chapterIndex' : chapterIndex}));
      getCurrentChapterData();//请求章节详情数据
    } else {
      MyToast.showText(text: res.msg ?? '');
    }
  }
}
