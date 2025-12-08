import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
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
        // const _BlurView(),
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
                   ..._buildContentStrings(config.vipNameStr),
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

  List<Widget> _buildContentStrings(String vipNameStr) {
    if (vipNameStr.isEmpty) return [];
    final vipNameList = vipNameStr.split('#');
    if (vipNameList.length < 3) {
      return vipNameList.map((e) => Text(e, style: MyTheme.white14)).toList();
    }
    final normalItems = vipNameList.take(vipNameList.length - 3);
    final specialItems = vipNameList.sublist(vipNameList.length - 3);
    return [
      ...normalItems.map((text) {
      if (text.contains('解锁') ||
            text.contains('严重') ||
            text.contains('仅对')) {
          return Text(text, style: MyTheme.red24015);
        }
        return Text(text, style: MyTheme.white14);
      }),
      _buildSpecialCard(specialItems),
    ];
  }

  Widget _buildSpecialCard(List<String> items) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: Stack(
        children: [
          const Positioned.fill(
            child: MyImage.asset(
              MyImagePaths.appRestrictedContentBg,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
            child: Column(
              children: [
                Text(items[0], style: MyTheme.white14),
                kIsWeb
                    ? Text(items[1],
                        style: TextStyle(
                            fontSize: 16.sp, color: MyTheme.primaryColor))
                    : ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color.fromRGBO(255, 133, 164, 1),
                            Color.fromRGBO(255, 173, 66, 1),
                            Color.fromRGBO(133, 202, 255, 1)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(bounds),
                        blendMode: BlendMode.srcIn,
                        child: Text(
                          items[1],
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.white),
                        ),
                      ),
                Text(items[2], style: MyTheme.white14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}