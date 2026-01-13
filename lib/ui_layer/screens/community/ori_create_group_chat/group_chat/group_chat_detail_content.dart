import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/ui_layer/screens/community/ori_create_group_chat/group_chat/card/soul_member_card.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/domain.dart';
import 'package:jygf/domain/model/user_model.dart';
import 'package:jygf/domain/type_def.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/event_bus/event_bus.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class GroupChatDetailContent extends StatefulWidget {
  const GroupChatDetailContent({super.key, required this.id, required this.ms});

  final int id;
  final int ms;

  @override
  State<GroupChatDetailContent> createState() => _GroupChatDetailContentState();
}

class _GroupChatDetailContentState extends State<GroupChatDetailContent> {
  late final config = context.read<HomeConfigNotifier>().config;
  late final _appDomain = context.read<AppDomain>();
  List<UserModel> members = [];
  bool isSetTop = false;
  bool isLoding = true;

  @override
  void initState() {
    super.initState();
    _getMembers();
  }

  Future<void> _getMembers() async {
    final param = Map.from({})
      ..['id'] = widget.id
      ..['page'] = 1
      ..['limit'] = 15;

    final result = await _appDomain.getConstructByApiLink(
      apiLink: 'chatgroup/group_detail',
      params: param,
    );

    isLoding = false;

    if (result.status == 1) {
      isSetTop = result.data['set_top'] == 1;
      members = result.data['members']
              ?.map<UserModel>((x) => UserModel.fromJson(x))
              .toList() ??
          [];
    } else {
      MyToast.showText(text: result.msg ?? '');
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(title: tr('ltxq')),
        body: isLoding
            ? const LoadingView()
            : ListView(
                padding: EdgeInsets.all(MyTheme.pagePadding),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: members.length,
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          childAspectRatio: 1 / 1.3,
                          crossAxisSpacing: 10.w,
                          mainAxisSpacing: 10.w),
                      itemBuilder: (context, index) {
                        final partsItem = members[index];
                        return SoulMemberCard(data: partsItem);
                      }),
                  members.length >= 15
                      ? ReportGestureDetector(
                          onTap: () {
                            //查看更多成员
                            GroupMembersContentRoute(id: widget.id)
                                .push(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 13.w),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(tr('ckgdcy'), style: MyTheme.white14),
                                SizedBox(width: 3.w),
                                MyImage.asset(
                                    MyImagePaths.appOriginalArrowRight,
                                    width: 7.w,
                                    height: 12.w)
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  Container(
                    padding: EdgeInsets.only(left: 5.w, top: 13.w, bottom: 0.w),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(tr('zdxx'), style: MyTheme.white14),
                        Transform.scale(
                          scale: 0.8, // 调整开关的尺寸
                          child: Switch(
                            value: isSetTop,
                            onChanged: (value) {
                              _setTop();
                            },
                            activeColor: Colors.white,
                            // 滑块的颜色（开启状态）
                            activeTrackColor:
                                const Color.fromRGBO(36, 211, 207, 1),
                            // 轨道颜色（开启状态）
                            inactiveThumbColor: Colors.white,
                            // 滑块的颜色（关闭状态）
                            inactiveTrackColor:
                                MyTheme.white008Color, // 轨道颜色（关闭状态）
                          ),
                        ),
                      ],
                    ),
                  ),
                  ReportGestureDetector(
                    onTap: () {
                      //清空历史记录
                      _cleanSoulGroupMsg();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 13.w),
                      child: Text(tr('qkjl'), style: MyTheme.white14),
                    ),
                  ),
                  ReportGestureDetector(
                    onTap: () {
                      //退出此群
                      _outSoulGroup();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 13.w),
                      child: Text(tr('tccq'), style: MyTheme.white14),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _setTop() async {
    final param = Map.from({})..['id'] = widget.id;

    final result = await _appDomain.getConstructByApiLink(
      apiLink: 'chatgroup/set_top',
      params: param,
    );

    if (result.status == 1) {
      isSetTop = result.data['set_top'] == 1;
      eventBus.fire(MyEvent('RrefrehSoulGroup')); //发通知去群广场界面/我加入的列表界面刷新数据
    } else {
      MyToast.showText(text: result.msg ?? '');
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future _cleanSoulGroupMsg() async {
    late final domain = context.read<AppDomain>();

    final param = Map.from({})
      ..['ms'] = widget.ms
      ..['id'] = widget.id;
    final res = await domain.getConstructByApiLink(
      apiLink: 'chatgroup/del_msg',
      params: param,
    );

    if (res.isValid) {
      context.pop();
      context.pop();
    } else {
      MyToast.showText(text: res.msg ?? '');
    }
  }

  Future _outSoulGroup() async {
    late final domain = context.read<AppDomain>();

    final param = Map.from({})..['id'] = widget.id;
    final res = await domain.getConstructByApiLink(
      apiLink: 'chatgroup/exit_group',
      params: param,
    );

    if (res.isValid) {
      eventBus.fire(MyEvent('RrefrehSoulGroup')); //发通知去群广场界面/我加入的列表界面刷新数据
      context.pop();
      context.pop();
    } else {
      MyToast.showText(text: res.msg ?? '');
    }

    setState(() {});
  }
}
