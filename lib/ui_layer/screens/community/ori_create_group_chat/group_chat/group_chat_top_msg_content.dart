import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/model/soul_group_model.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/theme.dart';

class GroupChatTopMsgContent extends StatefulWidget {
  const GroupChatTopMsgContent({super.key, required this.data});

  final GroupsMessageModel data; //置顶消息

  @override
  State<GroupChatTopMsgContent> createState() => _GroupChatTopMsgContentState();
}

class _GroupChatTopMsgContentState extends State<GroupChatTopMsgContent> {
  late final config = context.read<HomeConfigNotifier>().config;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: tr('zdxx'),
        ),
        body: Container(
            padding: EdgeInsets.all(MyTheme.pagePadding),
            child: widget.data.type == 1
                ? Text(widget.data.msg ?? '', style: MyTheme.white07_14)
                : MyImage.network(widget.data.msg ?? '', fit: BoxFit.contain,)),
      ),
    );
  }
}
