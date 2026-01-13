import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/welfare_task_model.dart';
import 'package:jygf/domain/remote_domain/domains/sign.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/api_validator.dart';
import '../../../../../domain/async_value.dart';
import '../../../../../domain/model/member_model.dart';
import '../../../../../domain/model/proxy_detail_model.dart';
import '../../../../../domain/remote_domain/domains/proxy.dart';
import '../../../../notifiers/home_config_notifier.dart';
import '../../../../notifiers/user_notifier.dart';
import '../../../../router/routes.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_avatar.dart';
import '../../../common_widgets/my_button.dart';
import '../../../common_widgets/my_image.dart';
import '../../../common_widgets/my_list_view.dart';
import '../../../common_widgets/status/loading.dart';
import '../../../common_widgets/status/network_error.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';
import '../../share_to_user/widgets/jelly_share.dart';
import '../../share_to_user/widgets/share_tips.dart';
import '../../widgets/mine_agent_apply.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class AgentView extends StatefulWidget {
  const AgentView({super.key});

  @override
  State<AgentView> createState() => _AgentViewState();
}

class _AgentViewState extends State<AgentView> {
  late final proxyDomain = context.read<ProxyDomain>();
  late Member member;
  late final config = context.read<HomeConfigNotifier>().config;

  AsyncValue<ProxyDetail?> _asyncValue = const AsyncInit();

  /// 是否显示申请页面
  bool showApplyPage = false;

  WelfareTaskModel? taskModel;

  @override
  void initState() {
    _loadUserAgentData();
    super.initState();
  }

  Future _loadUserAgentData() async {
    member = context.read<UserNotifier>().member;

    if (_asyncValue.isLoading) return;

    setState(() {
      _asyncValue = AsyncLoading(value: _asyncValue.data);
    });
    if (!member.isSelf) {
      showApplyPage = true;
      setState(() {
        _asyncValue = const AsyncData(null);
      });
      return;
    }

    final res = await proxyDomain.getProxyDetail();

    if (!res.isValid) {
      if ((res.msg ?? '').contains('请先申请成为代理')) {
        showApplyPage = true;
        _asyncValue = const AsyncData(null);
      } else {
        MyToast.showText(text: res.msg ?? '');
        _asyncValue = const AsyncError();
      }
    } else {
      _asyncValue = AsyncData(res.data);
    }

    if (mounted) {
      setState(() {});
      _getTaskData();
    }
  }

  //获取分享任务
  Future _getTaskData() async {
    late final userNotifier = context.read<UserNotifier>();
    late final signDomain = context.read<SignDomain>();
    final res = await signDomain.signListTask(type: 'share');

    if (res.data case final data?) {
      userNotifier.setExp(data.exp);
      taskModel = data;
    } else {
      if (res.msg case final msg?) {
        MyToast.showText(text: msg);
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildShareView() {
    if (taskModel == null) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: EdgeInsets.all(MyTheme.pagePadding),
      child: Column(
        children: [
          SizedBox(height: 30.w),
          Text('fxfl'.tr(context: context), style: MyTheme.white18mudium),
          SizedBox(height: 13.w),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  taskModel?.list?.length ?? 0, // Number of children
                  (index) => Container(
                      margin: EdgeInsets.symmetric(vertical: 5.w),
                      padding:
                          EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(35, 34, 57, 1),
                          borderRadius: BorderRadius.all(Radius.circular(5.w))),
                      height: 40.w,
                      width: double.infinity,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(taskModel?.list?[index].title ?? '',
                                    style: MyTheme.white13)),
                            ReportGestureDetector(
                              onTap: () {
                                const MineShareToUserRoute().push(context);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 70.w,
                                height: 26.w,
                                decoration: BoxDecoration(
                                    color: MyTheme.jellyCyanColor103224185,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(13.w))),
                                child: Text('ljfx'.tr(context: context),
                                    style: MyTheme.white10),
                              ),
                            )
                          ])))),
        ],
      ),
    );
  }

  Widget _buildActionView() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyButton.gradient(
            minimumSize: Size(150.w, 38.5.w),
            text: 'fztglj'.tr(context: context),
            onPressed: () async {
              CommonUtils.copyToClipboard(
                  text: '${member.share?.affUrlCopy?.url}');
              MyToast.showText(text: 'fzcg'.tr(context: context));
            },
          ),
          SizedBox(width: 15.w),
          MyButton.gradient(
            minimumSize: Size(150.w, 38.5.w),
            text: 'ljyqt'.tr(context: context),
            onPressed: () async {
              const MineShareToUserRoute().push(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDataView(ProxyDetail? data) {
    return showApplyPage
        ? MineAgentApplyView(
            applySuccess: () {
              showApplyPage = false;
              _loadUserAgentData();
            },
          )
        : CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              MyIndicator(onRefresh: _loadUserAgentData),
              SliverPadding(
                padding: EdgeInsets.all(18.w),
                sliver: SliverList.list(
                  // padding: const EdgeInsets.all(18),
                  children: [
                    Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 53.w,
                              child: Row(
                                children: [
                                  ClipRRect(
                                    clipBehavior: Clip.hardEdge,
                                    borderRadius: BorderRadius.circular(26.5.w),
                                    child: MyAvatar(
                                      size: 53.w,
                                      thumb: member.thumb,
                                    ),
                                  ),
                                  SizedBox(width: 9.w),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${data?.levelStr}',
                                                style: MyTheme.white14Medium,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'yhysj'.tr(context: context),
                                                style: MyTheme.white06_12,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.w),
                            Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    MyImagePaths.appAgentUserbg,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              width: double.infinity,
                              height: 72.w,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.5.w),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'ktxje'.tr(context: context),
                                            style: MyTheme.white12,
                                          ),
                                          Text(
                                            data?.money ?? '',
                                            style: TextStyle(
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.bold,
                                              color: MyTheme.goldColor255_211_123,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Row(
                                        children: [
                                          _CardButton(
                                            onTap: () {
                                              const MineWithdrawalRoute(true).push(context);
                                            },
                                            text: 'ljtx'.tr(context: context),
                                            colorFlag: false,
                                          ),
                                          SizedBox(width: 10.w),
                                          _CardButton(
                                            onTap: () {
                                              const MineAgentPromoteDataRoute()
                                                  .push(context);
                                            },
                                            text: 'tgsj'.tr(context: context),
                                            colorFlag: true,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 5.w),
                    MineShareToUserTips(proxyDetail: data),
                    SizedBox(height: 25.w),
                    JellyShareCard(proxyDetail: data),
                    SizedBox(height: 31.w),
                    _buildActionView(),
                    _buildShareView(),
                    SizedBox(height: 30.w),
                    Center(
                      child: Text(
                        'yqbz'.tr(context: context),
                        style: MyTheme.white255_24_B,
                      ),
                    ),
                    Center(
                      child: Text(
                        config.tipsShareText ?? 'loading',
                        style: MyTheme.white255_15,
                      ),
                    ),
                    SizedBox(height: 50.w),
                    Center(
                      child: Stack(
                        children: [
                          MyImage.asset(
                            MyImagePaths.appWdFxbotmbgN,
                            height: 500.w,
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 20.w,
                            child: ReportGestureDetector(
                              onTap: () => const MineAgentRoute().push(context),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 50.w),
                  ],
                ),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return _asyncValue.maybeWhen(
      error: (_, __) => NetworkErrorView(onTap: _loadUserAgentData),
      orElse: () => const LoadingView(),
      loading: (data) {
        if (data == null) return const LoadingView();
        return _buildDataView(data);
      },
      data: _buildDataView,
    );
  }
}

class _CardButton extends StatelessWidget {
  const _CardButton({
    required this.onTap,
    required this.text,
    required this.colorFlag,
  });

  final GestureTapCallback onTap;
  final String text;
  final bool colorFlag;

  @override
  Widget build(BuildContext context) {
    return ReportGestureDetector(
      onTap: onTap,
      child: Container(
        width: 100.w,
        height: 30.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(15.w),
          gradient: colorFlag ? MyTheme.gradient_90_114 : MyTheme.gradient_90_118,
        ),
        child: Text(
          text,
          style: MyTheme.white15_M,
        ),
      ),
    );
  }
}
