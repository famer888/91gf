import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/common_widgets/search_app_bar.dart';
import 'package:jygf/ui_layer/screens/live_video/live_nav/broadcastTopNavView.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/theme.dart';

class LiveBroadcastScreen extends StatefulWidget {
  const LiveBroadcastScreen({super.key, this.needNavi = true});
  final bool needNavi;

  @override
  State<LiveBroadcastScreen> createState() => _LiveBroadcastState();
}

class _LiveBroadcastState extends State<LiveBroadcastScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: widget.needNavi ? const MyAppBar(
          title: '直播',
        ) : null,
          body: Padding(
        padding:widget.needNavi ? EdgeInsets.zero : EdgeInsets.only(top: 44.w + MyTheme.statusHeight),
        child: const BroadcastTopNavView(),
      )),
    );
  }
}
