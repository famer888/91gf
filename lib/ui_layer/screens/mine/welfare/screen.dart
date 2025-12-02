import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../notifiers/home_config_notifier.dart';

import '../../common_widgets/keep_alive_wrapper.dart';
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

class _MineWelfareScreenState extends State<MineWelfareScreen>
    with TickerProviderStateMixin {
  late final config = context.read<HomeConfigNotifier>().config;
  late final titles =
      config.showApp == 1 ? ['dlzq', 'flrw', 'yytj'] : ['dlzq', 'flrw'];
  late final tabController = TabController(
      length: titles.length, vsync: this, initialIndex: widget.index);
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: _AppBar(
          tabController: tabController,
          titles: titles,
        ),
        body: TabBarView(
          controller: tabController,
          children: const [
            KeepAliveWrapper(child: AgentView()),
            KeepAliveWrapper(child: TaskView()),
            KeepAliveWrapper(child: AppCenterView()),
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({required this.tabController, required this.titles});

  final TabController tabController;
  final List<String> titles;

  @override
  final Size preferredSize = const Size.fromHeight(44);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 40.w,
      leading: GestureDetector(
        onTap: () {
          context.pop();
        },
        child: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: Image.asset(
            MyImagePaths.appBackIcon,
            width: 20.w,
            height: 20.w,
          ),
        ),
      ),
      actions: [SizedBox(width: 40.w)],
      backgroundColor: Colors.transparent,
      iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
      title: Theme(
        data: Theme.of(context).copyWith(
            tabBarTheme: TabBarTheme(
          labelStyle: MyTheme.jellyCyan_15,
          labelPadding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
          unselectedLabelStyle: TextStyle(
            color: const Color.fromRGBO(255, 255, 255, 1),
            fontSize: 15.sp,
            overflow: TextOverflow.visible,
            decoration: TextDecoration.none,
          ),
          indicatorSize: TabBarIndicatorSize.label,
          indicator: const LineIndicator(),
          indicatorColor: Colors.transparent,
          overlayColor: WidgetStateProperty.resolveWith<Color>(
            (_) => Colors.transparent,
          ),
          tabAlignment: TabAlignment.start,
          dividerColor: Colors.transparent,
        )),
        child: RepaintBoundary(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
            ),
            child: SizedBox(
              height: 41.w,
              child: TabBar(
                physics: const BouncingScrollPhysics(),
                isScrollable: false,
                padding: EdgeInsets.symmetric(vertical: 2.w),
                controller: tabController,
                tabAlignment: TabAlignment.center,
                tabs: titles
                    .map((title) => Tab(
                          height: MyTheme.navbarHegiht,
                          text: title.tr(context: context),
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
