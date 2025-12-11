import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/comic_model.dart';
import 'package:jygf/app_global.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';

class ComicItemCard extends StatelessWidget {
  const ComicItemCard({super.key, required this.data});

  final ComicItemsModel data;

  String get imageUrl => CommonUtils.getThumb(data.toJson());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        ComicDetailRoute(data.id.toString() ?? '').push(context);
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
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Container(
                //     height: 40.w,
                //     decoration: BoxDecoration(
                //       gradient: MyTheme.gradient_90_114,
                //       borderRadius: BorderRadius.all(Radius.circular(5.w)),
                //     ),
                //   ),
                // ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(5.w),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                           MyImage.asset(MyImagePaths.appComicView,
                          width: 12.w,
                          height: 12.w,
                          // color: Colors.white,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '${CommonUtils.renderEnFixedNumber(data.viewFct ?? 0)}',
                          style: MyTheme.white10,
                          // textAlign: ,
                        ),
                     
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 5.w,
                  right: 5.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                    decoration: BoxDecoration(
                      color: data.isEnd == 1 ?const Color.fromRGBO(28, 149, 36, 1): const Color.fromRGBO(147, 19, 19, 1),
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    child: Text(
                      data.isEnd == 1
                          ? 'wj'.tr(context: context)
                          : 'lzz'.tr(context: context),
                      style: MyTheme.white10,
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
          SizedBox(height: 2.w),
          Builder(builder: (context) {
            if ((data.tag ?? '').isEmpty) {
              return Container(height: 19.w);
            }
            List tags = (data.tag ?? '').split(',');
            if (tags.length > 3) {
              tags = tags.sublist(0, 3);
            }
           
            return  ClipRect(
              child: SizedBox(
                height: 19.w,
                child: Wrap(
                  runSpacing: 3.w,
                  spacing: 3.w,
                  children: tags.asMap().entries.map(
                        (entry) => Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.w, vertical: 1.w),
                      decoration: BoxDecoration(
                        color: AppGlobal.tagColors[entry.key % AppGlobal.tagColors.length],
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      child: Text(
                        entry.value,
                        style: MyTheme.white09_10,
                      ),
                    ),
                  ).toList(),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
