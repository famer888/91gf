import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/album_model.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';

class YellowPictureItemCard extends StatelessWidget {
  const YellowPictureItemCard({super.key, required this.data});

  final AlbumItemsModel data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
         PictureReaderRoute('${data.id}').push(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                MyImage.network(
                  data.cover ?? '',
                  fit: BoxFit.cover,
                  backgroundColor: MyTheme.imageBgColor,
                  borderRadius: 5.w,
                ),
                data.type == 0
                    ? Container()
                    : Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 1.w),
                        decoration: BoxDecoration(
                            gradient: data.type == 1
                                        ? MyTheme.shareButtonGradient
                                        : MyTheme.orangeGradient,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5.w),bottomRight: Radius.circular(5.w))),
                        child: Text(
                          data.type == 2
                              ? 'jb'.tr(context: context)
                              : 'VIP',
                          style: MyTheme.white10,
                        ))),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            MyImage.asset(MyImagePaths.appComicView, width: 15.w, height: 15.w),
                            SizedBox(width: 2.w),
                            Text(
                              '${CommonUtils.renderNumber(data.viewFct ?? 0)}',
                              style: MyTheme.white10,
                              // textAlign: ,
                            ),
                          ],
                        ),
                        Text(
                          '${CommonUtils.renderNumber(data.photoCt ?? 0)}${tr('zhang')}', ///todo：
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
        ],
      ),
    );
  }
}
