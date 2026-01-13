import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';



class DanSanDialog extends StatelessWidget {
  const DanSanDialog({
    super.key,
    this.title,
    this.content,
    this.backgroundColor = const Color.fromRGBO(21, 28, 40, 1),
  });

  final String? title;
  final Widget? content;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          const Positioned.fill(
            child: MyImage.asset(
              MyImagePaths.appDialogBg,
              fit: BoxFit.fill,
            ),
          ),
 Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 300.w,
              padding: EdgeInsets.only(
                  left: 15.w,
                  right: 15.w,
                  top: title == null ? 0 : 25.w,
                  bottom: 33.5.w),
              decoration:const BoxDecoration(
                // color: backgroundColor,
                borderRadius:  BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          title ?? '',
                          style: MyTheme.white255_18_M,
                        ),
                      ),
                      // ReportGestureDetector(
                      //   onTap: () => context.pop(),
                      //   child: MyImage.asset(
                      //     MyImagePaths.appCircleClose,
                      //     width: 30.w,
                      //   ),
                      // ),
                    ],
                  ),
                  Container(
                      margin: title == null
                          ? EdgeInsets.zero
                          : EdgeInsets.only(top: 26.w),
                      child: content),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
