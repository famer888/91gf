import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';

class MemberVipWidget extends StatelessWidget {
  const MemberVipWidget({
    super.key,
    this.height = 16,
    this.margin = 0,
    this.vipImage,
  });
  final double height;
  final double margin;
  final String? vipImage;

  @override
  Widget build(BuildContext context) {
    if (vipImage == null || vipImage!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.only(right: margin.w),
      height: height,
      alignment: Alignment.centerLeft,
      child: MyImage.network(
        vipImage!,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}
