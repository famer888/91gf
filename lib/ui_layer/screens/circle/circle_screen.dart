import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/async_value.dart';
import 'package:jygf/domain/model/post/circle/circle_post_nav_model.dart';
import 'package:jygf/domain/remote_domain/domains/community.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/notifiers/user_notifier.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/network_error.dart';
import 'package:jygf/ui_layer/screens/circle/circle_content.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:provider/provider.dart';

class CircleCommunityScreen extends StatefulWidget {
  const CircleCommunityScreen({super.key});

  @override
  State<CircleCommunityScreen> createState() => _CircleCommunityScreenState();
}

class _CircleCommunityScreenState extends State<CircleCommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: _Body()),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  late final _appDomain = context.read<CommunityDomain>();
  AsyncValue<List<CirclePostNavModel>> _asyncValue = const AsyncInit();

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    if (_asyncValue.isLoading) return;
    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final result = await _appDomain.reqGetCircleNav();

    setState(() {
      if (result.data case final data? when result.isValid) {
        _asyncValue = AsyncData(data);
      }
      else {
        _asyncValue = const AsyncError();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _asyncValue.maybeWhen(
      data: (data) {
        if (data.length == 1) {
          // if (data.first.mask == 1) {
            return Stack(fit: StackFit.expand, children: [
              CircleCommunityContentView(id: data.first.id),
              const _BlurView(),
            ]);
          // }
          // return CircleCommunityContentView(id: data.first.id);
        }
        else {
          return TabBarWithView.line(
            tabBarPadding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
            labelPadding: 15.w,
            titles: data.map((e) => e.name).toList(),
            views: data.map((e) {
              // if (e.mask == 1) {
                return Stack(fit: StackFit.expand, children: [
                  CircleCommunityContentView(id: e.id),
                  const _BlurView(),
                ]);
              // }
              // return CircleCommunityContentView(id: e.id);
            }).toList(),
          );
        }
      },
      error: (_, __) => NetworkErrorView(onTap: _init),
      orElse: () => const LoadingView(),
    );
  }
}

class _BlurView extends StatelessWidget {
  const _BlurView();

  @override
  Widget build(BuildContext context) {
    return Selector<UserNotifier, (int, int)>(
      selector: (_, userNotifier) => (userNotifier.member.circlePrivilege, userNotifier.member.agent ?? 0),
      builder: (context, values, child) {
        final config = context.read<HomeConfigNotifier>().config;

        if (values.$1 == 1 || values.$2 == 1) {
          // 改判断遮罩逻辑
          return const SizedBox.shrink();
        }

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            const VipCenterRoute().push(context);
          },
          child: ColoredBox(
            color: Colors.black.withOpacity(0.85),
            child: Center(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 9.w, sigmaY: 9.w),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 241.5.w,
                        width: 165.w,
                        child: MyImage.network(
                          config.imgBase + config.vipNameCircleStrImg,
                        ),
                      ),
                      SizedBox(height: 15.w),
                      for (final name in config.vipNameAwqStr.split('\n'))
                        name.contains('卡') || name.contains('、')
                            ? Text(
                                name, 
                                style: TextStyle(
                                  color: const Color.fromRGBO(255, 204, 0, 1),
                                  fontSize: 13.sp,
                                ),
                              )
                            : Text(
                                name, 
                                style: TextStyle(
                                  color: MyTheme.white08Color,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500
                                ),
                                maxLines: 1,
                              )
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
