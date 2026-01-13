import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:jygf/domain/model/member_model.dart';
import 'package:jygf/domain/remote_domain/domains/ai.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/ai_server/widgets/dialog/ai_server_dialog.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/notifiers/user_notifier.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class AIOffDeRobe extends StatefulWidget {
  const AIOffDeRobe({super.key});

  @override
  State<AIOffDeRobe> createState() => _AIOffDeRobeState();
}

class _AIOffDeRobeState extends State<AIOffDeRobe> {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final aiDomain = context.read<AIDomain>();
  late final userNotifier = context.read<UserNotifier>();
  late int stripCoinsValue = _homeConfig.config.stripCoins;
  String uploadMaxSize = '2M';
  Map uploadObject = {};
  EdgeInsets piaddings = EdgeInsets.symmetric(horizontal: 10.w);
  Future _initData() async {}

  Future<void> imagePickerAssets() async {
    if (await CommonUtils.pickImage() case final xFile?) {
      MyToast.showLoading(text: 'scz'.tr());
      final result = await _homeConfig.uploadImage(xFile);
      if (result != null && result['code'] == 1) {
        final url = "${result['msg']}";

        final image = await decodeImageFromList(await xFile.readAsBytes());

        uploadObject = {
          'media_url': url,
          'url': _homeConfig.config.imgBase + url,
          'thumb_width': image.width,
          'thumb_height': image.height,
        };

        if (mounted) {
          setState(() {});
        }
      } else {
        MyToast.showText(text: result?['msg'] ?? 'failed');
      }
      MyToast.closeAllLoading();
    }
  }

  void onSubmitOffDerobe() async {
    if (uploadObject.isEmpty) {
      AiServerDialog.showTip(context, 'qsctp'.tr(context: context));
      return;
    }
    MyToast.showLoading();
    Member? user = userNotifier.member;
    final userCoins = user.money; //用户剩余金币

    final result = await aiDomain.strip(
        thumb: uploadObject['media_url'],
        thumbW: uploadObject['thumb_width'],
        thumbH: uploadObject['thumb_height']);
    BotToast.closeAllLoading();
    if (result.status == 1) {
      setState(() {
        uploadObject = {};
      });
      final stripValue = user.stripValue - 1;
      if (stripValue >= 0) {
        //更新用户剩余次数
        userNotifier.setStripValue(num: stripValue);
      } else {
        //免费次数不够直接扣金币，刷新用户金币余额
        userNotifier.setMoney(money: user.money - stripCoinsValue); //更新用户的金币数量
      }
      AiServerDialog.showSubmitSuccess(context);
    } else {
      if (result.msg != '余额不足') {
        MyToast.showText(text: result.msg ?? '提交失败');
        return;
      }
      //余额不足，提示金币不足
      AiServerDialog.showBalanceNotEnough(context, userCoins);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
          appBar: MyAppBar(
            title: 'AI去衣',
            rightWidget: Align(
              alignment: Alignment.centerRight,
              child: ReportGestureDetector(
                onTap: () {
                  const MineAIRecordRoute(index: 1).push(context);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    'wdai'.tr(),
                    style: MyTheme.white255_13.copyWith(height: 1.0),
                  ),
                ),
              ),
            ),
          ),
          body: CustomScrollView(slivers: [
            MyIndicator(onRefresh: _initData),
            SliverList.list(children: [
              SizedBox(height: 10.w),
              Padding(
                padding: piaddings,
                child: ReportGestureDetector(
                  onTap: imagePickerAssets,
                  child: Container(
                    width: double.infinity,
                    height: 140.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6.w)),
                      color: MyTheme.white02Color,
                    ),
                    child: uploadObject.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                             MyImage.asset(
                              MyImagePaths.appAiUploadIcon,
                              width: 50.w,
                              height: 50.w,
                            ),
                              Text('djscrwxx'.tr(context: context),
                                  style: MyTheme.white13),
                              Text('tpdxbcg'.tr(context: context) + uploadMaxSize,
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      color: const Color(0xff9f9f9f))),
                            ],
                          )
                        : Stack(
                            children: [
                              MyImage.network(
                                uploadObject['url'],
                                fit: BoxFit.fitHeight,
                                borderRadius: 6.w,
                                backgroundColor: MyTheme.imageBgColor,
                              ),
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child: ReportGestureDetector(
                                    onTap: () {
                                      setState(() {
                                        uploadObject = {};
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5.w),
                                      decoration: const BoxDecoration(
                                          color: Color(0xFF3094FF)),
                                      child: Center(
                                          child: Icon(
                                        Icons.delete_forever,
                                        size: 20.sp,
                                        color: Colors.white,
                                      )),
                                    ),
                                  ))
                            ],
                          ),
                  ),
                ),
              ),
              SizedBox(height: 10.w),
              Center(
                  child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('clyzzpdfy'.tr(context: context), style: MyTheme.white14),
                  Text('$stripCoinsValue', style: MyTheme.blue80_14),
                  Text('jb'.tr(context: context), style: MyTheme.white14),
                  Text('，', style: MyTheme.white14),
                  Selector<UserNotifier, int>(
                      selector: (_, config) => config.member.stripValue,
                      builder: (context, number, child) {
                        return Row(
                          children: [
                            Text('nymfcs'.tr(context: context),
                                style: MyTheme.white14),
                            Text('$number', style: MyTheme.blue80_14),
                            Text('ci'.tr(context: context),
                                style: MyTheme.white14)
                          ],
                        );
                      })
                ],
              )),
              SizedBox(height: 10.w),
              Center(
                child: ReportGestureDetector(
                  onTap: onSubmitOffDerobe,
                  child: Container(
                    width: 150.w,
                    padding:
                        EdgeInsets.symmetric(vertical: 10.w, horizontal: 3.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(26.w)),
                        gradient: MyTheme.gradient_90_114),
                    child: Center(
                        child: Text(
                      'shengc'.tr(context: context),
                      style: MyTheme.white15bold,
                    )),
                  ),
                ),
              ),
              SizedBox(height: 20.w),
              Padding(
                padding: piaddings,
                child: Column(
                  children: [
                    SizedBox(height: 10.w),
                    TipText(content: 'zyss'.tr(context: context)),
                    TipText(content: 'zyss1'.tr(context: context)),
                    TipText(content: 'zyss2'.tr(context: context)),
                    TipText(content: 'zyss3'.tr(context: context)),
                    TipText(content: 'zyss4'.tr(context: context)),
                    TipText(content: 'zyss5'.tr(context: context)),
                  ],
                ),
              ),
              SizedBox(height: 10.w),
              Padding(
                padding: piaddings,
                child: Row(
                  children: [
                    Text('sl'.tr(context: context), style: MyTheme.white15),
                    const SizedBox.shrink(),
                  ],
                ),
              ),
              SizedBox(height: 10.w),
              Padding(
                  padding: piaddings,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PictureCard(
                          thumb: MyImagePaths.appStritpBefore,
                          text: 'quyq'.tr(context: context)),
                      PictureCard(
                          thumb: MyImagePaths.appStritpAfter,
                          text: 'quyh'.tr(context: context))
                    ],
                  ))
            ])
          ])),
    );
  }
}

class PictureCard extends StatelessWidget {
  const PictureCard({
    super.key,
    required this.thumb,
    required this.text,
  });

  final String thumb;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 172.w,
      child: Stack(
        children: [
          Image.asset(
            thumb,
            width: 172.w,
            height: 230.w,
            fit: BoxFit.contain,
          ),
          Positioned(
              top: 5.w,
              left: 5.w,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 3.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(3.w)),
                    gradient: MyTheme.gradient_90_114),
                child: Text(text, style: MyTheme.white12),
              ))
        ],
      ),
    );
  }
}

class TipText extends StatelessWidget {
  const TipText({super.key, required this.content});
  final String content;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(content, style: MyTheme.white11),
        const SizedBox.shrink(),
      ],
    );
  }
}
