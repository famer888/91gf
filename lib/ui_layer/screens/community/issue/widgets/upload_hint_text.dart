import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme.dart';

class UploadHintText extends StatelessWidget {
  const UploadHintText({
    super.key,
    required this.title,
    this.subTitle,
    required this.text,
  });
  final String title;
  final String? subTitle;
  final String text;
  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 2,
      text: TextSpan(
        text: '$title ',
        style: MyTheme.white15bold,
        children: [
          TextSpan(
            text: subTitle,
            style: TextStyle(
              color: const Color(0xFFE83125),
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(text: ' $text', style: MyTheme.gray208_13)
        ],
      ),
    );
  }
}
