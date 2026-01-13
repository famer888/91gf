import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/user_model.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_avatar.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class SoulMemberCard extends StatelessWidget {
  const SoulMemberCard({super.key, required this.data});

  final UserModel data;
  @override
  Widget build(BuildContext context) {
    return ReportGestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        //跳转用户中心
        final aff = '${data.aff}';
        UserCenterRoute(aff).push(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyAvatar(size: 55.w, thumb: data.thumb ?? ''),
          SizedBox(height: 4.w),
          Text(
            data.nickname ?? '',
            style: MyTheme.white12,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
