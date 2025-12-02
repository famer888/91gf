import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/ui_layer/screens/common_widgets/event_bus/event_bus.dart';
import 'package:provider/provider.dart';

import '../../../domain/type_def.dart';
import '../../../domain/domain.dart';
import '../../notifiers/user_notifier.dart';
import '../../utils/common_utils.dart';
import '../../utils/my_toast.dart';
import '../common_widgets/dialog/widgets/regular_dialog.dart';
import '../common_widgets/my_app_bar.dart';
import '../common_widgets/my_button.dart';
import '../common_widgets/my_image.dart';
import '../image_paths.dart';
import '../theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  late final _accountDomain = context.read<AccountDomain>();
  late final _userNotifier = context.read<UserNotifier>();

  Future<void> _register() async {
    if (userNameController.text.isEmpty || userNameController.text.length < 6) {
      MyToast.showText(text: tr('srzh'));
      return;
    }
    if (passwordController.text.isEmpty) {
      MyToast.showText(text: tr('srmm'));
      return;
    }

    MyToast.showLoading(text: tr('zzzc'));
    final result = await _accountDomain.loginByReg(
        userName: userNameController.text, password: passwordController.text);
    if (result.status != 0) {
      await _userNotifier.init();
      await _showAlert();
      if (mounted) {
        context.pop();
      }
    }
    MyToast.closeAllLoading();
    MyToast.showText(text: result.msg ?? '');
  }

  Future<void> _login() async {
    if (userNameController.text.isEmpty || userNameController.text.length < 6) {
      MyToast.showText(text: 'srzh'.tr());
      return;
    }
    if (passwordController.text.isEmpty) {
      MyToast.showText(text: 'srmm'.tr());
      return;
    }
    MyToast.showLoading(text: 'zzdl'.tr());
    final result = await _accountDomain.loginByAccount(
      username: userNameController.text,
      password: passwordController.text,
    );
    if (result.status != 0) {
      if (await _userNotifier.init()) {
        eventBus.fire(MyEvent('RefreshVoicePayerUI')); //发通知去刷新ASMR列表数据
        if (mounted) {
          MyToast.showText(text: 'cgdl'.tr());
          context.pop();
          return;
        }
      }
    }
    MyToast.closeAllLoading();
    MyToast.showText(text: result.msg ?? '');
  }

  Future<void> _showAlert() async => await CommonUtils.showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => RegularDialog(
          title: 'ts'.tr(context: context),
          buttonText: 'fzzhqbc'.tr(context: context),
          content: Column(
            children: [
              Text(
                'fzzhqbctx'.tr(context: context),
                style: MyTheme.white255_13,
                overflow: TextOverflow.clip,
                maxLines: 100,
              ),
              SizedBox(
                height: 15.w,
              ),
              Text(
                'fzzhqbcqw'.tr(context: context),
                style: MyTheme.red13,
                overflow: TextOverflow.clip,
                maxLines: 100,
              ),
            ],
          ),
          confirmOnTap: () async {
            CommonUtils.copyToClipboard(
                text:
                    '回家地址：${_userNotifier.member.share?.affUrlCopy?.url} 帐号：${userNameController.text} 密码：${passwordController.text}');
            if (context.mounted) {
              MyToast.showText(text: 'zccgdl'.tr(context: context));
              context.pop();
            }
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const MyAppBar(),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: MyImage.asset(
                MyImagePaths.appLoginBackground,
                fit: BoxFit.fill,
              ),
            ),
            SafeArea(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                children: [
                  SizedBox(
                    height: 40.w,
                  ),
                  Container(
                    width: 325.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.w),
                      color: Colors.transparent,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'yhldcm'.tr(context: context),
                          style: TextStyle(
                            color: const Color.fromRGBO(255, 255, 255, 1),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20.w),
                        MyImage.asset(
                          MyImagePaths.appLogoIcon,
                          width: 63.w,
                        ),
                        SizedBox(height: 38.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _LoginInputBox(
                              controller: userNameController,
                              hintText: 'qsrzh'.tr(context: context),
                            ),
                            SizedBox(height: 33.w),
                            _LoginInputBox(
                              controller: passwordController,
                              hintText: 'qsrmm'.tr(context: context),
                              isPassword: true,
                            ),
                          ],
                        ),
                        SizedBox(height: 55.w),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyButton.gradient(
                              minimumSize: Size(140.w, 40.w),
                              onPressed: () async {
                                _register();
                              },
                              borderRadius: 8,
                              text: 'zc'.tr(context: context),
                            ),
                            MyButton.gradient(
                              minimumSize: Size(140.w, 40.w),
                              onPressed: () async {
                                _login();
                              },
                              borderRadius: 8,
                              text: 'dl'.tr(context: context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 26.5.w),
                        Text(
                          'ts'.tr(context: context),
                          style: MyTheme.white255_15,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 20.w),
                        Text(
                          "1.${'zhty'.tr(context: context)}\n2.${'zhte'.tr(context: context)}\n3.${'zhts'.tr(context: context)}",
                          style: MyTheme.white12,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginInputBox extends StatelessWidget {
  const _LoginInputBox({
    required this.hintText,
    this.isPassword = false,
    required this.controller,
  });
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      height: 50.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.all(
          Radius.circular(5.w),
        ),
      ),
      child: TextField(
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]|[0-9]')),
          LengthLimitingTextInputFormatter(20)
        ],
        controller: controller,
        obscureText: isPassword,
        style: MyTheme.white255_14,
        cursorColor: MyTheme.cyanColor00edfd,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: MyTheme.gray180_14,
        ),
      ),
    );
  }
}
