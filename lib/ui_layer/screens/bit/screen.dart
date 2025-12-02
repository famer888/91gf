import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../domain/api_validator.dart';
import '../../../domain/async_value.dart';
import '../../../domain/domain.dart';
import '../../../domain/model/bit_nav_model.dart';
import '../../notifiers/home_config_notifier.dart';
import '../common_widgets/my_tab_bar.dart';
import '../common_widgets/screen_background.dart';
import '../common_widgets/status/loading.dart';
import '../common_widgets/status/network_error.dart';
import '../theme.dart';
import 'content.dart';

class BitScreen extends StatefulWidget {
  const BitScreen({super.key});

  @override
  State<BitScreen> createState() => _BitScreenState();
}

class _BitScreenState extends State<BitScreen> with TickerProviderStateMixin {
  late final config = context.read<HomeConfigNotifier>().config;
  late final navList = config.seedTopNav;
  late final tabController = TabController(length: navList.length, vsync: this);

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: _AppBar(
          tabController: tabController,
          titles: navList.map((e) => e.name).toList(),
        ),
        body: TabBarView(
          controller: tabController,
          children: navList.map((e) => _BitView(id: e.id)).toList(),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({required this.tabController, required this.titles});

  final TabController tabController;
  final List<String> titles;

  @override
  final Size preferredSize = const Size.fromHeight(44);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      title: SizedBox(
        height: 30.w,
        child: TabBar(
          padding: EdgeInsets.zero,
          controller: tabController,
          labelPadding: const EdgeInsets.symmetric(horizontal: 10),
          tabAlignment: TabAlignment.center,
          isScrollable: true,
          labelStyle: MyTheme.white255_13,
          unselectedLabelStyle: MyTheme.gray163_13,
          overlayColor: WidgetStateProperty.resolveWith<Color>(
            (_) => Colors.transparent,
          ),
          indicatorColor: Colors.transparent,
          indicator: BoxDecoration(
            gradient: MyTheme.gradient_90_114,
            borderRadius: BorderRadius.circular(30.w),
          ),
          dividerColor: Colors.transparent,
          dividerHeight: 0,
          tabs: titles.map((e) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Tab(
                iconMargin: EdgeInsets.zero,
                height: MyTheme.navbarHegiht,
                child: Center(
                  child: Text(e),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _BitView extends StatefulWidget {
  const _BitView({required this.id});
  final int id;
  @override
  State<_BitView> createState() => _BitViewState();
}

class _BitViewState extends State<_BitView> {
  late final _appDomain = context.read<SeedDomain>();

  AsyncValue<List<BitNavModel>> _asyncValue = const AsyncInit();

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

    final result = await _appDomain.reqGetPostBit(id: widget.id);

    if (result.data case final data? when result.isValid) {
      _asyncValue = AsyncData(data);
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
        titles: data.map((e) => e.name).toList(),
        views: data.map((e) => BitContentView(nav: e)).toList(),
      ),
      error: (_, __) => NetworkErrorView(onTap: _init),
      orElse: () => const LoadingView(),
    );
  }
}
