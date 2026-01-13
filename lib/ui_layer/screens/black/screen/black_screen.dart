import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/async_value.dart';
import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/remote_domain/domains/black_domain.dart';
import 'package:jygf/ui_layer/screens/black/model/black_model.dart';
import 'package:jygf/ui_layer/screens/black/widgets/black_item_widget.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/network_error.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';import 'package:jygf/report/ui_layer/report_general_banner.dart';



class BlackScreen extends StatefulWidget {
  const BlackScreen({super.key});

  @override
  State<BlackScreen> createState() => _BlackScreenState();
}

class _BlackScreenState extends State<BlackScreen> with TickerProviderStateMixin {
  late final _domain = context.read<BlackDomain>();
  late final _screenUtils = ScreenUtil();
  AsyncValue<List<BlackModel>> _asyncValue = const AsyncInit();
  final ValueNotifier<List<TipModel>> _blackListNoticeNotifier = ValueNotifier([]);
  final ValueNotifier<List<BannerModel>> _bannersNotifier = ValueNotifier([]);

  late final TabController? tabController;
  int _initialIndex = 0;
  bool isInit = false;

  Future<void> _initData() async {
    if (_asyncValue.isLoading) return;

    setState(() {
      _asyncValue = const AsyncLoading();
    });
    await _getBlackNotice();
    final res = await _domain.getCategoryList(token: '');
    if (res.status == 1) {
      if (res.data?.list case final data? when data.isNotEmpty) {
        _initialIndex = data.indexWhere((e) => e.current == true);
        BlackModel? currentItem = _initialIndex != -1 ? data[_initialIndex] : null;
        if (currentItem == null) {
          _initialIndex = 0;
          currentItem = data.first;
        }
        tabController = TabController(initialIndex: _initialIndex, length: data.length, vsync: this);
        _asyncValue =  AsyncData(data);
      } else {
        _asyncValue = const AsyncError();
      }
    } else {
      _asyncValue = const AsyncError();
    }

    if (mounted && !isInit) {
      setState(() {
        isInit = true;
      });
    }
  }

  Future<List<BlackListItemModel>?> _getBlackList({
    required int mid,
    required int page,
    required int limit,
  }) async {
    final result = await _domain.getBlackList(mid: mid, page: page, limit: limit);
    CommonUtils.log('获取黑料列表数据 $result');
    if (result.status == 1) {
      if (result.data?.banners case final data? when data.isNotEmpty) {
        _bannersNotifier.value = data;
      }

      if (result.data?.list case final posts?  when posts.isNotEmpty) {
        return posts;
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  Future<void> _getBlackNotice() async {
    final res = await _domain.getBlackNotices();
    CommonUtils.log('获取黑料公告数据 $res');
    if (res.status == 1) {
      if (res.data case final data? when data.isNotEmpty) {
        _blackListNoticeNotifier.value = data;
      }
    } else {
      CommonUtils.log('获取黑料公告数据 msg:${res.msg}');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _asyncValue.maybeWhen(
      init: () {
        _initData();
        return const LoadingView();
      },
      error: (_, __) => NetworkErrorView(onTap: _initData),
      orElse: () => const LoadingView(),
      data: (data) => NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverToBoxAdapter(
            child: _Header(
              bannersNotifier: _bannersNotifier,
              tipsNoticeNotifier: _blackListNoticeNotifier,
            ),
          ),
        ],
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
          child: TabBarWithView.fillColor(
            initialIndex: _initialIndex,
            tabController: tabController,
            tabBarPadding: EdgeInsets.symmetric(vertical: 6.w),
            tabBarHeight: 32.w,
            borderRadius: 5.w,
            isScrollable: true,
            titles: isInit ? data.map((e) => e.name).toList() : [],
            views: [
              for (final BlackModel nav in data)
                MyListView.list(
                  contentPadding: 15.w,
                  padding: EdgeInsets.only(top: 5.w, bottom: MyTheme.pagePadding),
                  itemBuilder: (context, item, index) => BlackItemWidget(item: item, itemWidth: (_screenUtils.screenWidth - MyTheme.pagePadding * 2)),
                  onFetchingMore: (currentPage, pageSize) => _getBlackList(page: currentPage, limit: pageSize, mid: nav.mid),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.bannersNotifier,
    required this.tipsNoticeNotifier,
  });

  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final ValueNotifier<List<TipModel>> tipsNoticeNotifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 6.w),
        ValueListenableBuilder(
          valueListenable: bannersNotifier,
          builder: (context, banners, child) {
            if (banners.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: ReportGeneralAppsListVidget(data: banners),
            );
          },
        ),
        ValueListenableBuilder(
            valueListenable: tipsNoticeNotifier,
            builder: (context, tips, child) {
              return Padding(padding: EdgeInsets.only(top: 5.w, bottom: 10.w), child: CommonUtils.buildNotifyWidget(tips));
            }),
      ],
    );
  }
}
