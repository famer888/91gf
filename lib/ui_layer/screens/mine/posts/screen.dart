import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:provider/provider.dart';

import '../../../../domain/model/member_model.dart';
import '../../../notifiers/user_notifier.dart';
import '../../../router/routes.dart';
import '../../common_widgets/post/center/post_center.dart';
import '../../common_widgets/screen_background.dart';
import '../../image_paths.dart';
import '../../theme.dart';

class MinePostScreen extends StatefulWidget {
  const MinePostScreen({super.key});

  @override
  State<MinePostScreen> createState() => _MinePostScreenState();
}

class _MinePostScreenState extends State<MinePostScreen> with TickerProviderStateMixin {
  final titles = ['待审核', '审核通过', '拒绝'];
  late final TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: titles.length, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      needBgImg: false,
      child: Scaffold(
        // appBar: MyAppBar(
        //   title: 'fbdtz'.tr(context: context),
        // ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  height: 220.w,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        MyImagePaths.appPostCenterBg,
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 30.w,
                        left: 10.w,
                        child: GestureDetector(
                          child: MyImage.asset(
                            MyImagePaths.appBackIcon,
                            width: 20.w,
                            height: 20.w,
                          ),
                          onTap: () => context.pop(),
                        ),
                      ),
                     const Align(
                        alignment: Alignment.bottomCenter,
                        child:  _Header(),
                      ),
                    ],
                  ),
                ),
              ),
              SliverAppBar(
                pinned: true,
                toolbarHeight: 0,
                collapsedHeight: 0,
                expandedHeight: 0,
                backgroundColor: Colors.transparent,
                elevation: 0,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(48.w),
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                    child: SizedBox(
                      height: 48.w,
                      child: TabBar(
                        controller: tabController,
                        tabAlignment: TabAlignment.fill,
                        indicatorColor: Colors.transparent, 
                        indicator: const BoxDecoration(),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white,
                        labelStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal,
                        ),
                        tabs: titles.asMap().entries.map((e) {
                          final index = e.key;
                          final title = e.value;
                          final isSelected = tabController.index == index;
                          return Tab(
                            height: 28.w,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              decoration: BoxDecoration(
                                gradient: isSelected ? MyTheme.gradient_90_114 : MyTheme.gradient_90_114_15,
                                borderRadius: BorderRadius.circular(4.w),
                              ),
                              alignment: Alignment.center,
                              child: Text(title),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(controller: tabController, children: [
            const PostCenter(),
            const PostCenter(),
            const PostCenter(),
          ]),
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
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            MyImagePaths.appAgentUserbg,
          ),
          fit: BoxFit.fill,
        ),
      ),
      width: double.infinity,
      height: 72.w,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.5.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ktxsy'.tr(context: context),
                    style: MyTheme.white12,
                  ),
                  Text(
                    '${member.incomeMoney}${'jb'.tr(context: context)}',
                    style: TextStyle(
                      fontSize: 22.sp,
                      // fontWeight: FontWeight.bold,
                      color: MyTheme.goldColor255_211_123,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      const MineWithdrawalRoute(false).push(context);
                    },
                    child: Container(
                      width: 100.w,
                      height: 30.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(15.w),
                        gradient: MyTheme.gradient_90_118,
                      ),
                      child: Text(
                        'ljtx'.tr(context: context),
                        style: MyTheme.white15_M,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      const MineIncomeDetailRoute().push(context);
                    },
                    child: Container(
                      width: 100.w,
                      height: 30.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(15.w),
                        gradient: MyTheme.gradient_90_114,
                      ),
                      child: Text(
                        'symx'.tr(context: context),
                        style: MyTheme.white15_M,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
