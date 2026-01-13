import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class BlackRegularDialog extends StatelessWidget {
  const BlackRegularDialog({
    super.key,
    this.title,
    this.content,
    this.confirmOnTap,
    this.cancelOnTap,
    this.buttonText,
    this.cancelText,
    this.leftPadding,
    this.rightPadding,
    this.topPadding,
    this.bottomPadding,
    this.showUpCloseBtn = false,
    this.backgroundColor = const Color.fromRGBO(21, 28, 40, 1),
  });

  final String? title;
  final Widget? content;
  final VoidCallback? confirmOnTap;
  final VoidCallback? cancelOnTap;
  final double? leftPadding;
  final double? rightPadding;
  final double? topPadding;
  final double? bottomPadding;
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
                  onTap: () => context.pop(),
                  child: MyImage.asset(MyImagePaths.appDialogClose, width: 30.w),
                ),
                SizedBox(height: 25.w)
              ],
            ),
          Container(
            width: 300.w,
            padding: EdgeInsets.only(
              left: leftPadding ?? 22.5.w,
              right: rightPadding ?? 22.5.w,
              top: title == null ? 0 : (topPadding ?? 25.w),
              bottom: bottomPadding ?? 33.5.w,
            ),
            decoration: BoxDecoration(color: backgroundColor, borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) Center(child: Text(title ?? '', style: MyTheme.white255_18_M)),
                Container(margin: title == null ? EdgeInsets.zero : EdgeInsets.only(top: 26.w), child: content),
                Row(
                  children: [
                    if (cancelText != null)
                      Expanded(
                          child: Center(
                        child: ReportGestureDetector(
                          onTap: () => cancelOnTap == null ? context.pop() : cancelOnTap?.call(),
                          child: Container(
                            margin: EdgeInsets.only(left: 5.w, right: 5.w, top: 40.w),
                            width: 163.5.w,
                            height: 32.w,
                            decoration: BoxDecoration(gradient: MyTheme.gradient_90_114, borderRadius: BorderRadius.all(Radius.circular(16.w))),
                            child: Center(child: Text(cancelText ?? '', style: MyTheme.hexa3a2a2_13_M)),
                          ),
                        ),
                      )),
                    if (buttonText != null)
                      Expanded(
                          child: Center(
                        child: ReportGestureDetector(
                          onTap: () => confirmOnTap == null ? context.pop() : confirmOnTap?.call(),
                          child: Container(
                            margin: EdgeInsets.only(left: 5.w, right: 5.w, top: 40.w),
                            width: 163.5.w,
                            height: 32.w,
                            decoration: BoxDecoration(gradient: MyTheme.gradient_90_114, borderRadius: BorderRadius.all(Radius.circular(16.w))),
                            child: Center(
                              child: Text(buttonText!, style: MyTheme.white255_13_M),
                            ),
                          ),
                        ),
                      ))
                  ],
                )
              ],
            ),
          ),
          if (showUpCloseBtn) AbsorbPointer(absorbing: true, child: SizedBox(height: 55.w))
        ],
      ),
    );
  }
}
