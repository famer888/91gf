import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/enum.dart';
import 'package:jygf/domain/model/member_model.dart';
import 'package:jygf/ui_layer/notifiers/user_notifier.dart';
import 'package:jygf/ui_layer/screens/black/widgets/black_regular_dialog.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

import '../../router/routes.dart';
import '../common_widgets/dialog/my_dialog.dart';
import '../common_widgets/my_image.dart';
import '../image_paths.dart';
import '../theme.dart';

class VipPayDialog {
  static void showVipDialog(BuildContext context) {
    MyDialog.showDialog(
      context: context,
      child: BlackRegularDialog(
        leftPadding: 0,
        rightPadding: 0,
        topPadding: 0,
        bottomPadding: 0,
        content: Container(
          padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 20.w, bottom: 15.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.w)),
            image: DecorationImage(image: AssetImage(MyImagePaths.appMineRuleBg), fit: BoxFit.fill),
          ),
          child: DefaultTextStyle(
            style: MyTheme.gray102_13,
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('wxts'.tr(context: context), style: MyTheme.white255_13_M.s18),
                    SizedBox(height: 27.w),
                    Text('jbhcjs'.tr(context: context), style: MyTheme.white255_13.s14.w400),
                    SizedBox(height: 40.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.pop();
                            const MineShareToUserRoute().push(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: MyTheme.gradient_90_135_colors),
                              borderRadius: BorderRadius.all(Radius.circular(25.w)),
                            ),
                            child: Text(tr('fxlvip'), style: MyTheme.white255_13.s14.w400),
                          ),
                        ),
                        SizedBox(width: 38.w),
                        GestureDetector(
                          onTap: () {
                            context.pop();
                            const VipCenterRoute().push(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: MyTheme.gradient_90_114_colors),
                              borderRadius: BorderRadius.all(Radius.circular(25.w)),
                            ),
                            child: Text(tr('czvip'), style: MyTheme.white255_13.s14.w400),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: MyImage.asset(MyImagePaths.appRemove, width: 15.w, height: 15.w),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void showCoinsDialog({
    required BuildContext context,
    required Member member,
    required double coins,
    required VoidCallback onPay,
    bool barrierDismissible = true,
  }) {
    MyDialog.showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      child: BlackRegularDialog(
        leftPadding: 0,
        rightPadding: 0,
        topPadding: 0,
        bottomPadding: 0,
        content: Container(
          padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 20.w, bottom: 15.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.w)),
            image: const DecorationImage(image: AssetImage(MyImagePaths.appMineRuleBg), fit: BoxFit.fill),
          ),
          child: DefaultTextStyle(
            style: MyTheme.gray102_13,
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('jbgm'.tr(context: context), style: MyTheme.white255_13_M.s18),
                    SizedBox(height: 27.w),
                    Row(
                      children: [
                        Text('金币余额：${member.money}', style: MyTheme.white255_13.s14.w400),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            context.pop();
                            const CoinRechargeRoute().push(context);
                          },
                          child: Text(
                            '立即充值',
                            style: TextStyle(
                              color: MyTheme.blueColor63,
                              fontSize: 14.sp,
                              overflow: TextOverflow.ellipsis,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.w),
                    Row(
                      children: [
                        Text('支付金额', style: MyTheme.white255_13.s14.w400),
                        const Spacer(),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(text: coins.toString(), style: MyTheme.white255_15.color250_255_115),
                            TextSpan(text: '金币', style: MyTheme.white255_15),
                          ]),
                        ),
                      ],
                    ),
                    SizedBox(height: 40.w),
                    GestureDetector(
                      onTap: () async {
                        // 检查登录
                        final userNotifier = context.read<UserNotifier>();
                        if (userNotifier.tokenStatus != MyTokenStatus.valid) {
                          await const LoginRoute().push(context);
                          if (userNotifier.tokenStatus == MyTokenStatus.valid) {
                            onPay.call();
                          } else {
                            MyToast.showText(text: '请先登录！');
                          }
                          return;
                        }
                        onPay.call();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: MyTheme.gradient_90_114_colors),
                          borderRadius: BorderRadius.all(Radius.circular(25.w)),
                        ),
                        child: Text(tr('立即购买'), style: MyTheme.white255_13.s14.w400),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: MyImage.asset(MyImagePaths.appRemove, width: 15.w, height: 15.w),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
