//悬浮广告view
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../domain/model/banner_model.dart';
import '../../ui_layer/screens/common_widgets/my_image.dart';
import '../../ui_layer/screens/image_paths.dart';
import '../../ui_layer/screens/theme.dart';
import '../../ui_layer/utils/common_utils.dart';
import 'report_gesture_detector.dart';
import '../event_tracking.dart';
import 'report_timing_observer.dart';

class ReportTopADWidget extends StatefulWidget {
  const ReportTopADWidget({super.key, required this.toADs});

  final List<BannerModel> toADs;

  @override
  State<StatefulWidget> createState() => _ReportTopADWidgetState();
}

class _ReportTopADWidgetState extends State<ReportTopADWidget> {
  bool offstage = false;

  Map<String, bool> adIdMap = {}; // 已经显示true 未显示null
  List<String> get adIds => List<String>.from(adIdMap.keys);
  bool didReport = false; //本生命周期内 只上报一次

  void _showBanner(BannerModel banner) {
    // 没存进Map 就是没上传过show 上传&记录
    if (adIdMap[banner.advertiseCode] == null) {
      postActionReport(banner, "show");
      adIdMap[banner.advertiseCode ?? ''] = true;
    }

    if (adIds.length == widget.toADs.length) {
      postShowReport();
    }
  }

  //展示广告上报 展示完或页面消失上报
  void postShowReport() {
    if (didReport) return;

    // final pageName = context.parentTitle;
    // final widgetType = context.parentWidgetType.toString();
    BannerModel tp = widget.toADs.first;
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
    // final pageName = context.parentTitle;
    // final widgetType = context.parentWidgetType.toString();

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
    postActionReport(tp, "click");

    // final pageName = context.parentTitle;
    // final widgetType = context.parentWidgetType.toString();
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
  Widget build(BuildContext context) {
    return widget.toADs.isEmpty ? Container() : _buildButton();
  }

  Widget _buildButton() {
    return Offstage(
      offstage: offstage,
      child: SizedBox(
        width: 120.w,
        height: 120.w,
        child: Stack(
          children: [
            Positioned.fill(
                child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                  // color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(5.w))),
              child: Swiper(
                autoplay: widget.toADs.length > 1,
                loop: widget.toADs.length > 1,
                itemBuilder: (BuildContext context, int index) {
                  double w = 80.w;
                  return VisibilityDetector(
                    key: Key("swiper_item_$index"),
                    onVisibilityChanged: (info) {
                      if (didReport) {
                        return;
                      }
                      if (info.visibleFraction > 0.8 &&
                          adIds.length < widget.toADs.length) {
                        _showBanner(widget.toADs[index]);
                      }
                    },
                    child: ReportGestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        postClickReport(widget.toADs[index]);
                        CommonUtils.openRoute(
                            context, widget.toADs[index].toJson());
                      },
                      child: SizedBox(
                          width: w,
                          height: w,
                          child: MyImage.network(
                            CommonUtils.getThumb(widget.toADs[index].toJson()),
                            borderRadius: 5.w,
                          )),
                    ),
                  );
                },
                itemCount: widget.toADs.length,
                pagination: widget.toADs.length > 1
                    ? SwiperPagination(
                        margin: EdgeInsets.only(bottom: 5.w),
                        builder:
                            SwiperCustomPagination(builder: (context, config) {
                          int count = widget.toADs.length;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(count, (index) {
                              return config.activeIndex == index
                                  ? Container(
                                      width: 4.w,
                                      height: 4.w,
                                      margin: EdgeInsets.only(right: 4.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(2.w)),
                                      ),
                                    )
                                  : Container(
                                      width: 4.w,
                                      height: 4.w,
                                      margin: EdgeInsets.only(right: 4.w),
                                      decoration: BoxDecoration(
                                        color: MyTheme.grayColor150,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(2.w)),
                                      ),
                                    );
                            }),
                          );
                        }))
                    : null,
              ),
            )),
            Positioned(
                right: 0,
                top: 0,
                width: 20.w,
                height: 20.w,
                child: ReportGestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        offstage = true;
                      });
                    },
                    child: const MyImage.asset(MyImagePaths.appDialogClose)))
          ],
        ),
      ),
    );
  }
}
