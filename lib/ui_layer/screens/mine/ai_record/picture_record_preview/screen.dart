import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';



class PictureRecordPreviewScreen extends StatefulWidget {
  const PictureRecordPreviewScreen({super.key, required this.url, required this.delTapCall});

  final String url;
  final Function delTapCall;

  @override
  State<PictureRecordPreviewScreen> createState() =>
      _PictureRecordPreviewScreenState();
}

class _PictureRecordPreviewScreenState
    extends State<PictureRecordPreviewScreen> {

  @override
  Widget build(BuildContext context) {
    final sheetHeight = ScreenUtil().screenHeight * 0.8;

    return Container(
        padding: EdgeInsets.only(left: MyTheme.pagePadding, top: MyTheme.pagePadding, right: MyTheme.pagePadding, bottom: 44.w),
        color: MyTheme.bgColor,
        height: sheetHeight,
        child: Column(children: [
          Expanded(child: MyImage.network(widget.url, fit: BoxFit.contain, borderRadius: 14.w)),
          SizedBox(height: 30.w),
          ReportGestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              _saveImage(context);
            },
            child: Container(
              height: 45.w,
              decoration: BoxDecoration(
                  gradient: MyTheme.gradient_90_114,
                  borderRadius: BorderRadius.circular(5.w)),
              child: Center(
                child: Text(
                  tr('bc'),
                  style: MyTheme.white16medium,
                ),
              ),
            ),
          ),
          SizedBox(height: 15.w),
          ReportGestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              widget.delTapCall.call();
              // context.pop();
            },
            child: Container(
              height: 45.w,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(5.w)),
              child: Center(
                child: Text(
                  tr('sch'),
                  style: MyTheme.white16medium,
                ),
              ),
            ),
          )
        ]));
  }

  Future<void> _saveImage(BuildContext context) async {
    try {
      CommonUtils.localStorageImage(widget.url);
    } catch (e) {
      MyToast.showText(text: tr('tpbcsb'));
    }
  }

}
