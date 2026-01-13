import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/model/post_model.dart';
import 'package:jygf/domain/model/topic_model.dart';
import 'package:jygf/domain/remote_domain/domains/community.dart';
import 'package:jygf/domain/type_def.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/follow_button.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_avatar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/post/card/card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';
import 'package:jygf/report/ui_layer/report_general_banner.dart';



class FollowScreen extends StatefulWidget {
  const FollowScreen({super.key});

  @override
  State<FollowScreen> createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> with TickerProviderStateMixin {
  late final _appDomain = context.read<CommunityDomain>();
  final ValueNotifier<List<BannerModel>> _bannersNotifier = ValueNotifier([]);
  final ValueNotifier<List<TipModel>> _tipsNotifier = ValueNotifier([]);
  final _titles = [
    '话题',
    '用户',
  ];
  bool _isInit = false;
  int _initialIndex = 0;
  late final TabController? tabController;

  Future<void> _getNoticeList() async {
    final noticeResult = await _appDomain.getNoticeList();
    if (noticeResult.status == 1) {
      if (noticeResult.data case final data? when data.isNotEmpty) {
        _tipsNotifier.value = data;
      }
    } else {
      CommonUtils.log('获取公告失败 :${noticeResult.msg}');
    }
  }

  Future<List<TopicModel>> _getTopics() async {
    final followTopicResult = await _appDomain.getFollowTopicList();
    if (followTopicResult.status == 1) {
      _getNoticeList();
      if (followTopicResult.data?.banner case final data? when data.isNotEmpty) {
        _bannersNotifier.value = data;
      }

      if (!_isInit) {
        _isInit = true;
        tabController = TabController(initialIndex: _initialIndex, length: _titles.length, vsync: this);
        setState(() {});
      }

      if (followTopicResult.data?.topics case final topics? when topics.isNotEmpty) {
        return topics;
      }
    } else {
      MyToast.showText(text: followTopicResult.msg ?? '');
    }

    return [];
  }

  Future<List<PostModel>> _getUsers() async {
    final followUserResult = await _appDomain.getFollowUserList();
    if (followUserResult.status == 1) {
      _getNoticeList();
      if (followUserResult.data?.banner case final data? when data.isNotEmpty) {
        _bannersNotifier.value = data;
      }
      if (!_isInit) {
        _isInit = true;
        tabController = TabController(initialIndex: _initialIndex, length: _titles.length, vsync: this);
        setState(() {});
      }

      if (followUserResult.data?.posts case final posts? when posts.isNotEmpty) {
        return posts;
      }
    } else {
      MyToast.showText(text: followUserResult.msg ?? '');
    }

    return [];
  }

  @override
  void initState() {
    _getTopics();
    _getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return Text('什么玩意');
    return !_isInit
        ? const LoadingView()
        : NestedScrollView(
            headerSliverBuilder: (_, __) => [
              SliverToBoxAdapter(
                child: _Header(
                  bannersNotifier: _bannersNotifier,
                  tipsNotifier: _tipsNotifier,
                ),
              ),
            ],
            body: TabBarWithView.line(
              initialIndex: _initialIndex,
              tabController: tabController,
              tabBarHeight: 44.w,
              tabBarPadding: EdgeInsets.symmetric(vertical: 0.w),
              gradientColors: MyTheme.gradient_follow_colors,
              labelStyle: TextStyle(color: const Color.fromRGBO(255, 211, 123, 1), fontSize: 16.sp, fontWeight: FontWeight.w600),
              unselectedLabelStyle: TextStyle(color: const Color.fromRGBO(255, 255, 255, 0.8), fontSize: 16.sp, fontWeight: FontWeight.w500),
              isScrollable: true,
              isCenter: true,
              titles: _titles,
              tabBarBottomWidget: Divider(color: MyTheme.primaryColor_01, height: 0.6.w),
              views: [
                _TopicListView(fetchMoreCallback: (currentPage, pageSize) => _getTopics()),
                _UserListView(fetchMoreCallback: (currentPage, pageSize) => _getUsers()),
              ],
            ),
          );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.bannersNotifier,
    required this.tipsNotifier,
  });

  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final ValueNotifier<List<TipModel>> tipsNotifier;

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
            valueListenable: tipsNotifier,
            builder: (context, tips, child) {
              if (tips.isEmpty) return const SizedBox.shrink();

              return Padding(padding: EdgeInsets.only(top: 10.w, bottom: 0.w), child: CommonUtils.buildNotifyWidget(tips));
            }),
      ],
    );
  }
}

class _TopicListView extends StatelessWidget {
  final Future<List<TopicModel>> Function(int currentPage, int pageSize) fetchMoreCallback;

  const _TopicListView({required this.fetchMoreCallback});

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      padding: EdgeInsets.only(top: 2.w, bottom: MyTheme.pagePadding),
      itemBuilder: (context, item, index) => _TopicItem(data: item, index: index),
      onFetchingMore: fetchMoreCallback,
    );
  }
}

class _UserListView extends StatelessWidget {
  final Future<List<PostModel>> Function(int currentPage, int pageSize) fetchMoreCallback;

  const _UserListView({required this.fetchMoreCallback});

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      contentPadding: 15.w,
      padding: EdgeInsets.only(top: 2.w, bottom: MyTheme.pagePadding),
      itemBuilder: (context, item, index) => PostCard.community(data: item, backgroundColor: const Color.fromRGBO(0, 0, 0, 0)),
      onFetchingMore: fetchMoreCallback,
    );
  }
}

class _TopicItem extends StatefulWidget {
  final TopicModel data;
  final int index;

  const _TopicItem({required this.data, required this.index});

  @override
  State<_TopicItem> createState() => _TopicItemState();
}

class _TopicItemState extends State<_TopicItem> {
  @override
  Widget build(BuildContext context) {
    return ReportGestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        CommunityTagDetailRoute('${widget.data.id}').push(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 15.w),
          Row(
            children: [
              SizedBox(width: MyTheme.pagePadding),
              MyAvatar(thumb: widget.data.thumb, size: 40.w),
              SizedBox(width: 8.w),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.data.name, style: MyTheme.white255_15_M),
                  SizedBox(height: 5.w),
                  Text(
                    '${widget.data.postNum}${'tiez'.tr(context: context)}',
                    style: MyTheme.white255_12,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const Spacer(),
              _TopicFollowButton(widget.data),
              SizedBox(width: MyTheme.pagePadding),
            ],
          ),
          if (widget.data.postList case final posts? when posts.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: MyTheme.pagePadding, right: MyTheme.pagePadding, bottom: 15.w),
              child: GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 15.w, bottom: 2.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 7.w,
                  crossAxisSpacing: 7.w,
                  childAspectRatio: 11 / 17.4,
                ),
                itemCount: min(posts.length, 3),
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final itemData = posts[index];
                  final postMedia = itemData.medias;
                  if (postMedia == null || postMedia.isEmpty) return const SizedBox.shrink();

                  final title = itemData.title;
                  final cover = postMedia.first.cover;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 110.w,
                        height: 150.w,
                        child: MyImage.network(
                          cover,
                          borderRadius: 5.w,
                          fit: BoxFit.cover,
                          backgroundColor: MyTheme.imageBgColor,
                        ),
                      ),
                      SizedBox(height: 5.w),
                      Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: MyTheme.white255_12.s14),
                    ],
                  );
                },
              ),
            ),
          Divider(color: MyTheme.primaryColor_01, height: 0.6.w),
        ],
      ),
    );
  }
}

class _TopicFollowButton extends StatefulWidget {
  final TopicModel data;
  const _TopicFollowButton(this.data);

  @override
  State<_TopicFollowButton> createState() => _TopicFollowButtonState();
}

class _TopicFollowButtonState extends State<_TopicFollowButton> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (_, setState) {
      final isFollowed = widget.data.isFollow == 1;
      bool isLoading = false;

      return FollowButton(
        isFollowed: isFollowed,
        onTap: () async {
          if (isLoading) return;
          isLoading = true;

          final communityDomain = context.read<CommunityDomain>();
          final res = await communityDomain.communityFollowTopic(topicId: '${widget.data.id}');
          if (res.isValid) {
            setState(() {
              widget.data.isFollow = isFollowed ? 0 : 1;
            });
          } else if (res.msg case final msg? when msg.isNotEmpty) {
            MyToast.showText(text: msg);
          }

          isLoading = false;
        },
      );
    });
  }
}

