import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/banner_model.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/model/cartoon/cartoon_detail_model.dart';
import 'package:jygf/domain/model/cartoon/cartoon_model.dart';

import '../../../../../../domain/api_validator.dart';
import '../../../../../../domain/domain.dart';
import '../../../../../../domain/model/feed/feed_model.dart';
import '../../../../../notifiers/user_notifier.dart';
import '../../../../../router/routes.dart';
import '../../../../../utils/common_utils.dart';
import '../../../../../utils/download_utils.dart';
import '../../../../../utils/my_toast.dart';
import '../../../../common_widgets/dialog/my_dialog.dart';
import '../../../../common_widgets/dialog/widgets/png_dialog.dart';
import '../../../../common_widgets/my_image.dart';
import '../../../../common_widgets/status/empty_data.dart';
import '../../../../image_paths.dart';
import '../../../../theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';import 'package:jygf/report/ui_layer/report_general_banner.dart';




class CartoonIntroductionView extends StatefulWidget {
  const CartoonIntroductionView(
      {super.key, required this.id, required this.data});
  final String id;
  final CartoonDetailModel data;
  @override
  State<CartoonIntroductionView> createState() =>
      _CartoonIntroductionViewState();
}

class _CartoonIntroductionViewState extends State<CartoonIntroductionView> {
  Widget _btnItem(
      {required String icon,
      required String name,
      Color? color,
      double? width}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MyImage.asset(
          icon,
          width: width ?? 18.w,
          fit: BoxFit.fitWidth,
        ),
        SizedBox(width: 4.w),
        Text(
          name,
          style: TextStyle(
            color: color ?? Colors.white.withOpacity(0.6),
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final videoInfo = widget.data.detail;
    // final topic = videoInfo.topic;
    // final desp = videoInfo.topic?['desp'] as String?;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: 5.w),
            Text(
              videoInfo.title ?? '',
              style: MyTheme.white255_18_M,
              maxLines: 10,
            ),
            // if (desp?.isNotEmpty == true)
            //   Padding(
            //     padding: EdgeInsets.only(top: 12.w),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Expanded(
            //           child: Text(
            //             desp!,
            //             style: MyTheme.gray163_13,
            //           ),
            //         ),
            //         ReportGestureDetector(
            //           behavior: HitTestBehavior.translucent,
            //           onTap: () {
            //
            //             // _showDespAlert();
            //           },
            //           child: Text(
            //             'qbjj'.tr(context: context),
            //             style: MyTheme.jellyCyan_13_M,
            //             textAlign: TextAlign.end,
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
            SizedBox(height: 22.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${videoInfo.viewFakeCount}${'cbf'.tr(context: context)}',
                  style: MyTheme.gray153_14_M,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StatefulBuilder(builder: (
                      _,
                      setState,
                    ) {
                      final isFavorites = videoInfo.isFavorite == 1;

                      return ReportGestureDetector(
                        onTap: () async {
                          if (videoInfo.id case final id?) {
                            final userDomain = context.read<UserDomain>();
                            final res =
                                await userDomain.userFavorite(type: 8, id: id);
                            if (res.isValid) {
                              videoInfo.isFavorite = isFavorites ? 0 : 1;

                              isFavorites
                                  ? videoInfo.favoriteFakeCount--
                                  : videoInfo.favoriteFakeCount++;
                              setState(() {});
                            } else if (res.msg case final msg?) {
                              MyToast.showText(text: msg);
                            }
                          }
                        },
                        child: _btnItem(
                          icon: isFavorites
                              ? MyImagePaths.appCollectOn
                              : MyImagePaths.appCollectOff,
                          name: CommonUtils.renderFixedNumber(
                              videoInfo.favoriteFakeCount),
                        ),
                      );
                    }),
                    SizedBox(width: 20.w),
                    ReportGestureDetector(
                      onTap: () {
                        const MineShareToUserRoute().push(context);
                      },
                      child: _btnItem(
                        icon: MyImagePaths.appShareOn,
                        name: 'fx'.tr(context: context),
                      ),
                    ),
                    if (!kIsWeb) SizedBox(width: 20.w),
                    if (!kIsWeb)
                      InkWell(
                        onTap: () async {
                          // 先判断本地有没有
                          final userNotifier = context.read<UserNotifier>();
                          final member = userNotifier.member;
                          if (member.vipLevel < 1) {
                            MyDialog.showDialog(
                              context: context,
                              child: PNGDialog(
                                buttonText: 'ljkt'.tr(),
                                cancelText: 'qx'.tr(),
                                confirmOnTap: () =>
                                    const VipCenterRoute().push(context),
                                content: Column(
                                  children: [
                                    Text(
                                      'wxts'.tr(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 46.w,
                                    ),
                                    Text(
                                      'ktvkpyp'.tr(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            final privilegeDomain =
                                context.read<PrivilegeDomain>();
                            final cache = context.read<CacheDomain>();
                            final downloadUtil = context.read<DownloadUtil>();

                            // final tags =
                            //     videoInfo.tags == '' || videoInfo.tags == null
                            //         ? []
                            //         : videoInfo.tags!.split(',');

                            final taskInfo = {
                              'id': '${videoInfo.id}',
                              'urlPath': videoInfo.source_240,
                              'title': videoInfo.title,
                              'thumbCover': videoInfo.cover,
                              'tags': [], // tags.join('/'),
                              'contentType': 1,
                              'downloading': false,
                              'isWaiting': true
                            };
                            final tasks = await cache.readDownloadVideoTasks();
                            final existTaskIndex = tasks
                                .indexWhere((e) => e['id'] == taskInfo['id']);
                            if (tasks.isNotEmpty && existTaskIndex != -1) {
                              final info = tasks[existTaskIndex];
                              if (info['progress'] == 1) {
                                MyToast.showText(
                                    text: 'wjyxz'.tr()); //当前视频已下载，请去我的下载缓存查看吧
                              } else {
                                MyToast.showText(
                                    text: 'dqrwcz'.tr()); //当前任务已经存在,请勿重复操作！
                              }
                              return;
                            }

                            ///修改数据
                            privilegeDomain
                                .downNum(id: '${videoInfo.id}')
                                .then((res) {
                              if (res.status == 1) {
                                final downNum = member.videoDownloadValue ?? 0;
                                if (downNum > 0) {
                                  userNotifier.setDownNum(num: downNum - 1);
                                }

                                downloadUtil.createDownloadTask(
                                    taskInfo: taskInfo);
                              } else {
                                MyToast.showText(text: res.msg ?? '');
                              }
                            });
                          }
                        },
                        child: _btnItem(
                          icon: MyImagePaths.appDownload,
                          width: 20.w,
                          name: 'xz'.tr(context: context),
                        ),
                      )
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.w),
              child: Container(
                height: 1.w,
                color: Colors.white.withOpacity(0.03),
              ),
            ),
            if (widget.data.banner case final banner? when banner.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 20.w),
                child: ReportGeneralAppsListVidget(
                  data: banner.map((e) => BannerModel.fromJson(e.toJson())).toList(),
                  aspectRatio: 7 / 2,
                ),
              ),
            Text('jctj'.tr(context: context), style: MyTheme.white16medium),
            RecommendListView(model: widget.data),
          ],
        ),
      ),
    );
  }
}

class RecommendListView extends StatefulWidget {
  const RecommendListView({super.key, required this.model});
  final CartoonDetailModel model;
  @override
  State<RecommendListView> createState() => _RecommendListViewState();
}

class _RecommendListViewState extends State<RecommendListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<CartoonModel> data = widget.model.recommend ?? [];
    return data.isEmpty
        ? const Center(child: PageEmptyDataView())
        : ListView.separated(
            padding: EdgeInsets.only(top: 8.w, bottom: 20.w),
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => SizedBox(
                  height: 16.w,
                ),
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) =>
                CartoonSingleColumCard(data: data[index]));
  }
}

class AdSingleColumnCard extends StatelessWidget {
  const AdSingleColumnCard({
    super.key,
    required this.data,
    this.imageRatio = 175 / 108,
  });
  final FeedAdModel data;
  final double imageRatio;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      final w = constrains.maxWidth;
      return ReportGestureDetector(
        onTap: () {},
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.w),
          child: Container(
            color: MyTheme.white008Color,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: 175.w,
                      height: w / imageRatio,
                      child: MyImage.network(
                        CommonUtils.clipImageUrl(
                          CommonUtils.getThumb(data.toJson()),
                          inputWidth: 175.w,
                        ),
                        borderRadius: 5.w,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 38.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(252, 231, 80, 1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(3.w),
                              bottomRight: Radius.circular(3.w)),
                        ),
                        child: Center(
                            child: Text(
                          'gg'.tr(context: context),
                          style: MyTheme.black12_M,
                        )),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            data.title,
                            style: MyTheme.white13,
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(height: 5.w),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            data.description ?? data.subTitle ?? '',
                            style: MyTheme.graya3a2a2_11,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Sized
              ],
            ),
          ),
        ),
      );
    });
  }
}

class CartoonSingleColumCard extends StatelessWidget {
  const CartoonSingleColumCard({
    super.key,
    required this.data,
    this.imageRatio = 175 / 108,
  });
  final CartoonModel data;
  final double imageRatio;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      return ReportGestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          CartoonDetailRoute('${data.id}').push(context);
          // VideoDetailRoute('${data.id}').push(context);

          // ComicDetailRoute(id: data.id ?? 0).push(context);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: 160.w,
                  height: 90.w,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      MyImage.network(
                        CommonUtils.clipImageUrl(
                          CommonUtils.getThumb(data.toJson()),
                          inputWidth: 175.w,
                        ),
                        borderRadius: 5.w,
                        fit: BoxFit.cover,
                      ),
                      data.type == 0
                          ? Container()
                          : Positioned(
                          top: 5.w,
                          left: 5.w,
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.w, vertical: 1.w),
                              decoration: BoxDecoration(
                                  color: MyTheme.blackColor18,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10.w))),
                              child: Row(children: [
                                MyImage.asset(
                                    data.type == 2
                                        ? MyImagePaths.appVideoCoins
                                        : MyImagePaths.appVideoVip,
                                    width: 11.5.w,
                                    height: 11.5.w),
                                SizedBox(width: 3.w),
                                Text(
                                  data.type == 2
                                      ? 'jb'.tr(context: context)
                                      : 'VIP',
                                  style: MyTheme.white10,
                                ),
                              ]))),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 4.w),
                          child: Text(
                              '${CommonUtils.getHMTime(data.duration ?? 0)}',
                              style: MyTheme.white12medium),
                        ),
                      ),
                      SizedBox(
                        height: 5.w,
                      ),
                    ],
                  )),
              SizedBox(
                width: 8.w,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        data.title ?? '',
                        style: MyTheme.white13,
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(height: 5.w),
                    // SizedBox(
                    //   height: 24.w,
                    //   child: ListView.separated(
                    //     separatorBuilder: (context, index) => SizedBox(
                    //       width: 16.w,
                    //     ),
                    //     padding: EdgeInsets.zero,
                    //     scrollDirection: Axis.horizontal,
                    //     physics: const NeverScrollableScrollPhysics(),
                    //     itemCount: min(data.tagList.length, 2),
                    //     itemBuilder: (context, index) => Container(
                    //       alignment: Alignment.center,
                    //       padding: EdgeInsets.symmetric(horizontal: 8.w),
                    //       decoration: ShapeDecoration(
                    //         color: Colors.white.withOpacity(0.1),
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(4)),
                    //       ),
                    //       child: Text(
                    //         data.tagList[index],
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.w400,
                    //             fontSize: 12.sp,
                    //             color: Colors.white.withOpacity(
                    //               0.7,
                    //             )),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 5.w,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            MyImage.asset(
                              MyImagePaths.app2024ComBofangliangBig1,
                              width: 16.w,
                              height: 16.w,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              CommonUtils.renderFixedNumber(data.viewFakeCount),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white.withOpacity(0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            MyImage.asset(
                              MyImagePaths.appCommentIcon,
                              width: 16.w,
                              height: 16.w,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '${data.commentCount}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white.withOpacity(0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              // Sized
            ],
          ),
        ),
      );
    });
  }
}
