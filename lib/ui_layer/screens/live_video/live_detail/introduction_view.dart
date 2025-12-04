import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/model/live_video_detail_model.dart';
import 'package:jygf/domain/remote_domain/domains/live.dart';
import 'package:jygf/ui_layer/const.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/general_apps_list_widget.dart';
import 'package:jygf/ui_layer/screens/common_widgets/general_banner.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/live_video/live_card/live_video_card.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

class LiveVideoDetailIntroductionView extends StatefulWidget {
  const LiveVideoDetailIntroductionView(
      {super.key, required this.id, required this.data});

  final String id;
  final LiveVideoDetailData data;

  @override
  State<LiveVideoDetailIntroductionView> createState() =>
      _LiveVideoDetailIntroductionViewState();
}

class _LiveVideoDetailIntroductionViewState
    extends State<LiveVideoDetailIntroductionView> {
  late final liveDomain = context.read<LiveDomain>();

  Future<List<LiveModel>?> _getData(
      {required int page, required int pageSize}) async {
    final res = await liveDomain.getLiveRecommend(
        id: int.parse(widget.id), page: page, limit: 20 //推荐直播视频只显示20个
        );
    if (res.data case final data?) {
      return data;
    } else {
      if (res.msg case final msg?) {
        MyToast.showText(text: msg);
      }
    }
    if (mounted) {
      setState(() {});
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final videoInfo = widget.data;
    return MyListView.grid(
      childAspectRatio: UILayerConst.liveVideoRatio,
      crossAxisSpacing: 5.w,
      header: _HeaderView(data: videoInfo),
      isNeedMore: false,
      padding: EdgeInsets.symmetric(
          horizontal: MyTheme.pagePadding, vertical: MyTheme.pagePadding),
      itemBuilder: (context, item, index) => LiveVideoCard(data: item),
      onFetchingMore: (currentPage, pageSize) =>
          _getData(page: currentPage, pageSize: pageSize),
    );
  }
}

class _HeaderView extends StatefulWidget {
  const _HeaderView({required this.data});

  final LiveVideoDetailData data;

  @override
  State<_HeaderView> createState() => _HeaderViewState();
}

class _HeaderViewState extends State<_HeaderView> {
  @override
  Widget build(BuildContext context) {
    final videoInfo = widget.data.live;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: 5.w),
          Row(children: [
            MyImage.network(
              videoInfo.thumb ?? '',
              borderRadius: 18.w,
              width: 36.w,
              height: 36.w,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                videoInfo.username ?? '',
                style: MyTheme.white255_16_M,
                maxLines: 2,
              ),
            ),
          ]),
          Offstage(
              offstage: videoInfo.intro?.isEmpty ?? false,
              child: Padding(
                  padding: EdgeInsets.only(top: 15.w, bottom: 0),
                  child: Text(videoInfo.intro ?? '',
                      style: MyTheme.whiteOpacity614w500))),
          SizedBox(height: 22.w),
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
                  SizedBox(
                    width: 4.w,
                  ),
                  Text(
                    CommonUtils.renderEnFixedNumber(videoInfo.viewFct ?? 0),
                    style: MyTheme.whiteOpacity612w500,
                  ),
                  Text(
                    'cgk'.tr(context: context),
                    style: MyTheme.whiteOpacity612w500,
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StatefulBuilder(builder: (_, setState) {
                    final isFavorite = videoInfo.isFavorite == 1;

                    return GestureDetector(
                      onTap: () async {
                        if (videoInfo.id case final id?) {
                          final liveDomain = context.read<LiveDomain>();
                          final res = await liveDomain.getLiveFavorite(id: id);
                          if (res.isValid) {
                            if (res.data['is_favorite'] == 0) {
                              videoInfo.isFavorite = 0;
                              videoInfo.favoriteFct =
                                  (videoInfo.favoriteFct ?? 0) - 1;
                              videoInfo.favoriteFct! <= 0
                                  ? 0
                                  : videoInfo.favoriteFct;
                            } else {
                              videoInfo.isFavorite = 1;
                              videoInfo.favoriteFct =
                                  (videoInfo.favoriteFct ?? 0) + 1;
                            }
                            setState(() {});
                          } else if (res.msg case final msg?) {
                            MyToast.showText(text: msg);
                          }
                        }
                      },
                      child: _btnItem(
                        icon: isFavorite
                            ? MyImagePaths.appCollectRedOn
                            : MyImagePaths.appCollectWhiteOff,
                        name: 'sc'.tr(context: context),
                      ),
                    );
                  }),
                  SizedBox(width: 20.w),
                  GestureDetector(
                    onTap: () {
                      const MineShareToUserRoute().push(context);
                    },
                    child: _btnItem(
                      icon: MyImagePaths.app2024ComFenxiangOn,
                      name: 'fx'.tr(context: context),
                    ),
                  ),
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
          if (widget.data.banners case final banners? when banners.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 15.w),
              // child: GeneralAppsListVidget(
              //   apps: banners,
              // )

              child: GeneralBannerAppsListWidget(
                data: banners
                    .map((e) => BannerModel.fromJson(e.toJson()))
                    .toList(),
                // aspectRatio: 10 / 3,
              ),
            ),
          Text('rmzb'.tr(context: context), style: MyTheme.white16medium),
        ],
      ),
    );
  }

  Widget _btnItem({required String icon, required String name, Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MyImage.asset(
          icon,
          width: 16.w,
          fit: BoxFit.fitWidth,
        ),
        SizedBox(width: 4.w),
        Text(
          name,
          style: TextStyle(
            color: color ?? Colors.white.withOpacity(0.6),
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
        )
      ],
    );
  }
}
