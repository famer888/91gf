import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../router/routes.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';
import '../../my_image.dart';

class CardHashTag extends StatelessWidget {
  const CardHashTag({super.key, required this.id, required this.name});
  final String id;
  final String name;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CommunityTagDetailRoute(id).push(context),
      child: Container(
        height: 24.w,
        decoration: ShapeDecoration(
          color: const Color(0x19ECAE37),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyImage.asset(
                MyImagePaths.appHashtagIcon,
                width: 16.w,
                height: 16.w,
              ),
              SizedBox(
                width: 4.w,
              ),
              Text(
                name,
                style: MyTheme.white12w500,
              )
            ],
          ),
        ),
      ),
    );
  }
}
