import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/common_widgets/gradient_border.dart';
import '../theme.dart';

class FollowButton extends StatelessWidget {
  const FollowButton({super.key, required this.isFollowed, this.horizontal, required this.onTap});

  final bool isFollowed;
  final double? horizontal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        onTap();
      },
      behavior: HitTestBehavior.translucent,
      child: GradientBorder(
        strokeWidth: 1,
        gradient: LinearGradient(
          colors: [
            isFollowed ? Colors.transparent : const Color.fromRGBO(176, 66, 255, 1),
            isFollowed ? Colors.transparent : const Color.fromRGBO(255, 133, 164, 1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(5.w),
        child: Container(
          height: 25.w,
          padding: EdgeInsets.symmetric(horizontal: horizontal ?? 10.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              isFollowed ? const Color.fromRGBO(176, 66, 255, 1) : Colors.transparent,
              isFollowed ? const Color.fromRGBO(255, 133, 164, 1) : Colors.transparent,
            ]),
            borderRadius: BorderRadius.circular(5.w),
          ),
          child: Text(isFollowed ? 'ygz'.tr(context: context) : '+${'gz'.tr(context: context)}', style: MyTheme.white12.w500),
        ),
      ),
    );
  }
}
