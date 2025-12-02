import 'package:flutter/material.dart';
import 'package:jygf/domain/model/home_data_model.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/webview/screen.dart';
import 'package:provider/provider.dart';

import '../../../domain/async_value.dart';
import '../../../domain/domain.dart';
import '../../../domain/model/link_model.dart';
import 'api_link_view.dart';
import 'my_tab_bar.dart';
import 'status/loading.dart';
import 'status/network_error.dart';

class TopNaviView extends StatefulWidget {
  const TopNaviView({super.key, this.id});

  final int? id;

  @override
  State<TopNaviView> createState() => _TopNaviViewState();
}

class _TopNaviViewState extends State<TopNaviView>
    with TickerProviderStateMixin {
  late final _appDomain = context.read<AppDomain>();
  AsyncValue<List<LinkModel>> _asyncValue = const AsyncInit();
  late final TabController _tabController;

  late final _homeConfig = context.read<HomeConfigNotifier>();

  //需要插入额外的分类界面
  late List<NavPrependModel> nav_prepend = _homeConfig.config.nav_prepend ?? [];

  int _initialIndex = 0;

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    if (_asyncValue.isLoading) return;

    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final result = await _appDomain.getFirstTopNavConfig(navId: widget.id);

    if (result.data?.value case final data?) {
      List<LinkModel> list = List.from(data);
      for (var e in nav_prepend) {
        LinkModel item = LinkModel(
            is_nav_prepend: true,
            id: 0,
            linkUrl: e.value ?? '',
            resourceUrl: '',
            redirectType: e.type ?? 0,
            name: e.label ?? '',
            desc: '',
            api: '',
            params: {});
        list.insert(e.sort ?? 0, item); //插入到对应位置
      }

      _initialIndex = (_homeConfig.config.nav_default ?? 0);

      _tabController = TabController(length: list.length, vsync: this, initialIndex: _initialIndex);

      _asyncValue = AsyncData(list);
    } else {
      _asyncValue = const AsyncError();
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return _asyncValue.maybeWhen(
      data: (data) => TabBarWithView.line(
        tabController: _tabController,
        initialIndex: _initialIndex,
        titles: data.map((e) => e.name).toList(),
        views: data.map((e) {
          return (e.is_nav_prepend ?? false)
              ? configNavPrependPage(e)
              : ApiLinkView(
                  linkModel: e,
                  onLinkNavTap: (value) {
                    if (data.indexWhere((element) => element.linkUrl == value)
                        case final index when index != -1) {
                      _tabController.index = index;
                    }
                  },
                );
        }).toList(),
      ),
      error: (_, __) => NetworkErrorView(onTap: _init),
      orElse: () => const LoadingView(),
    );
  }

  Widget configNavPrependPage(LinkModel data) {
    return KeepAliveWrapper(
      child: data.redirectType == 1
          ? WebViewScreen(url: data.linkUrl, needNav: false)
          : Container(),
    );
  }
}
