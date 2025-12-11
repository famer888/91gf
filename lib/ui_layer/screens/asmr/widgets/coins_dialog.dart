import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/model/member_model.dart';
import 'package:jygf/domain/model/voice_model.dart';
import 'package:jygf/ui_layer/notifiers/user_notifier.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/asmr/voice_player/voice_player_manager.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:provider/provider.dart';

class CoinsDialog extends StatefulWidget {
  const CoinsDialog({super.key, required this.data});

  final VoiceModel data; //需要购买的数据

  @override
  State<CoinsDialog> createState() => _CoinsDialogState();
}

class _CoinsDialogState extends State<CoinsDialog> {
  @override
  Widget build(BuildContext context) {
    final data = VoicePlayerManager.instance.data;
    List<TextSpan> textSpans = [];
    if (data?.type == 1) {
      textSpans = [TextSpan(text: data?.payTip ?? '', style: MyTheme.white15)];
    } else if (data?.type == 2) {
      textSpans = [
        TextSpan(text: 'dqyp'.tr(context: context), style: MyTheme.white15),
        TextSpan(text: '${data?.coins}${'jb'.tr(context: context)}', style: MyTheme.jellyCyan_15_M),
        TextSpan(text: 'gmbf'.tr(context: context), style: MyTheme.white15),
      ];
    }

    Widget current = Container(
      padding: EdgeInsets.all(20.w),
      color: const Color.fromRGBO(35, 38, 46, 1),
      width: 305.w,
      child: Column(
          mainAxisSize: MainAxisSize.min, // 让 Column 高度自适应
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('wxts'.tr(context: context), style: MyTheme.white18mudium),
            SizedBox(height: 25.w),
            RichText(text: TextSpan(children: textSpans)),
            SizedBox(height: 25.w),
            Row(mainAxisSize: MainAxisSize.min, children: [
              InkWell(
                onTap: () {
                  //取消
                  context.pop(); //隐藏弹窗
                  final canpop = GoRouter.of(context).routerDelegate.canPop();
                  if (canpop) {
                    context.pop(); //退出播放器界面
                  }
                },
                child: Container(
                    width: 120.w,
                    height: 36.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: MyTheme.gray117, borderRadius: BorderRadius.all(Radius.circular(18.w))),
                    child: Text('qx'.tr(context: context), style: MyTheme.white15_M)),
              ),
              SizedBox(width: 20.w),
              InkWell(
                onTap: () {
                  //确定
                  if (data?.type == 1) {
                    //需要开通会员
                    const VipCenterRoute().push(context);
                  } else if (data?.type == 2) {
                    //需要金币购买
                    sureAction();
                  }
                },
                child: Container(
                    width: 120.w,
                    height: 36.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: MyTheme.jellyCyanColor103224185, borderRadius: BorderRadius.all(Radius.circular(18.w))),
                    child: Text('qd'.tr(context: context), style: MyTheme.white15_M)),
              ),
            ]),
            data?.type == 2
                ? InkWell(
                    onTap: () {
                      //后续不再提醒，直接购买
                      VoicePlayerManager.instance.needCoinsTip = !VoicePlayerManager.instance.needCoinsTip;
                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 20.w),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        MyImage.asset(VoicePlayerManager.instance.needCoinsTip ? MyImagePaths.appAsmrOpenNor : MyImagePaths.appAsmrOpenSel,
                            width: 10.w, height: 10.w),
                        SizedBox(width: 5.w),
                        Text('zjgm'.tr(context: context), style: MyTheme.jellyCyan_11_M)
                      ]),
                    ),
                  )
                : Container(),
          ]),
    );
    current = ClipRRect(
      borderRadius: BorderRadius.circular(10.w),
      child: current,
    );

    return Center(child: current);
  }

  void sureAction() {
    Member member = context.read<UserNotifier>().member;
    bool sufficient = member.money >= (widget.data.coins ?? 0);
    if (sufficient) {
      //用户余额足够直接购买
      VoicePlayerManager.instance.buyVoice(widget.data);
      return;
    } else {
      //弹窗提示余额不足，去充值
      context.pop(); //隐藏弹窗
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => const Material(
          type: MaterialType.transparency,
          child: PopScope(
              canPop: false, //禁止弹窗通过滑动隐藏
              child: CoinsNotEnoughDialog()),
        ),
      );
    }
  }
}

class CoinsNotEnoughDialog extends StatefulWidget {
  const CoinsNotEnoughDialog({super.key});

  @override
  State<CoinsNotEnoughDialog> createState() => _CoinsNotEnoughDialogState();
}

class _CoinsNotEnoughDialogState extends State<CoinsNotEnoughDialog> {
  @override
  Widget build(BuildContext context) {
    Widget current = Container(
      padding: EdgeInsets.all(20.w),
      color: const Color.fromRGBO(35, 38, 46, 1),
      width: 305.w,
      child: Column(
          mainAxisSize: MainAxisSize.min, // 让 Column 高度自适应
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('wxts'.tr(context: context), style: MyTheme.white18mudium),
            SizedBox(height: 25.w),
            Text('jbbzqcz'.tr(context: context), style: MyTheme.white15),
            SizedBox(height: 25.w),
            Row(mainAxisSize: MainAxisSize.min, children: [
              InkWell(
                onTap: () {
                  //取消
                  context.pop(); //隐藏弹窗
                  final canpop = GoRouter.of(context).routerDelegate.canPop();
                  if (canpop) {
                    context.pop(); //退出播放器界面
                  }
                },
                child: Container(
                    width: 120.w,
                    height: 36.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: MyTheme.gray117, borderRadius: BorderRadius.all(Radius.circular(18.w))),
                    child: Text('qx'.tr(context: context), style: MyTheme.white15_M)),
              ),
              SizedBox(width: 20.w),
              InkWell(
                onTap: () {
                  //确定
                  const CoinRechargeRoute().push(context);
                },
                child: Container(
                    width: 120.w,
                    height: 36.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: MyTheme.jellyCyanColor103224185, borderRadius: BorderRadius.all(Radius.circular(18.w))),
                    child: Text('qd'.tr(context: context), style: MyTheme.white15_M)),
              ),
            ]),
          ]),
    );
    current = ClipRRect(
      borderRadius: BorderRadius.circular(10.w),
      child: current,
    );

    return Center(child: current);
  }
}
