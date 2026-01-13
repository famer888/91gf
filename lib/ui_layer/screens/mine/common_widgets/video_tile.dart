import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../domain/model/collection_model.dart';
import '../../../router/routes.dart';
import '../../../utils/common_utils.dart';
import '../../theme.dart';
import '../../common_widgets/my_image.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class MineVideoTile extends StatelessWidget {
  const MineVideoTile({super.key, required this.data});
  final MineVideoCardData data;
  @override
  Widget build(BuildContext context) {
    double w = (1.sw - MyTheme.pagePadding * 2 - 4.w) / 2;
    return ReportGestureDetector(
      onTap: () {
        VideoDetailRoute('${data.id}').push(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: w / 173 * 100,
            width: w,
            child: MyImage.network(
              CommonUtils.clipImageUrl(
                CommonUtils.getThumb(data.toJson()),
                inputWidth: 173.w,
              ),
              borderRadius: 5,
            ),
          ),
          SizedBox(height: 3.5.w),
          Text(data.title ?? 'loading', style: MyTheme.white255_14, maxLines: 2),
          SizedBox(height: 3.5.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  '${CommonUtils.renderFixedNumber(data.playCt ?? 0)}${'cbf'.tr(context: context)}',
                  style: MyTheme.gray105_11),
              const Spacer(),
              Text('${CommonUtils.getHMTime(data.duration ?? 0)}',
                  style: MyTheme.gray105_11),
              SizedBox(width: 5.w)
            ],
          )
        ],
      ),
    );
  }
}
