import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';

class NewSubscriptWidget extends StatelessWidget {
  final int? pos;

  const NewSubscriptWidget({super.key, this.pos});

  @override
  Widget build(BuildContext context) {
    return Container(width: 32.w, height: 26.w, clipBehavior: Clip.none, child: Image.asset(MyImagePaths.appSubNew));
  }
}

/// 热门
class HotSubscriptWidget extends StatelessWidget {
  final int? pos;

  const HotSubscriptWidget({super.key, this.pos});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15.w,
      height: 20.w,
      margin: EdgeInsets.only(top: 2.w, left: 1.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.w),
      ),
      clipBehavior: Clip.none,
      child: Image.asset(MyImagePaths.appSubHot),
    );
  }
}

/// VIP
class VipSubscriptWidget extends StatelessWidget {
  final int? pos; // 默认右
  const VipSubscriptWidget({super.key, this.pos});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28.w,
      height: 17.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(pos == 0 ? 5.w : 0),
          bottomRight: Radius.circular(pos == 0 ? 0 : 5.w),
          topLeft: Radius.circular(pos == 0 ? 0 : 5.w),
          topRight: Radius.circular(pos == 0 ? 5.w : 0),
        ),
        gradient: MyTheme.vip_gradient_90_135,
      ),
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      child: Text('VIP', style: MyTheme.white14.s12),
    );
  }
}

/// 金币
class CoinSubscriptWidget extends StatelessWidget {
  final int? pos;

  const CoinSubscriptWidget({super.key, this.pos});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28.w,
      height: 17.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(pos == 0 ? 5.w : 0),
          bottomRight: Radius.circular(pos == 0 ? 0 : 5.w),
          topLeft: Radius.circular(pos == 0 ? 0 : 5.w),
          topRight: Radius.circular(pos == 0 ? 5.w : 0),
        ),
        gradient: MyTheme.gradient_90_114,
      ),
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      child: Text('jb'.tr(context: context), style: MyTheme.white14.s12),
    );
  }
}
