import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/model/member_model.dart';
import 'package:jygf/domain/remote_domain/domains/aikiss.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/ai_server/widgets/dialog/ai_server_dialog.dart';
import 'package:jygf/ui_layer/screens/common_widgets/dialog/widgets/regular_dialog.dart';
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

class AIKissPage extends StatefulWidget {
  const AIKissPage({super.key});

  @override
  State<AIKissPage> createState() => _AIKissPageState();
}

class _AIKissPageState extends State<AIKissPage> {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final aiDomain = context.read<AIKissDomain>();
  late final userNotifier = context.read<UserNotifier>();
  late int kissCoinsValue = _homeConfig.config.payAiKiss;
  String uploadMaxSize = '2M';

  Map leftUpload = {};
  Map rightUpload = {};

  EdgeInsets paddings = EdgeInsets.symmetric(horizontal: 10.w);
  Future _initData() async {}

  Future<void> _pickImage({required bool isLeft}) async {
    if (await CommonUtils.pickImage() case final xFile?) {
      MyToast.showLoading(text: 'scz'.tr());
      final result = await _homeConfig.uploadImage(xFile);
      if (result != null && result['code'] == 1) {
        final url = "${result['msg']}";
        final image = await decodeImageFromList(await xFile.readAsBytes());
        final obj = {
          'media_url': url,
          'url': _homeConfig.config.imgBase + url,
          'thumb_width': image.width,
          'thumb_height': image.height,
        };
        if (isLeft) {
          leftUpload = obj;
        } else {
          rightUpload = obj;
        }
        if (mounted) setState(() {});
      } else {
        MyToast.showText(text: result?['msg'] ?? 'failed');
      }
      MyToast.closeAllLoading();
    }
  }

  void _onSubmitKiss() async {
    if (leftUpload.isEmpty || rightUpload.isEmpty) {
      CommonUtils.showDialog(
        context: context,
        builder: (context) => RegularDialog(
          buttonText: 'qd'.tr(),
          title: 'wxts'.tr(),
          content:
              Text('qsctp'.tr(context: context), style: MyTheme.white255_15),
          confirmOnTap: () {
            Navigator.pop(context);
          },
        ),
      );
      return;
    }
    Member? user = userNotifier.member;
    final int coins = user.money;

    if (user.aiKissValue <= 0 && kissCoinsValue > coins) {
      AiServerDialog.showBalanceNotEnough(context, coins);
      return;
    }
    MyToast.showLoading();

    final result = await aiDomain.aiKissGenerate(
      firstThumb: leftUpload['media_url'],
      firstThumbW: leftUpload['thumb_width'].toString(),
      firstThumbH: leftUpload['thumb_height'].toString(),
      endThumb: rightUpload['media_url'],
      endThumbW: rightUpload['thumb_width'].toString(),
      endThumbH: rightUpload['thumb_height'].toString(),
    );
    MyToast.closeAllLoading();

    if (result.status == 1) {
      setState(() {
        leftUpload = {};
        rightUpload = {};
      });
      final aiKissValue = user.aiKissValue - 1;
      if (aiKissValue >= 0) {
        userNotifier.setAiKissValue(num: aiKissValue);
      } else {
        userNotifier.setMoney(money: user.money - kissCoinsValue);
      }
      AiServerDialog.showSubmitSuccess(context);
    } else {
      MyToast.showText(text: result.msg ?? '失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
          appBar: MyAppBar(
            title: 'AI接吻',
            rightWidget: TextButton(
              onPressed: () {
                const MineAIRecordRoute(index: 2).push(context);
              },
              child: Center(
                child: Text(
                  'wdai'.tr(),
                  style: MyTheme.white255_13,
                ),
              ),
            ),
          ),
          body: CustomScrollView(slivers: [
            MyIndicator(onRefresh: _initData),
            SliverList.list(children: [
              SizedBox(height: 10.w),
              Padding(
                padding: paddings,
                child: Row(
                  children: [
                    Expanded(child: _buildUploadTile(isLeft: true)),
                    SizedBox(width: 10.w),
                    Expanded(child: _buildUploadTile(isLeft: false)),
                  ],
                ),
              ),
              SizedBox(height: 10.w),
              Center(
                  child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('clyzzpdfy'.tr(context: context), style: MyTheme.white14),
                  Text('$kissCoinsValue', style: MyTheme.blue80_14),
                  Text('jb'.tr(context: context), style: MyTheme.white14),
                  Text('，', style: MyTheme.white14),
                  Selector<UserNotifier, int>(
                      selector: (_, config) => config.member.aiKissValue,
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
                child: GestureDetector(
                  onTap: _onSubmitKiss,
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
                padding: paddings,
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
                padding: paddings,
                child: Row(
                  children: [
                    Text('sl'.tr(context: context), style: MyTheme.white15),
                    const SizedBox.shrink(),
                  ],
                ),
              ),
              SizedBox(height: 10.w),
              Padding(
                  padding: paddings,
                  child: const PictureCard(
                      thumb: MyImagePaths.appKissAfter, text: '生成后'))
            ])
          ])),
    );
  }

  Widget _buildUploadTile({required bool isLeft}) {
    final data = isLeft ? leftUpload : rightUpload;
    return GestureDetector(
      onTap: () => _pickImage(isLeft: isLeft),
      child: Container(
        height: 250.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6.w)),
          color: const Color(0xff1b1c2b),
        ),
        child: data.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(Icons.add, color: const Color(0xff9f9f9f), size: 26.w),
                  Text('djscrwxx'.tr(context: context), style: MyTheme.white13),
                  Text('tpdxbcg'.tr(context: context) + uploadMaxSize,
                      style: TextStyle(
                          fontSize: 10.sp, color: const Color(0xff9f9f9f))),
                ],
              )
            : Stack(
                children: [
                  MyImage.network(
                    data['url'],
                    fit: BoxFit.fitHeight,
                    borderRadius: 6.w,
                    backgroundColor: MyTheme.imageBgColor,
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isLeft) {
                              leftUpload = {};
                            } else {
                              rightUpload = {};
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(5.w),
                          decoration:
                              const BoxDecoration(color: Color(0xFF3094FF)),
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
