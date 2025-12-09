import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/comic_model.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/acg/comic/card/comic_chapter_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/event_bus/event_bus.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/theme.dart';

///漫画全部章节界面
class ComicChaptersContent extends StatefulWidget {
  const ComicChaptersContent({super.key, required this.data});

  final ComicDetailModel data;

  @override
  State<ComicChaptersContent> createState() => _ComicChaptersContentState();
}

class _ComicChaptersContentState extends State<ComicChaptersContent> {

  bool isDes = true; //默认正序
  List<ChaptersModel> chapters = [];
  late StreamSubscription<MyEvent> _subscription;

  @override
  void initState() {
    super.initState();

    chapters = widget.data.chapters ?? [];

    _subscription = eventBus.on<MyEvent>().listen((event) {
      debugPrint('Received event: ${event.message}');
      if (event.message == 'ComicIsPaySuccess') {
        int index = event.param?['chapterIndex'];
        chapters[index].isPay = 1;
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
            physics: const BouncingScrollPhysics(),
            itemCount: chapters.length,
            itemBuilder: (context, index) => ComicChapterCard(data: chapters[index],
            tapCall: () {//章节点击进入阅读界面
              jumperComicReaderView(index);
            }),
          ),
      ),
    );
  }

  jumperComicReaderView(int index) {
    final int _index = isDes ? index : chapters.length - index - 1;
    ComicReaderRoute(chapterIndex: _index, $extra: widget.data).push(context);
  }

}