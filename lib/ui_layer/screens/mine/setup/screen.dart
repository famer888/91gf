import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/ui_layer/screens/asmr/voice_player/voice_player_manager.dart';
import 'package:jygf/ui_layer/screens/common_widgets/event_bus/event_bus.dart';
import 'package:provider/provider.dart';

import '../../../../domain/api_validator.dart';
import '../../../../domain/domain.dart';
import '../../../../domain/enum.dart';
import '../../../../domain/model/member_model.dart';
import '../../../../domain/type_def.dart';
import '../../../notifiers/home_config_notifier.dart';
import '../../../notifiers/user_notifier.dart';
import '../../../router/routes.dart';
import '../../../utils/common_utils.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/dialog/widgets/regular_dialog.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/my_avatar.dart';
import '../../common_widgets/my_image.dart';
import '../../common_widgets/screen_background.dart';
import '../../image_paths.dart';
import '../../theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class MineSetupScreen extends StatefulWidget {
  const MineSetupScreen({super.key});

  @override
  State<MineSetupScreen> createState() => _MineSetupScreenState();
}

class _MineSetupScreenState extends State<MineSetupScreen> {
  late final cache = context.read<CacheDomain>();
  late final userDomain = context.read<UserDomain>();
  late final userNotifier = context.read<UserNotifier>();
  late final homeConfigNotifier = context.read<HomeConfigNotifier>();

  void _editNickName({required vipLevel}) {
    if (vipLevel < 1) {
      CommonUtils.showDialog(
        context: context,
        builder: (context) => RegularDialog(
          buttonText: 'ljkt'.tr(),
          title: 'ts'.tr(),
          content: Text(
            'khygm'.tr(),
            style: MyTheme.gray203_13,
          ),
          confirmOnTap: () {
            context.pop();
            const VipCenterRoute().push(context);
          },
        ),
      );
    } else {
      MineFillCodeRoute('${'txi'.tr()}${'nc'.tr()}').push(context);
    }
  }

  Future<void> _bindEmail() async {
    Member user = userNotifier.member;

    if (user.bindEmail == 1) {
      MyToast.showText(text: 'nyjbdyx'.tr());
    } else {
      const MineBindEmailRoute().push(context);
    }
  }

  Future<void> _clearCache() async {
    await userDomain.clearCached();
    if (kIsWeb) {
      PaintingBinding.instance.imageCache.clear();
      MyToast.showText(text: 'qhcg'.tr());
    } else {
      await cache.clearImageCacheIfNeed(force: true);
      MyToast.showText(text: 'qhccq'.tr());
    }
  }

  Future<void> _logOut() async {
    MyToast.showLoading();
    await userDomain.clearCached();
    await userNotifier.logout();
    CommonUtils.logoutStopVoicePlayer();
    MyToast.closeAllLoading();

    if (mounted) {
      context.pop();
    }
  }

  Future<void> showUploadImg({required int vipLevel}) async {
    if (vipLevel < 1) {
      CommonUtils.showDialog(
        context: context,
        builder: (context) => RegularDialog(
          buttonText: 'ljkt'.tr(),
          title: 'ts'.tr(),
          content: Text(
            'khygtx'.tr(),
            style: MyTheme.white255_13,
          ),
          confirmOnTap: () {
            context.pop();
            const VipCenterRoute().push(context);
          },
        ),
      );
    } else if (await CommonUtils.pickImage() case final xFile?) {
      MyToast.showLoading(text: 'scz'.tr());
      final result = await homeConfigNotifier.uploadImage(xFile);
      if (result != null) {
        await updateUserInfo(data: result);
      }
      MyToast.closeAllLoading();
    }
  }

  Future<void> updateUserInfo({required Json data}) async {
    if (data['code'] == 1) {
      final imgUrl = data['msg'].toString();
      final result = await userDomain.updateUserInfo(thumb: imgUrl);
      if (result.isValid) {
        // userNotifier.setThumb(
        //   thumb: homeConfigNotifier.config.imgBase + imgUrl,
        // );
        MyToast.showText(
            text: (result.msg ?? '').isNotEmpty
                ? result.msg.toString()
                : result.data.toString());
      } else {
        MyToast.showText(text: result.msg!);
      }
    } else {
      MyToast.showText(text: data['msg'] ?? 'failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final version = context.read<AppDomain>().info["version"].toString();
    return ScreenBackground(
        child: Scaffold(
            appBar: MyAppBar(
              title: 'bjzl'.tr(context: context),
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 30.w,
                ),
                Selector<UserNotifier, Member>(
                    selector: (_, userNotifier) => userNotifier.member,
                    builder: (context, member, child) {
                      return ReportGestureDetector(
                        onTap: () => showUploadImg(vipLevel: member.vipLevel),
                        child: Column(
                          children: [
                            MyAvatar(
                              thumb: member.thumb,
                              size: 90.w,
                            ),
                            SizedBox(height: 10.w),
                            Text(
                              'xgtx'.tr(context: context),
                              style: MyTheme.gray187_15_M,
                            ),
                          ],
                        ),
                      );
                    }),
                SizedBox(
                  height: 30.w,
                ),
                Expanded(
                    child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                  child: Column(
                    children: [
                      Selector<UserNotifier, Member>(
                          selector: (_, userNotifier) => userNotifier.member,
                          builder: (context, member, child) {
                            return SetupItem(
                              iconName: MyImagePaths.appSettingNickname,
                              title: 'nc'.tr(context: context),
                              subTitle: member.nickname,
                              onTap: () =>
                                  _editNickName(vipLevel: member.vipLevel),
                            );
                          }),
                      const SetupItemDivider(),
                      SetupItem(
                          iconName: MyImagePaths.appSettingMail,
                          title: 'bdyx'.tr(context: context),
                          onTap: _bindEmail),
                      const SetupItemDivider(),
                      SetupItem(
                          iconName: MyImagePaths.appSettingClearcache,
                          title: 'qchc'.tr(context: context),
                          onTap: _clearCache),
                      const SetupItemDivider(),
                      SetupItem(
                        iconName: MyImagePaths.appSettingUpdate,
                        title: 'bbgx'.tr(context: context),
                        subTitle: version,
                      ),
                      const SetupItemDivider(),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )),
                Selector<UserNotifier, bool>(
                  selector: (_, userNotifier) =>
                      userNotifier.tokenStatus == MyTokenStatus.valid,
                  builder: (context, isLogin, child) => isLogin
                      ? Padding(
                          padding: EdgeInsets.only(
                            left: MyTheme.pagePadding,
                            right: MyTheme.pagePadding,
                            bottom: MyTheme.pagePadding,
                          ),
                          child: ReportGestureDetector(
                            onTap: _logOut,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: MyTheme.gradient_90_114,
                                borderRadius: BorderRadius.all(Radius.circular(20.w)),
                              ),
                              child: SafeArea(
                                child: Container(
                                  height: 40.w,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'tcdl'.tr(context: context),
                                    style: MyTheme.white255_18_B,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            )));
  }
}

class SetupItemDivider extends StatelessWidget {
  const SetupItemDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1.w,
      thickness: 0.5.w,
      color: const Color.fromRGBO(31, 31, 31, 1),
    );
  }
}

class SetupItem extends StatelessWidget {
  const SetupItem({super.key, this.onTap, required this.title, this.subTitle, required this.iconName});
  final String iconName;
  final VoidCallback? onTap;
  final String title;
  final String? subTitle;
  @override
  Widget build(BuildContext context) {
    return ReportGestureDetector(
      onTap: () => onTap?.call(),
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 18.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyImage.asset(
              iconName,
              width: 25.w,
              height: 25.w,
            ),
            Text(
              title,
              style: MyTheme.black64_15_M,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  subTitle != null
                      ? SizedBox(
                          child: Text(
                            subTitle!,
                            style: MyTheme.gray180_14_line,
                            textAlign: TextAlign.right,
                          ),
                        )
                      : const SizedBox.shrink(),
                  SizedBox(
                    width: 3.5.w,
                  ),
                  MyImage.asset(
                    MyImagePaths.appMineRightArrow,
                    width: 25.w,
                    height: 25.w,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
