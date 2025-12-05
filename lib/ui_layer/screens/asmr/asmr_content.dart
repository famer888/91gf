import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/model/navigator_model.dart';
import 'package:jygf/domain/model/voice_model.dart';
import 'package:jygf/domain/remote_domain/domains/asmr.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/asmr/card/voice_gird_card.dart';
import 'package:jygf/ui_layer/screens/asmr/card/voice_list_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/event_bus/event_bus.dart';
import 'package:jygf/ui_layer/screens/common_widgets/general_banner.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

class ASMRContentView extends StatefulWidget {
  const ASMRContentView({super.key, this.topPadding = 0});
  final double topPadding;

  @override
  State<ASMRContentView> createState() => _ASMRContentViewState();
}

class _ASMRContentViewState extends State<ASMRContentView> {
  late final _domain = context.read<ASMRDomain>();
  late final _homeConfig = context.read<HomeConfigNotifier>();

  final ValueNotifier<List<BannerModel>> _bannersNotifier = ValueNotifier([]);

  final ValueNotifier<List<FaceNavigatorModel>> topicsNotifier =
      ValueNotifier([]);

  late final List<FaceNavigatorModel> _navs =
      _homeConfig.config.voiceNav ?? [];

  late final List<NavigatorModel> _sorts =
      _homeConfig.config.voiceSortNav ?? [];

  FaceNavigatorModel? tapNav;

  List<TipModel> tips = [];

  int currentId = 0;

  bool isGird = true;//是否格子布局

  bool isInit = false;

  @override
  void initState() {
    super.initState();

    tapNav = _navs.first;//默认第一个

    _getData();
  }

  //只为获取广告数据
 _getData() async {
    final result = await _domain.voiceIndexList(
      sort: 'up',
      id: tapNav?.id ?? 0,
      page: 1,
      limit: 0,
    );
    if (result.status == 1) {
      isInit = true;
      if (result.data?.banners case final data? when data.isNotEmpty) {
        tips = _homeConfig.config.forumTips ?? [];
        _bannersNotifier.value = data;
      }
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
        child: Padding(
        padding: EdgeInsets.only(top: widget.topPadding),
        child: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverToBoxAdapter(
            child: _Header(
              bannersNotifier: _bannersNotifier,
              topicsNotifier: topicsNotifier,
              tips: tips,
              navs: isInit ? _navs : [],
              onLinkNavTap: (item) {
                tapNav = item;
                setState(() {});
              },
              currentNav: tapNav,
            ),
          ),
        ],
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
          child: TabBarWithView.fillColor(
            tabBarRightWidget: GestureDetector(
              onTap: () {
                isGird = !isGird;
                setState(() {});
              },
              child: Container(
                alignment: Alignment.centerRight,
                width: 18.w, height: 32.w,
                  child: MyImage.asset(MyImagePaths.appAsmrGird,
                      width: 18.w, height: 18.w)),
            ),
            tabBarPadding: EdgeInsets.symmetric(vertical: 6.w),
            tabBarHeight: 32.w,
            isScrollable: true,
            titles: isInit ? [for (final title in _sorts) title.title] : [],
            views: [
              for (final NavigatorModel sort in _sorts)
                isGird ? _GirdCardView(id: tapNav?.id ?? 0, sort: sort.type) :
                _ListCardView(id: tapNav?.id ?? 0, sort: sort.type)
            ],
          ),
        ),
      ),
    ),
    );
  }
}

class _ListCardView extends StatefulWidget {
  const _ListCardView({required this.id, required this.sort});

  final int id;

  final String sort;
  @override
  State<_ListCardView> createState() => _ListCardViewState();
}

class _ListCardViewState extends State<_ListCardView> {
  late final domain = context.read<ASMRDomain>();
  late StreamSubscription<MyEvent> _subscription;

  @override
  void initState() {
    super.initState();

    // 订阅登录刷新界面
    _subscription = eventBus.on<MyEvent>().listen((event) {
      if (event.message == 'RefreshVoiceListUI') {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel(); // 取消订阅
    super.dispose();
  }

  Future<List<VoiceModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await domain.voiceIndexList(
      sort: widget.sort,
      id: widget.id,
      page: page,
      limit: pageSize,
    );
    if (result.status == 1) {
      if (result.data?.voices case final voices) {
        return voices;
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      key: UniqueKey(),
      contentPadding: 15.w,
      padding: EdgeInsets.only(top: 5.w, bottom: MyTheme.pagePadding),
      itemBuilder: (context, item, index) =>
          VoiceListCard(data: item),
      onFetchingMore: (currentPage, pageSize) =>
          _getData(page: currentPage, pageSize: pageSize),
    );
  }
}

class _GirdCardView extends StatefulWidget {
  const _GirdCardView({required this.id, required this.sort});

  final int id;

  final String sort;
  @override
  State<_GirdCardView> createState() => _GirdCardViewState();
}

class _GirdCardViewState extends State<_GirdCardView> {
  late final domain = context.read<ASMRDomain>();
  late StreamSubscription<MyEvent> _subscription;

  @override
  void initState() {
    super.initState();

    // 订阅登录刷新界面
    _subscription = eventBus.on<MyEvent>().listen((event) {
      if (event.message == 'RefreshVoiceListUI') {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel(); // 取消订阅
    super.dispose();
  }

  Future<List<VoiceModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await domain.voiceIndexList(
      sort: widget.sort,
      id: widget.id,
      page: page,
      limit: pageSize,
    );
    if (result.status == 1) {
      if (result.data?.voices case final voices) {
        return voices;
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      key: UniqueKey(),
      contentPadding: 15.w,
      childAspectRatio: 172 / 148,
      padding: EdgeInsets.only(top: 5.w, bottom: MyTheme.pagePadding),
      itemBuilder: (context, item, index) =>
          VoiceGirdCard(data: item),
      onFetchingMore: (currentPage, pageSize) =>
          _getData(page: currentPage, pageSize: pageSize),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.bannersNotifier,
    required this.topicsNotifier,
    required this.tips,
    required this.navs,
    required this.onLinkNavTap,
    required this.currentNav,
  });

  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final ValueNotifier<List<FaceNavigatorModel>> topicsNotifier;
  final List<TipModel> tips;
  final List<FaceNavigatorModel> navs;

  final Function(FaceNavigatorModel) onLinkNavTap;
  final FaceNavigatorModel? currentNav;

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
              child: GeneralBannerAppsListWidget(data: banners),
            );
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: 5.w, bottom: 5.w),
          child: CommonUtils.buildNotifyWidget(tips),
        ),
        SizedBox(height: 5.w),
        Padding(
          padding: EdgeInsets.only(bottom: 5.w),
          child: GridView.builder(
              shrinkWrap: true,
              addRepaintBoundaries: false,
              addAutomaticKeepAlives: false,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: navs.length,
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 80.w / 35.w,
                mainAxisSpacing: 8.w,
                crossAxisSpacing: 10.w,
              ),
              itemBuilder: (context, index) {
                final topic = navs[index];
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    onLinkNavTap(topic);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: topic.id == currentNav?.id ? MyTheme.gradient_90_114 : MyTheme.gradient_90_114_15,
                        borderRadius: BorderRadius.circular(4.w),
                      ),
                    child: Center(
                      child: Text(
                        topic.name,
                        style: topic.id == currentNav?.id
                            ? MyTheme.white255_13_B
                            : MyTheme.white13,
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
