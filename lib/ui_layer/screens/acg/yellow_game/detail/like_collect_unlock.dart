import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/game/game_detail_model.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';

class GameLikeButton extends StatelessWidget {
  const GameLikeButton(
      {super.key,
      required this.isLiked,
      required this.likeNum,
      required this.onTap});

  final bool isLiked;
  final int likeNum;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        onTap();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyImage.asset(
            isLiked ? MyImagePaths.appGameLikeOn : MyImagePaths.appGameLikeOff,
            width: 25.w,
            height: 25.w,
          ),
          SizedBox(width: 2.w),
          Text(
            'dz'.tr(context: context) + ' ${likeNum}',
            style: MyTheme.gray190_12,
          ),
        ],
      ),
    );
  }
}

class GameCollectButton extends StatelessWidget {
  const GameCollectButton(
      {super.key,
      required this.isCollected,
      required this.collectNum,
      required this.onTap});

  final bool isCollected;
  final int collectNum;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        onTap();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyImage.asset(
            isCollected
                ? MyImagePaths.appGameCollectOn
                : MyImagePaths.appGameCollectOff,
            width: 25.w,
            height: 25.w,
          ),
          SizedBox(width: 2.w),
          Text(
            'sc'.tr(context: context) + ' $collectNum',
            style: MyTheme.gray190_12,
          ),
        ],
      ),
    );
  }
}

class GameUnlockButton extends StatelessWidget {
  const GameUnlockButton({super.key, required this.data});

  final GameDetailInfoModel data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyImage.asset(
          MyImagePaths.appGameUnlock,
          width: 25.w,
          height: 25.w,
        ),
        SizedBox(width: 2.w),
        Text(
          'js'.tr(context: context) + ' ${data.payFct ?? 0}',
          style: MyTheme.gray190_12,
        ),
      ],
    );
  }
}
