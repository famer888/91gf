import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/domain.dart';
import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/model/navigator_model.dart';
import 'package:jygf/domain/model/post_model.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/post/card/card.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';
import 'package:jygf/report/ui_layer/report_general_banner.dart';

class SeedDwonContentView extends StatefulWidget {
  const SeedDwonContentView({super.key});

  @override
  State<SeedDwonContentView> createState() => _SeedDwonContentViewState();
}

class _SeedDwonContentViewState extends State<SeedDwonContentView> {
  late final _domain = context.read<SeedDomain>();
  late final _homeConfig = context.read<HomeConfigNotifier>();

  final ValueNotifier<List<BannerModel>> _bannersNotifier = ValueNotifier([]);

  final ValueNotifier<List<FaceNavigatorModel>> topicsNotifier = ValueNotifier([]);

  late final List<NavigatorModel> _titles = _homeConfig.config.seedSortNav ?? [];

  late final List<FaceNavigatorModel> _topics = _homeConfig.config.seedTopNav;

  List<TipModel> tips = [];

  bool isInit = false;

  int currentId = 0;

  String currentSort = '';

  @override
  void initState() {
    super.initState();

    currentId = _topics.first.id; //默认拿第一个标签的ID去获取广告和公告数据
  }

  Future<List<PostModel>?> _getData({
    required int id,
    required String sort,
    required int page,
    required int pageSize,
  }) async {
    final result = await _domain.bitSortList(
      id: id,
      sort: sort,
      page: page,
      limit: pageSize,
    );

    currentSort = sort;

    if (!isInit) {
      setState(() {
        isInit = true;
      });
    }

    if (result.status == 1) {
      if (result.data?.banners case final data? when data.isNotEmpty) {
        _bannersNotifier.value = data;
      }

      if (result.data?.tips case final data? when data.isNotEmpty) {
        tips = data;
      }

      topicsNotifier.value = _topics;

      if (result.data?.posts case final posts?) {
        return posts;
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (_, __) => [
        SliverToBoxAdapter(
          child: _Header(
            bannersNotifier: _bannersNotifier,
            topicsNotifier: topicsNotifier,
            tips: tips,
            currentId: currentId,
            topicTapCall: (id) {
              currentId = id;
              setState(() {});
            },
          ),
        ),
      ],
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
        child: TabBarWithView.fillColor(
          // initialIndex: _initialIndex,
          // tabController: tabController,
          tabBarHeight: 26.w,
          borderRadius: 5.w,
          isScrollable: true,
          tabBarPadding: EdgeInsets.symmetric(vertical: 0.w),
          titles: isInit ? _titles.map((e) => e.title).toList() : [],
          views: [
            for (final NavigatorModel nav in _titles)
              MyListView.list(
                key: UniqueKey(),
                //这样做为了每次点击标签时都可以直接刷新数据
                contentPadding: 15.w,
                padding: EdgeInsets.only(top: 5.w, bottom: MyTheme.pagePadding),
                itemBuilder: (context, item, index) => PostCard.bit(
                  data: item,
                  backgroundColor: Colors.transparent,
                ),
                onFetchingMore: (currentPage, pageSize) => _getData(
                  id: currentId,
                  page: currentPage,
                  pageSize: pageSize,
                  sort: nav.type,
                ),
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
    required this.topicsNotifier,
    required this.tips,
    required this.currentId,
    required this.topicTapCall,
  });

  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final ValueNotifier<List<FaceNavigatorModel>> topicsNotifier;
  final List<TipModel> tips;
  final int currentId;
  final Function(int) topicTapCall;

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
        Padding(
          padding: EdgeInsets.only(top: 5.w, bottom: 10.w),
          child: CommonUtils.buildNotifyWidget(tips),
        ),
        ValueListenableBuilder(
          valueListenable: topicsNotifier,
          builder: (context, topics, child) {
            if (topics.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(bottom: 15.w),
              child: GridView.builder(
                shrinkWrap: true,
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 80 / 35,
                  mainAxisSpacing: 10.w,
                  crossAxisSpacing: 10.w,
                ),
                primary: false,
                padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                itemBuilder: (context, index) {
                  final topic = topics[index];
                  return DecoratedBox(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.w)),
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: ReportGestureDetector(
                        onTap: () {
                          topicTapCall.call(topic.id);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: topic.id == currentId
                                ? MyTheme.dhButtonGradient
                                : LinearGradient(
                                    colors: [
                                      MyTheme.primaryColor_01,
                                      MyTheme.primaryColor_01,
                                    ],
                                  ),
                            borderRadius: BorderRadius.all(Radius.circular(2.w)),
                          ),
                          child: Text(topics[index].name, style: MyTheme.white13),
                        ),
                      ));
                },
                itemCount: topics.length,
              ),
            );
          },
        ),
      ],
    );
  }
}
