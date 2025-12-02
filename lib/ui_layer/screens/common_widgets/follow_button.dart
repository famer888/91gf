import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme.dart';

class FollowButton extends StatelessWidget {
  const FollowButton(
      {super.key, required this.isFollowed, required this.onTap});
  final bool isFollowed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        onTap();
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 25.w,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: isFollowed ? MyTheme.cyanColor00edfd : Colors.transparent,
            borderRadius: BorderRadius.circular(12.5.w),
            border: Border.all(
                color:
                    isFollowed ? Colors.transparent : MyTheme.cyanColor00edfd,
                width: 1.w)),
        child: Text(
          isFollowed
              ? 'ygz'.tr(context: context)
              : '+${'gz'.tr(context: context)}',
          style: isFollowed ? MyTheme.white11 : MyTheme.blue80_11,
        ),
      ),
    );
  }
}
