import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/async_value.dart';
import 'package:jygf/domain/model/post/circle/circle_post_nav_model.dart';
import 'package:jygf/domain/remote_domain/domains/community.dart';
import 'package:jygf/domain/type_def.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/notifiers/user_notifier.dart';
import 'package:jygf/ui_layer/router/router.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/gradient_border.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/network_error.dart';
import 'package:jygf/ui_layer/screens/circle/circle_content.dart';
import 'package:jygf/ui_layer/screens/community/issue/screen.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:provider/provider.dart';
//约炮
class CircleCommunityScreen extends StatefulWidget {
  const CircleCommunityScreen({super.key});

  @override
  State<CircleCommunityScreen> createState() => _CircleCommunityScreenState();
}

class _CircleCommunityScreenState extends State<CircleCommunityScreen> {

  Future<void> _showIssueSheet(BuildContext context) {


    final issues = [
      (
        title: 'tp'.tr(context: context),
        iconName: MyImagePaths.appFabuPicture,
        type: CommunityIssueType.image,
      ),
      (
        title: 'sping'.tr(context: context),
        iconName: MyImagePaths.appFabuVideo,
        type: CommunityIssueType.video,
      ),
      (
        title: 'twen'.tr(context: context),
        iconName: MyImagePaths.appFabuText,
        type: CommunityIssueType.imageAndText,
      ),
    ];
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      constraints: BoxConstraints(maxWidth: 1.sw),
      context: AppRouter.rootNavigatorKey.currentContext ?? context,
      builder: (context) => Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              image: const DecorationImage(image: AssetImage(MyImagePaths.appIssueBg), fit: BoxFit.cover),
              border:const Border(top: BorderSide(color: Color.fromRGBO(154, 48, 133, 1), width: 1)),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16.w), topRight: Radius.circular(16.w)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 13.w),
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox.shrink(),
                        Text('xzfblx'.tr(), style: MyTheme.white16bold),
                        InkWell(
                          onTap: () => context.pop(),
                          child: MyImage.asset(MyImagePaths.appIssueClose, width: 14.w, height: 14.w),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (final issue in issues)
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            context.pop();
                            CommunityIssueRoute(type: issue.type, topicType: CommunityIssueTopicType.date).push(context);
                          },
                          child: Column(
                            children: [
                              MyImage.asset(issue.iconName, width: 50.w, height: 52.7.w),
                              SizedBox(height: 4.w),
                              Text(issue.title, style: MyTheme.white255_14)
                            ],
                          ),
                        )
                    ],
                  ),
                  SizedBox(height: 42.5.w)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  ScreenBackground(
      child:  Scaffold(
        appBar:  MyAppBar(
          title: 'yuep'.tr(),
           rightWidget:context.read<UserNotifier>().member.vipLevel.isVip() ? GestureDetector(
          onTap: () {
            _showIssueSheet(context);
          },
          child: GradientBorder(
            gradient: MyTheme.gradient_90_114,
            borderRadius: BorderRadius.circular(4.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.w),
              child: Text('fb'.tr(), style: MyTheme.white10),
            ),
          ),
        ):const SizedBox.shrink(),
        ),
        body:const SafeArea(child: _Body()),
      ),
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
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 9.w, sigmaY: 9.w),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 100.w),
                      const MyImage.asset(MyImagePaths.appCircleBg1, fit: BoxFit.fill),
                      SizedBox(height: 20.w),
                      const MyImage.asset(MyImagePaths.appCircleBg2, fit: BoxFit.fill),
                      SizedBox(height: 20.w),
                      const MyImage.asset(MyImagePaths.appCircleBg3, fit: BoxFit.fill),
                      // SizedBox(
                      //   height: 241.5.w,
                      //   width: 165.w,
                      //   child: MyImage.network(
                      //     config.imgBase + config.vipNameCircleStrImg,
                      //   ),
                      // ),
                      // SizedBox(height: 15.w),
                      // for (final name in config.vipNameAwqStr.split('\n'))
                      //   name.contains('卡') || name.contains('、')
                      //       ? Text(
                      //           name, 
                      //           style: TextStyle(
                      //             color: const Color.fromRGBO(255, 204, 0, 1),
                      //             fontSize: 13.sp,
                      //           ),
                      //         )
                      //       : Text(
                      //           name, 
                      //           style: TextStyle(
                      //             color: MyTheme.white08Color,
                      //             fontSize: 18.sp,
                      //             fontWeight: FontWeight.w500
                      //           ),
                      //           maxLines: 1,
                      //         )
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
