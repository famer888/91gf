import 'package:flutter/material.dart';
import 'package:jygf/domain/model/navigator_model.dart';
import 'package:provider/provider.dart';
import 'package:jygf/app_global.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/domain.dart';
import 'package:jygf/domain/model/vlog_model.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/vlog/card/vlog_card.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final List<NavigatorModel> titles =
      _homeConfig.config.vlogDiscoverSortNav ?? [];

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
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: MyTheme.statusHeight + MyTheme.navbarHegiht),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
            // child: const Divider(
            //     thickness: 0.5, height: 0.5, color: MyTheme.white02Color),
          ),
          Expanded(child: configContentView())
        ],
      ),
    );
  }

  Widget configContentView() {
    return TabBarWithView.line(
      // labelPadding: 9.w,
      // tabBarHeight: 32.w,
      // tabBarPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.w),
      titles: [for (final title in titles) title.title ?? ''],
      views: [
        for (final NavigatorModel model in titles)
          KeepAliveWrapper(
              child:
                  DiscoverContentView(sort: model, key: Key(model.title ?? '')))
      ],
    );
  }
}

class DiscoverContentView extends StatefulWidget {
  const DiscoverContentView({super.key, required this.sort});

  final NavigatorModel sort;

  @override
  State<DiscoverContentView> createState() => DiscoverContentViewState();
}

class DiscoverContentViewState extends State<DiscoverContentView> {
  late final _domain = context.read<VlogDomain>();
  List<VlogModel> array = [];

  int _page = 1;
  int _limit = 15;

  Future<List<VlogModel>?> _getData(
      {required int page, required int pageSize, required String type}) async {
    _page = page;
    _limit = pageSize;

    final result = await _domain.mvDiscoverList(
      type: type,
      page: page,
      limit: pageSize,
    );
    if (result.isValid) {
      List<VlogModel> tp = List.from(result.data ?? []);
      if (page == 1) {
        array = [...tp];
      } else {
        array.addAll(tp);
      }
      return tp;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      childAspectRatio: 170 / 255,
      itemBuilder: (context, item, index) => VlogCard(
          data: item,
          onTapFunc: (type) {
            if (type == 1) {
              //点击短视频视频
              AppGlobal.shortVideosInfo = {
                'list': array,
                'page': _page,
                'index': index,
                'api': 'vlog/list_discover',
                'params': {
                  'type': widget.sort.type,
                  'limit': _limit,
                },
              };

              const VlogSecondRoute().push(context);
            } else {
              //广告类型
              CommonUtils.openRoute(context, item.toJson());
            }
          }),
      onFetchingMore: (currentPage, pageSize) => _getData(
          page: currentPage, pageSize: pageSize, type: widget.sort.type ?? ''),
    );
  }
}
