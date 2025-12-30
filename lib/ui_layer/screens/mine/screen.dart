import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/common_widgets/dialog/my_dialog.dart';
import 'package:jygf/ui_layer/screens/common_widgets/dialog/widgets/regular_dialog.dart';
import 'package:jygf/ui_layer/screens/common_widgets/gradient_text.dart';
import 'package:jygf/ui_layer/screens/mine/bind_email/screen.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

import '../../../domain/type_def.dart';
import '../../../domain/enum.dart';
import '../../../domain/model/member_model.dart';
import '../../notifiers/home_config_notifier.dart';
import '../../notifiers/user_notifier.dart';
import '../../router/routes.dart';
import '../common_widgets/member_vip.dart';
import '../common_widgets/my_avatar.dart';
import '../common_widgets/my_image.dart';
import '../common_widgets/my_list_view.dart';
import '../common_widgets/screen_background.dart';
import '../image_paths.dart';
import '../theme.dart';

class MineScreen extends StatefulWidget {
  const MineScreen({super.key});

  @override
  State<MineScreen> createState() => _MineScreenState();
}

class _MineScreenState extends State<MineScreen> {
  _judgeIfBindEmail() {
    late final userNotifier = context.read<UserNotifier>();
    if (userNotifier.member.bindEmail != 1) {
      _showBindEmailPop();
    }
  }

  _showBindEmailPop() {
    MyDialog.showDialog(
        context: context,
        child: Dialog(
            // title: tr('ts'),
            backgroundColor: MyTheme.bgColor,
            //前往充值 - 立即购买
            // buttonText: tr('fxdv'),
            // //做任务得VIP
            // confirmOnTap: () {
            //   const MineWelfareRoute(index: 1).push(context);
            // },
            // cancelOnTap: () {
            //   if (isInsufficient) {
            //     const CoinRechargeRoute().push(context);
            //   } else {
            //     byVideoRes(member.money - widget.info.coins!);
            //   }
            // },
            child: Container(
              width: 305.w,
              height: 410.w,
              padding: EdgeInsets.symmetric(vertical: 10.w),
              child: const MineBindEmailScreen(
                isForPop: true,
              ),
            )));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(milliseconds: 300), () {
      _judgeIfBindEmail();
    });
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Stack(
        children: [
          const SizedBox(
            width: double.infinity,
            child: MyImage.asset(
              MyImagePaths.appMineBgTop,
              fit: BoxFit.fitWidth,
            ),
          ),
          Column(
            children: [
              SizedBox(height: topPadding),
              const _FixedTopArea(),
              Expanded(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    MyIndicator(onRefresh: () async {
                      await context.read<UserNotifier>().init();
                    }),
                    const SliverToBoxAdapter(
                      child: _Body(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FixedTopArea extends StatelessWidget {
  const _FixedTopArea();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, right: 13, bottom: 11),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const _SystemNoticeIcon(),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: () => const MineSetupRoute().push(context),
            child: const MyImage.asset(
              MyImagePaths.appMineSetting,
              width: 25,
              fit: BoxFit.fitWidth,
            ),
          )
        ],
      ),
    );
  }
}

class _SystemNoticeIcon extends StatelessWidget {
  const _SystemNoticeIcon();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        const MessageCenterRoute().push(context);
      },
      child: Selector<UserNotifier, bool>(
          selector: (_, notifier) => (notifier.systemNotice != null &&
              (notifier.systemNotice?.systemNoticeCount != 0 ||
                  notifier.systemNotice?.feedCount != 0)),
          builder: (context, value, _) {
            return Stack(
              children: [
                const MyImage.asset(
                  MyImagePaths.appMineMessage,
                  width: 25,
                  fit: BoxFit.fitWidth,
                ),
                value
                    ? Positioned(
                        right: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  width: 0.5,
                                  color: Colors.white.withOpacity(0.4))),
                        ),
                      )
                    : Container()
              ],
            );
          }),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _HeaderInfo(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: const Column(
            children: [
              SizedBox(height: 20),
              _VIPCenter(),
              SizedBox(height: 15),
              _CenterMenu(),
              // _FirstMenu(),
              SizedBox(height: 15),
              _AiEntry(),
              SizedBox(height: 10),
              _SecondMenu(),
              SizedBox(height: 10),
              _ThirdMenu(),
              SizedBox(height: 15),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderInfo extends StatelessWidget {
  const _HeaderInfo();

  @override
  Widget build(BuildContext context) {
    return Selector<UserNotifier, Member>(
      selector: (_, config) => config.member,
      builder: (context, member, child) => Padding(
        padding: const EdgeInsets.only(left: 13),
        child: Row(
          children: [
            MyAvatar(
              thumb: member.thumb,
              margin: 1,
              size: 60.w,
              gradient:
                  const LinearGradient(colors: [Colors.white, Colors.white]),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: 150.w),
                      child: Text(
                        member.nickname,
                        style: MyTheme.white18bold,
                      ),
                    ),
                    if (member.agent == 1)
                      Container(
                        margin: EdgeInsets.only(left: 5.w),
                        child: const Icon(
                          Icons.verified_sharp,
                          size: 17,
                          color: Color.fromRGBO(247, 208, 93, 1),
                        ),
                      ),
                    if (member.vipUpgrade == 1)
                      GestureDetector(
                        onTap: () => const VipUpgradeRoute().push(context),
                        child: Container(
                          margin: EdgeInsets.only(left: 5.w),
                          child: MyImage.asset(
                            MyImagePaths.appMineVipUpgrade,
                            width: 70.w,
                            height: 22.w,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (member.vipLevel.isVip())
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: MemberVipWidget(
                          vipImage: member.vipImg,
                        ),
                      ),
                    Text(
                      'ID: ${member.aff ?? '0000000'}',
                      style: MyTheme.white255_14.white25507,
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Selector<UserNotifier, MyTokenStatus?>(
              selector: (_, userNotifier) => userNotifier.tokenStatus,
              builder: (context, tokenStatus, child) =>
                  tokenStatus == MyTokenStatus.valid
                      ? const SizedBox.shrink()
                      : GestureDetector(
                          onTap: () => const LoginRoute().push(context),
                          child: Container(
                            width: 70,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(35, 38, 46, 1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    tr('dl'),
                                    style: const TextStyle(
                                      color: Color.fromRGBO(250, 207, 135, 1),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: Color.fromRGBO(250, 207, 135, 1),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
            )
          ],
        ),
      ),
    );
  }
}

class _VIPCenter extends StatefulWidget {
  const _VIPCenter();

  @override
  State<_VIPCenter> createState() => _VIPCenterState();
}

class _VIPCenterState extends State<_VIPCenter> {
  late final config = context.read<HomeConfigNotifier>().config;

  /// 当前日期
  String time = DateFormat('yyyy-MM-dd').format(DateTime.now());

  /// 取得副标题
  String getSubTitle({String? expiredAt, required bool isVIP}) {
    if (isVIP) {
      String expiredDate = expiredAt?.split(' ')[0] ?? '';
      if (expiredDate.isEmpty) {
        return tr('fhy');
      } else {
        return (expiredDate == time) ? tr('fhy') : expiredDate + tr('dq');
      }
    } else {
      return tr('fhy');
    }
  }

  @override
  Widget build(BuildContext context) {
    final menu = [
      (
        title: 'vpsp'.tr(context: context),
        iconName: MyImagePaths.appMineVipmv,
        onTap: null,
      ),
      (
        title: 'dsp'.tr(context: context),
        iconName: MyImagePaths.appMineShortmv,
        onTap: null,
      ),
      (
        title: 'zsxl'.tr(context: context),
        iconName: MyImagePaths.appMineLine,
        onTap: null,
      ),
      (
        title: 'plhf'.tr(context: context),
        iconName: MyImagePaths.appMineReply,
        onTap: null,
      )];
    return SizedBox(
      height: 150.w,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => const VipCenterRoute().push(context),
        child: Stack(
          children: [
            const Positioned.fill(
              child: MyImage.asset(
                MyImagePaths.appMineVip,
                fit: BoxFit.fill,
              ),
            ),
            Positioned.fill(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Selector<UserNotifier, Member>(
                  selector: (_, userNotifier) => userNotifier.member,
                  builder: (context, member, child) {
                    final subTitle = getSubTitle(
                        expiredAt: member.expiredAt,
                        isVIP: member.vipLevel.isVip());

                    return Padding(
                      padding: EdgeInsets.only(top: 20.w,left: 10.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //   config.tipsShareText ??
                          //       'cgyqsqt'.tr(context: context),
                          //   style: const TextStyle(
                          //     color: Colors.white,
                          //     fontSize: 14,
                          //     fontWeight: FontWeight.w600,
                          //   ),
                          // ),
                          // const SizedBox(height: 6),
                          Row(
                            children: [
                              MyImage.asset(
                                MyImagePaths.appMineKtVip,
                                height: 16.w,
                                fit: BoxFit.fitHeight,
                              ),
                              SizedBox(width: 8.w),
                              GradientText(
                                subTitle,
                                gradient: MyTheme.gradient_90_114,
                                style:  TextStyle(
                                  fontSize: 12.sp,
                                ),
                                maxLines: 1,
                              ),
                              const SizedBox(width: 5),
                              
                            ],
                          ),
                          SizedBox(height: 5.w),
                          Text(
                                "${'syxzcs'.tr(context: context)}${member.videoDownloadValue}",
                                style: MyTheme.white10.copyWith(color: const Color.fromRGBO(187, 187, 187, 1.0)),
                                maxLines: 1,
                              ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Align(alignment: Alignment.bottomCenter,child: _MenuButtonGrid(menu: menu, isVipCenter: true)),
          ],
        ),
      ),
    );
  }
}

class _CenterMenu extends StatelessWidget {
  const _CenterMenu();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 124.w,
      child: Stack(
        children: [
          Selector<UserNotifier, int>(
              selector: (_, config) => config.member.money,
              builder: (context, money, child) {
                return Positioned(
                  top: 0,
                  left: 0,
                  bottom: 0,
                  child: SizedBox(
                    width: 174.w,
                    // height: 124.w,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => const CoinRechargeRoute().push(context),
                      child: Stack(
                        children: [
                          const MyImage.asset(
                            MyImagePaths.appMineRecharge, // fit: BoxFit.fill,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Positioned(
                            top: 12.w,
                            left: 13.w,
                            right: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'jbcz'.tr(context: context),
                                  style: MyTheme.white255_18,
                                ),
                                const SizedBox(height: 5),
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                    text: "${'yee'.tr(context: context)} : ",
                                    style: MyTheme.white255_12.copyWith(color: const Color.fromRGBO(187, 187, 187, 1.0)),
                                  ),
                                  TextSpan(
                                    text: "$money",
                                    style: MyTheme.white12.yellow255.copyWith(color: const Color.fromRGBO(246, 203, 163, 1.0)),
                                  ),
                                ])),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
          Positioned(
            top: 0,
            right: 0,
            // bottom: 0,
            child: SizedBox(
              width: 171.w,
              height: 54.w,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => const MineShareToUserRoute().push(context),
                child: Stack(
                  children: [
                    const MyImage.asset(
                      MyImagePaths.appMineShare, // fit: BoxFit.fill,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned.fill(
                      left: 20.w,
                      // top: 12.w,
                      // right: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'fxyq'.tr(context: context),
                            style: MyTheme.white255_18.s16.white25509,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'yqhydvp'.tr(context: context),
                            style: MyTheme.white255_11.white25506.copyWith(color: const Color.fromRGBO(187, 187, 187, 1.0)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: SizedBox(
              width: 171.w,
              height: 54.w,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => const MineWelfareRoute().push(context),
                child: Stack(
                  children: [
                    const MyImage.asset(
                      MyImagePaths.appMineAgent, // fit: BoxFit.fill,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned.fill(
                      // top: 12.w,
                      left: 20.w,
                      // right: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'tgzxj'.tr(context: context),
                            style: MyTheme.white255_18.s16.white25509,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'ye'.tr(context: context),
                            style: MyTheme.white255_11.white25506.copyWith(color: const Color.fromRGBO(187, 187, 187, 1.0)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _AiEntry extends StatelessWidget {
  const _AiEntry();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => const AIServerRoute().push(context),
        child:  SizedBox(
          width: 1.sw,
          height: 70.w,
          child:const MyImage.asset(
            MyImagePaths.appMineAiEntry,
            fit: BoxFit.fill,
          ),
        ));
  }
}

class _CenterMenuCard extends StatelessWidget {
  const _CenterMenuCard({
    required this.onTap,
    required this.title,
    required this.subTitle,
    required this.backgroundImg,
  });
  final VoidCallback onTap;
  final Widget title;
  final Widget subTitle;
  final String backgroundImg;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Stack(
        children: [
          MyImage.asset(
            backgroundImg,
            // fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            top: 12.w,
            left: 10.w,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                title,
                const SizedBox(height: 5),
                subTitle,
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _FirstMenu extends StatelessWidget {
  const _FirstMenu();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      children: [
        Selector<UserNotifier, int>(
            selector: (_, config) => config.member.money,
            builder: (context, money, child) {
              return _FirstMenuCard(
                backgroundImg: MyImagePaths.appMineCoinChargeBackground,
                title: 'jbcz'.tr(context: context),
                subTitle: "${'dqye'.tr(context: context)} $money",
                onTap: () => const CoinRechargeRoute().push(context),
              );
            }),
        _FirstMenuCard(
          backgroundImg: MyImagePaths.appMineShareBackground,
          title: 'fxyqlhb'.tr(context: context),
          subTitle: 'yqhydvp'.tr(context: context),
          onTap: () => const MineShareToUserRoute().push(context),
        ),
        _FirstMenuCard(
          backgroundImg: MyImagePaths.appMineWelfareBackground,
          title: 'tgzxj'.tr(context: context),
          subTitle: 'ye'.tr(context: context),
          onTap: () => const MineWelfareRoute().push(context),
        ),
      ],
    );
  }
}

class _FirstMenuCard extends StatelessWidget {
  const _FirstMenuCard({
    required this.onTap,
    required this.title,
    required this.subTitle,
    required this.backgroundImg,
  });
  final VoidCallback onTap;
  final String title;
  final String subTitle;
  final String backgroundImg;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Stack(
        children: [
          MyImage.asset(
            backgroundImg,
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subTitle,
                  style: const TextStyle(
                    color: Color.fromRGBO(246, 203, 163, 1),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _SecondMenu extends StatelessWidget {
  const _SecondMenu();

  @override
  Widget build(BuildContext context) {
    final menu = [
      (
        title: 'tzfb'.tr(context: context),
        iconName: MyImagePaths.appMinePost,
        onTap: () => const MinePostRoute().push(context),
      ),
      (
        title: 'wdsc'.tr(context: context),
        iconName: MyImagePaths.appMineCollection,
        onTap: () => const MineCollectionRoute().push(context),
      ),
      (
        title: 'ycrz'.tr(context: context),
        iconName: MyImagePaths.appMineBlogger,
        onTap: () => const OriginalEnterRoute().push(context),
      ),
    ];

    return Container(
        decoration: const BoxDecoration(
          // color: Color.fromRGBO(21, 19, 42, 1),
          // borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        padding: EdgeInsets.symmetric(vertical: 6.w),
        child: Row(
          children: [
            for (int i = 0; i < menu.length; i++) ...[
              if (i > 0) SizedBox(width: 10.w),
              Expanded(
                child: GestureDetector(
                  onTap: menu[i].onTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(21, 19, 42, 1),
                      borderRadius: BorderRadius.circular(20),
                    
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          menu[i].title,
                          style: MyTheme.white12.copyWith(color: Color.fromRGBO(187, 187, 187, 1.0)),
                        ),
                        SizedBox(width: 4.w),
                        const Icon(
                          Icons.chevron_right,
                          size: 30,
                          color: Color.fromRGBO(187, 187, 187, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ));
  }
}

class _ThirdMenu extends StatelessWidget {
  const _ThirdMenu();

  @override
  Widget build(BuildContext context) {
    final menu = [
      (
        title: 'wdgm'.tr(context: context),
        iconName: MyImagePaths.appMineBuy,
        onTap: () => const MineBuyRoute().push(context),
      ),
      (
        title: 'wdai'.tr(context: context),
        iconName: MyImagePaths.appMineAi,
        onTap: () => const MineAIRecordRoute().push(context),
      ),
      (
        title: 'wdgz'.tr(context: context),
        iconName: MyImagePaths.appMineFollow,
        onTap: () => const MineFollowingRoute().push(context),
      ),
      (
        title: 'zxhc'.tr(context: context),
        iconName: MyImagePaths.appMineDownload,
        onTap: () => const MineDownloadRoute().push(context),
      ),
      (
        title: 'gfkf'.tr(context: context),
        iconName: MyImagePaths.appMineService,
        onTap: () => const MineCustomerServiceRoute().push(context),
      ),
      (
        title: 'txyqm'.tr(context: context),
        iconName: MyImagePaths.appMineInviteCode,
        onTap: () =>
            MineFillCodeRoute('yqm'.tr(context: context)).push(context),
      ),
      (
        title: 'txdhm'.tr(context: context),
        iconName: MyImagePaths.appMineRedeem,
        onTap: () =>
            MineFillCodeRoute('dhm'.tr(context: context)).push(context),
      ),
      // (
      //   title: 'cjwt'.tr(context: context),
      //   iconName: MyImagePaths.appMineHelp,
      //   onTap: () => const MineHelpRoute().push(context),
      // ),
      (
        title: 'gfjlq'.tr(context: context),
        iconName: MyImagePaths.appMineGroups,
        onTap: () => const MineOfficialGroupRoute().push(context),
      ),
    ];

    return Container(color: const Color.fromRGBO(21, 19, 42, 1),child: _MenuButtonGrid(menu: menu));
  }
}

class _MenuButtonGrid extends StatelessWidget {
  const _MenuButtonGrid ({required this.menu, this.isVipCenter = false});
  final List<({String iconName, String title, VoidCallback? onTap})> menu;
  final bool? isVipCenter;
  
  Widget _buildButton(({String iconName, String title, VoidCallback? onTap}) data) {
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MyImage.asset(
          data.iconName,
          width: 40.w,
          height: 40.w,
        ),
        const SizedBox(height: 5),
        isVipCenter == true ? GradientText(data.title,
         gradient: MyTheme.gradient_90_114,style: TextStyle(fontSize: 14.sp),):Text(
          data.title,
          style:  TextStyle(
            fontSize: 11.sp,
            color: const Color.fromRGBO(187, 187, 187, 1.0),
          ),
        )
      ],
    );
    return data.onTap != null
        ? GestureDetector(onTap: data.onTap, child: content)
        : content;
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13 / 2),
        child: GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4),
          children: [
            for (final data in menu)
              _buildButton(data)
          ],
        ));
  }
}