import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/domain.dart';
import 'package:jygf/domain/model/novel_model.dart';
import 'package:jygf/domain/remote_domain/domains/novel.dart';
import 'package:jygf/ui_layer/const.dart';
import 'package:jygf/ui_layer/router/approute_observer.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/acg/novel/card/novel_chapter_card.dart';
import 'package:jygf/ui_layer/screens/acg/novel/card/novel_item_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/event_bus/event_bus.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';

class NovelIntroContent extends StatefulWidget {
  const NovelIntroContent(
      {super.key, required this.data, this.favoriteSucsess});

  final NovelDetailWithBannersModel data;

  final Function(NovelDetailWithBannersModel data)?
      favoriteSucsess; //收藏成功回调刷新上层界面收藏状态

  @override
  State<NovelIntroContent> createState() => _NovelIntroContentState();
}

class _NovelIntroContentState extends State<NovelIntroContent> with RouteAware {
  late final _domain = context.read<NovelDomain>();

  List<NovelChaptersModel> chapters = [];
  List<NovelItemsModel> recommends = [];
  int lastReadChapter = -1;

  late final cacheDomain = context.read<CacheDomain>();
  late StreamSubscription<MyEvent> _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = eventBus.on<MyEvent>().listen((event) {
      debugPrint('Received event: ${event.message}');
      if (event.message == 'NovelIsPaySuccess') {
        int index = event.param?['chapterIndex'];
        String txt = event.param?['txt'];
        chapters[index].txt = txt;
        setState(() {});
      }
    });

    initData();
  }

  @override
  void dispose() {
    _subscription.cancel(); // 取消订阅
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

  /// 上面的页面被pop后当前页面被显示时 viewWillAppear.
  @override
  void didPopNext() {
    initData(); //阅读界面切换了章节，返回此界面刷新下当前章节，以便继续阅读时定位章节位置
  }

  Future<void> initData() async {
    //获取缓存阅读到的章节
    lastReadChapter = await cacheDomain.readNovelReaderChapterIndex(
        novelIdkey: '${widget.data.detail?.id}');
    chapters = List.from(widget.data.detail?.chapters ?? []);
    recommends = List.from(widget.data.recommend ?? []);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (widget.data.detail?.intro?.isEmpty ?? false)
                          ? SizedBox(height: MyTheme.pagePadding)
                          : Padding(
                              padding:
                                  EdgeInsets.only(bottom: MyTheme.pagePadding),
                              child: Text(
                                widget.data.detail?.intro ?? '',
                                style: MyTheme.white07_14,
                                maxLines: 100,
                              ),
                            ),
                      Builder(builder: (context) {
                        if ((widget.data.detail?.tag ?? '')
                            .toString()
                            .isEmpty) {
                          return Container();
                        }
                        List tags = '${widget.data.detail?.tag}'.split(',');
                        return Wrap(
                          runSpacing: 10.w,
                          spacing: 10.w,
                          children: tags
                              .map(
                                (tag) => InkWell(
                                  onTap: () {
                                    // CommonUtils.log('点击标签：$tag');
                                    // Utils.navTo(context, "/homesearchpage?searchStr=$tag&index=7");
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.5.w, vertical: 2.w),
                                    decoration: BoxDecoration(
                                      color: MyTheme.white008Color,
                                      borderRadius: BorderRadius.circular(2.w),
                                    ),
                                    child: Text(
                                      tag,
                                      style: MyTheme.white09_10,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      }),
                      SizedBox(height: 13.w),
                      Row(
                        children: [
                          Text(widget.data.detail?.isEnd == 1
                              ? 'wj'.tr(context: context) : 'lzz'.tr(context: context),
                              style: MyTheme.white15_M),
                          SizedBox(width: 6.w),
                          Padding(
                            padding: EdgeInsets.only(top: 3.w),
                            child: Text(
                                '${'zjgx'.tr(context: context)}${widget.data.detail?.chapters?.length ?? 0}${'zang'.tr(context: context)}',
                                style: MyTheme.white08_12),
                          ),
                          const Spacer(),
                          chapters.length > 3
                              ? GestureDetector(
                                  onTap: () {
                                    //更多章节
                                    NovelChaptersRoute(widget.data.detail!)
                                        .push(context);
                                  },
                                  child: Text(
                                    'gd'.tr(context: context),
                                    style: MyTheme.white04_12,
                                  ),
                                )
                              : Container()
                        ],
                      ),
                      SizedBox(height: 5.w),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: (chapters.length > 3
                                  ? chapters.sublist(0, 3)
                                  : chapters)
                              .asMap()
                              .keys
                              .map((index) {
                            NovelChaptersModel chapter = chapters[index];
                            return NovelChapterCard(
                              data: chapter,
                              tapCall: () {
                                //章节点击进入阅读界面
                                lastReadChapter = index;
                                jumperNovelReaderView();
                              },
                            );
                          }).toList()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          chapters.length >= 4
                              ? SizedBox(
                                  height: 60.w,
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        //查看全部章节
                                        NovelChaptersRoute(widget.data.detail!)
                                            .push(context);
                                      },
                                      child: Container(
                                        height: 30.w,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: MyTheme.pagePadding),
                                        decoration: BoxDecoration(
                                            color: MyTheme.white008Color,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.w))),
                                        alignment: Alignment.center,
                                        child: Row(children: [
                                          MyImage.asset(
                                              MyImagePaths.appNovelAllCatelog,
                                              width: 12.w,
                                              height: 12.w),
                                          SizedBox(width: 5.w),
                                          Text(
                                            'ckqbzj'.tr(context: context),
                                            style: MyTheme.white07_12,
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      )
                    ],
                  ),
                ),
                recommends.isNotEmpty
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: MyTheme.pagePadding),
                        child: Column(
                          children: [
                            Container(
                              height: 27.w,
                              margin: EdgeInsets.symmetric(vertical: 10.w),
                              alignment: Alignment.centerLeft,
                              child: Text('klyk'.tr(context: context),
                                  style: MyTheme.white15_M),
                            ),
                            GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: recommends.length,
                                padding: EdgeInsets.only(bottom: 30.w),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: UILayerConst.pictureRatio,
                                  mainAxisSpacing: 10.w,
                                  crossAxisSpacing: 10.w,
                                ),
                                itemBuilder: (context, index) {
                                  final item = recommends[index];
                                  return NovelItemCard(data: item);
                                })
                          ],
                        ),
                      )
                    : Container(height: 30.w)
              ],
            ),
          ),
        ),
        bottomView()
      ],
    );
  }

  Widget bottomView() {
    return Container(
      color: MyTheme.white008Color,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 7.5.w),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 30.w),
                        iconButton(
                            imageName: widget.data.detail?.isFavorite == 1
                                ? MyImagePaths.appGameCollectOn
                                : MyImagePaths.appGameCollectOff,
                            title: 'sc'.tr(context: context),
                            func: () {
                              _changeFavorite();
                            }),
                        // SizedBox(width: 40.w),
                        // iconButton(
                        //     imageName: MyImagePaths.appListenNovel,
                        //     title: 'tshu'.tr(context: context),
                        //     func: () {
                        //       const NovelVoicePalyerContentRoute().push(context);
                        //     }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              //开始阅读/ 继续阅读
              jumperNovelReaderView();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              height: 40.w,
              margin: EdgeInsets.only(right: MyTheme.pagePadding),
              decoration: BoxDecoration(
                color: MyTheme.jellyCyanColor,
                borderRadius: BorderRadius.circular(20.w),
              ),
              alignment: Alignment.center,
              child: Center(
                  child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: lastReadChapter > -1
                              ? 'jxyd'.tr(context: context)
                              : 'ksyd'.tr(context: context),
                              // ? '${'jxyd'.tr(context: context)} ${'di'.tr(context: context)}${lastReadChapter + 1}${'zang'.tr(context: context)}'
                              // : '${'ksyd'.tr(context: context)} ${'di'.tr(context: context)}1${'zang'.tr(context: context)}',
                          style: MyTheme.white14,
                        )
              ]))),
            ),
          )
        ],
      ),
    );
  }

  jumperNovelReaderView() async {
    NovelReaderRoute(
            chapterIndex: lastReadChapter > -1 ? lastReadChapter : 0,
            $extra: widget.data.detail!)
        .push(context);
  }

  Widget iconButton(
      {String imageName = '', String title = '', Function? func}) {
    return GestureDetector(
      onTap: () {
        func?.call();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyImage.asset(
            imageName,
            width: 25.w,
            height: 25.w,
          ),
          SizedBox(height: 3.w),
          Text(title, style: MyTheme.white11),
        ],
      ),
    );
  }

  Future<void> _changeFavorite() async {
    final domain = context.read<UserDomain>();

    final result =
        await domain.userFavorite(type: 11, id: widget.data.detail?.id ?? 0);
    if (result.status == 1) {
      final oldValue = widget.data.detail?.isFavorite ?? 0;
      final newValue = oldValue == 0 ? 1 : 0;
      widget.data.detail?.isFavorite = newValue;
      if (newValue == 1) {
        widget.data.detail?.favoriteFct =
            (widget.data.detail?.favoriteFct ?? 0) + 1;
      } else {
        widget.data.detail?.favoriteFct =
            (widget.data.detail?.favoriteFct ?? 0) - 1;
      }
      if (mounted) {
        setState(() {});
      }
      widget.favoriteSucsess?.call(widget.data);
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
  }
}
