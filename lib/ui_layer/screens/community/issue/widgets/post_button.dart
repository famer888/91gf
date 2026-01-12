import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme.dart';

class PostButton extends StatelessWidget {
  const PostButton({
    super.key,
    required this.onTap,
    required this.publishAvAvailableNotifier,
  });

  final VoidCallback onTap;
  final ValueNotifier<bool> publishAvAvailableNotifier;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: ValueListenableBuilder<bool>(
          valueListenable: publishAvAvailableNotifier,
          builder: (_, publishAvAvailable, __) {
            return Container(
              decoration: BoxDecoration(
                gradient: publishAvAvailableNotifier.value
                    ? MyTheme.gradient_90_114
                    : LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          MyTheme.primaryColor_01,
                          MyTheme.primaryColor_01,
                        ],
                      ),
                borderRadius: BorderRadius.all(Radius.circular(5.w)),
              ),
              height: 28.w,
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Center(
                child: Text(
                  'fb'.tr(context: context),
                  style: publishAvAvailableNotifier.value ? MyTheme.white255_14 : MyTheme.white255_14.white25506,
                ),
              ),
            );
          }),
    );
  }
}
