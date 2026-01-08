import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/type_def.dart';
import 'package:jygf/ui_layer/screens/common_widgets/gradient_text.dart';
import 'package:jygf/ui_layer/screens/common_widgets/member_vip.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
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
  const TaskView({super.key, this.needNavi = true});
  final bool needNavi;
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
      slivers: [
        MyIndicator(onRefresh: _initData),
        SliverList.list(children: [
          _MemberView(data: data),
          SizedBox(height: 6.w),
          _signInContent(data),
          // SizedBox(height: 13.w),
          Container(
              color: MyTheme.blackColor29_2_24,

            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   border: Border.all(
            //     color: Colors.white.withOpacity(0.03),
            //     width: 1.w,
            //   ),
            //   borderRadius: BorderRadius.only(
            //     topLeft: Radius.circular(8.w),
            //     topRight: Radius.circular(8.w),
            //   ),
            // ),
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
            // margin: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 20.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(30.w),
              color: MyTheme.blackColor29_2_24,
              border: Border(top: BorderSide(color:const Color.fromRGBO(154, 48, 133, 1), width: 1.w,)),
              
            ),
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'zmrrw'.tr(context: context),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'ljl'.tr(context: context),
                    style: MyTheme.white07_10,
                  ),
                  const Spacer(),
                  Text(
                    'yljqd'.tr(context: context),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    ' ${data.signNum} ',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: MyTheme.primaryColor, 
                    ),
                  ),
                  Text(
                    'tian'.tr(context: context),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: (data.signRewardList ?? [])
                    .map((e) => Expanded(child: siginItem(e, data.signNum ?? 0)))
                    .toList(),
              ),
              SizedBox(height: 10.w),
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
                      width: 93.w,
                      height: 35.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(22.5.w),
                        gradient: MyTheme.gradient_90_118,
                      ),
                      child: Selector<UserNotifier, Member?>(
                        selector: (_, notifier) => notifier.member,
                        builder: (context, member, child) {
                          return Text(
                            data.signStatus == true ? tr('yqiandao') : tr('ljqd'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              // fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  GestureDetector(
                    onTap: () {
                      //兑换VIP
                      const VipCenterRoute(pageIndex: 1).push(context);
                    },
                    child: Container(
                      width: 93.w,
                      height: 35.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(22.5.w),
                        gradient: MyTheme.gradient_90_114,
                      ),
                      child: Text(
                        tr('dhvp'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          // fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ]),
          );
  }

  Widget siginItem(WelfareTaskListModel data, int signNum) {
    bool isSigned = (data.sort ?? 0) <= signNum;
    return Column(
      children: [
        Container(
          width: 46.w,
          height: 81.w,
          decoration: BoxDecoration(
            gradient: isSigned
                ? const LinearGradient(
                    colors: [Color.fromRGBO(59, 12, 79, 1),Color.fromRGBO(78, 12, 79, 1)],
                  )
                : const LinearGradient(
                    colors: MyTheme.gradient_90_114_colors,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
            borderRadius: BorderRadius.circular(22.w),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isSigned ? 'yqiandao'.tr(context: context) : 'wks'.tr(context: context), // 已签到/未签到
                style: TextStyle(
                  color: isSigned ? Colors.white.withOpacity(0.5) : Colors.white,
                  fontSize: 10.sp,
                ),
              ),
              SizedBox(height: 4.w),
              isSigned
                  ? MyImage.asset(MyImagePaths.appTaskSigned, width: 22.w, height: 22.w,fit: BoxFit.contain,)
                  : MyImage.asset(MyImagePaths.appTaskUnsigned, width: 22.w, height: 22.w,fit: BoxFit.cover,),
              SizedBox(height: 4.w),
              Text(
                '${data.desc}',
                style: TextStyle(
                  color: isSigned ? const Color(0xFF8E7AA6) : const Color(0xFFFFE066), // 深紫灰 / 亮黄
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5.w),
        Text(
          data.title ?? '',
          style: TextStyle(
            color: Colors.white,
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _asyncValue.maybeWhen(
      error: (_, __) => NetworkErrorView(onTap: _initData),
      orElse: () => const LoadingView(),
      loading: (data) {
        if (data == null) return const LoadingView();
        return _buildDataView(data);
      },
      data: _buildDataView,
    );
    return widget.needNavi ? ScreenBackground(child: Scaffold(appBar: MyAppBar(title: 'flrw'.tr()),body:content)) : content;
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
                                       if (member.vipLevel.isVip())
                                       Padding( padding:  EdgeInsets.only(left: 5.w),
                                         child: MemberVipWidget(
                                         height: 15.w,
                                         vipImage: member.vipImg,
                                         ),),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        member.vipLevel.isVip()
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
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadiusDirectional.circular(20.w),
                  //     gradient: const LinearGradient(
                  //       begin: Alignment.bottomCenter,
                  //       end: Alignment.topCenter,
                  //       colors: <Color>[Color.fromRGBO(239, 205, 168, 1), Color.fromRGBO(252, 231, 207, 1)],
                  //     )),
                  child: Selector<UserNotifier, Member?>(
                    selector: (_, notifier) => notifier.member,
                    builder: (context, member, child) {
                      if (member == null) return const SizedBox.shrink();
                      return MyImage.asset(
                        member.vipLevel > 0
                            ? MyImagePaths.appTaskRenewVip
                            : MyImagePaths.appTaskBuyVip,
                        width: 300.w,
                        height: 40.w,
                        fit: BoxFit.fill,
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
        // SizedBox(height: 10.w),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              'flrw'.tr(context: context),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              '${'ts'.tr(context: context)}: ${'rwwchsx'.tr(context: context)}',
              style: MyTheme.white07_10,
            )
          ],
        ),
        SizedBox(height: 10.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${'yqrs'.tr(context: context)}${data.invitedNum}人',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(15),
                  overflow: TextOverflow.ellipsis,
                  // fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                )),
            Selector<UserNotifier, Member?>(
                builder: (context, member, child) {
                  return Text('${'wdjf'.tr(context: context)}${member?.exp ?? ''}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(15),
                        overflow: TextOverflow.ellipsis,
                        // fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                      ));
                },
                selector: (_, notifier) => notifier.member),
            GestureDetector(
              onTap: () async {
                const VipCenterRoute().push(context);
              },
              child: Container(
                width: 60.w,
                height: 20.w,
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  gradient: MyTheme.gradient_90_114,
                  borderRadius: BorderRadius.circular(16.w),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: MyTheme.blackColor29_2_24,
                    borderRadius: BorderRadius.circular(15.w),
                  ),
                  alignment: Alignment.center,
                  child:GradientText(tr('dhvp'), gradient: MyTheme.gradient_90_114,style: TextStyle(color: Colors.white, fontSize: 12.sp,),),
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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${data.subTitle}',
                    style: MyTheme.white07_11,
                    maxLines: 1,
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
            child: Container(
              width: 60.w,
              height: 20.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.w),
                color: state == 3 ? const Color(0xFF2C1E40) : null,
                gradient: state == 3
                    ? null
                    : (state == 2 || (type == 3 && state != 3) || (type >= 4 && type <= 7 && state != 3))
                        ? MyTheme.gradient_90_118
                        : MyTheme.gradient_90_114,
              ),
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
                  style: TextStyle(
                    color: state == 3 ? Colors.white.withOpacity(0.6) : Colors.white,
                    fontSize: 11.sp,
                    // fontWeight: FontWeight.w500,
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
