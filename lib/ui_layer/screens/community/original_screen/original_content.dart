import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/blogger_model.dart';
import 'package:jygf/domain/model/community_nav_model.dart';
import 'package:jygf/domain/model/follow_user_model.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/model/navigator_model.dart';
import 'package:jygf/domain/model/post_model.dart';
import 'package:jygf/domain/remote_domain/domains/dynamic.dart';
import 'package:jygf/domain/type_def.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/notifiers/user_notifier.dart';
import 'package:jygf/ui_layer/router/router.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/event_bus/event_bus.dart';
import 'package:jygf/ui_layer/screens/common_widgets/follow_button.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_avatar.dart';
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




class OriginalCommunityContentView extends StatelessWidget {
  const OriginalCommunityContentView({super.key, required this.data});

  final OriginalCommunityNavModel data;

  @override
  Widget build(BuildContext context) {
    return switch (data.type) {
      'follow' => _FollowView(url: data.uri),
      'blogger' => _BloggerView(url: data.uri),
      _ => _NormalView(id: data.id, url: data.uri),
    };
  }
}

class _FollowView extends StatefulWidget {
  const _FollowView({required this.url});

  final String url;

  @override
  State<_FollowView> createState() => _FollowViewState();
}

class _FollowViewState extends State<_FollowView> {
  late final _domain = context.read<DynamicDomain>();
  late final _userNotifier = context.read<UserNotifier>();
  final ValueNotifier<List<FollowingUserData>> _followingUsersNotifier = ValueNotifier([]);

  bool isInit = false;

  Future<List<PostModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final param = {
      'sort': 'new',
      'page': page,
      'limit': pageSize,
    };

    final result = await _domain.getConstructByApiLink(
      apiLink: widget.url,
      params: param,
    );

    if (!isInit) {
      setState(() {
        isInit = true;
      });
    }

    if (result.isValid) {
      if (result.data['follow'] case final List data when page == 1) {
        final followingUsers = data.map((x) => FollowingUserData.fromJson(x)).toList();
        _followingUsersNotifier.value = followingUsers;
      }

      final List<PostModel>? posts = result.data['posts']?.map<PostModel>((x) => PostModel.fromJson(x)).toList();

      _userNotifier.patchUserFollowStatus(
        posts
                ?.where((post) => post.user?.isFollow == 1)
                .map((post) => '${post.user?.aff}') ??
            [],[]
      );
      return posts;
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      padding: EdgeInsets.only(top: 5.w, bottom: MyTheme.pagePadding),
      header: ValueListenableBuilder(
        valueListenable: _followingUsersNotifier,
        builder: (context, value, _) {
          if (value.isEmpty) return const SizedBox.shrink();
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: MyTheme.pagePadding,
                  right: MyTheme.pagePadding,
                  top: MyTheme.pagePadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(tr('wdgz'), style: MyTheme.white14),
                    ReportGestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        const MineFollowingRoute().push(context);
                      },
                      child: Row(
                        children: [
                          Text(tr('ckgd'), style: MyTheme.white14),
                          SizedBox(width: 2.w),
                          MyImage.asset(
                            MyImagePaths.appOriginalArrowRight,
                            width: 6.7.w,
                            height: 12.3.w,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(MyTheme.pagePadding),
                height: 75.w,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  children: value
                      .map(
                        (e) => Row(
                          children: [
                            ReportGestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                UserCenterRoute('${e.aff}').push(context);
                              },
                              child: SizedBox(
                                width: 50.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    MyAvatar(
                                      size: 50.w,
                                      margin: 2.w,
                                      gradient: MyTheme.gradient_90_114,
                                      thumb: e.thumb ?? '',
                                    ),
                                    SizedBox(height: 5.w),
                                    SizedBox(
                                      height: 20.w,
                                      child: Text(
                                        e.nickname ?? '',
                                        style: MyTheme.white12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          );
        },
      ),
      itemBuilder: (context, item, index) => Padding(
        padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
        child: PostCard.community(
          data: item,
        ),
      ),
      onFetchingMore: (currentPage, pageSize) => _getData(page: currentPage, pageSize: pageSize),
    );
  }
}

class _BloggerView extends StatefulWidget {
  const _BloggerView({required this.url});

  final String url;

  @override
  State<_BloggerView> createState() => _BloggerViewState();
}

class _BloggerViewState extends State<_BloggerView> {
  late final _domain = context.read<DynamicDomain>();
  late final _userNotifier = context.read<UserNotifier>();
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final List<NavigatorModel> _titles = _homeConfig.config.originalBloggerNav ?? [];
  List<TipModel> tips = [];

  final ValueNotifier<List<BannerModel>> _bannersNotifier = ValueNotifier([]);

  bool isInit = false;

  Future<List<BloggerModel>?> _getData({
    required int page,
    required int pageSize,
    required String type,
  }) async {
    final param = {
      'type': type,
      'page': page,
      'limit': pageSize,
    };

    final result = await _domain.getConstructByApiLink(
      apiLink: widget.url,
      params: param,
    );

    if (!isInit) {
      setState(() {
        isInit = true;
      });
    }

    if (result.isValid) {
      if (result.data['banners'] case final List data when data.isNotEmpty && _bannersNotifier.value.isEmpty) {
        final banner = data.map((x) => BannerModel.fromJson(x)).toList();
        _bannersNotifier.value = banner;
        tips = _homeConfig.config.forumTips ?? [];
      }
      final List<BloggerModel>? rank = result.data['rank']?.map<BloggerModel>((x) => BloggerModel.fromJson(x)).toList();

      _userNotifier.patchUserFollowStatus(rank
              ?.where((user) => user.isFollow == 1)
              .map((user) => '${user.aff}') ??
          [],[]);

      return rank;
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
            tips: tips,
          ),
        ),
      ],
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
        child: TabBarWithView.fillColor(
          tabBarPadding: EdgeInsets.symmetric(vertical: 6.w),
          tabBarHeight: 32.w,
          isScrollable: true,
          titles: isInit ? [for (final title in _titles) title.title] : [],
          views: [
            for (final NavigatorModel nav in _titles)
              MyListView.list(
                padding: EdgeInsets.only(bottom: MyTheme.pagePadding),
                itemBuilder: (context, item, index) => _BloggerCard(
                  user: item,
                  type: nav.type,
                ),
                onFetchingMore: (currentPage, pageSize) => _getData(page: currentPage, pageSize: pageSize, type: nav.type),
              )
          ],
        ),
      ),
    );
  }
}

class _NormalView extends StatefulWidget {
  const _NormalView({required this.id, required this.url});

  final int id;
  final String url;

  @override
  State<_NormalView> createState() => _NormalViewState();
}

class _NormalViewState extends State<_NormalView> {
  late final _domain = context.read<DynamicDomain>();
  late final _userNotifier = context.read<UserNotifier>();
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final _titles = _homeConfig.config.originalSortNav ?? [];

  List<TipModel> tips = [];

  final ValueNotifier<List<BannerModel>> _bannersNotifier = ValueNotifier([]);
  final ValueNotifier<List<BloggerModel>> _rankNotifier = ValueNotifier([]);

  bool isInit = false;

  Future<List<PostModel>?> _getData({
    required int page,
    required int pageSize,
    required String sort,
  }) async {
    final param = {
      'sort': sort,
      'page': page,
      'limit': pageSize,
      'id': widget.id,
    };

    final result = await _domain.getConstructByApiLink(
      apiLink: widget.url,
      params: param,
    );

    if (!isInit) {
      setState(() {
        isInit = true;
      });
    }

    if (result.isValid) {
      if (result.data['banners'] case final List data when data.isNotEmpty && _bannersNotifier.value.isEmpty) {
        final banner = data.map((x) => BannerModel.fromJson(x)).toList();
        _bannersNotifier.value = banner;
        tips = _homeConfig.config.forumTips ?? [];
      }

      if (result.data['rank'] case final List data when data.isNotEmpty && _rankNotifier.value.isEmpty) {
        final rank = data.map((x) => BloggerModel.fromJson(x)).toList();
        _rankNotifier.value = rank;
      }
      final List<PostModel>? posts = result.data['posts']?.map<PostModel>((x) => PostModel.fromJson(x)).toList();

      _userNotifier.patchUserFollowStatus(
        posts
                ?.where((post) => post.user?.isFollow == 1)
                .map((post) => '${post.user?.aff}') ??
            [],[]
      );
      return posts;
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  Widget rankWidet() {
    return ValueListenableBuilder(
      valueListenable: _rankNotifier,
      builder: (context, value, _) {
        if (value.isEmpty) return const SizedBox.shrink();
        return Row(
          children: [
            Expanded(
              child: Container(
                height: 70.w,
                margin: EdgeInsets.only(bottom: 12.w, top: 10.w),
                // color: Colors.deepOrange,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: value
                        .map((e) => Padding(
                              padding: EdgeInsets.only(right: 20.w),
                              child: _BloggerAvatarCard(user: e, type: 'rank'),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            ReportGestureDetector(
              onTap: () {
                eventBus.fire(MyEvent('to-blogger'));
              },
              child: Container(
                width: 23.w,
                height: 65.w,
                decoration: BoxDecoration(
                  color: MyTheme.blueColor64,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15.w),
                    bottomRight: Radius.circular(15.w),
                  ),
                ),
                alignment: Alignment.center,
                child: Text('ckgdv'.tr(), style: MyTheme.white12.h1),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NestedScrollView(
          headerSliverBuilder: (_, __) => [
            SliverToBoxAdapter(
              child: _Header(bannersNotifier: _bannersNotifier, tips: tips),
            ),
          ],
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
            child: TabBarWithView.fillColor(
              tabBarPadding: EdgeInsets.symmetric(vertical: 6.w),
              tabInterMargin: 6,
              tabBarHeight: 32.w,
              isScrollable: true,
              titles: isInit ? [for (final title in _titles) title.title] : [],
              views: [
                for (final NavigatorModel nav in _titles)
                  MyListView.list(
                    contentPadding: 15.w,
                    padding: EdgeInsets.only(top: 5.w, bottom: MyTheme.pagePadding),
                    header: rankWidet(),
                    itemBuilder: (context, item, index) {
                      if (nav.type == 'rank') {
                        //榜单列表前三个数据显示top1\top2\top3
                        item.index = index;
                      } else if (widget.id == 54 && nav.type == 'recommend') {
                        //推荐列表也显示top1\top2\top3 -- 2024.9.11
                        item.index = index;
                      }
                      return PostCard.community(data: item);
                    },
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
              child: MyImage.asset(
                MyImagePaths.appIssueIcon,
                width: 50.w,
                height: 50.w,
              ),
            ))
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
      builder: (context) => DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF23262f),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.w),
            topRight: Radius.circular(10.w),
          ),
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
                      child: MyImage.asset(
                        MyImagePaths.appIssueClose,
                        width: 15.w,
                        height: 15.w,
                      ),
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
                        CommunityIssueRoute(type: issue.type, topicType: CommunityIssueTopicType.original).push(context);
                      },
                      child: Column(
                        children: [
                          MyImage.asset(
                            issue.iconName,
                            width: 50.w,
                            height: 52.7.w,
                          ),
                          SizedBox(height: 4.w),
                          Text(
                            issue.title,
                            style: MyTheme.gray163_15,
                          )
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
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.bannersNotifier,
    required this.tips,
  });

  final ValueNotifier<List<BannerModel>> bannersNotifier;
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
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.w),
          child: CommonUtils.buildNotifyWidget(tips),
        ),
      ],
    );
  }
}

class _BloggerCard extends StatelessWidget {
  const _BloggerCard({required this.user, required this.type});

  final BloggerModel user;
  final String type;

  @override
  Widget build(BuildContext context) {
    final thumb = user.thumb ?? '';
    final nickname = user.nickName ?? '';
    final userAgent = user.agent ?? 0;
    final aff = '${user.aff}';

    final tip = switch (type) {
      'like' => '${tr("dz")}${CommonUtils.renderNumber(user.likeCt ?? 0)}',
      'view' => '${tr("rq")}${CommonUtils.renderNumber(user.viewCt ?? 0)}',
      _ => '${tr("fans")}${CommonUtils.renderNumber(user.fansCt ?? 0)}',
    };

    return Column(
      children: [
        SizedBox(height: 10.w),
        ReportGestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            UserCenterRoute(aff).push(context);
          },
          child: Row(
            children: [
              MyAvatar(thumb: thumb, size: 50.w),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(nickname, style: MyTheme.white255_15_M),
                        SizedBox(width: 2.w),
                        if (userAgent == 1)
                          Icon(
                            Icons.verified_sharp,
                            size: 14.w,
                            color: const Color.fromRGBO(247, 208, 93, 1),
                          )
                      ],
                    ),
                    SizedBox(height: 2.w),
                    Text(
                      tip,
                      style: TextStyle(color: const Color(0xFFc6c7d9), fontSize: 12.sp),
                    )
                  ],
                ),
              ),
              SizedBox(width: 5.w),
              Selector<UserNotifier, bool>(
                selector: (_, notifier) => notifier.userFollowingStatus.contains(aff),
                builder: (_, isFollowed, __) => FollowButton(
                  isFollowed: isFollowed,
                  onTap: () => context.read<UserNotifier>().changeUserFollow(aff),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.w),
        Container(color: const Color.fromARGB(25, 255, 255, 255), height: 0.5)
      ],
    );
  }
}

class _BloggerAvatarCard extends StatelessWidget {
  const _BloggerAvatarCard({required this.user, required this.type});

  final BloggerModel user;
  final String type;

  @override
  Widget build(BuildContext context) {
    final thumb = user.thumb ?? '';
    final nickname = user.nickName ?? '';
    final userAgent = user.agent ?? 0;
    final aff = '${user.aff}';

    final tip = switch (type) {
      'like' => '${tr("dz")}${CommonUtils.renderNumber(user.likeCt ?? 0)}',
      'view' => '${tr("rq")}${CommonUtils.renderNumber(user.viewCt ?? 0)}',
      _ => '${tr("fans")}${CommonUtils.renderNumber(user.fansCt ?? 0)}',
    };

    return SizedBox(
      width: 45.w,
      // height: 66.w,
      child: ReportGestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            UserCenterRoute(aff).push(context);
          },
          child: Column(children: [
            MyAvatar(thumb: thumb, size: 45.w),
            SizedBox(height: 5.w),
            Text(nickname, style: MyTheme.white244_12),
          ])),
    );
  }
}
