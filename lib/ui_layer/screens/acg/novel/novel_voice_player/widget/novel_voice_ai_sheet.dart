import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/acg/novel/novel_voice_player/novel_voice_player_manager.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class NovelVoiceAISheet extends StatefulWidget {
  const NovelVoiceAISheet({super.key});

  @override
  State<NovelVoiceAISheet> createState() => _NovelVoiceAISheetState();
}

class _NovelVoiceAISheetState extends State<NovelVoiceAISheet> {
  double get bottomBarHeight => kIsWeb ? 17 : ScreenUtil().bottomBarHeight;

  List<String> titles = ['御姐音', '萝莉音', '男主音', '女主音'];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(
            top: 10.w,
            bottom: bottomBarHeight + 20.w,
            left: MyTheme.pagePadding,
            right: MyTheme.pagePadding),
        decoration: BoxDecoration(
            color: MyTheme.bgColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.w))),
        height: 46.w * titles.length + bottomBarHeight + 20.w + 70.w,
        child: Column(
          children: [
            SizedBox(
              height: 46.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 42.w,
                  ),
                  Text('aisy'.tr(context: context), style: MyTheme.white_17),
                  ReportGestureDetector(
                    onTap: () => Navigator.pop(context),
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      height: double.infinity,
                      child: MyImage.asset(
                        MyImagePaths.appClose,
                        width: 16.w,
                        height: 16.w,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10.w),
            Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: titles.length,
                    itemBuilder: (context, index) =>
                        NovelVoiceAISheetCard(title: titles[index])))
          ],
        ),
      ),
    );
  }
}


class NovelVoiceAISheetCard extends StatefulWidget {
  const NovelVoiceAISheetCard({super.key, required this.title});

  final String title;

  @override
  State<NovelVoiceAISheetCard> createState() => NovelVoiceAISheetCardState();
}

class NovelVoiceAISheetCardState extends State<NovelVoiceAISheetCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // NovelVoicePlayerManager.instance.minutes = widget.title;
        // NovelVoicePlayerManager.instance.startTimer();
        Navigator.pop(context);
      },
      child: SizedBox(
        height: 46.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Divider(color: Colors.white.withOpacity(0.2), thickness: 0.5, height: 0.5),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Text(
                          widget.title,
                          style: MyTheme.white09_15_M)),
                  SizedBox(width: 10.w),
                  MyImage.asset(
                    MyImagePaths.appAsmrGouS,
                    width: 18.w,
                    height: 18.w,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
