import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/common_widgets/general_banner.dart';
import 'package:jygf/ui_layer/screens/community/ori_create_group_chat/group_chat/card/soul_groud_list_card.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/domain.dart';
import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/model/soul_group_model.dart';
import 'package:jygf/domain/type_def.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/common_widgets/event_bus/event_bus.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';

class GroupPlazaContent extends StatefulWidget {
  const GroupPlazaContent({super.key});

  @override
  State<GroupPlazaContent> createState() => _GroupPlazaContentState();
}

class _GroupPlazaContentState extends State<GroupPlazaContent> {
  late final config = context.read<HomeConfigNotifier>().config;

  late final _appDomain = context.read<AppDomain>();
  final ValueNotifier<List<BannerModel>> _bannersNotifier = ValueNotifier([]);
  final ValueNotifier<List<TipModel>> _tipsNotifier = ValueNotifier([]);

  List<TipModel> tips = [];
  late StreamSubscription<MyEvent> _subscription;

  bool isInit = false;

  @override
  void initState() {
    super.initState();

    _subscription = eventBus.on<MyEvent>().listen((event) {
      debugPrint('Received event: ${event.message}');
      // if (event.message == 'RrefrehSoulGroup' &&
      //     event.param?['isNotNeedRefresh'] == true) {
      //   return;
      // }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _subscription.cancel(); // 取消订阅
    super.dispose();
  }

  Future<List<GroupsModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final param = Map.from({})
      ..['page'] = page
      ..['limit'] = pageSize;

    final result = await _appDomain.getConstructByApiLink(
      apiLink: 'chatgroup/list_group',
      params: param,
    );

    if (!isInit) {
      setState(() {
        isInit = true;
      });
    }

    if (result.status == 1) {
      if (result.data['banner'] case final List data
          when data.isNotEmpty && _bannersNotifier.value.isEmpty) {
        final banner = data.map((x) => BannerModel.fromJson(x)).toList();
        _bannersNotifier.value = banner;
      }
      if (result.data['notice'] case final List data
          when data.isNotEmpty && _tipsNotifier.value.isEmpty) {
        final tips = data.map((x) => TipModel.fromJson(x)).toList();
        _tipsNotifier.value = tips;
      }

      return result.data['groups']
          ?.map<GroupsModel>((x) => GroupsModel.fromJson(x))
          .toList();
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      key: UniqueKey(),
      header: _Header(
        bannersNotifier: _bannersNotifier,
        tipsNotifier: _tipsNotifier,
      ),
      contentPadding: 15.w,
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      itemBuilder: (context, item, index) => SoulGroudListCard(data: item),
      onFetchingMore: (currentPage, pageSize) =>
          _getData(page: currentPage, pageSize: pageSize),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.bannersNotifier,
    required this.tipsNotifier,
  });

  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final ValueNotifier<List<TipModel>> tipsNotifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // SizedBox(height: 6.w),
        ValueListenableBuilder(
          valueListenable: bannersNotifier,
          builder: (context, banners, child) {
            if (banners.isEmpty) return const SizedBox.shrink();
            return Padding(
                padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                child: GeneralBannerAppsListWidget(data: banners)
                //  CustomGirdBanner(data: banners),
                );
          },
        ),
        ValueListenableBuilder(
          valueListenable: tipsNotifier,
          builder: (context, tips, child) {
            if (tips.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(top: 5.w, bottom: 10.w),
              child: CommonUtils.buildNotifyWidget(tips),
            );
          },
        ),
      ],
    );
  }
}
