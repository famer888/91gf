import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/home_data_model.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';

class AdCardView extends StatelessWidget {
  const AdCardView({super.key, required this.ad, this.height});

  final AdModel ad;
  final double? height;
  String get description => ad.description ?? ad.subTitle ?? '4567890-';
  String get imgUrl => CommonUtils.getThumb(ad.toJson());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        CommonUtils.openRoute(context, ad.toJson());
      },
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.w),
          ),
          height: height ?? 94.w,
          child: Stack(fit: StackFit.expand, children: [
            MyImage.network(
              imgUrl,
              fit: BoxFit.cover,
            ),
            Positioned(
              right: -0.5.w,
              top: -0.5.w,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(9.w),
                  ),
                  gradient: MyTheme.gradient_90_114,
                ),
                height: 16.5.w,
                width: 28.w,
                child: Text(
                  'gg'.tr(),
                  style: MyTheme.white14Medium,
                ),
              ),
            )
          ]),
        ),
        SizedBox(height: 5.w),
        Text(
          ad.title ?? '',
          style: MyTheme.black13,
          maxLines: 1,
        ),
        const Spacer(),
        Text(
          description,
          style: MyTheme.gray153_11,
          maxLines: 1,
        ),
      ]),
    );
  }
}
