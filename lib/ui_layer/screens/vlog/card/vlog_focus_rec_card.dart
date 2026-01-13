import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/domain.dart';
import 'package:jygf/domain/model/vlog_model.dart';
import 'package:jygf/domain/type_def.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/follow_button.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class VlogFocusRecCard extends StatefulWidget {
  const VlogFocusRecCard({super.key, required this.data});

  final RecommendBloggerModel data;

  @override
  State<VlogFocusRecCard> createState() => _VlogFocusRecCardState();
}

class _VlogFocusRecCardState extends State<VlogFocusRecCard> {
  @override
  Widget build(BuildContext context) {
    return ReportGestureDetector(
      onTap: () {
        //点击头像加入用户详情
        final aff = '${widget.data.aff}';
        UserCenterRoute(aff).push(context);
      },
      child: Container(
        padding: EdgeInsets.all(MyTheme.pagePadding),
        margin: EdgeInsets.only(bottom: 10.w),
        decoration: BoxDecoration(
          color: MyTheme.white008Color,
          borderRadius: BorderRadius.all(Radius.circular(10.w)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50.w,
                  width: 50.w,
                  child: MyImage.network(widget.data.thumb ?? '',
                      borderRadius: 25.w),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.data.nickname ?? '',
                            style: MyTheme.white255_15_semibold,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          if (widget.data.mvs?.first.member?.agent == 1) ...[
                            SizedBox(width: 5.w),
                            Icon(
                              Icons.verified_sharp,
                              size: 15.w,
                              color: const Color.fromRGBO(247, 208, 93, 1),
                            ),
                          ]
                        ],
                      ),
                      SizedBox(height: 2.w),
                      Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: CommonUtils.renderNumber(
                                      int.parse(widget.data.likeCt ?? '0')),
                                  style: MyTheme.white12,
                                ),
                                TextSpan(
                                  text: ' ${'zan'.tr(context: context)}',
                                  style: MyTheme.white07_14,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15.w),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: CommonUtils.renderNumber(
                                      int.parse(widget.data.vlogCt ?? '0')),
                                  style: MyTheme.white12,
                                ),
                                TextSpan(
                                  text: ' ${'zp'.tr(context: context)}',
                                  style: MyTheme.white07_14,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15.w),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: CommonUtils.renderNumber(
                                      int.parse(widget.data.fansCt ?? '0')),
                                  style: MyTheme.white12,
                                ),
                                TextSpan(
                                  text: ' ${'fans'.tr(context: context)}',
                                  style: MyTheme.white07_14,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                FollowButton(
                    isFollowed: widget.data.isFollow == 1,
                    onTap: () {
                      changeUserFollow('${widget.data.aff}');
                    }),
              ],
            ),
            SizedBox(height: 10.w),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 10.w),
            //   child: Text('简介：什么都没有留下',
            //       style: MyTheme.white14, maxLines: 10),
            // ),
            widget.data.mvs?.isEmpty ?? false
                ? Container()
                : SizedBox(
                    height: 140.w,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.data.mvs?.length,
                      // shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 10.w,
                        crossAxisSpacing: 10.w,
                        childAspectRatio: 140 / 100,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final data = widget.data.mvs?[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: MyTheme.white008Color,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.w)),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Positioned.fill(
                                child: MyImage.network(
                                  data?.coverHorizontal ?? '',
                                  fit: BoxFit.cover,
                                  backgroundColor: MyTheme.imageBgColor,
                                  borderRadius: 5.w,
                                ),
                              ),
                              Positioned(
                                  bottom: 0.w,
                                  left: 0.w,
                                  right: 0.w,
                                  child: Container(
                                    height: 30.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.w)),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color.fromRGBO(0, 0, 0, 0.6),
                                            Color.fromRGBO(0, 0, 0, 0),
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        )),
                                  )),
                              Positioned(
                                bottom: 3.w,
                                left: 2.w,
                                right: 2.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            MyImage.asset(MyImagePaths.appHots,
                                                height: 18.w, width: 18.w),
                                            Text(
                                              '${CommonUtils.renderFixedNumber(data?.playCt ?? 0)}',
                                              style: MyTheme.white07_10,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          RelativeDateFormat.getHMTime(
                                              time: data?.duration),
                                          style: MyTheme.white07_10,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // data.isfree == 0
                              false
                                  ? Container()
                                  : Positioned(
                                      top: 5.w,
                                      left: 2.w,
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.w, vertical: 1.w),
                                          decoration: BoxDecoration(
                                              color: MyTheme.blackColor25505,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.w))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // MyImage.asset(
                                              //     data?.isFree == 2
                                              //         ? MyImagePaths
                                              //             .appVideoCoins
                                              //         : MyImagePaths
                                              //             .appVideoVip,
                                              //     width: 11.5.w,
                                              //     height: 11.5.w),
                                              SizedBox(width: 3.w),
                                              Text(
                                                data?.isFree == 2
                                                    ? 'jb'.tr(context: context)
                                                    : 'VIP',
                                                style: MyTheme.white10,
                                              ),
                                            ],
                                          ))),
                            ],
                          ),
                        );
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Future changeUserFollow(String id) async {
    late final domain = context.read<UserDomain>();
    final res = await domain.communityFollowUser(aff: id);
    if (res.isValid) {
      final follow = res.data['is_follow'];
      widget.data.isFollow = follow;
    } else {
      MyToast.showText(text: res.msg ?? '');
    }

    setState(() {});
  }
}
