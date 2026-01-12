import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../image_paths.dart';
import '../../theme.dart';

class NetworkErrorView extends StatelessWidget {
  const NetworkErrorView({
    super.key,
    this.text,
    this.onTap,
  });

  final String? text;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(MyImagePaths.appNoNetwork, width: 206.w, fit: BoxFit.fitWidth),
            SizedBox(height: 5.w),
            Text(text ?? 'zzsb'.tr(context: context), style: MyTheme.gray666_13),
          ],
        ),
      ),
    );
  }
}
