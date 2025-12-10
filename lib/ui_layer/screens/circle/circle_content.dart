import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/navigator_model.dart';
import 'package:jygf/domain/model/post_model.dart';
import 'package:jygf/domain/model/topic_model.dart';
import 'package:jygf/domain/remote_domain/domains/community.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/notifiers/user_notifier.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/general_banner.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/circle/circle_post_card.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

class CircleCommunityContentView extends StatefulWidget {
  const CircleCommunityContentView({super.key, required this.id});
  final int id;

  @override
  State<CircleCommunityContentView> createState() =>
      _CircleCommunityContentViewState();
}

class _CircleCommunityContentViewState
    extends State<CircleCommunityContentView> {
  late final _domain = context.read<CommunityDomain>();
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final _userNotifier = context.read<UserNotifier>();

  final ValueNotifier<List<BannerModel>> _bannersNotifier = ValueNotifier([]);

  final ValueNotifier<List<TopicModel>> topicsNotifier = ValueNotifier([]);

  late final List<NavigatorModel> _titles = _homeConfig.config.circleNav;

  bool isInit = false;

  Future<List<PostModel>?> _getData({
    required int page,
    required int pageSize,
    required String sort,
  }) async {
    final result = await _domain.circleSortList(
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
      }

      if (result.data?.topics case final data? when data.isNotEmpty) {
        topicsNotifier.value = data;
      }

      if (result.data?.posts case final posts?) {
        _userNotifier.patchUserFollowStatus(
          posts
              .where((post) => post.user?.isFollow == 1)
              .map((post) => '${post.user?.aff}'),
          posts
              .where((post) => post.user?.isFollow != 1)
              .map((post) => '${post.user?.aff}'),
        );
        return posts;
      }
    }
    else {
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
          ),
        ),
      ],
      body: widget.id == 100 || widget.id == 68
          ? MyListView.list(
              contentPadding: 20.w,
              padding: EdgeInsets.symmetric(vertical: 12.5.w),
              itemBuilder: (context, item, index) => PostCard(
                data: item,
              ),
              onFetchingMore: (currentPage, pageSize) =>
                  _getData(page: currentPage, pageSize: pageSize, sort: ''),
            )
          : TabBarWithView.fillColor(
              tabBarPadding: EdgeInsets.symmetric(vertical: 6.w),
              tabBarHeight: 32.w,
              isScrollable: true,
              labelPadding: 0.w,
              titles: isInit ? [for (final title in _titles) title.title] : [],
              views: [
                for (final NavigatorModel nav in _titles)
                  MyListView.list(
                    contentPadding: 20.w,
                    padding: EdgeInsets.symmetric(vertical: MyTheme.pagePadding),
                    itemBuilder: (context, item, index) {
                      if (nav.type == 'rank' && index < 3) {
                        return PostCard(
                          data: item,
                          rank: index,
                        );
                      }

                      return PostCard(
                        data: item,
                      );
                    },
                    onFetchingMore: (currentPage, pageSize) => _getData(
                      page: currentPage,
                      pageSize: pageSize,
                      sort: nav.type),
                  )
              ],
            ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.bannersNotifier,
    required this.topicsNotifier,
  });
  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final ValueNotifier<List<TopicModel>> topicsNotifier;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(height: 5.w),
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
      ValueListenableBuilder(
        valueListenable: topicsNotifier,
        builder: (context, topics, child) {
          if (topics.isEmpty) return const SizedBox.shrink();
          return Padding(
            padding: EdgeInsets.only(top: 10.w, bottom: 5.w),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.w),
                    ),
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: AlignmentDirectional.center,
                    children: [
                      MyImage.network(
                        topic.bgThumb,
                        borderRadius: 6.w,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          CommunityTagDetailRoute('${topic.id}')
                              .push(context);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              topics[index].name,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 2.w),
                            Center(
                              child: Text(
                                "${topic.postNum}${'tiez'.tr(context: context)}",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                ),
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
      Divider(
        color: Colors.white.withOpacity(0.04),
        height: 10,
        indent: MyTheme.pagePadding,
        endIndent: MyTheme.pagePadding,
      ),
    ]);
  }
}
