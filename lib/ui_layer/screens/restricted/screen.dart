import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../notifiers/user_notifier.dart';
import '../../notifiers/home_config_notifier.dart';
import '../../router/routes.dart';
import '../common_widgets/screen_background.dart';
import '../common_widgets/top_navi_view.dart';
import '../common_widgets/search_app_bar.dart';
import '../theme.dart';

class RestrictedScreen extends StatefulWidget {
  const RestrictedScreen({super.key});

  @override
  State<RestrictedScreen> createState() => _RestrictedScreenState();
}

class _RestrictedScreenState extends State<RestrictedScreen> {
  late final homeConfigNotifier = context.read<HomeConfigNotifier>();
  late final id = homeConfigNotifier.config.awNavid;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ScreenBackground(
          child: Scaffold(
            appBar: const SearchAppBar(),
            body: TopNaviView(id: id),
          ),
        ),
        const _BlurView(),
      ],
    );
  }
}

class _BlurView extends StatelessWidget {
  const _BlurView();

  @override
  Widget build(BuildContext context) {
    return Selector<UserNotifier, String>(
      selector: (_, userNotifier) => userNotifier.member.vipStr,
      builder: (context, vipStr, child) {
        final config = context.read<HomeConfigNotifier>().config;
        if (config.vipLevelStr.contains(vipStr)) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            const VipCenterRoute().push(context);
          },
          child: ColoredBox(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12.w, sigmaY: 12.w),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (final name in config.vipNameStr.split('#'))
                        name.contains('卡')
                            ? Text(name, style: MyTheme.blue80_15)
                            : Text(name, style: MyTheme.white15)
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
