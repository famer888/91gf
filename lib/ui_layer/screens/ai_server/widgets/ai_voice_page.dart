import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/remote_domain/domains/aiaudio.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/notifiers/user_notifier.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/ai_server/widgets/dialog/ai_server_dialog.dart';
import 'package:jygf/ui_layer/screens/common_widgets/dialog/widgets/regular_dialog.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
// import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class AiVoicePage extends StatefulWidget {
  const AiVoicePage({super.key});

  @override
  State<AiVoicePage> createState() => _AiVoicePageState();
}

class _AiVoicePageState extends State<AiVoicePage> {
  String content = '';
  final TextEditingController contentcontroller = TextEditingController();
  late final _domain = context.read<AIAudioDomain>();
  late final userNotifier = context.read<UserNotifier>();
  int get freeNumber => userNotifier.member.aiAudioValue;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<HomeConfigNotifier>().config;
    final user = context.watch<UserNotifier>();
    final int needCoins = config.payAiAudio;
    final int coins = user.member.money;
    final int aiAudioFontCt = config.aiAudioFontCt;

    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: 'AI语音',
          rightWidget: TextButton(
            onPressed: () {
              const MineAIRecordRoute(index: 5).push(context);
            },
            child: Center(
              child: Text('wdai'.tr(), style: MyTheme.white255_13),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.w),
                    Text('内容（必填）', style: MyTheme.white16medium),
                    SizedBox(height: 10.w),
                    CommonUtils.dashedBorder(
                      color: MyTheme.white03Color,
                      borderRadius: BorderRadius.all(Radius.circular(5.w)),
                      child: Container(
                      height: 100.w,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: MyTheme.white01Color,
                        borderRadius: BorderRadius.all(Radius.circular(5.w)),
                      ),
                      child: TextField(
                        style: MyTheme.white14,
                        cursorColor: Colors.white,
                        maxLines: 6,
                        controller: contentcontroller,
                        maxLength: aiAudioFontCt,
                        decoration: InputDecoration(
                          hintText: '请输入内容',
                          hintStyle:
                              MyTheme.white14.copyWith(color: Colors.white70),
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                          border: InputBorder.none,
                          counterStyle:
                              MyTheme.white12.copyWith(color: Colors.white70),
                        ),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        onChanged: (value) => content = value,
                      ),
                    ),)
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.w),
            ReportGestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => _submit(context,
                  coins: coins,
                  needCoins: needCoins,
                  aiAudioValue: user.member.aiAudioValue),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                height: 40.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.w)),
                  gradient: MyTheme.gradient_90_114,
                ),
                child: Text(
                  freeNumber > 0
                      ? '免费生成（剩余 $freeNumber 次）'
                      : '需消耗 $needCoins 金币【余额 $coins】生成',
                  style: MyTheme.white16medium,
                ),
              ),
            ),
            SizedBox(height: 20.w),
          ],
        ),
      ),
    );
  }

  void _submit(BuildContext context,
      {required int coins,
      required int needCoins,
      required int aiAudioValue}) async {
    if (content.isEmpty) {
      AiServerDialog.showTip(context, '请填写内容');
      return;
    }

    if (aiAudioValue <= 0 && needCoins > coins) {
      AiServerDialog.showBalanceNotEnough(context, coins);
      return;
    }
    MyToast.showLoading();
    final result =
        await _domain.aiAudioGenerate(text: content, spkId: 'yellow1');
    MyToast.closeAllLoading();
    if (result.status == 1) {
      setState(() {
        content = '';
        contentcontroller.clear();
      });
      final newAiAudioValue = aiAudioValue - 1;
      if (newAiAudioValue >= 0) {
        userNotifier.setAiAudioValue(num: newAiAudioValue);
      } else {
        userNotifier.setMoney(money: coins - needCoins);
      }
      AiServerDialog.showSubmitSuccess(context);
    } else {
      MyToast.showText(text: result.msg ?? '提交失败');
    }
  }
}
