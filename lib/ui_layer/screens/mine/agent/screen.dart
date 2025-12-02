import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return Scaffold(
      backgroundColor: MyTheme.blackColor22,
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
                          : Stack(
                              children: [
                                Container(
                                  height: 157.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.w),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color.fromRGBO(210, 163, 127, 1),
                                        Color.fromRGBO(245, 228, 212, 1),
                                        Color.fromRGBO(232, 207, 183, 1),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 53.w,
                                      margin: EdgeInsets.all(16.5.w),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            clipBehavior: Clip.hardEdge,
                                            borderRadius:
                                                BorderRadius.circular(26.5.w),
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${data.levelStr}',
                                                      style: MyTheme
                                                          .brown916044_14medium,
                                                    ),
                                                    Text(
                                                      'ktxje'
                                                          .tr(context: context),
                                                      style: MyTheme
                                                          .brown916044_12semibold,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'yhysj'
                                                          .tr(context: context),
                                                      style: MyTheme
                                                          .brown916044_12medium,
                                                    ),
                                                    Text(
                                                      data.money,
                                                      style: MyTheme
                                                          .brown916044_24semibold,
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10.w),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _CardButton(
                                          onTap: () {
                                            const MineWithdrawalRoute(true)
                                                .push(context);
                                          },
                                          text: 'ljtx'.tr(context: context),
                                        ),
                                        SizedBox(width: 54.w),
                                        _CardButton(
                                          onTap: () {
                                            const MineAgentPromoteDataRoute()
                                                .push(context);
                                          },
                                          text: 'tgsj'.tr(context: context),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: MyTheme.blackColor32,
                          borderRadius: BorderRadius.circular(5.w),
                        ),
                        child: Column(
                          children: [
                            AgentTitleWidget('czjd'.tr(context: context)),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'czsm'.tr(context: context),
                                style: MyTheme.gold15,
                              ),
                            ),
                            Text(
                              'czsmza'.tr(context: context),
                              style: TextStyle(
                                  color: const Color.fromRGBO(255, 255, 255, 1),
                                  fontSize: 11.sp,
                                  overflow: TextOverflow.visible,
                                  decoration: TextDecoration.none),
                              // maxLines: 3,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'syly'.tr(context: context),
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
                      ),
                      Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            color: MyTheme.blackColor32,
                            borderRadius: BorderRadius.circular(5.w),
                          ),
                          child: Column(children: [
                            AgentTitleWidget('dldjsm'.tr(context: context)),
                            SizedBox(height: 20.w),
                            Table(
                              border: TableBorder.all(
                                color: tableBorderColor,
                                width: 1.w,
                              ),
                              children: levelList.asMap().keys.map(
                                (index) {
                                  TextStyle style = index == 0
                                      ? MyTheme.gold12medium
                                      : TextStyle(
                                          color: const Color.fromRGBO(
                                              255, 255, 255, 1),
                                          fontSize: 11.sp,
                                          overflow: TextOverflow.visible,
                                          decoration: TextDecoration.none,
                                        );
                                  final height = (index == 0 ? 30 : 46).w;

                                  return TableRow(children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 71,
                                          child: Container(
                                            height: height,
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${levelList[index]}j'
                                                  .tr(context: context),
                                              style: style,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          color: tableBorderColor,
                                          height: height,
                                          width: 1,
                                        ),
                                        Expanded(
                                            flex: 71,
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '${levelList[index]}jp'
                                                    .tr(context: context),
                                                style: style,
                                              ),
                                            )),
                                        Container(
                                          color: tableBorderColor,
                                          height: height,
                                          width: 1,
                                        ),
                                        Expanded(
                                            flex: 176,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.w),
                                              alignment: Alignment.center,
                                              child: Text(
                                                '${levelList[index]}jc'
                                                    .tr(context: context),
                                                style: style,
                                                textAlign: TextAlign.center,
                                                // maxLines: 2,
                                              ),
                                            )),
                                      ],
                                    ),
                                  ]);
                                },
                              ).toList(),
                            ),
                          ])),
                      Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                              color: MyTheme.blackColor32,
                              borderRadius: BorderRadius.circular(5.w)),
                          child: Column(children: [
                            AgentTitleWidget('ztsy'.tr(context: context)),
                            SizedBox(height: 20.w),
                            Text(
                              'ztsyx'.tr(context: context),
                              style: TextStyle(
                                color: const Color.fromRGBO(255, 255, 255, 1),
                                fontSize: 11.sp,
                                overflow: TextOverflow.visible,
                                decoration: TextDecoration.none,
                              ),
                              // maxLines: 3,
                            ),
                            SizedBox(height: 20.w),
                            MyImage.asset(
                              MyImagePaths.appDlcj,
                              width: 283.w,
                              height: 121.w,
                            ),
                          ])),
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: MyTheme.blackColor32,
                          borderRadius: BorderRadius.circular(5.w),
                        ),
                        child: Column(
                            children: [
                          AgentTitleWidget('cjsyt'.tr(context: context)),
                          Text(
                            'cjsyx'.tr(context: context),
                            style: TextStyle(
                              color: const Color.fromRGBO(255, 255, 255, 1),
                              fontSize: 11.sp,
                              overflow: TextOverflow.visible,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Container(
                            alignment: Alignment.topCenter,
                            width: double.infinity,
                            child: MyImage.asset(
                              MyImagePaths.appDlcy,
                              width: 340.w,
                              height: 165.w,
                            ),
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text: 'cjsyy'.tr(context: context),
                              style: MyTheme.white11,
                            ),
                            TextSpan(
                              text: 'cjsyyw'.tr(context: context),
                              style: TextStyle(
                                color: const Color.fromRGBO(0, 188, 9, 1),
                                fontSize: 11.sp,
                                overflow: TextOverflow.ellipsis,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ])),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text: 'cjsye'.tr(context: context),
                              style: MyTheme.white11,
                            ),
                            TextSpan(
                              text: 'cjsyew'.tr(context: context),
                              style: TextStyle(
                                color: const Color.fromRGBO(36, 98, 239, 1),
                                fontSize: 11.sp,
                                overflow: TextOverflow.ellipsis,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ])),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'cjsyys'.tr(context: context),
                                  style: MyTheme.white11,
                                ),
                                TextSpan(
                                  text: 'cjsysw'.tr(context: context),
                                  style: TextStyle(
                                    color:
                                        const Color.fromRGBO(239, 127, 36, 1),
                                    fontSize: 11.sp,
                                    overflow: TextOverflow.ellipsis,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]
                                .map((e) => Column(
                                      children: [
                                        e,
                                        SizedBox(height: 15.w),
                                      ],
                                    ))
                                .toList()),
                      ),
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                            color: MyTheme.blackColor32,
                            borderRadius: BorderRadius.circular(5.w)),
                        child: Column(children: [
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
                          AgentTitleWidget(
                            'gzkd'.tr(context: context),
                            hideIcon: true,
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
                            child: MyImage.asset(
                              MyImagePaths.appDljq,
                              width: 255.w,
                              height: 35.w,
                            ),
                          ),
                          SizedBox(height: 15.w),
                        ]),
                      ),
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
                                  width: 264.w,
                                  height: 38.5.w,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFfaddbd),
                                        Color(0xFFf2c380)
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(19.25.w),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'ljtg'.tr(context: context),
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xffaa5000),
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
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class AgentTitleWidget extends StatelessWidget {
  const AgentTitleWidget(this.title, {super.key, this.hideIcon = false});
  final String title;
  final bool hideIcon;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: UnconstrainedBox(
        child: Row(
          children: [
            hideIcon
                ? Container()
                : MyImage.asset(
                    MyImagePaths.appDlbtw,
                    width: 43.w,
                    height: 14.5.w,
                  ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.5.w),
              child: Text(
                title,
                style: kIsWeb
                    ? MyTheme.gold18M
                    : TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                        foreground: Paint()
                          ..shader = const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: <Color>[
                                    Color.fromRGBO(236, 180, 129, 1),
                                    Color.fromRGBO(255, 238, 216, 1),
                                  ],
                                  tileMode: TileMode.repeated)
                              .createShader(
                            Rect.fromLTWH(0.0, 0.0, 3.0, 19.w),
                          ),
                      ),
              ),
            ),
            hideIcon
                ? const SizedBox()
                : MyImage.asset(
                    MyImagePaths.appDlbtw2,
                    width: 43.w,
                    height: 14.5.w,
                  ),
          ],
        ),
      ),
    );
  }
}

class _CardButton extends StatelessWidget {
  const _CardButton({
    required this.onTap,
    required this.text,
  });
  final GestureTapCallback onTap;
  final String text;
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
            gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: <Color>[
                Color.fromRGBO(24, 23, 21, 1),
                Color.fromRGBO(76, 56, 28, 1)
              ],
            )),
        child: Text(
          text,
          style: MyTheme.hexf2c774_14,
        ),
      ),
    );
  }
}
