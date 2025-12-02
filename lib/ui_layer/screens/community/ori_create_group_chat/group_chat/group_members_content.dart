import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/community/ori_create_group_chat/group_chat/card/soul_member_card.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/domain.dart';
import 'package:jygf/domain/model/user_model.dart';
import 'package:jygf/domain/type_def.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';

class GroupMembersContent extends StatefulWidget {
  const GroupMembersContent({super.key, required this.id});

  final int id;

  @override
  State<GroupMembersContent> createState() => _GroupMembersContentState();
}

class _GroupMembersContentState extends State<GroupMembersContent> {
  late final config = context.read<HomeConfigNotifier>().config;
  late final _appDomain = context.read<AppDomain>();

  @override
  void initState() {
    super.initState();
  }

  Future<List<UserModel>?> _getMembers(
      {required int page, required int pageSize}) async {
    final param = Map.from({})
      ..['id'] = widget.id
      ..['page'] = page
      ..['limit'] = pageSize;

    final result = await _appDomain.getConstructByApiLink(
      apiLink: 'chatgroup/group_detail',
      params: param,
    );

    if (result.status == 1) {
      return result.data['members']
              ?.map<UserModel>((x) => UserModel.fromJson(x))
              .toList() ??
          [];
    } else {
      MyToast.showText(text: result.msg ?? '');
    }

    if (mounted) {
      setState(() {});
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
          appBar: MyAppBar(title: tr('qbcy')),
          body: MyListView.grid(
            childAspectRatio: 1 / 1.3,
            mainAxisSpacing: 10.w,
            crossAxisSpacing: 10.w,
            crossAxisCount: 5,
            padding: EdgeInsets.all(MyTheme.pagePadding),
            itemBuilder: (context, item, index) => SoulMemberCard(data: item),
            onFetchingMore: (currentPage, pageSize) =>
                _getMembers(page: currentPage, pageSize: pageSize),
          )),
    );
  }
}
