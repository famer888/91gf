import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/novel_model.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class NovelChapterCard extends StatelessWidget {
  const NovelChapterCard({super.key, required this.data, this.tapCall, this.isLocation});
  final NovelChaptersModel data;
  final Function? tapCall;
  final bool? isLocation;

  String get title {
    String text = data.title ?? '';
    int index = text.indexOf('章');
    if (index != -1) {
      return '${text.substring(0, index + 1)} │ ${text.substring(index + 1)}';
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return ReportGestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        tapCall?.call();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: MyTheme.pagePadding),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: MyTheme.white14,
                      maxLines: 1,
                    ),
                  ),
                  if (isLocation ?? false)
                    ...[SizedBox(width: 6.w),
                      MyImage.asset(MyImagePaths.appNovelLocation,
                          width: 15.w, height: 15.w)],
                ],
              ),
            ),
            SizedBox(width: 10.w),
            isFreeBadge(data)
          ],
        ),
      ),
    );
  }

  Widget isFreeBadge(NovelChaptersModel item) {
    Color? bgColor;
    Color? bordColor;
    Widget ww;
    EdgeInsets padding = EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.w);
    Gradient? gradient;

    if (item.type == 0 || (item.txt?.isNotEmpty ?? false)) {
      bgColor = const Color.fromRGBO(255, 255, 255, 0);
      bordColor = const Color.fromRGBO(255, 255, 255, 0.7);
      ww = Text(
        'gk'.tr(),
        style: MyTheme.white12,
        textAlign: TextAlign.center,
      );
    } else if (item.type == 1) {
      gradient = MyTheme.gradient_90_114;
      ww = Text(
        'VIP',
        style: MyTheme.white12,
        textAlign: TextAlign.center,
      );
    } else if (item.type == 2) {
      bgColor = MyTheme.jellyCyanColor.withOpacity(0.2);
      bordColor = MyTheme.jellyCyanColor;
      ww = Row(
        children: [
          Text(
            CommonUtils.renderFixedNumber(item.coins ?? 0),
            style: MyTheme.white12medium,
          ),
          SizedBox(width: 2.w),
          MyImage.asset(
            MyImagePaths.appCoinLogo,
            width: 12.w,
            height: 12.w,
          )
        ],
      );
    } else {
      return Container();
    }
    return Container(
      padding: padding,
      constraints: BoxConstraints(
        minWidth: 40.w, // 设置最小宽度为 40
      ),
      decoration: BoxDecoration(
          color: bgColor,
          gradient: gradient,
          border: Border.all(
            color: bordColor ?? Colors.transparent, // 设置边框颜色
            width: 1, // 设置边框宽度
          ),
          borderRadius: BorderRadius.all(Radius.circular(3.w))),
      child: ww,
    );
  }
}
