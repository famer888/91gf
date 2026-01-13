import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/novel_model.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class NovelListCard extends StatelessWidget {
  const NovelListCard({super.key, required this.data});

  final NovelItemsModel data;

  String get imageUrl => CommonUtils.getThumb(data.toJson());

  @override
  Widget build(BuildContext context) {
    return ReportGestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        NovelDetailRoute(data.id.toString() ?? '').push(context);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(5.w),
                  bottomRight: Radius.circular(5.w)),
            ),
            clipBehavior: Clip.antiAlias,
            width: 90.w,
            height: 120.w,
            child: MyImage.network(
              imageUrl, fit: BoxFit.fill, borderRadius: 5.w),
          ),
          Expanded(
            child: Container(
              height: 110.w,
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: MyTheme.white008Color,
                borderRadius: BorderRadius.only(topRight: Radius.circular(5.w),
                bottomRight: Radius.circular(5.w)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(data.title ?? '', style: MyTheme.white14,
                      maxLines: 1),
                  Flexible(
                    child: Text(data.intro ?? '', style: MyTheme.white07_12,
                        maxLines: 3),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${CommonUtils.renderFixedNumber(data.viewFct ?? 0)}${'gk'.tr(context: context)}',
                        style: MyTheme.white04_12,
                        // textAlign: ,
                      ),
                      Text(
                        data.isEnd == 1
                            ? 'wj'.tr(context: context)
                            : 'lzz'.tr(context: context),
                        // '${'gxz'.tr(context: context)}${data.chapterCt}${'hua'.tr(context: context)}',
                        style: MyTheme.white04_12,
                        // textAlign: ,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
