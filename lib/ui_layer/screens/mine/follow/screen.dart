import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:provider/provider.dart';

import '../../../../domain/api_validator.dart';
import '../../../../domain/domain.dart';
import '../../../../domain/model/follow_user_model.dart';
import '../../../../domain/model/topic_model.dart';
import '../../../../domain/type_def.dart';
import '../../../notifiers/user_notifier.dart';
import '../../../router/routes.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/keep_alive_wrapper.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/my_avatar.dart';
import '../../common_widgets/my_image.dart';
import '../../common_widgets/my_list_view.dart';
import '../../common_widgets/my_tab_bar.dart';
import '../../common_widgets/screen_background.dart';
import '../../theme.dart';

class MineFollowingScreen extends StatefulWidget {
  const MineFollowingScreen({super.key});

  @override
  State<MineFollowingScreen> createState() => _MineFollowingScreenState();
}

class _MineFollowingScreenState extends State<MineFollowingScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: 'wdgz'.tr(context: context),
        ),
        body: TabBarWithView.line(
          indicatorType: IndicatorType.light,
          tabBarPadding: EdgeInsets.symmetric(
            vertical: 0.w,
            horizontal: MyTheme.pagePadding,
          ),
          labelStyle: MyTheme.jellyCyan_15,
          unselectedLabelStyle: TextStyle(
            color: const Color.fromRGBO(255, 255, 255, 1),
            fontSize: 15.sp,
            overflow: TextOverflow.visible,
            decoration: TextDecoration.none,
          ),
          // tabBarHeight: 40.w,
          isScrollable: false,
          titles: [
            'yhu'.tr(context: context),
            'htt'.tr(context: context),
          ],
          views: const [
            KeepAliveWrapper(
              child: FollowingUserView(),
            ),
            KeepAliveWrapper(
              child: FollowingTopic(),
            ),
          ],
        ),
      ),
    );
  }
}

class FollowingUserView extends StatefulWidget {
  const FollowingUserView({super.key});

  @override
  State<FollowingUserView> createState() => _FollowingUserViewState();
}

class _FollowingUserViewState extends State<FollowingUserView> {
  late final userDomain = context.read<UserDomain>();

  late final userNotifier = context.read<UserNotifier>();

  String lastIx = '';
  Future<List<FollowingUserData>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final res = await userDomain.userListFollow(
        page: page,
        limit: pageSize,
        lastIx: page == 1 ? '' : lastIx
    );

    if (res.isValid) {
      lastIx = res.data?.lastIx ?? '';
      userNotifier.patchUserFollowStatus(
          res.data?.followFansModelList?.map((e) => '${e.aff}') ?? [],[]);
    } else if (res.msg case final msg? when msg.isNotEmpty) {
      MyToast.showText(text: msg);
    }

    return res.data!.followFansModelList!;
  }

  Widget _buildTile(FollowingUserData data) {
    final aff = '${data.aff}';
    return Column(children: [
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          UserCenterRoute(aff).push(context);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyAvatar(size: 50.w, thumb: data.thumb),
            SizedBox(width: 9.5.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${data.nickname}', style: MyTheme.white16medium),
                  SizedBox(
                    height: 8.w,
                  ),
                  Text(
                    '${data.exp ?? 0}${'jfen'.tr(context: context)}',
                    style: MyTheme.whiteOpacity614w400,
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                await userNotifier.changeUserFollow(aff);
              },
              child: Selector<UserNotifier, bool>(
                  selector: (_, notifier) =>
                      notifier.userFollowingStatus.contains(aff),
                  builder: (_, isFollowed, __) {
                    if (isFollowed) {
                      return Container(
                        width: 65.w,
                        height: 25.w,
                        decoration: BoxDecoration(
                            color: MyTheme.cyanColor00edfd,
                            borderRadius: BorderRadius.circular(4.w)),
                        child: Center(
                            child: Text(tr('qxgz'), style: MyTheme.white11)),
                      );
                    }
                    return Container(
                      width: 65.w,
                      height: 25.w,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: MyTheme.cyanColor00edfd,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(12.5.w)),
                      child: Center(
                          child: Text(tr('jgz'), style: MyTheme.jellyCyan_11)),
                    );
                  }),
            )
          ],
        ),
      ),
      SizedBox(height: 10.w),
      Container(
        color: const Color.fromARGB(25, 255, 255, 255),
        height: 0.5,
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      padding: EdgeInsets.all(MyTheme.pagePadding),
      contentPadding: 10.w,
      itemBuilder: (context, item, index) => _buildTile(item),
      onFetchingMore: (currentPage, pageSize) =>
          _getData(page: currentPage, pageSize: pageSize),
    );
  }
}

class FollowingTopic extends StatefulWidget {
  const FollowingTopic({super.key});

  @override
  State<FollowingTopic> createState() => _FollowingTopicState();
}

class _FollowingTopicState extends State<FollowingTopic> {
  late final communityDomain = context.read<CommunityDomain>();

  Future<List<TopicModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final res = await communityDomain.focusTops(page: page, limit: pageSize);

    if (res.msg case final msg? when msg.isNotEmpty) {
      MyToast.showText(text: msg);
    }

    return res.data!;
  }

  Widget _buildTile(TopicModel data) {
    final w = (1.sw - MyTheme.pagePadding * 2 - 10.w) / 2;
    return SizedBox(
      width: w,
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              CommunityTagDetailRoute('${data.id}').push(context);
            },
            child: SizedBox(
              height: w / 170 * 75,
              child: Stack(
                children: [
                  MyImage.network(
                    data.bgThumb,
                    borderRadius: 6.w,
                  ),
                  Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.w),
                            gradient: const LinearGradient(colors: [
                              Color.fromRGBO(176, 66, 255, 0.45),
                              Color.fromRGBO(255, 133, 164, 0.45),
                            ]),
                          ),
                        ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          data.name,
                          style: MyTheme.white18semibold,
                        ),
                      ),
                      SizedBox(height: 2.w),
                      Center(
                        child: Text(
                          "${data.postNum}${'tiez'.tr(context: context)}",
                          style: MyTheme.white_13,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 8.5.w),
          StatefulBuilder(builder: (_, setState) {
            final isFollowing = data.isFollow == 1;
            bool isLoading = false;
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                if (isLoading) return;
                isLoading = true;

                final communityDomain = context.read<CommunityDomain>();
                final res = await communityDomain.communityFollowTopic(
                    topicId: '${data.id}');
                if (res.isValid) {
                  if (mounted) {
                    setState(() {
                      data.isFollow = isFollowing ? 0 : 1;
                    });
                  }
                } else if (res.msg case final msg? when msg.isNotEmpty) {
                  MyToast.showText(text: msg);
                }

                isLoading = false;
              },
              child: Container(
                width: 65.w,
                height: 20.w,
                decoration: BoxDecoration(
                    color: isFollowing
                        ? MyTheme.cyanColor00edfd
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4.w),
                    border: Border.all(
                        color: isFollowing
                            ? Colors.transparent
                            : MyTheme.cyanColor00edfd,
                        width: 0.5.w)),
                child: Center(
                  child: Text(
                    isFollowing ? tr('qxgz') : '+ ${tr('gz')}',
                    style: isFollowing ? MyTheme.white11 : MyTheme.blue80_11,
                  ),
                ),
              ),
            );
          })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      padding: EdgeInsets.all(MyTheme.pagePadding),
      itemBuilder: (context, item, index) => _buildTile(item),
      childAspectRatio: 204 / 138,
      mainAxisSpacing: 10.w,
      crossAxisSpacing: 20.w,
      onFetchingMore: (currentPage, pageSize) =>
          _getData(page: currentPage, pageSize: pageSize),
    );
  }
}