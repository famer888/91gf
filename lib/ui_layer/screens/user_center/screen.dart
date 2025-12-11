import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/model/collection_model.dart';
import 'package:jygf/domain/type_def.dart';
import 'package:jygf/ui_layer/screens/common_widgets/feed/feed_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/follow_button.dart';
import 'package:jygf/ui_layer/screens/common_widgets/gradient_border.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/mine/common_widgets/video_tile.dart';
import 'package:jygf/ui_layer/screens/vlog/card/vlog_card.dart';
import 'package:provider/provider.dart';

import '../../../domain/async_value.dart';
import '../../../domain/domain.dart';
import '../../../domain/model/creator_info_model.dart';
import '../../../domain/model/member_model.dart';
import '../../notifiers/user_notifier.dart';
import '../../router/routes.dart';
import '../../utils/common_utils.dart';
import '../../utils/my_toast.dart';
import '../common_widgets/member_vip.dart';
import '../common_widgets/my_avatar.dart';
import '../common_widgets/post/center/post_center.dart';
import '../common_widgets/screen_background.dart';
import '../common_widgets/status/loading.dart';
import '../common_widgets/status/network_error.dart';
import '../theme.dart';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:jygf/app_global.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/model/vlog_model.dart';
import 'package:jygf/ui_layer/const.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';

class UserCenterScreen extends StatefulWidget {
  const UserCenterScreen({super.key, required this.aff, this.index = 0});

  final String aff;
  final int? index;

  @override
  State<UserCenterScreen> createState() => _UserCenterScreenState();
}

class _UserCenterScreenState extends State<UserCenterScreen> {
  late final domain = context.read<AppDomain>();
  late final communityDomain = context.read<CommunityDomain>();

  AsyncValue<CreatorInfo> _asyncValue = const AsyncInit();
  final _topicBarKey = GlobalKey<_UserTopicBarWidgetState>();
  var controller = ScrollController();
  late final userNotifier = context.read<UserNotifier>();
  late final homeConfig = context.read<HomeConfigNotifier>();

  @override
  void initState() {
    _initData();
    super.initState();

    controller.addListener(() {
      double opacity = controller.offset / 180.w;
      _topicBarKey.currentState?.updateOpacityAction(opacity);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _initData() async {
    if (_asyncValue.isLoading) return;
    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final res = await communityDomain.peerCenterInfo(aff: widget.aff);

    if (res.data case final data?) {
      _asyncValue = AsyncData(data);
    } else {
      if (res.msg case final msg? when msg.isNotEmpty) {
        MyToast.showText(
          text: msg,
        );
      }
      _asyncValue = const AsyncError();
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        body: _asyncValue.maybeWhen(
            orElse: () => const LoadingView(),
            error: (_, __) => Column(
                  children: [
                    UserTopicBarWidget('', key: _topicBarKey),
                    Expanded(child: NetworkErrorView(onTap: _initData)),
                  ],
                ),
            data: (data) => configContent(data)),
      ),
    );
  }

  Widget configContent(CreatorInfo data) {
    return Stack(children: [
      SizedBox(
        width: double.infinity,
        height: 240.w,
        child: const MyImage.asset(MyImagePaths.appUserCenterBg, fit: BoxFit.fill),
      ),
      Column(
        children: [
          UserTopicBarWidget(data.nickname ?? '', key: _topicBarKey),
          Expanded(
            child: NestedScrollView(
              controller: controller,
              headerSliverBuilder: (_, __) => [
                SliverToBoxAdapter(child: configUserInfoView(data)),
              ],
              body: configSubListView(data),
            ),
          ),
        ],
      ),
    ]);
  }

  Future<void> _buyData(CreatorInfo data) async {
    MyToast.showLoading();
    Map<String, dynamic> param = Map.from({})..['aff'] = data.aff;
    final result = await domain.getConstructByApiLink(
      apiLink: 'user/buy',
      params: param,
    );

    MyToast.closeAllLoading();

    if (result.status == 1) {
      userNotifier.setMoney(money: userNotifier.member.money - (data.coins ?? 0));
      data.contact = result['data']['contact'];
      _asyncValue = AsyncData(data);
      setState(() {});
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
  }

  Widget configUserInfoView(CreatorInfo data) {
    final aff = '${data.aff}';

    final city = (data.city?.isNotEmpty ?? false) ? data.city : '火星';
    final sex = data.sex == 0 ? '保密' : (data.sex == 1 ? '男' : '女');
    List<String> tags = (data.fetish ?? '').split(',').where((element) => element.isNotEmpty).toList();
    String tagsStr = ' ';
    for (String e in tags) {
      final String str = '#$e ';
      tagsStr = tagsStr + str;
    }

    return Selector<UserNotifier, Member>(
      builder: (_, member, __) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 10.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  MyAvatar(
                    margin: 2,
                    size: 62.w,
                    thumb: data.thumb,
                    gradient: const LinearGradient(colors: [Color.fromRGBO(255, 255, 255, 1), Color.fromRGBO(255, 255, 255, 1)]),
                  ),
                  SizedBox(width: 8.w),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(data.nickname ?? 'kkyh'.tr(context: context), style: MyTheme.white16bold),
                        SizedBox(width: 5.w),
                        MemberVipWidget(vipImage: data.vipImg),
                      ],
                    ),
                    SizedBox(height: 6.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyImage.asset(MyImagePaths.appVIcon, width: 14.5.w, height: 14.5.w),
                        SizedBox(width: 2.w),
                        Text('kkyhrz'.tr(context: context), style: MyTheme.white255_12),
                      ],
                    )
                  ]),
                  const Spacer(),
                  member.uuid == data.uuid
                      ? const SizedBox.shrink()
                      : GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            if ((member.username ?? '').isEmpty) {
                              MyToast.showText(text: 'zcyhcz'.tr(context: context));
                              return;
                            }
                            final uuid = data.uuid!;
                            final nick = data.nickname!;
                            final url = data.thumb?.isNotEmpty == true ? data.thumb! : ' ';
                            ChatMessageRoute(nickName: Uri.encodeComponent(nick), thumb: Uri.encodeComponent(url), toUuid: uuid).push(context);
                          },
                          child: Container(
                            height: 25.w,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.5), width: 1.w),
                              borderRadius: BorderRadius.all(Radius.circular(5.w)),
                            ),
                            child: Text('sxta'.tr(context: context), style: MyTheme.white12.w500),
                          ),
                        ),
                  member.uuid == data.uuid
                      ? const SizedBox.shrink()
                      : Selector<UserNotifier, bool>(
                          selector: (_, notifier) => notifier.userFollowingStatus.contains('${data.aff}'),
                          builder: (_, isFollowed, __) {
                            return Container(
                              margin: EdgeInsets.only(left: 6.w),
                              child: FollowButton(
                                  isFollowed: isFollowed,
                                  horizontal: 6.w,
                                  onTap: () async {
                                    await userNotifier.changeUserFollow('${data.aff}');
                                  }),
                            );
                          }),
                ],
              ),
              SizedBox(height: 15.w),
              Row(
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(text: CommonUtils.renderFixedNumber(data.followCount ?? 0), style: MyTheme.white255_13_M.s14),
                      WidgetSpan(child: SizedBox(width: 8.w)),
                      WidgetSpan(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 3.w),
                          child: Container(
                            height: 10.w,
                            width: 1.w,
                            color: const Color.fromRGBO(255, 255, 255, 0.7),
                          ),
                        ),
                      ),
                      WidgetSpan(child: SizedBox(width: 8.w)),
                      TextSpan(text: '${'fans'.tr(context: context)}  ', style: MyTheme.white255_13_M.w400.white25507),
                    ]),
                  ),
                  SizedBox(width: 30.w),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(text: CommonUtils.renderFixedNumber(data.likesCount ?? 0), style: MyTheme.white255_13_M.s14),
                      WidgetSpan(child: SizedBox(width: 8.w)),
                      WidgetSpan(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 3.w),
                          child: Container(
                            height: 10.w,
                            width: 1.w,
                            color: const Color.fromRGBO(255, 255, 255, 0.7),
                          ),
                        ),
                      ),
                      WidgetSpan(child: SizedBox(width: 8.w)),
                      TextSpan(text: '${'hz'.tr(context: context)}  ', style: MyTheme.white255_13_M.w400.white25507),
                    ]),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      selector: (_, notifier) => notifier.member,
    );
  }

  Widget _contactView(CreatorInfo data) {
    return data.hasContact == 1
        ? (data.contact?.isNotEmpty ?? false)
            ? GestureDetector(
                onTap: () {
                  //解锁联系方式
                  if (data.contact?.isNotEmpty ?? false) {
                    CommonUtils.copyToClipboard(text: data.contact ?? '');
                    MyToast.showText(text: 'fzcgqxz'.tr(context: context));
                    return;
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10.w),
                  child: Text(data.contact ?? '', style: MyTheme.white07_12, maxLines: 10),
                ),
              )
            : GestureDetector(
                onTap: () {
                  _buyData(data);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: DottedDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4.w)), shape: Shape.box, color: MyTheme.blueColor63, strokeWidth: 1.w),
                  margin: EdgeInsets.only(bottom: 10.w),
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  height: 40.w,
                  child: Text((data.contact?.isNotEmpty ?? false) ? data.contact ?? '' : data.payTip ?? 'jslxfs'.tr(context: context),
                      style: MyTheme.blue80_13_M, textAlign: TextAlign.center, maxLines: 2),
                ),
              )
        : Container();
  }

  Widget configSubListView(CreatorInfo data) {
    return Container(
        padding: EdgeInsets.only(top: 10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.w),
            topRight: Radius.circular(16.w),
          ),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.w),
                topRight: Radius.circular(16.w),
              ),
              child: Transform.translate(
                offset: const Offset(0, -5), // 向上移动 5 像素
                child: Image.asset(
                  MyImagePaths.appIssueBg,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            TabBarWithView.fillColor(
              tabBarPadding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 16.w),
              tabBarHeight: 32.w,
              borderRadius: 5.w,
              isScrollable: true,
              initialIndex: widget.index ?? 0,
              titles: [
                'csp'.tr(context: context),
                'dsp'.tr(context: context),
                'tiezt'.tr(context: context),
              ],
              views: [
                KeepAliveWrapper(child: _VideoView(aff: widget.aff)),
                KeepAliveWrapper(child: _VlogVideoView(aff: widget.aff)),
                KeepAliveWrapper(child: PostCenter(aff: widget.aff)),
              ],
            ),
          ],
        ));
  }
}

class _VlogVideoView extends StatefulWidget {
  const _VlogVideoView({this.aff});

  final String? aff;

  @override
  State<_VlogVideoView> createState() => _VlogVideoViewState();
}

class _VlogVideoViewState extends State<_VlogVideoView> {
  late final _domain = context.read<VlogDomain>();
  List<VlogModel> array = [];

  int _page = 1;
  int _limit = 15;

  Future<List<VlogModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    _page = page;
    _limit = pageSize;

    final result = await _domain.otherUserVlogList(aff: int.parse(widget.aff ?? '0'), page: page, limit: pageSize);
    if (result.isValid) {
      List<VlogModel> tp = List.from(result.data ?? []);
      if (page == 1) {
        array = tp;
      } else {
        array.addAll(tp);
      }
      return tp;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
      childAspectRatio: UILayerConst.vlogVideoRatio,
      crossAxisSpacing: 10.w,
      itemBuilder: (_, item, index) => VlogCard(
          data: item,
          onTapFunc: (type) {
            if (type == 1) {
              //点击短视频视频
              AppGlobal.shortVideosInfo = {
                'list': array,
                'page': _page,
                'index': index,
                'api': 'vlog/list_peer',
                'params': {
                  'aff': widget.aff,
                  'limit': _limit,
                }
              };
              const VlogSecondRoute().push(context);
            } else {
              //广告类型
              CommonUtils.openRoute(context, item.toJson());
            }
          }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _VideoView extends StatefulWidget {
  const _VideoView({required this.aff});

  final String aff;

  @override
  State<_VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<_VideoView> {
  late final _appDomain = context.read<AppDomain>();

  Future<List<MineVideoCardData>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final param = Map.from({})
      ..['page'] = page
      ..['limit'] = pageSize
      ..['aff'] = widget.aff;

    final result = await _appDomain.getConstructByApiLink(
      apiLink: 'mv/peer_mvs',
      params: param,
    );

    if (result.status == 1) {
      return result.data?.map<MineVideoCardData>((x) => MineVideoCardData.fromJson(x)).toList();
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      childAspectRatio: FeedCard.aspectRatio,
      mainAxisSpacing: 5.w,
      itemBuilder: (context, item, index) => MineVideoTile(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class UserTopicBarWidget extends StatefulWidget {
  final String title;

  const UserTopicBarWidget(this.title, {super.key});

  @override
  State createState() => _UserTopicBarWidgetState();
}

class _UserTopicBarWidgetState extends State<UserTopicBarWidget> {
  double opacity = 0.0;

  void updateOpacityAction(double opacity) {
    if (opacity < 0) opacity = 0;
    if (opacity > 1) opacity = 1;
    if (mounted) setState(() => this.opacity = opacity);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MyTheme.statusHeight),
      height: MyTheme.statusHeight + MyTheme.navbarHegiht,
      // color: MyTheme.bgColor.withOpacity(opacity),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        GestureDetector(
          child: Container(
            alignment: Alignment.center,
            width: 40.w,
            height: 40.w,
            child: Image.asset(MyImagePaths.appBackIcon, width: 20.w, height: 20.w),
          ),
          onTap: () {
            context.pop();
          },
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 30.w),
            child: Text(
              widget.title,
              style: TextStyle(color: Color.fromRGBO(255, 255, 255, opacity), fontSize: 16.sp, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Container(),
      ]),
    );
  }
}
