import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:provider/provider.dart';

import '../../../../domain/domain.dart';
import '../../../notifiers/user_notifier.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/screen_background.dart';
import '../../theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class MineBindEmailScreen extends StatefulWidget {
  const MineBindEmailScreen({super.key, this.isForPop = false});

  final bool isForPop;
  @override
  State<MineBindEmailScreen> createState() => _MineBindEmialScreenState();
}

class _MineBindEmialScreenState extends State<MineBindEmailScreen> {
  late final accountDomain = context.read<AccountDomain>();

  late final userNotifier = context.read<UserNotifier>();

  final myController = TextEditingController();
  final verController = TextEditingController();

  final focusNode = FocusNode();
  final vertifyFocusNode = FocusNode();

  //倒数60秒
  int seconds = 60;
  //验证码校验状态
  bool isVerify = false;

  void _getVerifyCode() async {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!emailRegExp.hasMatch(myController.text)) {
      MyToast.showText(text: 'qsrzqyx'.tr());
      return;
    }
    MyToast.showLoading();
    if (myController.text.isEmpty) {
      MyToast.closeAllLoading();
      MyToast.showText(
        text: '${'qing'.tr(context: context)}${'txyzm'.tr(context: context)}',
      );
    } else {
      final value = myController.text;

      var result = await accountDomain.sendCode(email: value);
      if (result.status == 1) {
        Timer.periodic(const Duration(seconds: 1), (Timer timer) {
          seconds--;
          if (seconds <= 0) {
            seconds = 60;
            timer.cancel();
          }
          if (mounted) setState(() {});
        });
      }

      MyToast.showText(text: result.msg ?? '');

      MyToast.closeAllLoading();
    }
  }

  void onSubmit() async {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!emailRegExp.hasMatch(myController.text)) {
      MyToast.showText(text: 'qsrzqyx'.tr());
      return;
    }
    MyToast.showLoading();
    if (myController.text.isEmpty) {
      MyToast.closeAllLoading();
      MyToast.showText(
        text: '${'qing'.tr(context: context)}${'sryx'.tr(context: context)}',
      );
      return;
    }

    if (verController.text.isEmpty) {
      MyToast.closeAllLoading();
      MyToast.showText(
        text: '${'qing'.tr(context: context)}${'txyzm'.tr(context: context)}',
      );
      return;
    }

    final value = myController.text;
    final code = verController.text;

    var result = await accountDomain.bindEmail(email: value, code: code);

    MyToast.closeAllLoading();
    showText(status: result.status, msg: result.msg, word: tr('txi'));

    if (result.status == 1) {
      userNotifier.setBindEmail(inviteBy: 1);
    }
  }

  void showText({status, msg, word = 'xg'}) {
    if (word == 'xg') {
      word = tr('xga');
    }
    if (status == 1) {
      MyToast.showText(text: '$word${tr('cg')} $msg');
      Future.delayed(const Duration(seconds: 2), () {
        context.pop();
      });
    } else {
      MyToast.showText(text: '$word${tr('sb')} $msg');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: widget.isForPop
            ? null
            : MyAppBar(
                title: 'bdyx'.tr(),
              ),
        body: ReportGestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            focusNode.unfocus();
            vertifyFocusNode.unfocus();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isForPop)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 20.w),
                      Container(
                        height: 40.w,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('bdyx'.tr(), style: MyTheme.white12medium.s17),
                          ],
                        ),
                      ),
                      ReportGestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: MyImage.asset(
                          MyImagePaths.appClose,
                          width: 16.w,
                          height: 16.w,
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                  child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 25.5.w,
                  vertical: 21.5.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          height: 50.w,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5.w),
                          ),
                          child: Center(
                            child: TextField(
                              focusNode: focusNode,
                              autofocus:
                                  widget.isForPop || kIsWeb ? false : true,
                              controller: myController,
                              style: MyTheme.white255_15_M,
                              cursorColor:
                                  const Color.fromRGBO(255, 255, 255, 1),
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                hoverColor: Colors.white,
                                hintText:
                                    '${'qing'.tr(context: context)}${'sryx'.tr(context: context)}',
                                hintStyle: TextStyle(
                                  color: const Color(0xff999999),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.sp,
                                ),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),

                          // "txyzm": "填写邮箱验证码",
                          // "": "获取验证码",
                        ),
                        SizedBox(height: 10.w),
                        Container(
                          padding: EdgeInsets.only(left: 10.w),
                          height: 50.w,
                          width: double.infinity,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5.w),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  focusNode: vertifyFocusNode,
                                  // autofocus: true,
                                  controller: verController,
                                  style: MyTheme.white255_15_M,
                                  cursorColor:
                                      const Color.fromRGBO(255, 255, 255, 1),
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hoverColor: Colors.white,
                                    hintText:
                                        '${'qing'.tr(context: context)}${'txyzm'.tr(context: context)}',
                                    hintStyle: TextStyle(
                                      color: const Color(0xff999999),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.sp,
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              // Padding(
                              //   padding: EdgeInsets.only(
                              //       top: 2.w, left: 10.w, right: 10.w),
                              //   child: verController.text.length == 6 &&
                              //           myController.text.isNotEmpty
                              //       ? Icon(
                              //           isVerify
                              //               ? Icons.check_circle
                              //               : Icons.error,
                              //           color: isVerify
                              //               ? Colors.green
                              //               : StyleTheme.cyan96Color,
                              //           size: 15.w)
                              //       : Container(),
                              // ),
                              ReportGestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  if (seconds < 60) return;

                                  _getVerifyCode();
                                },
                                child: Container(
                                  width: 95.w,
                                  // height: 24.w,
                                  decoration: const BoxDecoration(
                                    gradient: MyTheme.gradient_90_118,
                                    // borderRadius: BorderRadius.circular(12.w),
                                  ),
                                  child: Center(
                                    child: Text(
                                        seconds == 60
                                            ? 'hqyzm'.tr()
                                            : "$seconds${'mhcf'.tr()}",
                                        style: seconds == 60
                                            ? MyTheme.white255_14
                                            : MyTheme.white255_14),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 54.w),
                    ReportGestureDetector(
                      onTap: onSubmit,
                      child: Container(
                        height: 40.w,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            gradient: MyTheme.gradient_90_114,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.w))),
                        child: Center(
                          child: Text(
                            'qr'.tr(context: context),
                            style: MyTheme.white255_15_semibold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 38.w),
                    Text(
                      'wxts'.tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        // fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 18.w,
                    ),
                    Text(
                      context.read<HomeConfigNotifier>().config.bindEmailTip ??
                          '',
                      // 'bdyxtip1'.tr(),
                      style: MyTheme.gray172_14.s12,
                    ),
                    // Text(
                    //   'bdyxtip1'.tr(),
                    //   style: MyTheme.gray172_14.s12,
                    // ),
                    // Text(
                    //   'bdyxtip2'.tr(),
                    //   style: MyTheme.gray172_14.s12,
                    // ),
                    // Text(
                    //   'bdyxtip3'.tr(),
                    //   style: MyTheme.gray172_14.s12,
                    // ),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
