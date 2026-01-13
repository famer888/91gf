import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class ToggleIsOpenField extends StatelessWidget {
  const ToggleIsOpenField({super.key, required this.isOpenNotifier});
  final ValueNotifier<bool> isOpenNotifier;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.w),
            border:
                Border.all(color: Colors.white.withOpacity(0.3), width: 1.w)),
        child: ValueListenableBuilder(
          valueListenable: isOpenNotifier,
          builder: (context, isOpen, child) {
            return Row(
              children: [
                Text(
                  "${'sffbmzxx'.tr(context: context)}：",
                  style: TextStyle(
                    color: const Color(0xffa1a2a9),
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                ReportGestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => isOpenNotifier.value = true,
                  child: Row(
                    children: [
                      Text(
                        'qwmzxx'.tr(context: context),
                        style: TextStyle(
                          color: const Color(0xffa1a2a9),
                          fontSize: 15.sp,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Icon(
                        isOpen ? Icons.check_circle : Icons.circle_outlined,
                        size: 16.w,
                        color: isOpen
                            ? MyTheme.jellyCyanColor103224185
                            : const Color(0xffa1a2a9),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20.w),
                ReportGestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => isOpenNotifier.value = false,
                  child: Row(
                    children: [
                      Text(
                        'qwmzsm'.tr(context: context),
                        style: TextStyle(
                          color: const Color(0xffa1a2a9),
                          fontSize: 15.sp,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Icon(
                        isOpen ? Icons.circle_outlined : Icons.check_circle,
                        size: 16.w,
                        color: isOpen
                            ? const Color(0xffa1a2a9)
                            : const Color.fromRGBO(236, 174, 55, 1),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
