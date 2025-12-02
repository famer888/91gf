import 'package:flutter/material.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';

class MemberVipImgView extends StatelessWidget {
  const MemberVipImgView({
    super.key,
    this.img,
    this.height = 20,
    this.width = 65,
    this.margin = 0,
  });

  final String? img;
  final double height;
  final double width;
  final double margin;

  @override
  Widget build(BuildContext context) {
    if (img case final text? when text.isNotEmpty) {
      return Container(
        // decoration: BoxDecoration(
          // gradient: MyTheme.gradColorVIP,
          // borderRadius: BorderRadius.all(Radius.circular(10.w)),
        // ),
        margin: EdgeInsets.only(right: margin),
        width: width,
        height: height,
        child: MyImage.network(text, fit: BoxFit.fitWidth),
      );
    }
    return const SizedBox.shrink();
  }
}