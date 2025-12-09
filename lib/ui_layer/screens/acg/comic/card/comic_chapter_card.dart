import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/comic_model.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';

class ComicChapterCard extends StatelessWidget {
  const ComicChapterCard({super.key, required this.data, this.tapCall});
  final ChaptersModel data;
  final Function? tapCall;
  String get imgUrl => data.cover ?? '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        tapCall?.call();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.w),
        child: Row(
          children: [
            MyImage.network(
              imgUrl,
              borderRadius: 5.w,
              fit: BoxFit.cover,
              width: 172.w,
              height: 82.w,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                data.title ?? '',
                style: MyTheme.white14,
                maxLines: 1,
              ),
            ),
            SizedBox(width: 10.w),
            isFreeBadge(data)
          ],
        ),
      ),
    );
  }

  Widget isFreeBadge(ChaptersModel item) {
    Color bgColor;
    Color bordColor;
    Widget ww;
    EdgeInsets padding;

    if (item.type == 0 || item.isPay == 1) {
      padding = EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.w);
      bgColor = const Color.fromRGBO(0, 140, 255, 0.2);
      bordColor = const Color.fromRGBO(0, 140, 255, 1);
      ww = Text(
        'gk'.tr(),
        style: TextStyle(
            color: bordColor,
            fontSize: 12.sp),
        textAlign: TextAlign.center,
      );
    } else if (item.type == 1) {
      padding = EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.w);
      bgColor = const Color.fromRGBO(255, 162, 0, 0.2);
      bordColor = const Color.fromRGBO(255, 162, 0, 1);
      ww = Text(
        'VIP',
        style: TextStyle(
            color: bordColor,
            fontSize: 12.sp),
        textAlign: TextAlign.center,
      );
    } else if (item.type == 2) {
      padding = EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.w);
      bgColor = MyTheme.jellyCyanColor.withOpacity(0.2);
      bordColor = MyTheme.jellyCyanColor;
      ww = Row(
        children: [
          Text(
            CommonUtils.renderFixedNumber(item.coins ?? 0),
            style: MyTheme.white12medium,
          ),
          SizedBox(width: 2.w),
          MyImage.asset(MyImagePaths.appCoinLogo,
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
      decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(
            color: bordColor, // 设置边框颜色
            width: 0.5, // 设置边框宽度
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.w))),
      child: ww,
    );
  }
}
