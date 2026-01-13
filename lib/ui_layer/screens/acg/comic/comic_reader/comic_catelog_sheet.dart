import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/comic_model.dart';
import 'package:jygf/ui_layer/screens/acg/comic/card/comic_chapter_card.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class ComicCatelogSheet extends StatefulWidget {
  const ComicCatelogSheet({super.key, required this.data, this.onTap});
  final ComicDetailModel data;
  final Function(int)? onTap;

  @override
  State<ComicCatelogSheet> createState() => ComicCatelogSheetState();
}

class ComicCatelogSheetState extends State<ComicCatelogSheet> {


  bool isDes = true; //默认正序
  List<ChaptersModel> chapters = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    chapters = widget.data.chapters ?? [];

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
            itemBuilder: (context, index) => ComicChapterCard(data: chapters[index],
                tapCall: () {//章节点击进入阅读界面
                  Navigator.pop(context);
                  final int _index = isDes ? index : chapters.length - index - 1;
                  widget.onTap?.call(_index);
                }),
          ),
        ),
      ],
    );
  }
}
