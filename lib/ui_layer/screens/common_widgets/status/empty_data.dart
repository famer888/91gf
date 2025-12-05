import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../image_paths.dart';
import '../../theme.dart';
import '../my_image.dart';

class PageEmptyDataView extends StatelessWidget {
  const PageEmptyDataView({
    super.key,
    this.width = 200,
    this.text,
    this.alignment = Alignment.center,
    this.imgPath,
  });
  final String? text;
  final double width;
  final Alignment? alignment;
  final String? imgPath;
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 20.w),
      alignment: alignment,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyImage.asset(
            imgPath ?? MyImagePaths.appNoData,
            width: width.w,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(
            height: 5.w,
          ),
          Text(
            text ?? 'zwsj'.tr(),
            style: MyTheme.gray666_13,
          )
        ],
      ),
    );
  }
}
