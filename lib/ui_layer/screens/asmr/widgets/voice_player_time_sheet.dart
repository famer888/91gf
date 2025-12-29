import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/asmr/card/voice_time__sheet_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';

class VoicePlayerTimeSheet extends StatefulWidget {
  const VoicePlayerTimeSheet({super.key});

  @override
  State<VoicePlayerTimeSheet> createState() => _VoicePlayerTimeSheetState();
}

class _VoicePlayerTimeSheetState extends State<VoicePlayerTimeSheet> {
  double get bottomBarHeight => kIsWeb ? 17 : ScreenUtil().bottomBarHeight;

  List<int> titles = [10, 20, 30, 40, 50, 60];

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
            color: MyTheme.blackColor29_2_24,
            border:const Border(top: BorderSide(color: Color.fromRGBO(154, 48, 133, 1), width: 1)),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.w))),
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
                  Text('dsbf'.tr(context: context), style: MyTheme.white_17),
                  GestureDetector(
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
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
                    shrinkWrap: true,
                    itemCount: titles.length,
                    itemBuilder: (context, index) =>
                        VoiceTimeSheetCard(minute: titles[index])))
          ],
        ),
      ),
    );
  }
}
