import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../domain/model/feed/feed_model.dart';
import '../../../../utils/common_utils.dart';
import '../../../theme.dart';
import '../../my_image.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class AdCard extends StatelessWidget {
  const AdCard({super.key, required this.ad});
  final FeedAdModel ad;
  String get description => ad.description ?? ad.subTitle ?? '';
  String get imgUrl => CommonUtils.getThumb(ad.toJson());
  @override
  Widget build(BuildContext context) {
    return ReportGestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        CommonUtils.openRoute(context, ad.toJson());
      },
      child: LayoutBuilder(builder: (context, cons) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: cons.maxHeight * 94 / 158,
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
                        color: const Color.fromRGBO(252, 231, 80, 1),
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
                  )
                ],
              ),
            ),
            // SizedBox(height: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ad.title,
                        style: MyTheme.white13,
                        maxLines: 1,
                      ),
                      Text(
                        description,
                        style: MyTheme.graya3a2a2_11,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  Text(
                    '   ',
                    style: MyTheme.graya3a2a2_11,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
