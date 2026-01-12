import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../notifiers/home_config_notifier.dart';

import '../../common_widgets/keep_alive_wrapper.dart';
import '../../common_widgets/my_image.dart';
import '../../common_widgets/my_tab_bar.dart';
import '../../common_widgets/screen_background.dart';
import '../../image_paths.dart';
import '../../theme.dart';
import 'widgets/agent_view.dart';
import 'widgets/app_center_view.dart';
import 'widgets/tasks_view.dart';

class MineWelfareScreen extends StatefulWidget {
  const MineWelfareScreen({super.key, required this.index});
  final int index;
  @override
  State<MineWelfareScreen> createState() => _MineWelfareScreenState();
}

class _MineWelfareScreenState extends State<MineWelfareScreen> {
  late final config = context.read<HomeConfigNotifier>().config;
  
  List<String> get titles =>
      config.showApp == 1 ? ['dlzq', 'flrw', 'yytj'] : ['dlzq', 'flrw'];
  
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Positioned.fill(
                child: TabBarWithView.line(
                  indicatorType: IndicatorType.light,
                  isCenter: true,
                  titles: titles.map((title) => title.tr(context: context)).toList(),
                  views: [
                    const KeepAliveWrapper(child: AgentView()),
                    const KeepAliveWrapper(child: TaskView(needNavi: false)),
                    if (config.showApp == 1) const KeepAliveWrapper(child: AppCenterView()),
                  ],
                  initialIndex: widget.index,
                  labelStyle: MyTheme.white15.copyWith(color: MyTheme.yellow255123Color),
                  unselectedLabelStyle: TextStyle(
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 15.sp,
                    overflow: TextOverflow.visible,
                    decoration: TextDecoration.none,
                  ),
                  // tabBarHeight: 41.w,
                  isScrollable: false,
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: MyImage.asset(
                      MyImagePaths.appBackIcon,
                      width: 20.w,
                      height: 20.w,
                    ),
                  ),
                  onTap: () {
                    context.pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
