
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class MyDialog {
  static Future<T?> showDialog<T extends Object?>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
    bool needTransition = false,
  }) {
    return showGeneralDialog<T>(
      barrierColor: Colors.black.withOpacity(0.7),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      context: context,
      barrierDismissible: barrierDismissible,
      transitionBuilder: needTransition
          ? (context, a1, _, child) {
              var curve = Curves.easeInOut.transform(a1.value);
              return Transform.scale(
                scale: curve,
                child: child,
              );
            }
          : null,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return child;
      },
    );
  }

  //自定义对话框
  static showAnimationDialog({
    String? cancelTxt,
    String? confirmTxt = "确定",
    VoidCallback? cancel,
    VoidCallback? confirm,
    VoidCallback? backgroundReturn,
    Function? setContent,
  }) {
    return BotToast.showAnimationWidget(
      clickClose: false,
      allowClick: false,
      onlyOne: false,
      crossPage: true,
      backButtonBehavior: BackButtonBehavior.none,
      wrapToastAnimation: (controller, cancel, child) => Stack(
        children: [
          ReportGestureDetector(
            onTap: () {
              cancel(); // 按钮点击关闭弹窗
              backgroundReturn?.call();
            },
            //The DecoratedBox here is very important,he will fill the entire parent component
            child: AnimatedBuilder(
              builder: (_, child) => Opacity(
                opacity: controller.value,
                child: child,
              ),
              animation: controller,
              child: const DecoratedBox(
                decoration: BoxDecoration(color: Colors.black38),
                child: SizedBox.expand(),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              Tween<Offset> tweenOffset = Tween<Offset>(
                begin: const Offset(0.0, 0.8),
                end: Offset.zero,
              );
              Tween<double> tweenScale = Tween<double>(begin: 0.3, end: 1.0);
              Animation<double> animation =
                  CurvedAnimation(parent: controller, curve: Curves.decelerate);
              return FractionalTranslation(
                translation: tweenOffset.evaluate(animation),
                child: ClipRect(
                  child: Transform.scale(
                    scale: tweenScale.evaluate(animation),
                    child: Opacity(
                      opacity: animation.value,
                      child: child,
                    ),
                  ),
                ),
              );
            },
            child: child,
          )
        ],
      ),
      toastBuilder: (cancelFunc) {
        return Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 40.w),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12.w))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // MyImage.asset(
                //   MyImagePaths.appTipSincerly,
                //   width: 78.w,
                //   height: 20.w,
                //   fit: BoxFit.contain,
                // ),
                SizedBox(height: 15.w),
                setContent?.call(),
                SizedBox(height: 15.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    cancelTxt == null
                        ? Container()
                        : Expanded(
                            child: ReportGestureDetector(
                              onTap: () {
                                cancelFunc();
                                cancel?.call();
                              },
                              child: Container(
                                height: 44.w,
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                decoration: BoxDecoration(
                                  color: cancelTxt == 'fxlvip'.tr()
                                      ? const Color.fromRGBO(251, 165, 63, 1)
                                      : const Color.fromRGBO(178, 178, 178, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.w)),
                                ),
                                child: Center(
                                    child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: cancelTxt,
                                      style: MyTheme.white16medium,
                                    ),
                                  ]),
                                )),
                              ),
                            ),
                          ),
                    SizedBox(width: cancelTxt == null ? 0 : 20.w),
                    confirmTxt == null
                        ? Container()
                        : Expanded(
                            child: ReportGestureDetector(
                              onTap: () {
                                cancelFunc();
                                confirm?.call();
                              },
                              child: Container(
                                height: 44.w,
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                decoration: BoxDecoration(
                                    gradient: MyTheme.shareButtonGradient,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.w))),
                                alignment: Alignment.center,
                                child: Center(
                                    child: RichText(
                                        text: TextSpan(children: [
                                  TextSpan(
                                    text: confirmTxt,
                                    style: MyTheme.white16medium,
                                  )
                                ]))),
                              ),
                            ),
                          )
                  ],
                ),
              ],
            ),
          ),
        );
      },
      animationDuration: const Duration(milliseconds: 300),
    );
  }
}
