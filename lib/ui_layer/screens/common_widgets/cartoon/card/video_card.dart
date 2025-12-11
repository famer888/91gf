import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/cartoon/cartoon_model.dart';
import '../../../../router/routes.dart';
import '../../../../utils/common_utils.dart';
import '../../../theme.dart';
import '../../my_image.dart';

class CartoonVideoCard extends StatelessWidget {
  const CartoonVideoCard({super.key, required this.data});
  final CartoonModel data;
  static const aspectRatio = 163 / 130;

  String get imageUrl => CommonUtils.getThumb(data.toJson());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        CartoonDetailRoute('${data.id}').push(context);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 94.w,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    MyImage.network(
                      imageUrl,
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
                                    borderRadius:
                                        BorderRadius.only(topLeft: Radius.circular(5.w),bottomRight: Radius.circular(5.w))),
                                child: Text(
                                  data.type == 2
                                      ? '${data.coins}${tr('jb')}'
                                      : 'VIP',
                                  style: MyTheme.white09_10,
                                ))),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${CommonUtils.renderFixedNumber(data.viewFakeCount ?? 0)}${'bf'.tr()}',
                              style: MyTheme.white12,
                            ),
                            Text(
                              RelativeDateFormat.getHMTime(time: data.duration),
                              style: MyTheme.white12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.w),
              Text(
                (data.title?.replaceAll('\n', '')) ?? '',
                style: MyTheme.white12.h1,
                maxLines: 2,
              ),
            ],
          ),
          // SizedBox(height: 1.w),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       RelativeDateFormat.format(
          //           date: DateTime.parse(data.createdAt ?? '0')),
          //       style: MyTheme.graya3a2a2_11,
          //     ),
          //     Text(
          //       '${'pl'.tr()} ${data.commentCount}',
          //       style: MyTheme.graya3a2a2_11,
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
