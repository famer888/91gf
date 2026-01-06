import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../image_paths.dart';
import '../../../theme.dart';
import '../../my_image.dart';

class PostLikeButton extends StatelessWidget {
  const PostLikeButton({super.key, required this.isLiked, required this.onTap});

  final bool isLiked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        onTap();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyImage.asset(
            isLiked ? MyImagePaths.appThumbUpOnIcon : MyImagePaths.appThumbUpOffIcon,
            iconColor: isLiked ? MyTheme.primaryColor : MyTheme.whiteColor,
            width: 18.w,
            height: 18.w,
          ),
          SizedBox(width: 2.w),
          Text(
            isLiked ? 'ydz'.tr(context: context) : 'dz'.tr(context: context),
            style: MyTheme.gray190_12,
          ),
          SizedBox(width: 15.w),
        ],
      ),
    );
  }
}

class PostCollectButton extends StatelessWidget {
  const PostCollectButton({super.key, required this.isCollected, required this.onTap});

  final bool isCollected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        onTap();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyImage.asset(
            isCollected ? MyImagePaths.appCollectOn : MyImagePaths.appCollectOff,
            iconColor: isCollected ? MyTheme.primaryColor : MyTheme.whiteColor,
            width: 18.7.w,
            height: 18.7.w,
          ),
          SizedBox(width: 2.w),
          Text(
            isCollected ? 'ysc'.tr(context: context) : 'sc'.tr(context: context),
            style: MyTheme.gray190_12,
          ),
          SizedBox(width: 15.w),
        ],
      ),
    );
  }
}

class PostShareButton extends StatelessWidget {
  const PostShareButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        onTap();
      },
      child: Row(
        children: [
          MyImage.asset(
            MyImagePaths.appShareOn,
            iconColor: MyTheme.whiteColor,
            width: 18.w,
            height: 18.w,
          ),
          SizedBox(width: 2.w),
          Text(
            'fx'.tr(context: context),
            style: MyTheme.gray190_12,
          ),
        ],
      ),
    );
  }
}
