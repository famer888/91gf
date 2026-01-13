import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/model/navigator_model.dart';
import 'package:jygf/domain/model/post_model.dart';
import 'package:jygf/domain/remote_domain/domains/community.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/file_search/widget/check_file_item.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';
import 'package:jygf/report/ui_layer/report_general_banner.dart';

class CheckFileScreen extends StatefulWidget {
  const CheckFileScreen({super.key});

  @override
  State<CheckFileScreen> createState() => _CheckFileScreenState();
}

class _CheckFileScreenState extends State<CheckFileScreen> with TickerProviderStateMixin {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final _domain = context.read<CommunityDomain>();
  late final _screenUtils = ScreenUtil();
  final ValueNotifier<List<TipModel>> _noticeNotifier = ValueNotifier([]);
  final ValueNotifier<List<BannerModel>> _bannersNotifier = ValueNotifier([]);

  late final List<NavigatorModel> _titles = _homeConfig.config.forumNav ?? [];

  late final TabController? tabController;
  int _initialIndex = 0;
  bool isInit = false;

  Future<void> _initNotices() async {
    final result = await _domain.getNoticeList();
    if (result.status == 1) {
      if (result.data != null && result.data!.isNotEmpty) {
        _noticeNotifier.value = result.data!;
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
  }

  Future<List<PostModel>?> _getData({int page = 1, int limit = 16, String sort = ''}) async {
    final result = await _domain.getCheckFileList(page: page, limit: limit, sort: sort);
    CommonUtils.log('结果 res:${result.status}');
    if (result.status == 1) {
      if (result.data?.banners case final data? when data.isNotEmpty) {
        _bannersNotifier.value = data;
      }

      if (!isInit) {
        isInit = true;
        setState(() {});
      }

      if (result.data?.posts case final posts? when posts.isNotEmpty) {
        return posts;
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return [];
  }

  @override
  void initState() {
    _initNotices();
    _initialIndex = _titles.indexWhere((e) => e.type == 'new');
    if (_initialIndex == -1) {
      _initialIndex = 0;
    }
    tabController = TabController(initialIndex: _initialIndex, length: _titles.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (_, __) => [
        SliverToBoxAdapter(
          child: _Header(
            bannersNotifier: _bannersNotifier,
            tipsNoticeNotifier: _noticeNotifier,
          ),
        ),
      ],
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
        child: TabBarWithView.fillColor(
          initialIndex: _initialIndex,
          tabController: tabController,
          tabBarHeight: 26.w,
          borderRadius: 5.w,
          isScrollable: true,
          tabBarPadding: EdgeInsets.symmetric(vertical: 0.w),
          titles: isInit ? _titles.map((e) => e.title).toList() : [],
          views: [
            for (final NavigatorModel nav in _titles)
              MyListView.list(
                contentPadding: 15.w,
                padding: EdgeInsets.only(top: 5.w, bottom: MyTheme.pagePadding),
                itemBuilder: (context, item, index) => CheckFileItem(
                  item: item,
                  itemWidth: (_screenUtils.screenWidth - MyTheme.pagePadding * 2),
                ),
                onFetchingMore: (currentPage, pageSize) => _getData(page: currentPage, limit: pageSize, sort: nav.type),
              )
          ],
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
          },
        ),
      ],
    );
  }
}
