import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class LiveVideoCard extends StatelessWidget {
  const LiveVideoCard({super.key, required this.data});

  final LiveModel data;

  String get imageUrl => CommonUtils.getThumb(data.toJson());

  bool get isOnline => data.show == 'public';

  @override
  Widget build(BuildContext context) {
    final height = 110.w;

    return ReportGestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        LivesDetailRoute('${data.id}').push(context);
      },
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            Positioned.fill(
              child: MyImage.network(
                imageUrl,
                borderRadius: 10,
                backgroundColor: MyTheme.imageBgColor,
              ),
            ),
            Positioned.fill(
                child: !isOnline
                    ? CommonUtils.blurCover(borderRadius: 5.w)
                    : const SizedBox.shrink()),
            Positioned.fill(
                child: !isOnline
                    ? Container(
                        alignment: Alignment.center,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyImage.network(
                                data.thumb ?? '',
                                width: 30.w,
                                height: 30.w,
                                borderRadius: 15.w,
                              ),
                              SizedBox(width: 5.w),
                              Text('zbyxx'.tr(context: context), style: MyTheme.white11),
                            ]),
                      )
                    : const SizedBox.shrink()),
            Positioned(
                top: 5.w,
                left: 5.w,
                right: 5.w,
                child: isOnline
                    ? Text(
                        '${CommonUtils.renderEnFixedNumber(data.viewFct ?? 0)}${'gzong'.tr()}',
                        style: MyTheme.white09_10)
                    : const SizedBox.shrink()),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: MyImage.asset(
                MyImagePaths.appCardBottombg,
                height: 53.w,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.username ?? '',
                        style: MyTheme.white12,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                top: 7.w,
                right: 5.w,
                child: isOnline
                    ? Row(children: [
                        MyImage.asset(
                          MyImagePaths.appOnline,
                          height: 11.w,
                          width: 11.w,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          tr('zbz'),
                          style: MyTheme.white10,
                          maxLines: 1,
                        ),
                      ])
                    : const SizedBox.shrink())
          ],
        ),
      ),
    );
  }
}
