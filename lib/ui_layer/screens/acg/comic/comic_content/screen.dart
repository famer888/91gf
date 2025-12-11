import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/model/bit_nav_model.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/acg/comic/comic_content/comic_content.dart';
import 'package:jygf/ui_layer/screens/acg/comic/comic_content/comic_rec_content.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
class ComicScreen extends StatefulWidget {
  const ComicScreen({super.key});

  @override
  State<ComicScreen> createState() => _ComicScreenState();
}

class _ComicScreenState extends State<ComicScreen> {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final List<BitNavModel> titles = _homeConfig.config.comicTopNav ?? [];

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
    return TabBarWithView.line(
        tabBarHeight: 32.w,
        tabBarPadding: EdgeInsets.symmetric(vertical: 5.w),
        titles: titles.map((e) => e.name ?? '').toList(),
        views: titles.map((e) {
          if (e.type == 2) {
            //推荐
            return KeepAliveWrapper(
              child: ComicRecContent(id: e.id ?? 0),
            );
          } else {
            return KeepAliveWrapper(
              child: ComicContent(id: e.id ?? 0),
            );
          }
        }).toList());
  }
}
