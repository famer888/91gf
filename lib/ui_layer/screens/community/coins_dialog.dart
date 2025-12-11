import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';

class CoinsDialog extends StatefulWidget {
  final int unlockCoins;
  final int money;
  final VoidCallback actionCallback;
  const CoinsDialog({super.key, required this.unlockCoins, required this.money, required this.actionCallback});

  @override
  State<CoinsDialog> createState() => _CoinsDialogState();
}

class _CoinsDialogState extends State<CoinsDialog> {
  @override
  Widget build(BuildContext context) {
    Widget current = Container(
      padding: EdgeInsets.all(20.w),
      decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(MyImagePaths.appCoinsDialogBg), fit: BoxFit.cover)),
      width: 305.w,
      child: Column(
          mainAxisSize: MainAxisSize.min, // 让 Column 高度自适应
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('wxts'.tr(context: context), style: MyTheme.white18mudium),
            SizedBox(height: 25.w),
            Text('jbspjs'.tr(context: context), style: MyTheme.white15),
            SizedBox(height: 2.w),
            Text('${widget.unlockCoins}${'jbcoins'.tr(context: context)}', style: MyTheme.white15.cyanColor00edfd),
            SizedBox(height: 2.w),
            Text('${'kyje'.tr(context: context)}: ${widget.money}${'jbcoins'.tr(context: context)}', style: MyTheme.white15),
            SizedBox(height: 25.w),
            Row(mainAxisSize: MainAxisSize.min, children: [
              InkWell(
                onTap: () {
                  //取消
                  context.pop(); //隐藏弹窗
                  // final canPop = GoRouter.of(context).routerDelegate.canPop();
                  // if (canPop) {
                  //   context.pop(); //退出播放器界面
                  // }
                },
                child: Container(
                    width: 100.w,
                    height: 36.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: const Color.fromRGBO(49, 21, 47, 1), borderRadius: BorderRadius.all(Radius.circular(18.w))),
                    child: Text('qx'.tr(context: context), style: MyTheme.white15_M)),
              ),
              SizedBox(width: 32.w),
              InkWell(
                onTap: () {
                  if (widget.money >= widget.unlockCoins) {
                    // 扣除金币
                    context.pop();
                    widget.actionCallback.call();
                  } else {
                    // 前往充值
                    context.pop();
                    const CoinRechargeRoute().push(context);
                  }
                },
                child: Container(
                    width: 100.w,
                    height: 36.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(gradient: MyTheme.gradient_90_114, borderRadius: BorderRadius.all(Radius.circular(18.w))),
                    child: Text((widget.money >= widget.unlockCoins) ? 'qd'.tr(context: context) : 'qwcz'.tr(context: context), style: MyTheme.white15_M)),
              ),
            ]),
          ]),
    );
    current = ClipRRect(borderRadius: BorderRadius.circular(10.w), child: current);

    return Center(child: current);
  }
}
