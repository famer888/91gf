import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/novel_model.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';

class NovelItemCard extends StatelessWidget {
  const NovelItemCard({super.key, required this.data});

  final NovelItemsModel data;

  String get imageUrl => CommonUtils.getThumb(data.toJson());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        NovelDetailRoute(data.id.toString() ?? '').push(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                MyImage.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  backgroundColor: MyTheme.imageBgColor,
                  borderRadius: 5.w,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 40.w,
                    decoration: BoxDecoration(
                      gradient: MyTheme.gradient_90_114,
                      borderRadius: BorderRadius.all(Radius.circular(5.w)),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${CommonUtils.renderFixedNumber(data.viewFct ?? 0)}${'yd'.tr(context: context)}',
                          style: MyTheme.white10,
                          // textAlign: ,
                        ),
                        Text(
                          data.isEnd == 1
                              ? 'wj'.tr(context: context)
                              : 'lzz'.tr(context: context),
                          // '${'gxz'.tr(context: context)}${data.chapterCt}${'hua'.tr(context: context)}',
                          style: MyTheme.white10,
                          // textAlign: ,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.w),
          Text(
            data.title ?? '',
            style: MyTheme.white244_14,
            maxLines: 1,
          ),
          // SizedBox(height: 2.w),
          // Builder(builder: (context) {
          //   if ((data.tag ?? '').isEmpty) {
          //     return Container(height: 19.w);
          //   }
          //   List tags = (data.tag ?? '').split(',');
          //   if (tags.length > 3) {
          //     tags = tags.sublist(0, 3);
          //   }
          //   return  ClipRect(
          //     child: SizedBox(
          //       height: 19.w,
          //       child: Wrap(
          //         runSpacing: 3.w,
          //         spacing: 3.w,
          //         children: tags.map(
          //               (tag) => Container(
          //             padding: EdgeInsets.symmetric(
          //                 horizontal: 3.w, vertical: 2.w),
          //             decoration: BoxDecoration(
          //               color: MyTheme.white008Color,
          //               borderRadius: BorderRadius.circular(2.w),
          //             ),
          //             child: Text(
          //               tag,
          //               style: MyTheme.white09_10,
          //             ),
          //           ),
          //         ).toList(),
          //       ),
          //     ),
          //   );
          // }),
        ],
      ),
    );
  }
}
