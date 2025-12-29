import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/common_widgets/gradient_text.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:provider/provider.dart';

import '../../../../domain/api_validator.dart';
import '../../../../domain/async_value.dart';
import '../../../../domain/domain.dart';
import '../../../../domain/model/member_model.dart';
import '../../../../domain/model/proxy_detail_model.dart';
import '../../../notifiers/home_config_notifier.dart';
import '../../../notifiers/user_notifier.dart';
import '../../../router/routes.dart';
import '../../../utils/common_utils.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/my_avatar.dart';
import '../../common_widgets/my_image.dart';
import '../../common_widgets/status/loading.dart';
import '../../image_paths.dart';
import '../../theme.dart';

class MineAgentScreen extends StatefulWidget {
  const MineAgentScreen({super.key});

  @override
  State<MineAgentScreen> createState() => _MineAgentScreenState();
}

class _MineAgentScreenState extends State<MineAgentScreen> {
  late final proxyDomain = context.read<ProxyDomain>();
  late final member = context.read<UserNotifier>().member;

  AsyncValue<ProxyDetail?> _asyncValue = const AsyncInit();

  @override
  void initState() {
    _getAgentInfo();
    super.initState();
  }

  Future _getAgentInfo() async {
    if (member.isSelf) {
      final res = await proxyDomain.getProxyDetail();
      if (res.isValid) {
        _asyncValue = AsyncData(res.data);
      } else {
        MyToast.showText(text: res.msg ?? '');
        _asyncValue = const AsyncData(null);
      }
    } else {
      _asyncValue = const AsyncData(null);
    }

    if (mounted) {
      setState(() {});
    }
  }

  final tableBorderColor = MyTheme.goldColor234_202_147;

  final levelList = [
    'dld',
    'zs',
    'bj',
    'hj',
    'by',
    'qt',
    'pt',
  ];

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: 'dlzq'.tr(context: context),
          rightWidget: member.isSelf
              ? GestureDetector(
                  onTap: () => const MineAgentProfitRoute().push(context),
                  child: Text(
                    'symx'.tr(context: context),
                    style: MyTheme.gray15,
                  ),
                )
              : const SizedBox.shrink(),
        ),
        body: _asyncValue.maybeWhen(
            orElse: () => const LoadingView(),
            data: (data) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                child: Stack(
                  children: [
                    ListView(
                      padding: EdgeInsets.only(bottom: 65.w),
                      children: [
                        data == null
                            ? const SizedBox.shrink()
                            : _AgentHeaderWidget(member: member, data: data),
                        const _AgentCzWidget(),
                        _AgentTableWidget(levelList: levelList),
                        const _AgentZjsyWidget(),
                        const _AgentCjsyWidget(),
                        const _AgentZjWidget(),
                        SizedBox(height: 15.w)
                      ]
                          .map((e) => Column(
                                children: [SizedBox(height: 15.w), e],
                              ))
                          .toList(),
                    ),
                    Positioned(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () {
                            const MineShareToUserRoute().push(context);
                          },
                          child: SafeArea(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10.w),
                              child: SizedBox(
                                height: 38.5.w,
                                child: Center(
                                  child: Container(
                                    // width: 264.w,
                                    height: 38.5.w,
                                    decoration: BoxDecoration(
                                      gradient: MyTheme.gradient_90_114,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(19.25.w),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'ljtg'.tr(context: context),
                                        style: MyTheme.white16medium,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

class _AgentHeaderWidget extends StatelessWidget {
  const _AgentHeaderWidget({required this.member, required this.data});
  final Member member;
  final ProxyDetail data;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: 53.w,
              // margin: EdgeInsets.all(16.5.w),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${data.levelStr}',
                                style: MyTheme.white14Medium,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            data.money,
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
                              const MineAgentPromoteDataRoute().push(context);
                            },
                            text: 'tgsj'.tr(context: context),
                            colorFlag: true,
                          ),
                        ],
                      ),
                      // SizedBox(width: 54.w),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
class _AgentCzWidget extends StatelessWidget {
  const _AgentCzWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.w),
      decoration: BoxDecoration(
        color: MyTheme.white01Color,
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: Column(
        children: [
          AgentTitleWidget('czjd'.tr(context: context)),
          Container(
            alignment: Alignment.centerLeft,
            child: GradientText(
              'czsm'.tr(context: context),
              gradient: MyTheme.gradient_90_114,
              style: MyTheme.gold15,
            ),
          ),
          Text(
            'czsmza'.tr(context: context),
            style: TextStyle(
              color: const Color.fromRGBO(255, 255, 255, 1),
              fontSize: 11.sp,
              overflow: TextOverflow.visible,
              decoration: TextDecoration.none,
            ),
            // maxLines: 3,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: GradientText(
              'syly'.tr(context: context),
              gradient: MyTheme.gradient_90_114,
              style: MyTheme.gold15,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '1.${'ztsy'.tr(context: context)}',
              style: MyTheme.white255_11,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '2.${'cjsy'.tr(context: context)}',
              style: MyTheme.white255_11,
            ),
          ),
        ]
            .map(
              (e) => Column(
                children: [
                  e,
                  SizedBox(height: 15.w),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
class _AgentTableWidget extends StatelessWidget {
  const _AgentTableWidget({required this.levelList});
  final List<String> levelList;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.w),
      decoration: BoxDecoration(
        color: MyTheme.white01Color,
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: Column(
        children: [
          AgentTitleWidget('dldjsm'.tr(context: context)),
          SizedBox(height: 10.w),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.w),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(75),
                1: FlexColumnWidth(75),
                2: FlexColumnWidth(170),
              },
              children: levelList.asMap().keys.map((index) {
                bool isHeader = index == 0;
                TextStyle style = TextStyle(
                  color: isHeader
                      ? MyTheme.goldColor234_202_147
                      : Colors.white,
                  fontSize: isHeader ? 14.sp : 12.sp,
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                );

                Color rowBgColor = isHeader
                    ? MyTheme.white008Color
                    : (index % 2 == 0 ? MyTheme.white01Color : MyTheme.white02Color);

                return TableRow(
                  decoration: BoxDecoration(
                    color: rowBgColor,
                  ),
                  children: [
                    _buildTableCell('${levelList[index]}j'.tr(context: context), style, isHeader),
                    _buildTableCell('${levelList[index]}jp'.tr(context: context), style, isHeader),
                    _buildTableCell('${levelList[index]}jc'.tr(context: context), style, isHeader, padding: 10.w),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableCell(String text, TextStyle style, bool isHeader, {double padding = 0}) {
    return Container(
      height: (isHeader ? 45 : 60).w,
      padding: EdgeInsets.symmetric(horizontal: padding),
      alignment: Alignment.center,
      child: isHeader
          ? GradientText(
              text,
              gradient: MyTheme.gradient_90_114,
              style: style,
            )
          : Text(
              text,
              style: style,
              textAlign: TextAlign.center,
            ),
    );
  }
}
class _AgentZjWidget extends StatelessWidget {
  const _AgentZjWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.w),
      decoration: BoxDecoration(
        color: MyTheme.white01Color,
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: Column(
        children: [
          AgentTitleWidget(
            'zj'.tr(context: context),
            hideIcon: false,
          ),
          SizedBox(height: 20.w),
          Text(
            'zjy'.tr(context: context),
            style: TextStyle(
              color: const Color.fromRGBO(255, 255, 255, 1),
              fontSize: 11.sp,
              overflow: TextOverflow.visible,
              decoration: TextDecoration.none,
            ),
            // maxLines: 5,
          ),
          SizedBox(height: 20.w),
          Text(
            'zje'.tr(context: context),
            style: TextStyle(
              color: const Color.fromRGBO(255, 255, 255, 1),
              fontSize: 11.sp,
              overflow: TextOverflow.visible,
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 40.w),
          GradientText(
            'gzkd'.tr(context: context),
            gradient: MyTheme.gradient_90_114,
            style: MyTheme.white15,
          ),
          SizedBox(height: 20.w),
          GestureDetector(
            onTap: () {
              if (context
                      .read<HomeConfigNotifier>()
                      .config
                      .officialGroup
                  case final url?) {
                CommonUtils.launchUrl(url);
              }
            },
            child: Text(
              'jryrmj'.tr(context: context),
              style: MyTheme.white15,
            ),
          ),
          SizedBox(height: 15.w),
        ],
      ),
    );
  }
}

class _AgentZjsyWidget extends StatelessWidget {
  const _AgentZjsyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.w),
      decoration: BoxDecoration(
        color: MyTheme.white01Color,
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: Column(
        children: [
          AgentTitleWidget(
            'zjsy'.tr(context: context),
            hideIcon: false,
          ),
          SizedBox(height: 20.w),
          Text(
            'zjsy1'.tr(context: context),
            style: TextStyle(
              color: const Color.fromRGBO(255, 255, 255, 1),
              fontSize: 11.sp,
              overflow: TextOverflow.visible,
              decoration: TextDecoration.none,
            ),
            // maxLines: 5,
          ),
          SizedBox(height: 20.w),
          const MyImage.asset(MyImagePaths.appAgnetZjsy, fit: BoxFit.fitWidth),
          SizedBox(height: 15.w),
        ],
      ),
    );
  }
}

class _AgentCjsyWidget extends StatelessWidget {
  const _AgentCjsyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.w),
      decoration: BoxDecoration(
        color: MyTheme.white01Color,
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: Column(
        children: [
          AgentTitleWidget(
            'cjsyt'.tr(context: context),
            hideIcon: false,
          ),
          SizedBox(height: 20.w),
          Text(
            'cjsyx'.tr(context: context),
            style: TextStyle(
              color: const Color.fromRGBO(255, 255, 255, 1),
              fontSize: 11.sp,
              overflow: TextOverflow.visible,
              decoration: TextDecoration.none,
            ),
            // maxLines: 5,
          ),
          SizedBox(height: 20.w),
          const MyImage.asset(MyImagePaths.appAgentCjsy, fit: BoxFit.fitWidth),
          SizedBox(height: 20.w),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'cjsyy'.tr(context: context),
                  style: TextStyle(
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 11.sp,
                  ),
                ),
                TextSpan(
                  text: 'cjsyyw'.tr(context: context),
                  style: TextStyle(
                    color: const Color.fromRGBO(32, 179, 74, 1),
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'cjsye'.tr(context: context),
                  style: TextStyle(
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 11.sp,
                  ),
                ),
                TextSpan(
                  text: 'cjsyew'.tr(context: context),
                  style: TextStyle(
                    color: const Color.fromRGBO(75, 144, 255, 1),
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'cjsyys'.tr(context: context),
                  style: TextStyle(
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 11.sp,
                  ),
                ),
                TextSpan(
                  text: 'cjsysw'.tr(context: context),
                  style: TextStyle(
                    color: const Color.fromRGBO(255, 80, 60, 1),
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AgentTitleWidget extends StatelessWidget {
  const AgentTitleWidget(this.title, {super.key, this.hideIcon = false});
  final String title;
  final bool hideIcon;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: MyImage.asset(
            MyImagePaths.appDlTitltBg,
            width: 43.w,
            height: 14.5.w,
          ),
        ),
        Positioned(
          child: SizedBox(
            width: 226.w,
            height: 35.w,
            child: Center(
              child: Text(
                title,
                style: MyTheme.white16,
              ),
            ),
          ),
        )
      ],
    );
    // return Container(
    //   alignment: Alignment.center,
    //   child: UnconstrainedBox(
    //     child: Row(
    //       children: [
    //         hideIcon
    //             ? Container()
    //             : MyImage.asset(
    //                 MyImagePaths.appDlbtw,
    //                 width: 43.w,
    //                 height: 14.5.w,
    //               ),
    //         Container(
    //           padding: EdgeInsets.symmetric(horizontal: 4.5.w),
    //           child: Text(
    //             title,
    //             style: kIsWeb
    //                 ? MyTheme.gold18M
    //                 : TextStyle(
    //                     fontWeight: FontWeight.w500,
    //                     fontSize: 18.sp,
    //                     foreground: Paint()
    //                       ..shader = const LinearGradient(
    //                               begin: Alignment.topCenter,
    //                               end: Alignment.bottomCenter,
    //                               colors: <Color>[
    //                                 Color.fromRGBO(236, 180, 129, 1),
    //                                 Color.fromRGBO(255, 238, 216, 1),
    //                               ],
    //                               tileMode: TileMode.repeated)
    //                           .createShader(
    //                         Rect.fromLTWH(0.0, 0.0, 3.0, 19.w),
    //                       ),
    //                   ),
    //           ),
    //         ),
    //         hideIcon
    //             ? const SizedBox()
    //             : MyImage.asset(
    //                 MyImagePaths.appDlbtw2,
    //                 width: 43.w,
    //                 height: 14.5.w,
    //               ),
    //       ],
    //     ),
    //   ),
    // );
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
    return GestureDetector(
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
