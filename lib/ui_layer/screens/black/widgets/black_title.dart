import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const.dart';
import '../../../utils/common_utils.dart';
import '../../theme.dart';

class BlackTitleView extends StatelessWidget {
  const BlackTitleView({
    super.key,
    required this.topicTitle,
    required this.viewCount,
    required this.createdAt,
  });

  final String? topicTitle;
  final int? viewCount;
  final String? createdAt;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 15.w),
        Text(topicTitle ?? '', style: MyTheme.white18semibold, maxLines: UILayerConst.maxLine, textAlign: TextAlign.left),
        SizedBox(height: 10.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${CommonUtils.renderFixedNumber(viewCount ?? 0)}${"llan".tr(context: context)}", style: TextStyle(color: Colors.white54, fontSize: 12.sp)),
            Text("发布时间：$createdAt", style: TextStyle(color: Colors.white54, fontSize: 12.sp)),
          ],
        ),
        SizedBox(height: 10.w),
        Container(color: MyTheme.white25501Color, height: 0.5.w, width: double.infinity),
        SizedBox(height: 10.w),
      ],
    );
  }
}
