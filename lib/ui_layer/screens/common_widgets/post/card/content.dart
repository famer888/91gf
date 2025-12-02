import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/common_utils.dart';
import '../../../theme.dart';

class CardContentView extends StatelessWidget {
  const CardContentView(
      {super.key,
      required this.isBest,
      required this.title,
      this.maxLines = 2});

  final bool isBest;
  final String title;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      TextSpan(
        children: [
          if (isBest)
            WidgetSpan(
              child: Container(
                margin: EdgeInsets.only(right: 3.w), //, bottom: 1.5.w),
                // padding: EdgeInsets.symmetric(horizontal: 5.w),
                width: kIsWeb ? 26.w : 31.w,
                height: kIsWeb ? 12.w : 17.w,
                decoration: BoxDecoration(
                  gradient: MyTheme.gradient_90_114,
                  borderRadius: BorderRadius.all(
                    Radius.circular(2.w),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'jhua'.tr(context: context),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              style: TextStyle(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 15.sp,
                  height: 1.5,
                  overflow: TextOverflow.ellipsis,
                  decoration: TextDecoration.none),
            ),
          TextSpan(
            text: CommonUtils.convertEmojiAndHtml(title),
            style: TextStyle(
                color: const Color.fromRGBO(255, 255, 255, 1),
                fontSize: 15.sp,
                height: 1.2,
                overflow: TextOverflow.ellipsis,
                // textBaseline: TextBaseline.ideographic,
                decoration: TextDecoration.none),
          )
        ],
      ),
    );
  }
}
