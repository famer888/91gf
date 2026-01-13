import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/model/navigator_model.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/rank/content.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:provider/provider.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class RankScreen extends StatefulWidget {
  const RankScreen({super.key});

  @override
  State<RankScreen> createState() => _RankScreenState();
}

class _RankScreenState extends State<RankScreen> with SingleTickerProviderStateMixin {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final List<RankNavigatorModel> _titles = _homeConfig.config.rankTopNav ?? [];
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _titles.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return ScreenBackground(
      needBgImg: false,
      child: SafeArea(
        child: Scaffold(
          // appBar: MyAppBar(title: 'bd'.tr(context: context)),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Stack(children: [
                    MyImage.asset(MyImagePaths.appRankBg,width: 1.sw,fit: BoxFit.fitWidth,), 
                    Positioned(
                      bottom: -1.w,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 15.w,
                        decoration: BoxDecoration(
                          color: MyTheme.bgColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.w),
                            topRight: Radius.circular(40.w),
                          ),
                          border: Border(
                            top: BorderSide(
                              color: const Color.fromRGBO(154, 48, 133, 1),
                              width: 0.5.w,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child:ReportGestureDetector(child: MyImage.asset(MyImagePaths.appNavBackWN,width: 20.w,height: 20.w,fit: BoxFit.contain,),onTap: () {
                      GoRouter.of(context).pop();
                    },)),],)
                ),
              ];
            },
            body: Container(
              color: MyTheme.bgColor,
              child: Column(
                children: [
                  Container(
                    height: 33.w,
                    margin: EdgeInsets.symmetric(vertical: 10.w),
                    child: AnimatedBuilder(
                      animation: _tabController,
                      builder: (context, child) {
                        return Row(
                          children: List.generate(_titles.length, (index) {
                            final isSelected = _tabController.index == index;
                            return Expanded(
                              child: ReportGestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => _tabController.animateTo(index),
                                child: Center(
                                  child: _buildTabWithIndex(index, isSelected),
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: _titles.map((model) {
                        return KeepAliveWrapper(
                          child: RankContentScreen(data: model),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
    Widget _buildTabWithIndex(int index,bool isSelected) {
    switch (index) {
      case 0:
        return MyImage.asset( isSelected ? MyImagePaths.appRankBfbS : MyImagePaths.appRankBfbN,width: 90.w,height: 33.w,fit: BoxFit.contain,);
      case 1:
        return MyImage.asset( isSelected ? MyImagePaths.appRankCxbS : MyImagePaths.appRankCxbN,width: 90.w,height: 33.w,fit: BoxFit.contain,);
      case 2:
        return MyImage.asset( isSelected ? MyImagePaths.appRankScbS : MyImagePaths.appRankScbN,width: 90.w,height: 33.w,fit: BoxFit.contain,);        
      default:
      return Container();
    }
  }
}
