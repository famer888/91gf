import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/model/bit_nav_model.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/yellow_picture/yellow_picture_conten/picture_content.dart';
import 'package:jygf/ui_layer/screens/yellow_picture/yellow_picture_conten/picture_rec_content.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/theme.dart';

class YellowPictureScreen extends StatefulWidget {
  const YellowPictureScreen({super.key});

  @override
  State<YellowPictureScreen> createState() => _YellowPictureScreenState();
}

class _YellowPictureScreenState extends State<YellowPictureScreen> {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final List<BitNavModel> titles = _homeConfig.config.albumNav ?? [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: cofigContentView());
  }

  Widget cofigContentView() {
    return TabBarWithView.fillColor(
        tabBarHeight: 32.w,
        labelStyle: MyTheme.white15_M,
        tabBarPadding: EdgeInsets.symmetric(vertical: 5.w),
        unselectedLabelStyle: MyTheme.white08_15,
        titles: titles.map((e) => e.name ?? '').toList(),
        views: titles.map((e) {
          if (e.type == '2') {
            //推荐
            return KeepAliveWrapper(
              child: PictureRecContent(id: e.id ?? 0),
            );
          } else {
            return KeepAliveWrapper(
              child: PictureContent(id: e.id ?? 0),
            );
          }
        }).toList());
  }
}
