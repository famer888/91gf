import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/async_value.dart';
import 'package:jygf/domain/domain.dart';
import 'package:jygf/domain/model/bit_nav_model.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/acg/animation_video/screen.dart';
import 'package:jygf/ui_layer/screens/acg/comic/comic_content/screen.dart';
import 'package:jygf/ui_layer/screens/acg/novel/screen.dart';
import 'package:jygf/ui_layer/screens/acg/yellow_game/screen.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';

class ACGScreen extends StatefulWidget {
  const ACGScreen({super.key});

  @override
  State<ACGScreen> createState() => _ACGScreenState();
}

class _ACGScreenState extends State<ACGScreen> with TickerProviderStateMixin {
  late final _config = context.read<HomeConfigNotifier>().config;
  AsyncValue<List<BitNavModel>> _asyncValue = const AsyncInit();
  late final TabController? tabController;
  List<BitNavModel> navList = [];

  late final config = context.read<HomeConfigNotifier>().config;
  late final titles = config.acgNav ?? [];

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    navList = _config.acgNav ?? [];

    if (_asyncValue.isLoading) return;
    setState(() {
      _asyncValue = const AsyncLoading();
    });

    tabController = TabController(length: navList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        body: Stack(
          children: [
            TabBarWithView.line(
                labelStyle: MyTheme.white16bold,
                unselectedLabelStyle: MyTheme.white08_15,
                tabBarHeight: MyTheme.navbarHegiht,
                tabBarPadding: EdgeInsets.only(
                    top: MyTheme.statusHeight,
                    left: MyTheme.pagePadding
                ),
                isCenter: true,
                isStack: true,
                titles: titles.map((e) => e.title ?? '').toList(),
                views: titles.map((e) {
                  if (e.type == '1') {
                    return KeepAliveWrapper(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MyTheme.statusHeight + MyTheme.navbarHegiht),
                        child: const AnimationVideo(),
                      ),
                    );
                  } else if (e.type == '2') {
                    return KeepAliveWrapper(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MyTheme.statusHeight + MyTheme.navbarHegiht),
                        child: const ComicScreen(),
                      ),
                    );
                  } else if (e.type == '3') {
                   return KeepAliveWrapper(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MyTheme.statusHeight + MyTheme.navbarHegiht),
                        child: const YellowGameScreen(),
                      ),
                    );
                  } else {
                    return KeepAliveWrapper(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MyTheme.statusHeight + MyTheme.navbarHegiht),
                        child: const NovelScreen(),
                      ),
                    );
                  }
                }).toList()),
            Positioned(
                top: MyTheme.statusHeight,
                right: MyTheme.pagePadding,
                child: GestureDetector(
                  onTap: () {
                    const SearchRoute().push(context);
                  },
                  child: Container(
                    padding: EdgeInsets.only(bottom: 4.w),
                    height: MyTheme.navbarHegiht,
                    child: MyImage.asset(MyImagePaths.appSearchLogo,
                        width: 25.w, height: 25.w),
                  ),
                )),
            Positioned(
              top: MyTheme.statusHeight + MyTheme.navbarHegiht,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                child: const Divider(
                    thickness: 0.5, height: 0.5, color: MyTheme.white02Color),
              ),
            ),
            Positioned(
              left: 13.w,
                top: MyTheme.statusHeight - 1.w,
                child: Image.asset(
              MyImagePaths.appLogoIcon,
              width: 40.w,
              height: MyTheme.navbarHegiht,
              fit: BoxFit.contain,
            )),
          ],
        ),
      ),
    );
  }
}
