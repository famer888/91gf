import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/common_widgets/gradient_border.dart';

import '../../../../utils/common_utils.dart';

class CardContentView extends StatelessWidget {
  const CardContentView({super.key, required this.isBest, required this.title, this.maxLines = 2});

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
              child: GradientBorder(
                strokeWidth: 0.5.w,
                gradient: const LinearGradient(
                  colors: [
                    Color.fromRGBO(176, 66, 255, 1),
                    Color.fromRGBO(255, 133, 164, 1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(2.w),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  width: kIsWeb ? 26.w : 31.w,
                  height: kIsWeb ? 12.w : 17.w,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(176, 66, 255, 0.3),
                    borderRadius: BorderRadius.all(Radius.circular(2.w)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'jhua'.tr(context: context),
                        style: TextStyle(color: Colors.white, fontSize: 10.sp, height: 1),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
              style: TextStyle(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 15.sp,
                  height: 1.5,
                  overflow: TextOverflow.ellipsis,
                  decoration: TextDecoration.none),
            ),
          if (isBest) const TextSpan(text: '  '),
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
