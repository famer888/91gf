import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';
import '../../my_image.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class PNGDialog extends StatelessWidget {
  const PNGDialog({
    super.key,
    this.title,
    this.content,
    this.confirmOnTap,
    this.cancelOnTap,
    this.buttonText,
    this.cancelText,
    this.showUpCloseBtn = false,
    this.backgroundColor = const Color.fromRGBO(21, 28, 40, 1),
  });
  final String? title;
  final Widget? content;
  final VoidCallback? confirmOnTap;
  final VoidCallback? cancelOnTap;
  final String? buttonText;
  final String? cancelText;
  final bool showUpCloseBtn;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showUpCloseBtn)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ReportGestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: MyImage.asset(
                    MyImagePaths.appDialogClose,
                    width: 30.w,
                  ),
                ),
                SizedBox(height: 25.w)
              ],
            ),
          Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: (300 / 305 * 114 - 40).w),
                  Container(
                    width: 300.w,
                    padding: EdgeInsets.only(
                        left: 24.5.w,
                        right: 24.5.w,
                        top: title == null ? 0 : 50.w,
                        bottom: 33.5.w),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          margin: title == null
                              ? EdgeInsets.zero
                              : EdgeInsets.only(top: 26.w),
                          child: content,
                        ),
                        Row(
                          children: [
                            if (cancelText != null)
                              Expanded(
                                  child: Center(
                                child: ReportGestureDetector(
                                  onTap: () {
                                    context.pop();
                                    cancelOnTap?.call();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: 5.w,
                                      right: 5.w,
                                      top: 40.w,
                                    ),
                                    width: 163.5.w,
                                    height: 32.w,
                                    decoration: BoxDecoration(
                                      gradient: cancelText!.contains('qx'.tr())
                                          ? const LinearGradient(
                                              colors: [
                                                Color(0xFFA1A1A1),
                                                Color(0xFFA1A1A1)
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            )
                                          : MyTheme.gradient_90_118,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(16.w),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        cancelText!,
                                        style: MyTheme.white255_12,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                            if (buttonText != null)
                              Expanded(
                                child: Center(
                                  child: ReportGestureDetector(
                                    onTap: () {
                                      context.pop();
                                      confirmOnTap?.call();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        left: 5.w,
                                        right: 5.w,
                                        top: 40.w,
                                      ),
                                      width: 163.5.w,
                                      height: 32.w,
                                      decoration: BoxDecoration(
                                        gradient: MyTheme.gradient_90_114,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(16.w),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          buttonText!,
                                          style: MyTheme.white255_12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 300.w,
                height: (300 / 305 * 114).w,
                child: const MyImage.asset(
                  MyImagePaths.appAlertPngN,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
          ),
          if (showUpCloseBtn)
            AbsorbPointer(
              absorbing: true,
              child: SizedBox(height: 55.w),
            )
        ],
      ),
    );
  }
}
