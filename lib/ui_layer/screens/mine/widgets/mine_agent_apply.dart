import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/remote_domain/domains/proxy.dart';
import 'package:jygf/ui_layer/notifiers/user_notifier.dart';
import 'package:provider/provider.dart';

import '../../../notifiers/home_config_notifier.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/dialog/my_dialog.dart';
import '../../common_widgets/dialog/widgets/regular_dialog.dart';
import '../../common_widgets/my_image.dart';
import '../../image_paths.dart';
import '../../theme.dart';

class MineAgentApplyView extends StatefulWidget {
  const MineAgentApplyView({super.key, this.applySuccess});
  final VoidCallback? applySuccess;

  @override
  State<MineAgentApplyView> createState() => _MineAgentApplyViewState();
}

class _MineAgentApplyViewState extends State<MineAgentApplyView> {
  final _controller = TextEditingController();
  late final config = context.read<HomeConfigNotifier>();
  late final domain = context.read<ProxyDomain>();

  _applyAgent() async {
    String contact = _controller.text;
    if (contact.isEmpty) {
      MyToast.showText(text: 'srnr'.tr(context: context));
      return;
    }

    MyToast.showLoading();

    ///代理 申请代理
    final res = await domain.proxyApply(contact: contact);
    MyToast.closeAllLoading();
    if (res.isValid) {
      MyToast.showText(text: res.msg ?? '');
      await context.read<UserNotifier>().init();
      widget.applySuccess?.call();
      context.pop();
    } else {
      MyToast.showText(
          text: res.msg ?? '',
          onClose: () {
            Future.delayed(const Duration(milliseconds: 100), () {
              context.pop();
            });
          });
    }
  }

  _askApplyAgent() {
    final text = _controller.text;
    if (text.isEmpty) {
      MyToast.showText(text: 'srnr'.tr(context: context));
      return;
    }

    MyDialog.showDialog(
        context: context,
        child: RegularDialog(
          title: 'ts'.tr(context: context),
          buttonText: 'qd'.tr(context: context),
          confirmOnTap: _applyAgent,
          cancelText: 'qx'.tr(context: context),
          content: Text(
            'sqdlm'.tr(context: context),
            style: MyTheme.white13,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: Column(
          children: [
            SizedBox(height: 10.w),
            ClipRRect(
              borderRadius: BorderRadius.circular(5.w),
              child: const MyImage.asset(MyImagePaths.appDlsq),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 20.w),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'yy'.tr(context: context),
                      style: MyTheme.white255_14,
                    ),
                    TextSpan(
                      text: config.config.proxyJoinNum ?? '',
                      style: MyTheme.hexfbe099_13_M,
                    ),
                    TextSpan(
                      text: 're'.tr(context: context),
                      style: MyTheme.white255_14,
                    ),
                    TextSpan(
                      text: 'sqcw'.tr(context: context),
                      style: MyTheme.white255_14,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.w),
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'sqcw'.tr(context: context),
                      style: MyTheme.white255_20_M,
                    ),
                  ),
                  SizedBox(
                    height: 32.w,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 38.w),
                    height: 38.5.w,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(66, 163, 162, 162),
                            width: 0.5),
                        borderRadius: BorderRadius.circular(5.w)),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: _controller,
                      textAlign: TextAlign.center,
                      style: MyTheme.white255_14,
                      cursorColor: MyTheme.cyanColor00edfd,
                      decoration: InputDecoration(
                        hintText: 'txlx'.tr(context: context),
                        hintStyle: MyTheme.gray123_14,
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 38.5.w,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: _askApplyAgent,
                      child: Container(
                        alignment: Alignment.center,
                        width: 264.w,
                        height: 38.w,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Color(0xfffaddbd), Color(0xfff2c380)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter),
                          borderRadius: BorderRadius.circular(19.w),
                        ),
                        child: Text(
                          'tj'.tr(context: context),
                          style: MyTheme.hexaa5000_18_S,
                        ),
                      ),
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
