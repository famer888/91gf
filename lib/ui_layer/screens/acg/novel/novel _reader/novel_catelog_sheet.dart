import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/domain.dart';
import 'package:jygf/domain/model/novel_model.dart';
import 'package:jygf/ui_layer/screens/acg/novel/card/novel_chapter_card.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class NovelCatelogSheet extends StatefulWidget {
  const NovelCatelogSheet({super.key, required this.data, this.onTap});
  final NovelDetailModel data;
  final Function(int)? onTap;

  @override
  State<NovelCatelogSheet> createState() => _NovelCatelogSheetState();
}

class _NovelCatelogSheetState extends State<NovelCatelogSheet> {


  bool isDes = true; //默认正序
  List<NovelChaptersModel> chapters = [];
  late final cacheDomain = context.read<CacheDomain>();
  int lastReadChapter = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    chapters = widget.data.chapters ?? [];
    _getLastReadChapter();

  }

  Future<void> _getLastReadChapter() async {
    //获取缓存阅读到的章节
    lastReadChapter = await cacheDomain.readNovelReaderChapterIndex(
        novelIdkey: '${widget.data.id}');
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 100),
        child: Container(
            height: ScreenUtil().screenHeight * 0.8,
            width: 1.sw,
            decoration: BoxDecoration(
              color: MyTheme.bgColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.w),
                topRight: Radius.circular(10.w),
              ),
            ),
            child: ReportGestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.pop(context);
              },
              child: cofigContentView(),
            )));
  }

  Widget cofigContentView() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.w),
                child: Text('ml'.tr(context: context), style: MyTheme.white16),
              ),
              const Spacer(),
              ReportGestureDetector(
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
              ReportGestureDetector(
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
        Expanded(
          child: ListView.builder(
            cacheExtent: 1.sh,
            padding: EdgeInsets.only(
                left: MyTheme.pagePadding,
                right: MyTheme.pagePadding,
                bottom:  MyTheme.pagePadding
            ),
            physics: const BouncingScrollPhysics(),
            itemCount: chapters.length,
            itemBuilder: (context, index) {
              final int _index = isDes ? index : chapters.length - index - 1;
              final isLocation = (lastReadChapter == _index);
              return NovelChapterCard(data: chapters[index],
                  tapCall: () {//章节点击进入阅读界面
                    Navigator.pop(context);
                    widget.onTap?.call(_index);
                  },
                  isLocation: isLocation);
            }
          ),
        ),
      ],
    );
  }
}
