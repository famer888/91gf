import 'dart:async';
import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:jygf/app_global.dart';
import 'package:jygf/crypto.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/domain.dart';
import 'package:jygf/domain/model/novel_model.dart';
import 'package:jygf/domain/model/member_model.dart';
import 'package:jygf/domain/remote_domain/domains/novel.dart';
import 'package:jygf/ui_layer/notifiers/user_notifier.dart';
import 'package:jygf/ui_layer/router/approute_observer.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/acg/novel/novel%20_reader/novel_catelog_sheet.dart';
import 'package:jygf/ui_layer/screens/acg/novel/novel%20_reader/novel_reade_set_sheet.dart';
import 'package:jygf/ui_layer/screens/common_widgets/dialog/my_dialog.dart';
import 'package:jygf/ui_layer/screens/common_widgets/event_bus/event_bus.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';

///小说阅读界面
class NovelReaderContent extends StatefulWidget {
  const NovelReaderContent(
      {super.key, required this.chapterIndex, required this.data});

  final NovelDetailModel data;
  final int chapterIndex;

  @override
  State<NovelReaderContent> createState() => _NovelReaderContentState();
}

class _NovelReaderContentState extends State<NovelReaderContent>
    with RouteAware {
  late final _domain = context.read<NovelDomain>();

  List<NovelChaptersModel> chapters = []; //全部章节
  NovelChaptersModel? currentChapter; //当前章节
  int chapterIndex = -1; //当前章节位置
  String text = ''; //当前章节的显示内容
  late final cacheDomain = context.read<CacheDomain>();
  bool showControl = true; //控制器的隐藏显示
  final bottomHeght = 130.w;
  Color _bgColor = MyTheme.bgColor;
  double _fontSize = 15;
  int _bgColorIndex = 1;

  @override
  void dispose() {
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

    if (currentChapter?.txt?.isEmpty ?? false) {
      //没有查看权限弹窗，使用 WidgetsBinding 来在下一帧展示弹窗
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
    if (currentChapter?.text?.isNotEmpty ?? false) {
      //如果加载过的章节直接显示
      text = currentChapter?.text ?? '';
      if (mounted) setState(() {});
      return;
    }
    MyToast.showLoading();
    dynamic base64 = await CommonUtils.getNovel(currentChapter?.txt);
    if (base64 != null) {
      dynamic decrypted = await PlatformAwareCrypto.decryptNovel(base64);
      if (decrypted.isNotEmpty) {
        text = decrypted;
        currentChapter?.text = text;
        chapters[chapterIndex].text = text;
      }
    }
    MyToast.closeAllLoading();
    if (mounted) setState(() {});
  }

  //记录阅读章节, 获取字体/背景颜色设置缓存
  Future<void> saveReaderChapterIndex() async {
    if (currentChapter?.txt?.isEmpty ?? false) {//没有查看权限弹窗
      return;
    }
    await cacheDomain.upsertNovelReaderChapterIndex(
        novelIdkey: '${widget.data.id}', chapterIndex: chapterIndex);
    await cacheDomain.readNovelReaderFontSize().then((fontsize) {
      _fontSize = fontsize;
    });
    await cacheDomain.readNovelReaderBgColorIndex().then((bgColorIndex) {
      _bgColor = AppGlobal.bgColores[bgColorIndex];
      _bgColorIndex = bgColorIndex;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // 假设 text 是一个长字符串，我们按段落分割
    // List<String> paragraphs = text.split("\n").map((paragraph) {
    //   // 如果段落没有空格开头，则在前面加一个空格
    //   if (paragraph.isNotEmpty && !paragraph.startsWith('    ')) {
    //     return ' $paragraph';
    //   }
    //   return paragraph;
    // }).toList();

    List<String> paragraphs = text.split("\n"); // 按换行符分割
    // 删除空字符
    // paragraphs.removeWhere((item) => item.isEmpty);

    return Scaffold(
      appBar: MyAppBar(title: chapters[chapterIndex].title),
      backgroundColor: _bgColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                setState(() => showControl = !showControl);
              },
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(
                    left: 10.w, right: 10.w, bottom: bottomHeght),
                itemCount: paragraphs.length, // 根据文本长度设置 itemCount
                itemBuilder: (context, index) {
                  final str = paragraphs[index];
                  return str.isEmpty ? Container(height: 5.w) :  RichText(
                    text: TextSpan(
                      text: str,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _fontSize,
                        height: 1.6,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          AnimatedPositioned(
              left: 0,
              right: 0,
              bottom: showControl ? 0 : -bottomHeght,
              duration: const Duration(milliseconds: 250),
              child: bottomView()),
          // AnimatedPositioned(
          //     right: showControl ? 13.w : -100.w,
          //     bottom: bottomHeght,
          //     duration: const Duration(milliseconds: 250),
          //     child: GestureDetector(
          //       onTap: () {
          //         //跳转听书界面
          //         const NovelVoicePalyerContentRoute().push(context);
          //       },
          //       child: MyImage.asset(MyImagePaths.appNovelVoiceIcon,
          //           width: 50.w,
          //           height: 50.w),
          //     ))
        ],
      ),
    );
  }

  Widget bottomView() {
    return Container(
      // height: 100.w,
      // padding: EdgeInsets.only(bottom: MyTheme.bottom),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Container(
                      alignment: Alignment.center,
                      height: 36.w,
                      width: 90.w,
                      decoration: BoxDecoration(
                          color: MyTheme.white008Color,
                          borderRadius:
                              BorderRadius.all(Radius.circular(18.w))),
                      child: Text('syzng'.tr(context: context),
                          style: MyTheme.white14)),
                  onTap: () {
                    //上一章
                    jumpToChater(chapterIndex - 1);
                  },
                ),
                GestureDetector(
                  child: Container(
                      alignment: Alignment.center,
                      height: 36.w,
                      width: 90.w,
                      decoration: BoxDecoration(
                          color: MyTheme.white008Color,
                          borderRadius:
                              BorderRadius.all(Radius.circular(18.w))),
                      child: Text('xyzng'.tr(context: context),
                          style: MyTheme.white14)),
                  onTap: () {
                    //下一章
                    jumpToChater(chapterIndex + 1);
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 13.w),
          Container(
            color: MyTheme.white008Color,
            padding: EdgeInsets.symmetric(vertical: 13.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                iconButton(
                    imageName: MyImagePaths.appNovelMl,
                    title: 'ml'.tr(context: context),
                    func: () {
                      //目录
                      showNovelCatelogSheet();
                    }),
                iconButton(
                    imageName: widget.data.isFavorite == 1
                        ? MyImagePaths.appGameCollectOn
                        : MyImagePaths.appGameCollectOff,
                    title: 'sc'.tr(context: context),
                    func: () {
                      //收藏
                      _changeFavorite();
                    }),
                iconButton(
                    imageName: MyImagePaths.appNavShare,
                    title: 'fx'.tr(context: context),
                    func: () {
                      //分享
                      const MineShareToUserRoute().push(context);
                    }),
                iconButton(
                    imageName: MyImagePaths.appNovelSet,
                    title: 'sz'.tr(context: context),
                    func: () {
                      //设置
                      showNovelSetSheet();
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showNovelCatelogSheet() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (ctx, setBottomSheetState) {
            return NovelCatelogSheet(
                data: widget.data,
                onTap: (index) {
                  //点击目录章节跳转章节详情
                  jumpToChater(index);
                });
          });
        });
  }

  Future<void> _changeFavorite() async {
    late final domain = context.read<UserDomain>();
    final result = await domain.userFavorite(type: 11, id: widget.data.id ?? 0);
    if (result.status == 1) {
      final oldValue = widget.data.isFavorite ?? 0;
      final newValue = oldValue == 0 ? 1 : 0;
      widget.data.isFavorite = newValue;
      if (mounted) {
        setState(() {});
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
  }

  void showNovelSetSheet() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (ctx, setBottomSheetState) {
            return NovelReadeSetSheet(
                fontSize: _fontSize,
                bgColorIndex: _bgColorIndex,
                callback: (fontSize, bgColorIndex) {
                  _fontSize = fontSize;
                  _bgColorIndex = bgColorIndex;
                  _bgColor = AppGlobal.bgColores[bgColorIndex];

                  cacheDomain.upsertNovelFontSize(fontSize: _fontSize);
                  cacheDomain.upsertNovelBgColorIndex(index: bgColorIndex);
                  setState(() {});
                });
          });
        });
  }

  jumpToChater(int index) {
    if (index < 0) {
      MyToast.showText(text: 'yjdyz'.tr(context: context));
      return;
    }
    if (index > chapters.length - 1) {
      MyToast.showText(text: 'yjzhyz'.tr(context: context));
      return;
    }
    NovelReaderRoute(chapterIndex: index, $extra: widget.data)
        .pushReplacement(context);
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
            style: MyTheme.white11,
          )
        ],
      ),
    );
  }

  //没有小说查看权限弹窗提示
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
                    'dqxshfjb'
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
            return Text(
                currentChapter?.payTip ?? 'novelviptip'.tr(context: context),
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
    final res = await _domain.novelBuy(id: currentChapter?.id ?? 0);
    MyToast.closeAllLoading();
    if (res.isValid) {
      userNotifier.setMoney(money: money);
      currentChapter?.txt = res.data['txt'];
      widget.data.chapters?[chapterIndex] = currentChapter!;
      //发通知去刷新数据源中的章节txt数据
      eventBus.fire(MyEvent('NovelIsPaySuccess',
          param: {'chapterIndex': chapterIndex, 'txt': currentChapter?.txt}));
      getCurrentChapterData(); //请求章节详情数据
    } else {
      MyToast.showText(text: res.msg ?? '');
    }
  }
}
