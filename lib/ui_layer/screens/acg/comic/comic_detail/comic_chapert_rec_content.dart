import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/domain.dart';
import 'package:jygf/domain/model/comic_model.dart';
import 'package:jygf/domain/remote_domain/domains/comic.dart';
import 'package:jygf/ui_layer/const.dart';
import 'package:jygf/ui_layer/router/approute_observer.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/acg/comic/card/comic_chapter_card.dart';
import 'package:jygf/ui_layer/screens/acg/comic/card/comic_item_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/event_bus/event_bus.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';

class ComicChapertRecView extends StatefulWidget {
  const ComicChapertRecView({super.key, required this.data, this.favoriteSucsess});

  final ComicDetailWithBannersModel data;

  final Function(ComicDetailWithBannersModel data)? favoriteSucsess; //收藏成功回调刷新上层界面收藏状态

  @override
  State<ComicChapertRecView> createState() =>
      _ComicChapertRecViewState();
}

class _ComicChapertRecViewState
    extends State<ComicChapertRecView> with RouteAware{
  late final _domain = context.read<ComicDomain>();

  List<ChaptersModel> chapters = [];
  List<ComicItemsModel> recommends = [];
  int lastReadChapter = -1;

  late final cacheDomain = context.read<CacheDomain>();
  late StreamSubscription<MyEvent> _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = eventBus.on<MyEvent>().listen((event) {
      debugPrint('Received event: ${event.message}');
      if (event.message == 'ComicIsPaySuccess') {
        int index = event.param?['chapterIndex'];
        chapters[index].isPay = 1;
        setState(() {

        });
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
    initData();//阅读界面切换了章节，返回此界面刷新下当前章节，以便继续阅读时定位章节位置
  }

  Future<void> initData() async {
    //获取缓存阅读到的章节
    lastReadChapter = await cacheDomain.readComicReaderChapterIndex(comicIdkey: '${widget.data.detail?.id}');
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
                      Row(
                        children: [
                          Text('ml'.tr(context: context),
                              style: MyTheme.white15_M),
                          SizedBox(width: 6.w),
                          Padding(
                            padding: EdgeInsets.only(top: 3.w),
                            child: Text(
                                widget.data.detail?.isEnd == 1
                                    ? '${'qb'.tr(context: context)}${widget.data.detail?.chapterCt ?? 0}${'zang'.tr(context: context)}'
                                    : '${'zjgx'.tr(context: context)}${widget.data.detail?.chapterCt ?? 0}${'zang'.tr(context: context)}',
                                style: MyTheme.white10),
                          ),
                          const Spacer(),
                          chapters.length > 3 ? GestureDetector(
                            onTap: () {
                              //更多章节
                              ComicChaptersRoute(widget.data.detail!).push(context);
                            },
                            child: Text(
                              'gd'.tr(context: context),
                              style: MyTheme.white04_12,
                            ),
                          ) : Container()
                        ],
                      ),
                      SizedBox(height: MyTheme.pagePadding),
                      Stack(
                        children: [
                        const Positioned.fill(
                            child: MyImage.asset(
                              MyImagePaths.appDialogBg,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Column(
                              children: [
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: (chapters.length > 3
                                            ? chapters.sublist(0, 3)
                                            : chapters)
                                        .asMap()
                                        .keys
                                        .map((index) {
                                      ChaptersModel chapter = chapters[index];
                                      return ComicChapterCard(
                                        data: chapter,
                                        tapCall: () {
                                          //章节点击进入阅读界面
                                          lastReadChapter = index;
                                          jumperComicReaderView();
                                        },
                                      );
                                    }).toList()),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    chapters.length > 4
                                        ? SizedBox(
                                            height: 60.w,
                                            child: Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  //查看全部章节
                                                  ComicChaptersRoute(
                                                          widget.data.detail!)
                                                      .push(context);
                                                },
                                                child: Container(
                                                  height: 30.w,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 70.w),
                                                  decoration: BoxDecoration(
                                                      gradient: MyTheme.gradient_90_114,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20.w))),
                                                  alignment: Alignment.center,
                                                  child: Center(
                                                      child: RichText(
                                                          text: TextSpan(
                                                              children: [
                                                        TextSpan(
                                                          text: 'ckqbzj'
                                                              .tr(context:
                                                                  context),
                                                          style:
                                                              MyTheme.white12,
                                                        )
                                                      ]))),
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
                        ],
                      ),
                  
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
                              child: Text('xgtj'.tr(context: context),
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
                                  childAspectRatio: UILayerConst.comicRatio,
                                  mainAxisSpacing: 10.w,
                                  crossAxisSpacing: 10.w,
                                ),
                                itemBuilder: (context, index) {
                                  final item = recommends[index];
                                  return ComicItemCard(data: item);
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        iconButton(
                            imageName: widget.data.detail?.isFavorite == 1 ?
                            MyImagePaths.appThumbUpOnIcon : MyImagePaths.appThumbsIcon,
                            title: 'sc'.tr(context: context),
                            func: () {
                              _changeFavorite();
                            }),
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
              jumperComicReaderView();
            },
            child: Container(
              width: 1.sw / 2,
              height: 60.w,
              decoration: const BoxDecoration(gradient: MyTheme.gradient_90_114),
              alignment: Alignment.center,
              child: Center(
                  child: RichText(
                      text: TextSpan(children: [
                TextSpan(
                  text: lastReadChapter > -1
                      ? 'jxyd'.tr(context: context)
                      : 'ksyd'.tr(context: context),
                  style: MyTheme.white14,
                )
              ]))),
            ),
          )
        ],
      ),
    );
  }

  jumperComicReaderView() async {
    ComicReaderRoute(chapterIndex: lastReadChapter > -1 ? lastReadChapter : 0, $extra: widget.data.detail!).push(context);
    await cacheDomain.upsertComicReaderChapterIndex(comicIdkey: '${widget.data.detail?.id}', chapterIndex: lastReadChapter);
  }

  Widget iconButton(
      {String imageName = '', String title = '', Function? func}) {
    return GestureDetector(
      onTap: () {
        func?.call();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyImage.asset(
            imageName,
            width: 22.w,
            height: 22.w,
          ),
          SizedBox(width: 5.w),
          SizedBox(
            height: 30.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: const Color.fromRGBO(255, 255, 255, 0.4),
                      fontSize: 14.sp),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _changeFavorite() async {
    final domain = context.read<UserDomain>();

    final result =
    await domain.userFavorite(type: 3, id: widget.data.detail?.id ?? 0);
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
