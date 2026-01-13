import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/remote_domain/domains/ainovel.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/notifiers/user_notifier.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/ai_server/widgets/dialog/ai_server_dialog.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/dialog/widgets/regular_dialog.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class AiNovelPage extends StatefulWidget {
  const AiNovelPage({super.key});

  @override
  State<AiNovelPage> createState() => _AiNovelPageState();
}

class _AiNovelPageState extends State<AiNovelPage> {
  String desc = "";
  String people = "";
  String addres = "";
  String detail = "";
  String txtnum = "1000";
  late final _appDomain = context.read<AINovelDomain>();
  late final TextEditingController _descController = TextEditingController();
  late final TextEditingController _peopleController = TextEditingController();
  late final TextEditingController _addresController = TextEditingController();
  late final TextEditingController _detailController = TextEditingController();
  late final TextEditingController _txtnumController = TextEditingController();
  late final userNotifier = context.read<UserNotifier>();
  int get freeNumber => userNotifier.member.aiNovelValue;
  @override
  void dispose() {
    _descController.dispose();
    _peopleController.dispose();
    _addresController.dispose();
    _detailController.dispose();
    _txtnumController.dispose();
    super.dispose();
  }

  void _resetForm() {
    if (!mounted) return;
    setState(() {
      desc = "";
      people = "";
      addres = "";
      detail = "";
      txtnum = "1000";
      _descController.clear();
      _peopleController.clear();
      _addresController.clear();
      _detailController.clear();
      _txtnumController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeConfig = context.watch<HomeConfigNotifier>().config;
    final user = context.watch<UserNotifier>();
    final int needCoins = homeConfig.payAiNovel;
    final int coins = user.member.money;

    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: 'xscz'.tr(),
          rightWidget: TextButton(
            onPressed: () {
              const MineAIRecordRoute(index: 4).push(context);
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
                    SizedBox(height: 10.w),
                    Text('gsqjbt'.tr(), style: MyTheme.white16medium),
                    SizedBox(height: 10.w),
                    CommonUtils.dashedBorder(
                      color: MyTheme.white03Color,
                      borderRadius: BorderRadius.all(Radius.circular(5.w)),
                      child: Container(
                      height: 80.w,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: MyTheme.white01Color,
                        borderRadius: BorderRadius.all(Radius.circular(5.w)),
                      ),
                      child: TextField(
                        controller: _descController,
                        style: MyTheme.white14,
                        cursorColor: Colors.white,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'gsqjbtds'.tr(),
                          hintStyle:
                              MyTheme.white14.copyWith(color: Colors.white70),
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                          border: InputBorder.none,
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          desc = value;
                        },
                      ),
                    )),
                    SizedBox(height: 20.w),
                    Text('rwsd'.tr(), style: MyTheme.white16medium),
                    SizedBox(height: 10.w),
                    CommonUtils.dashedBorder(
                      color: MyTheme.white03Color,
                      borderRadius: BorderRadius.all(Radius.circular(5.w)),
                      child: Container(
                        height: 40.w,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: MyTheme.white01Color,
                          borderRadius: BorderRadius.all(Radius.circular(5.w)),
                        ),
                        child: TextField(
                          controller: _peopleController,
                          style: MyTheme.white14,
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            hintText: 'rwsdds'.tr(),
                            hintStyle:
                                MyTheme.white14.copyWith(color: Colors.white70),
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                            border: InputBorder.none,
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            people = value;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20.w),
                    Text('ddcj'.tr(), style: MyTheme.white16medium),
                    SizedBox(height: 10.w),
                    CommonUtils.dashedBorder(
                      color: MyTheme.white03Color,
                      borderRadius: BorderRadius.all(Radius.circular(5.w)),
                      child: Container(
                      height: 40.w,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: MyTheme.white01Color,
                        borderRadius: BorderRadius.all(Radius.circular(5.w)),
                      ),
                      child: TextField(
                        controller: _addresController,
                        style: MyTheme.white14,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: 'ddcjds'.tr(),
                          hintStyle:
                              MyTheme.white14.copyWith(color: Colors.white70),
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                          border: InputBorder.none,
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          addres = value;
                        },
                      ),
                    )),
                    SizedBox(height: 20.w),
                    Text('xjsm'.tr(), style: MyTheme.white16medium),
                    SizedBox(height: 10.w),
                    CommonUtils.dashedBorder(
                      color: MyTheme.white03Color,
                      borderRadius: BorderRadius.all(Radius.circular(5.w)),
                      child: Container(
                      height: 80.w,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: MyTheme.white01Color,
                        borderRadius: BorderRadius.all(Radius.circular(5.w)),
                      ),
                      child: TextField(
                        controller: _detailController,
                        style: MyTheme.white14,
                        cursorColor: Colors.white,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'xjsmds'.tr(),
                          hintStyle:
                              MyTheme.white14.copyWith(color: Colors.white70),
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                          border: InputBorder.none,
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          detail = value;
                        },
                      ),
                    )),
                    SizedBox(height: 20.w),
                    Text('xszs'.tr(), style: MyTheme.white16medium),
                    SizedBox(height: 10.w),
                    CommonUtils.dashedBorder(
                      color: MyTheme.white03Color,
                      borderRadius: BorderRadius.all(Radius.circular(5.w)),
                      child: Container(
                      height: 40.w,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                      color: MyTheme.white01Color,
                        borderRadius: BorderRadius.all(Radius.circular(5.w)),
                      ),
                      child: TextField(
                        controller: _txtnumController,
                        style: MyTheme.white14,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: 'xszsds'.tr(),
                          hintStyle:
                              MyTheme.white14.copyWith(color: Colors.white70),
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                          border: InputBorder.none,
                        ),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        onChanged: (value) {
                          if (value.isEmpty) {
                            txtnum = "1000";
                          } else {
                            txtnum = value;
                          }
                        },
                      ),
                    )),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.w),
            ReportGestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                _submit(context,
                    coins: coins,
                    needCoins: needCoins,
                    aiNovelValue: userNotifier.member.aiNovelValue);
              },
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
      required int aiNovelValue}) async {
    if (desc.isEmpty) {
      AiServerDialog.showTip(context, 'qtxgsqj'.tr());
      return;
    }
    final intNum = int.tryParse(txtnum) ?? 0;
    if (intNum < 200) {
      MyToast.showText(text: '字数不能小于200字');
      return;
    }

    if (aiNovelValue <= 0 && needCoins > coins) {
      AiServerDialog.showBalanceNotEnough(context, coins);
      return;
    }
    MyToast.showLoading();
    final result = await _appDomain.aiNovelGenerate(
      description: desc,
      characterSetting: people,
      locationScene: addres,
      details: detail,
      count: txtnum,
    );
    MyToast.closeAllLoading();
    if (result.status == 1) {
      _resetForm();
      final newAiNovelValue = aiNovelValue - 1;
      if (newAiNovelValue >= 0) {
        userNotifier.setAiNovelValue(num: newAiNovelValue);
      } else {
        userNotifier.setMoney(money: coins - needCoins);
      }
      AiServerDialog.showSubmitSuccess(context);
    } else {
      MyToast.showText(text: result.msg ?? '提交失败');
    }
  }
}
