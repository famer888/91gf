import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../domain/model/member_model.dart';
import '../../../notifiers/user_notifier.dart';
import '../../../router/routes.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/post/center/post_center.dart';
import '../../common_widgets/screen_background.dart';
import '../../theme.dart';

class MinePostScreen extends StatefulWidget {
  const MinePostScreen({super.key});

  @override
  State<MinePostScreen> createState() => _MinePostScreenState();
}

class _MinePostScreenState extends State<MinePostScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: 'fbdtz'.tr(context: context),
        ),
        body: Column(
          children: [
            SizedBox(height: 20.w),
            const _Header(),
            SizedBox(height: 10.w),
            const Expanded(child: PostCenter()),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final member =
        context.select<UserNotifier, Member>((notifier) => notifier.member);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      height: 100.w,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.all(Radius.circular(8.w))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              '${'ktxsy'.tr(context: context)}：${member.incomeMoney}${'jb'.tr(context: context)}',
              style: MyTheme.white15),
          SizedBox(height: 10.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  const MineWithdrawalRoute(false).push(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 100.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    gradient: MyTheme.gradient_90_114,
                    borderRadius: BorderRadius.circular(15.w),
                  ),
                  child: Text(
                    'ljtx'.tr(context: context),
                    style: MyTheme.white14,
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  const MineIncomeDetailRoute().push(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 100.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    gradient: MyTheme.gradient_90_114,
                    borderRadius: BorderRadius.circular(15.w),
                  ),
                  child: Text(
                    'symx'.tr(context: context),
                    style: MyTheme.white14,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
