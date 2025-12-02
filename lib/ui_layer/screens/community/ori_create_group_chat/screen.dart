import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/async_value.dart';
import 'package:jygf/domain/model/navigator_model.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/network_error.dart';
import 'package:jygf/ui_layer/screens/community/ori_create_group_chat/group_chat/group_chat_list_content.dart';
import 'package:jygf/ui_layer/screens/community/ori_create_group_chat/group_plaza/group_plaza_content.dart';
import 'package:jygf/ui_layer/screens/community/ori_create_group_chat/my_joined/my_joined_group_content.dart';
import 'package:jygf/ui_layer/screens/community/original_screen/original_screen.dart';
import 'package:jygf/ui_layer/screens/live_video/live_nav/broadcastTopNavView.dart';
import 'package:flutter/material.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/common_widgets/search_app_bar.dart';
import 'package:jygf/ui_layer/screens/live_video/live_nav/broadcastTopNavView.dart';
import 'package:jygf/ui_layer/screens/live_video/live_nav/screen.dart';
import 'package:jygf/ui_layer/screens/live_video/live_sub_screen/screen.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/screens/vlog/discover_screen.dart';
import 'package:jygf/ui_layer/screens/vlog/vlog_focus_page.dart';
import 'package:jygf/ui_layer/screens/vlog/vlog_play_screen.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:provider/provider.dart';

class OriginAndGroupChatScreen extends StatefulWidget {
  const OriginAndGroupChatScreen({super.key});

  @override
  State<OriginAndGroupChatScreen> createState() =>
      _OriginAndGroupChatScreenState();
}

class _OriginAndGroupChatScreenState extends State<OriginAndGroupChatScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: SearchAppBar(),
      body: Stack(
        children: [
          TabBarWithView.line(
              labelPadding: 20.w,
              // tabBarPadding: EdgeInsets.only(top: MyTheme.statusHeight

              //     // MyTheme.navbarHegiht,
              //     ),
              titles: [
                "qgc".tr(),
                "wjrd".tr(),
              ],
              views: const [
                KeepAliveWrapper(
                  child: GroupPlazaContent(),
                ),
                KeepAliveWrapper(child: MyJoinedGroupContent()),
              ]),
        ],
      ),
    );
  }
}
