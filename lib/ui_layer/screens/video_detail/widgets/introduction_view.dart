import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/common_widgets/follow_button.dart';
import 'package:jygf/ui_layer/screens/common_widgets/general_apps_list_widget.dart';
import 'package:jygf/ui_layer/screens/common_widgets/general_banner.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_avatar.dart';
import 'package:provider/provider.dart';

import '../../../../domain/api_validator.dart';
import '../../../../domain/async_value.dart';
import '../../../../domain/domain.dart';
import '../../../../domain/model/feed/feed_model.dart';
import '../../../../domain/model/video_detail_model.dart';
import '../../../notifiers/user_notifier.dart';
import '../../../router/routes.dart';
import '../../../utils/common_utils.dart';
import '../../../utils/download_utils.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/dialog/my_dialog.dart';
import '../../common_widgets/dialog/widgets/png_dialog.dart';
import '../../common_widgets/my_image.dart';
import '../../common_widgets/status/empty_data.dart';
import '../../common_widgets/status/loading.dart';
import '../../common_widgets/status/network_error.dart';
import '../../image_paths.dart';
import '../../theme.dart';

class IntroductionView extends StatefulWidget {
  const IntroductionView({super.key, required this.id, required this.data});
  final String id;
  final VideoDetailData data;
  @override
  State<IntroductionView> createState() => _IntroductionViewState();
}

class _IntroductionViewState extends State<IntroductionView> {
  late final userNotifier = context.read<UserNotifier>();

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
            SizedBox(height: 5.w),
            Text(
              videoInfo.title ?? '',
              style: MyTheme.white255_18_M,
              maxLines: 5,
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
            //         GestureDetector(
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
            widget.data.detail.member == null
                ? Container()
                : Container(
                    padding: EdgeInsets.only(top: 13.w),
                    child: GestureDetector(
                      onTap: () {
                        UserCenterRoute('${widget.data.detail.member?.aff}')
                            .push(context);
                      },
                      child: Row(children: [
                        MyAvatar(
                            size: 50.w,
                            thumb: widget.data.detail.member?.thumb ?? ''),
                        SizedBox(width: 10.w),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text(widget.data.detail.member?.nickname ?? '',
                                  style: MyTheme.white16medium),
                              SizedBox(height: 2.w),
                              Text(
                                  '${'zp'.tr(context: context)}${CommonUtils.renderFixedNumber(widget.data.detail.member?.workCt ?? 0)}  |  ${'fans'.tr(context: context)}${CommonUtils.renderFixedNumber(widget.data.detail.member?.fansCt ?? 0)}',
                                  style: MyTheme.white07_14),
                            ])),
                        Selector<UserNotifier, bool>(
                            selector: (_, notifier) => notifier
                                .userFollowingStatus
                                .contains('${widget.data.detail.member?.aff}'),
                            builder: (_, isFollowed, __) {
                              return FollowButton(
                                  isFollowed: isFollowed,
                                  onTap: () async {
                                    await userNotifier.changeUserFollow(
                                        '${widget.data.detail.member?.aff}');
                                  });
                            })
                      ]),
                    ),
                  ),
            SizedBox(height: 22.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${videoInfo.countPlay}${'cbf'.tr(context: context)}',
                  style: MyTheme.gray153_14_M,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StatefulBuilder(builder: (
                      _,
                      setState,
                    ) {
                      final isFavorites = videoInfo.userFavorites == 1;

                      return GestureDetector(
                        onTap: () async {
                          if (videoInfo.id case final id?) {
                            final userDomain = context.read<UserDomain>();
                            final res =
                                await userDomain.userFavorites(type: 1, id: id);
                            if (res.isValid) {
                              videoInfo.userFavorites = isFavorites ? 0 : 1;
                              isFavorites
                                  ? videoInfo.favorites--
                                  : videoInfo.favorites++;
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
                              videoInfo.favorites),
                        ),
                      );
                    }),
                    SizedBox(width: 20.w),
                    GestureDetector(
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
                          if (member.vipLevel < 1 && false) {
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

                            final tags =
                                videoInfo.tags == '' || videoInfo.tags == null
                                    ? []
                                    : videoInfo.tags!.split(',');

                            final taskInfo = {
                              'id': '${videoInfo.id}',
                              'urlPath': videoInfo.source240,
                              'title': videoInfo.title,
                              'thumbCover': videoInfo.coverThumbHorizontal ??
                                  videoInfo.coverThumbVerticle,
                              'tags': tags.join('/'),
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
                  padding: EdgeInsets.only(bottom: 15.w),
                  child: GeneralBannerAppsListWidget(
                    data: banner,
                  )
                  // child: GeneralBannerAppsListWidget(
                  //   data: banner,
                  //   aspectRatio: 7 / 2,
                  // ),
                  ),
            Text('jctj'.tr(context: context), style: MyTheme.white16medium),
            RecommendListView(id: widget.id),
          ],
        ),
      ),
    );
  }
}

class RecommendListView extends StatefulWidget {
  const RecommendListView({super.key, required this.id});
  final String id;
  @override
  State<RecommendListView> createState() => _RecommendListViewState();
}

class _RecommendListViewState extends State<RecommendListView> {
  late final mvDomain = context.read<MvDomain>();

  AsyncValue<List<FeedModel>> _asyncValue = const AsyncInit();

  @override
  void initState() {
    _initData();
    super.initState();
  }

  Future _initData() async {
    if (_asyncValue.isLoading) {}
    final res = await mvDomain.getDetailRecommendList(id: widget.id);
    if (res.data case final data?) {
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

  @override
  Widget build(BuildContext context) {
    return _asyncValue.maybeWhen(
      orElse: () => Padding(
        padding: EdgeInsets.only(top: 30.w),
        child: const LoadingView(),
      ),
      error: (_, __) => Padding(
        padding: EdgeInsets.only(top: 30.w),
        child: NetworkErrorView(
          onTap: _initData,
        ),
      ),
      data: (data) {
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
                itemBuilder: (context, index) => data[index].map(
                  video: (video) => VideoSingleColumCard(data: video),
                  ad: (ad) => AdSingleColumnCard(data: ad),
                ),
              );
      },
    );
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
      return GestureDetector(
        onTap: () {},
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.w),
          child: Container(
            color: const Color.fromRGBO(21, 21, 42, 1),
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

class VideoSingleColumCard extends StatelessWidget {
  const VideoSingleColumCard({
    super.key,
    required this.data,
    this.imageRatio = 175 / 108,
  });
  final FeedVideoModel data;
  final double imageRatio;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      return GestureDetector(
        onTap: () {
          VideoDetailRoute('${data.id}').push(context);
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
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 4.w),
                          child: Text('${CommonUtils.getHMTime(data.duration)}',
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
                        data.title,
                        style: MyTheme.white13,
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(height: 5.w),
                    SizedBox(
                      height: 24.w,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(
                          width: 16.w,
                        ),
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: min(data.tagList.length, 2),
                        itemBuilder: (context, index) => Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          decoration: ShapeDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          child: Text(
                            data.tagList[index],
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                                color: Colors.white.withOpacity(
                                  0.7,
                                )),
                          ),
                        ),
                      ),
                    ),
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
                              CommonUtils.renderFixedNumber(data.playCt),
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
                              '${data.countComment}',
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
