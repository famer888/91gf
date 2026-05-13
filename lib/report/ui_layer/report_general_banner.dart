import 'package:analytics_sdk/analytics_sdk.dart';
import 'package:analytics_sdk/entity/ad_click_event.dart';
import 'package:analytics_sdk/entity/ad_impression_event.dart';
import 'package:analytics_sdk/entity/advertising_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../ui_layer/notifiers/home_config_notifier.dart';
import '../../../domain/model/banner_model.dart';
import '../../ui_layer/screens/common_widgets/my_image.dart';
import '../../ui_layer/utils/common_utils.dart';
import '../analytics/analytics_page_sync.dart';
import '../event_tracking.dart';
import 'report_general_apps_list_swiper.dart';
import 'report_gesture_detector.dart';
import 'report_timing_observer.dart';

class ReportGeneralBanner extends StatefulWidget {
  const ReportGeneralBanner({
    super.key,
    required this.data,
    this.radius = 5,
    this.aspectRatio = 7 / 3,
  });
  final List<BannerModel> data;
  final double radius;
  final double aspectRatio;

  @override
  State<ReportGeneralBanner> createState() => _ReportGeneralBannerState();
}

class _ReportGeneralBannerState extends State<ReportGeneralBanner> {
  Map<String, bool> adIdMap = {}; // 已经显示true 未显示null
  List<String> get adIds => List<String>.from(adIdMap.keys);
  bool didReport = false; //本生命周期内 只上报一次

  void _showBanner(BannerModel banner) {
    // 没存进Map 就是没上传过show 上传&记录

    CommonUtils.log('_showBanner ');
    if (adIdMap[banner.advertiseCode] == null) {
      CommonUtils.log('_showBanner show');
      postActionReport(banner, "show");
      adIdMap[banner.advertiseCode ?? ''] = true;
    }

    if (adIds.length == widget.data.length) {
      postShowReport();
    }
  }

  //展示广告上报 展示完或页面消失上报
  void postShowReport() {
    if (didReport) return;

    // final pageName = context.parentTitle;
    // final widgetType = context.parentWidgetType.toString();
    BannerModel tp = widget.data.first;
    final pageInfo = syncAnalyticsPageFromContext(context);
    AnalyticsSdk.instance.track(
      AdImpressionEvent(
        pageKey: pageInfo.pageKey,
        pageName: pageInfo.pageName,
        adSlotKey: tp.advertiseLocationCode ?? '',
        adSlotName: tp.adSlotName ?? '',
        adId: adIds.join(","),
        creativeId: "",
        adType: tp.adType ?? '',
      ),
    );

    EventTracking().reportSingle({
      "event": "ad_impression",
      "page_key": RouteStore.currentPageKey,
      "page_name": RouteStore.currentPageName,
      "ad_slot_key": tp.advertiseLocationCode,
      "ad_slot_name": tp.adSlotName,
      "ad_id": adIds.join(","),
      "creative_id": "",
      "ad_type": tp.adType,
    }).then((value) {
      didReport = true;
      // CommonUtils.log(value);
    });
  }

  //上传广告行为
  void postActionReport(BannerModel tp, String action) {
    AnalyticsSdk.instance.track(
      AdvertisingEvent(
        eventType: action,
        advertisingKey: tp.advertiseLocationCode ?? '',
        advertisingName: tp.adSlotName ?? '',
        advertisingId: tp.advertiseCode ?? '',
      ),
    );

    EventTracking().reportSingle({
      "event": "advertising",
      "event_type": action,
      "advertising_key": tp.advertiseLocationCode,
      "advertising_name": tp.adSlotName,
      "advertising_id": tp.advertiseCode,
    });
  }

  //点击广告上报
  void postClickReport(BannerModel tp) {
    final pageInfo = syncAnalyticsPageFromContext(context);
    AnalyticsSdk.instance.track(
      AdClickEvent(
        pageKey: pageInfo.pageKey,
        pageName: pageInfo.pageName,
        adSlotKey: tp.advertiseLocationCode ?? '',
        adSlotName: tp.adSlotName ?? '',
        adId: tp.advertiseCode ?? '',
        creativeId: '',
        adType: tp.adType ?? '',
      ),
    );
    postActionReport(tp, "click");

    EventTracking().reportSingle({
      "event": "ad_click",
      "page_key": RouteStore.currentPageKey,
      "page_name": RouteStore.currentPageName,
      "ad_slot_key": tp.advertiseLocationCode,
      "ad_slot_name": tp.adSlotName,
      "ad_id": tp.advertiseCode,
      "creative_id": "",
      "ad_type": tp.adType,
    }).then((value) {
      // CommonUtils.log(value);
    });
  }

  @override
  void dispose() {
    postShowReport();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final length = widget.data.length;

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius),
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Swiper(
          autoplay: length > 1,
          itemBuilder: (BuildContext context, int index) {
            precacheImage(
                NetworkImage(CommonUtils.getThumb(
                    widget.data[(index + 1).clamp(0, length - 1)].toJson())),
                context);

            return VisibilityDetector(
              key: Key("swiper_item_$index"),
              onVisibilityChanged: (info) {
                if (didReport) {
                  return;
                }
                if (info.visibleFraction > 0.8 &&
                    adIds.length < widget.data.length) {
                  _showBanner(widget.data[index]);
                }
              },
              child: ReportGestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  CommonUtils.openRoute(context, widget.data[index].toJson());

                  EventTracking().reportSingle({});
                },
                child: MyImage.network(
                  CommonUtils.getThumb(widget.data[index].toJson()),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
          itemCount: length,
          pagination: SwiperPagination(
            builder: SwiperCustomPagination(
              builder: (context, config) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  length,
                  (index) {
                    bool isActive = config.activeIndex == index;
                    return Container(
                      width: 5.w,
                      height: 5.w,
                      margin: EdgeInsets.only(right: 7.w),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white
                            : Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ReportGeneralAppsListVidget extends StatefulWidget {
  const ReportGeneralAppsListVidget({
    super.key,
    required this.data,
    this.radius = 5,
    this.aspectRatio = 7 / 3,
  });
  final List<BannerModel> data;
  final double radius;
  final double aspectRatio;
  State<ReportGeneralAppsListVidget> createState() =>
      _ReportGeneralAppsListVidgetState();
}

class _ReportGeneralAppsListVidgetState
    extends State<ReportGeneralAppsListVidget> {
  late final homeConfigNotifier = context.read<HomeConfigNotifier>();
  List<BannerModel> apps = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.data != null) {
      apps = widget.data ?? [];
    } else {
      // apps = homeConfigNotifier.homeData.adsDetailBlock ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (homeConfigNotifier.config.adVersion != 1) {
      return RepaintBoundary(
        child: ReportGeneralBanner(
          data: widget.data,
          radius: widget.radius,
          aspectRatio: widget.aspectRatio,
        ),
      );
    }
    return RepaintBoundary(
      child: ReportGeneralAppListSwiper(
        data: widget.data,
        radius: widget.radius,
        aspectRatio: widget.aspectRatio,
      ),
    );
  }
}
