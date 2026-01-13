import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/model/navigator_model.dart';
import 'package:jygf/domain/model/post_model.dart';
import 'package:jygf/domain/model/topic_model.dart';
import 'package:jygf/domain/remote_domain/domains/community.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/notifiers/user_notifier.dart';
import 'package:jygf/ui_layer/router/router.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/post/card/card.dart';
import 'package:jygf/ui_layer/screens/community/issue/screen.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';import 'package:jygf/report/ui_layer/report_general_banner.dart';




class CommunityContentView extends StatefulWidget {
  const CommunityContentView({super.key, required this.id});

  final int id;

  @override
  State<CommunityContentView> createState() => _CommunityContentViewState();
}

class _CommunityContentViewState extends State<CommunityContentView> with TickerProviderStateMixin {
  late final _domain = context.read<CommunityDomain>();
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final _userNotifier = context.read<UserNotifier>();

  final ValueNotifier<List<BannerModel>> _bannersNotifier = ValueNotifier([]);

  final ValueNotifier<List<TopicModel>> topicsNotifier = ValueNotifier([]);

  late final List<NavigatorModel> _titles = _homeConfig.config.forumNav ?? [];

  List<TipModel> tips = [];
  late final TabController? tabController;
  int _initialIndex = 0;

  bool isInit = false;

  Future<List<PostModel>?> _getData({
    required int page,
    required int pageSize,
    required String sort,
  }) async {
    final result = await _domain.communitySortList(
      id: widget.id,
      sort: sort,
      page: page,
      limit: pageSize,
    );

    if (!isInit) {
      setState(() {
        isInit = true;
      });
    }

    if (result.status == 1) {
      if (result.data?.banners case final data? when data.isNotEmpty) {
        _bannersNotifier.value = data;
        tips = _homeConfig.config.forumTips ?? [];
      }

      if (result.data?.topics case final data? when data.isNotEmpty) {
        topicsNotifier.value = data;
      }

      if (result.data?.posts case final posts?) {
        _userNotifier.patchUserFollowStatus(posts.where((post) => post.user?.isFollow == 1).map((post) => '${post.user?.aff}'), []);
        return posts;
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _initialIndex = _titles.indexWhere((element) => element.type == 'new');
    tabController = TabController(initialIndex: _initialIndex, length: _titles.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NestedScrollView(
          headerSliverBuilder: (_, __) => [
            SliverToBoxAdapter(
              child: _Header(
                bannersNotifier: _bannersNotifier,
                topicsNotifier: topicsNotifier,
                tips: tips,
              ),
            ),
          ],
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
            child: TabBarWithView.fillColor(
              initialIndex: _initialIndex,
              tabController: tabController,
              tabBarPadding: EdgeInsets.symmetric(vertical: 3.w),
              tabBarHeight: 32.w,
              borderRadius: 5.w,
              isScrollable: true,
              titles: isInit ? [for (final title in _titles) title.title] : [],
              views: [
                for (final NavigatorModel nav in _titles)
                  MyListView.list(
                    contentPadding: 15.w,
                    padding: EdgeInsets.only(top: 5.w, bottom: MyTheme.pagePadding),
                    itemBuilder: (context, item, index) => PostCard.community(data: item, backgroundColor: const Color.fromRGBO(0, 0, 0, 0),),
                    onFetchingMore: (currentPage, pageSize) => _getData(page: currentPage, pageSize: pageSize, sort: nav.type),
                  )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 10.w,
          right: 13.w,
          child: ReportGestureDetector(
            onTap: _showIssueAlert,
            behavior: HitTestBehavior.translucent,
            child: MyImage.asset(MyImagePaths.appIssueIcon, width: 50.w, height: 50.w),
          ),
        ),
      ],
    );
  }

  Future<void> _showIssueAlert() {
    final issues = [
      (
        title: 'tp'.tr(context: context),
        iconName: MyImagePaths.appFabuPicture,
        type: CommunityIssueType.image,
      ),
      (
        title: 'sping'.tr(context: context),
        iconName: MyImagePaths.appFabuVideo,
        type: CommunityIssueType.video,
      ),
      (
        title: 'twen'.tr(context: context),
        iconName: MyImagePaths.appFabuText,
        type: CommunityIssueType.imageAndText,
      ),
    ];
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: AppRouter.rootNavigatorKey.currentContext ?? context,
      builder: (context) => Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              image: const DecorationImage(image: AssetImage(MyImagePaths.appIssueBg), fit: BoxFit.cover),
              border: Border.all(color: const Color.fromRGBO(154, 48, 133, 1), width: 0.5),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16.w), topRight: Radius.circular(16.w)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 13.w),
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox.shrink(),
                        Text('xzfblx'.tr(), style: MyTheme.white16bold),
                        InkWell(
                          onTap: () => context.pop(),
                          child: MyImage.asset(MyImagePaths.appIssueClose, width: 14.w, height: 14.w),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (final issue in issues)
                        ReportGestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            context.pop();
                            CommunityIssueRoute(type: issue.type, topicType: CommunityIssueTopicType.community).push(context);
                          },
                          child: Column(
                            children: [
                              MyImage.asset(issue.iconName, width: 50.w, height: 52.7.w),
                              SizedBox(height: 4.w),
                              Text(issue.title, style: MyTheme.white255_14)
                            ],
                          ),
                        )
                    ],
                  ),
                  SizedBox(height: 42.5.w)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.bannersNotifier,
    required this.topicsNotifier,
    required this.tips,
  });

  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final ValueNotifier<List<TopicModel>> topicsNotifier;
  final List<TipModel> tips;

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
        Padding(padding: EdgeInsets.only(top: 5.w, bottom: 10.w), child: CommonUtils.buildNotifyWidget(tips)),
        ValueListenableBuilder(
          valueListenable: topicsNotifier,
          builder: (context, topics, child) {
            if (topics.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(bottom: 5.w),
              child: GridView.builder(
                shrinkWrap: true,
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2,
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
                    child: Stack(
                      fit: StackFit.expand,
                      alignment: AlignmentDirectional.center,
                      children: [
                        MyImage.network(topic.bgThumb, borderRadius: 6.w),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.w),
                            gradient: const LinearGradient(colors: [
                              Color.fromRGBO(176, 66, 255, 0.45),
                              Color.fromRGBO(255, 133, 164, 0.45),
                            ]),
                          ),
                        ),
                        ReportGestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            CommunityTagDetailRoute('${topic.id}').push(context);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                topics[index].name,
                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                              SizedBox(height: 2.w),
                              Center(
                                child: Text(
                                  "${topic.postNum}${'tiez'.tr(context: context)}",
                                  style: TextStyle(fontSize: 12.sp, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
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
