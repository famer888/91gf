import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/async_value.dart';
import '../../../../../domain/domain.dart';
import '../../../../../domain/model/member_model.dart';
import '../../../../../domain/model/welfare_task_model.dart';
import '../../../../notifiers/home_config_notifier.dart';
import '../../../../notifiers/user_notifier.dart';
import '../../../../router/routes.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_avatar.dart';
import '../../../common_widgets/my_image.dart';
import '../../../common_widgets/my_list_view.dart';
import '../../../common_widgets/status/empty_data.dart';
import '../../../common_widgets/status/loading.dart';
import '../../../common_widgets/status/network_error.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  late final config = context.read<HomeConfigNotifier>().config;
  late final userNotifier = context.read<UserNotifier>();
  late final signDomain = context.read<SignDomain>();
  AsyncValue<WelfareTaskModel> _asyncValue = const AsyncInit();

  @override
  void initState() {
    _initData();
    super.initState();
  }

  Future _initData() async {
    if (_asyncValue.isLoading) return;
    setState(() {
      _asyncValue = AsyncLoading(value: _asyncValue.data);
    });

    final res = await signDomain.signListTask(type: '');

    if (!mounted) return;

    if (res.data case final data?) {
      userNotifier.setExp(data.exp);
      _asyncValue = AsyncData(data);
    } else {
      if (res.msg case final msg?) {
        MyToast.showText(text: msg);
      }
      _asyncValue = const AsyncError();
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future _signUp() async {
    MyToast.showLoading();
    final res = await signDomain.signUp();
    MyToast.closeAllLoading();
    if (res.isValid) {
      await context.read<UserNotifier>().init(); //签到成功更新用户数据
      _initData(); //刷新当前界面数据
    } else if (res.msg case final msg?) {
      MyToast.showText(text: msg);
    }
  }

  Widget _buildDataView(WelfareTaskModel data) {
    return CustomScrollView(
      // physics: const BouncingScrollPhysics(
      //   parent: AlwaysScrollableScrollPhysics(),
      // ),
      slivers: [
        MyIndicator(onRefresh: _initData),
        SliverList.list(children: [
          _MemberView(data: data),
          SizedBox(height: 6.w),
          _signInContent(data),
          SizedBox(height: 13.w),
          ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20.w), topRight: Radius.circular(20.w)),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.white.withOpacity(0.03),
                  width: 1.w,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.w),
                  topRight: Radius.circular(8.w),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: Column(
                children: [
                  _Header(data: data),
                  (data.list == null || data.list?.isEmpty == true)
                      ? Column(
                          children: [
                            SizedBox(height: 20.w),
                            const PageEmptyDataView(),
                            SizedBox(height: 0.5.sh),
                          ],
                        )
                      : ListView.builder(
                          addAutomaticKeepAlives: false,
                          addRepaintBoundaries: false,
                          shrinkWrap: true,
                          cacheExtent: 1.sh,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.list?.length,
                          itemBuilder: (context, index) => _Tile(
                            data: data.list![index],
                            getTaskData: _initData,
                          ),
                        ),
                ],
              ),
            ),
          )
        ]),
      ],
    );
  }

  //签到view
  Widget _signInContent(WelfareTaskModel data) {
    return data.signRewardList == null
        ? Container()
        : Container(
            // height: 325.w,
            margin: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
            padding: EdgeInsets.all(MyTheme.pagePadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(10.w),
              color: MyTheme.white008Color,
            ),
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'zmrrw'.tr(context: context),
                    style: MyTheme.white16bold,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'ljl'.tr(context: context),
                    style: MyTheme.white04_12,
                  ),
                  const Spacer(),
                  Text(
                    'yljqd'.tr(context: context),
                    style: MyTheme.white04_12,
                  ),
                  Text(
                    ' ${data.signNum} ',
                    style: MyTheme.blue80_12,
                  ),
                  Text(
                    'tian'.tr(context: context),
                    style: MyTheme.white04_12,
                  ),
                ],
              ),
              SizedBox(height: 10.w),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 150 / 200,
                ),
                itemCount: data.signRewardList?.length ?? 0,
                itemBuilder: (context, index) => siginItem(data.signRewardList![index], data.signNum ?? 0),
              ),
              SizedBox(height: 13.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (data.signStatus == false) {
                        _signUp();
                      }
                    },
                    child: Container(
                      width: 150.w,
                      height: 40.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(20.w),
                        gradient: data.signStatus == true ? MyTheme.gradient_228_246 : MyTheme.shareButtonGradient,
                      ),
                      child: Selector<UserNotifier, Member?>(
                        selector: (_, notifier) => notifier.member,
                        builder: (context, member, child) {
                          return Text(data.signStatus == true ? tr('yqiandao') : tr('ljqd'), style: MyTheme.white15_M);
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 13.w),
                  GestureDetector(
                    onTap: () {
                      //兑换VIP
                      const VipCenterRoute(pageIndex: 1).push(context);
                    },
                    child: Container(
                      width: 150.w,
                      height: 40.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.circular(20.w), gradient: MyTheme.shareButtonGradient),
                      child: Text(tr('dhvp'), style: MyTheme.white15_M),
                    ),
                  ),
                ],
              )
            ]),
          );
  }

  Widget siginItem(WelfareTaskListModel data, int signNum) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(45, 48, 65, 1),
        borderRadius: BorderRadius.all(
          Radius.circular(10.w),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.title ?? '',
                  style: MyTheme.white10,
                ),
                SizedBox(height: 10.w),
                SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: MyImage.network(data.icon ?? ''),
                ),
                SizedBox(height: 5.w),
                Text(
                  data.desc ?? '',
                  style: MyTheme.blue80_11,
                ),
              ],
            ),
          ),
          // data.sort == 7
          //     ? Positioned(
          //         right: 0,
          //         top: 0,
          //         child: MyImage.asset(MyImagePaths.appSiginCZ,
          //             width: 30.w, height: 30.w))
          //     : Container(),
          (data.sort ?? 0) <= signNum
              ? Container(
                  color: Colors.black45,
                  child: Center(
                      child: Text(
                    'yqiandao'.tr(context: context),
                    style: MyTheme.white14,
                  )))
              : Container(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _asyncValue.maybeWhen(
      error: (_, __) => NetworkErrorView(onTap: _initData),
      orElse: () => const LoadingView(),
      loading: (data) {
        if (data == null) return const LoadingView();
        return _buildDataView(data);
      },
      data: _buildDataView,
    );
  }
}

class _MemberView extends StatelessWidget {
  const _MemberView({required this.data});

  final WelfareTaskModel data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.w,
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 11.5.w),
              Selector<UserNotifier, Member?>(
                selector: (_, notifier) => notifier.member,
                builder: (context, member, child) {
                  return member == null
                      ? const SizedBox.shrink()
                      : Container(
                          height: 53.w,
                          margin: EdgeInsets.all(12.5.w),
                          child: Row(
                            children: [
                              MyAvatar(
                                size: 53.w,
                                thumb: member.thumb,
                              ),
                              SizedBox(width: 9.w),
                              Expanded(
                                  child: Column(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        Text(member.nickname,
                                            style: TextStyle(
                                                color: const Color.fromRGBO(255, 255, 255, 1),
                                                fontSize: 14.sp,
                                                overflow: TextOverflow.ellipsis,
                                                decoration: TextDecoration.none)),
                                        SizedBox(width: 9.w),
                                        member.vipLevel > 0
                                            ? MyImage.asset(MyImagePaths.appTaskVipIcon, width: 39.w, height: 18.w)
                                            : const SizedBox.shrink(),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        member.vipLevel > 0
                                            ? Text('vpwxk'.tr(context: context), style: MyTheme.gray127_14)
                                            : Text('${'sygkcs'.tr(context: context)}: ${data.freeViewCnt}/${data.totalFreeViewCnt}',
                                                style: MyTheme.gray127_14),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                            ],
                          ),
                        );
                },
              ),
              GestureDetector(
                onTap: () => const VipCenterRoute().push(context),
                child: Container(
                  width: 300.w,
                  height: 40.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(20.w),
                      gradient: const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: <Color>[Color.fromRGBO(239, 205, 168, 1), Color.fromRGBO(252, 231, 207, 1)],
                      )),
                  child: Selector<UserNotifier, Member?>(
                    selector: (_, notifier) => notifier.member,
                    builder: (context, member, child) {
                      return Text(
                        member == null
                            ? ''
                            : member.vipLevel > 0
                                ? tr('xfvpbxk')
                                : tr('ktvpbxk'),
                        style: TextStyle(
                            color: const Color.fromRGBO(46, 24, 12, 1),
                            fontSize: 13.sp,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.data});

  final WelfareTaskModel data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.w),
        Row(
          children: [
            Text(
              'flrw'.tr(context: context),
              style: MyTheme.black26_18_semi,
            ),
            SizedBox(width: 10.w),
            Text(
              '${'ts'.tr(context: context)}: ${'rwwchsx'.tr(context: context)}',
              style: MyTheme.gray13,
            )
          ],
        ),
        SizedBox(height: 10.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${'yqrs'.tr(context: context)}${data.invitedNum}人',
                style: TextStyle(
                  color: const Color.fromRGBO(26, 26, 26, 1),
                  fontSize: ScreenUtil().setSp(15),
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                )),
            Selector<UserNotifier, Member?>(
                builder: (context, member, child) {
                  return Text('${'wdjf'.tr(context: context)}${member?.exp ?? ''}',
                      style: TextStyle(
                        color: const Color.fromRGBO(26, 26, 26, 1),
                        fontSize: ScreenUtil().setSp(15),
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                      ));
                },
                selector: (_, notifier) => notifier.member),
            GestureDetector(
              onTap: () async {
                const VipCenterRoute().push(context);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.w),
                child: Container(
                  width: 75.w,
                  height: 32.w,
                  decoration: const BoxDecoration(color: Color.fromRGBO(250, 217, 163, 1)),
                  child: Center(
                      child: Text(
                    tr('dhvp'),
                    style: MyTheme.brown_996619_13_M,
                  )),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.data, required this.getTaskData});

  final WelfareTaskListModel data;
  final VoidCallback getTaskData;

  /// 领取
  _tapSignListTask(BuildContext context) async {
    MyToast.showLoading();
    final Map param = {'task_id': data.id};

    final result = await context.read<SignDomain>().signListTaskAccept(param);
    result.status == 1 ? getTaskData() : MyToast.showText(text: result.msg!);

    MyToast.closeAllLoading();
  }

  @override
  Widget build(BuildContext context) {
    final int type = data.taskType!;
    int state = data.progressStatus!;

    /// 0 = 未开始，1 = 未完成 ，2 = 待领取奖励， 3 = 已经领取
    state = state == 0 ? 1 : state;
    return Container(
      constraints: BoxConstraints(minHeight: 76.w),
      child: Row(
        children: [
          SizedBox.square(
            dimension: 42.w,
            child: MyImage.network(
              data.icon ?? '',
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${data.title}',
                    style: MyTheme.black1534,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${data.subTitle}',
                    style: MyTheme.gray153_11,
                    maxLines: 30,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: () async {
              if (state == 2) {
                _tapSignListTask(context);
              } else {
                if (type == 3) {
                  if (state != 2) {
                    CommonUtils.launchUrl(data.appUrl!);
                  }
                } else if (type >= 4 && type <= 7) {
                  // text = state != 2 ? '去邀请' : '领取';
                  const MineShareToUserRoute().push(context);
                }
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.w),
              child: Container(
                width: 75.w,
                height: 32.w,
                decoration: state == 2
                    ? const BoxDecoration(gradient: MyTheme.gradient_90_114)
                    : state == 3
                        ? const BoxDecoration(color: MyTheme.grayColor150)
                        : const BoxDecoration(
                            color: Color.fromRGBO(250, 217, 163, 1),
                          ),
                child: Center(
                  child: Builder(builder: (context) {
                    String text = '';
                    text = state == 2
                        ? 'lq'.tr(context: context)
                        : state == 1
                            ? 'wwc'.tr(context: context)
                            : state == 3
                                ? 'ylq'.tr(context: context)
                                : 'wks'.tr(context: context);
                    if (type == 3) {
                      text = state == 2
                          ? 'lq'.tr(context: context)
                          : state == 3
                              ? 'ylq'.tr(context: context)
                              : 'ljxz'.tr(context: context);
                    } else if (type >= 4 && type <= 7) {
                      text = state == 2
                          ? 'lq'.tr(context: context)
                          : state == 3
                              ? 'ylq'.tr(context: context)
                              : 'qyq'.tr(context: context);
                    }
                    return Text(
                      text,
                      style: state == 2
                          ? MyTheme.white255_13_M
                          : state == 1
                              ? MyTheme.brown_996619_13_M
                              : state == 3
                                  ? MyTheme.white255_13_M
                                  : MyTheme.brown_996619_13_M,
                    );
                  }),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
