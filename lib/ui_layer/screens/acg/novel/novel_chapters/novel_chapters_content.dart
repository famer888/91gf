import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/domain.dart';
import 'package:jygf/domain/model/novel_model.dart';
import 'package:jygf/ui_layer/router/approute_observer.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/acg/novel/card/novel_chapter_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/event_bus/event_bus.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/theme.dart';

///小说部章节界面
class NovelChaptersContent extends StatefulWidget {
  const NovelChaptersContent({super.key, required this.data});

  final NovelDetailModel data;

  @override
  State<NovelChaptersContent> createState() => _NovelChaptersContentState();
}

class _NovelChaptersContentState extends State<NovelChaptersContent> with RouteAware {

  bool isDes = true; //默认正序
  List<NovelChaptersModel> chapters = [];
  late StreamSubscription<MyEvent> _subscription;
  late final cacheDomain = context.read<CacheDomain>();
  int lastReadChapter = 0;

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
    _getLastReadChapter();
  }

  Future<void> _getLastReadChapter() async {
    //获取缓存阅读到的章节
    lastReadChapter = await cacheDomain.readNovelReaderChapterIndex(
        novelIdkey: '${widget.data.id}');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    chapters = widget.data.chapters ?? [];

    _subscription = eventBus.on<MyEvent>().listen((event) {
      debugPrint('Received event: ${event.message}');
      if (event.message == 'NovelIsPaySuccess') {
        int index = event.param?['chapterIndex'];
        String txt = event.param?['txt'];
        chapters[index].txt = txt;
        setState(() {
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel(); // 取消订阅
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          rightWidget: Row(
            children: [
              GestureDetector(
                onTap: () {//正序
                  if (isDes) {
                    return;
                  }
                  setState(() {
                    chapters = chapters.reversed.toList();
                    isDes = true;
                  });
                },
                child: Text('zxu'.tr(context: context), style: isDes ? MyTheme.white14Medium : MyTheme.white04_14),
              ),
              SizedBox(width: 8.w),
              Container(width: 0.5, height: 15.w, color: Colors.white.withOpacity(0.4)),
              SizedBox(width: 6.w),
              GestureDetector(
                onTap: () {//倒序
                  if (!isDes) {
                    return;
                  }
                  setState(() {
                    chapters = chapters.reversed.toList();
                    isDes = false;
                  });
                },
                child: Text('dxu'.tr(context: context), style: isDes ? MyTheme.white04_14 : MyTheme.white14Medium),
              ),
            ],
          ),
        ),
        body: ListView.builder(
          cacheExtent: 1.sh,
          padding: EdgeInsets.only(
              left: MyTheme.pagePadding,
              right: MyTheme.pagePadding,
              bottom:  MyTheme.pagePadding
          ),
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemCount: chapters.length,
          itemBuilder: (context, index)  {
            final int _index = isDes ? index : chapters.length - index - 1;
            final isLocation = (lastReadChapter == _index);
            return NovelChapterCard(
                data: chapters[index],
                tapCall: () {
                  //章节点击进入阅读界面
                  jumperNovelReaderView(index);
                },
                isLocation: (isLocation == false && lastReadChapter == -1 && (isDes ? index == 0 : index == chapters.length - 1))
                    ? true
                    : isLocation);
          }
        ),
      ),
    );
  }

  jumperNovelReaderView(int index) {
    final int _index = isDes ? index : chapters.length - index - 1;
    NovelReaderRoute(chapterIndex: _index, $extra: widget.data).push(context);
  }

}