import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/dialog/widgets/regular_dialog.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';

class AiServerDialog {
  /// 确认对话框(目前好像只有魔法中使用了)
  static Future<void> showConfirmDialog(BuildContext context, int coins, VoidCallback onConfirm) async {
    return CommonUtils.showDialog(
                    context: context,
                    builder: (context) => RegularDialog(
                      buttonText: 'qd'.tr(),
                      cancelText: 'qx'.tr(),
                      title: 'ts'.tr(),
                      content: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                              text: '使用$coins金币进行生成？',
                              style: MyTheme.white255_15,
                            ),
                          ])),
                      confirmOnTap: () {
                          onConfirm();
                        context.pop();
                      },
                    ),
                  );
  }

  /// 余额不足提示
  static Future<void> showBalanceNotEnough(BuildContext context, int userCoins) async {
    return CommonUtils.showDialog(
      context: context,
      builder: (context) => RegularDialog(
        buttonText: 'qwcz'.tr(),  
        cancelText: 'qx'.tr(),
        title: 'ts'.tr(),
        content: RichText(  
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: '${tr('ndyebz')}\n${tr('syjb')}',
                style: MyTheme.white255_15,
              ),
              TextSpan(
                text: '$userCoins金币',
                style: MyTheme.orange247_15,
              )
            ],
          ),
        ),
        confirmOnTap: () {
          //前往充值
          context.pop();
          const CoinRechargeRoute().push(context);
        },
        cancelOnTap: () {
          //取消
          context.pop();
        },
      ),
    );
  }

  /// 提交成功提示
  static void showSubmitSuccess(BuildContext context) {
    CommonUtils.showDialog(
      context: context,
      builder: (context) => RegularDialog(
        buttonText: 'gb'.tr(),
        title: 'wxts'.tr(),
        content: Text(
          '提交成功，稍后前往\n【AI记录】中查看',
          style: MyTheme.white255_15,
          textAlign: TextAlign.center,
        ),
        confirmOnTap: () async {
          context.pop();
        },
      ),
    );
  }

  /// 提示上传
  static void showTip(BuildContext context, String content) {
    CommonUtils.showDialog(
      context: context,
      builder: (context) => RegularDialog(
        buttonText: 'qd'.tr(),
        title: 'wxts'.tr(),
        content: Text(
          content,
          style: MyTheme.white255_15,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
