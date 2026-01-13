import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/comic_model.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class ComicAdCard extends StatelessWidget {
  const ComicAdCard({super.key, required this.data});
  final RecComicModel data;

  String get imgUrl => data.imgUrl ?? '';

  @override
  Widget build(BuildContext context) {
    return ReportGestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        CommonUtils.openRoute(context, data.toJson());
      },
      child: AspectRatio(
        aspectRatio: 7 / 2,
        child: Stack(
          fit: StackFit.expand,
          children: [
            MyImage.network(
              imgUrl,
              borderRadius: 5.w,
              fit: BoxFit.cover,
            ),
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 38.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(252, 231, 80, 0.8),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3.w),
                      bottomRight: Radius.circular(3.w)),
                ),
                child: Center(
                    child: Text(
                      'gg'.tr(),
                      style: MyTheme.black12_M,
                    )),
              ),
            ),
            // Positioned(
            //   bottom: MyTheme.pagePadding,
            //   right: MyTheme.pagePadding,
            //   child: Text(
            //     data.title ?? '',
            //     style: MyTheme.white13,
            //     maxLines: 1,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
