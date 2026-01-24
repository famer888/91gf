import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/type_def.dart';
import '../../../../../domain/model/user_model.dart';
import '../../../../notifiers/user_notifier.dart';
import '../../../../router/routes.dart';
import '../../../../utils/common_utils.dart';
import '../../../theme.dart';
import '../../follow_button.dart';
import '../../member_vip.dart';
import '../../my_avatar.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class CardUserView extends StatelessWidget {
  const CardUserView({
    super.key,
    required this.user,
    required this.createdAt,
  });
  final UserModel user;
  final String createdAt;

  @override
  Widget build(BuildContext context) {
    final thumb = user.thumb ?? '';
    final nickname = user.nickname ?? '';
    final userAgent = user.agent ?? 0;
    final userIsVip = user.vipLevel?.isVip() ?? false;
    final vipString = user.vipStr ?? '';
    final aff = '${user.aff}';
    return Row(
      children: [
        ReportGestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            UserCenterRoute(aff).push(context);
          },
          child: MyAvatar(
            thumb: thumb,
            size: 40.w,
          ),
        ),
        SizedBox(width: 9.5.w),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    nickname,
                    style: MyTheme.white255_15_M,
                  ),
                  SizedBox(width: 2.w),
                  if (userAgent == 1)
                    Icon(
                      Icons.verified_sharp,
                      size: 14.w,
                      color: const Color.fromRGBO(247, 208, 93, 1),
                    )
                ],
              ),
              SizedBox(height: 2.w),
              Row(
                children: [
                  if (userIsVip) MemberVipWidget(vipImage: user.vipImg),
                  SizedBox(width: (userIsVip ? 4 : 0).w),
                  Text(
                    RelativeDateFormat.format(
                        date: DateTime.tryParse(createdAt)),
                    style: MyTheme.gray163_11,
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(width: 5.w),
        Selector<UserNotifier, bool>(
          selector: (_, notifier) => notifier.userFollowingStatus.contains(aff),
          builder: (_, isFollowed, __) => FollowButton(
            isFollowed: isFollowed,
            onTap: () => context.read<UserNotifier>().changeUserFollow(aff),
          ),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }
}
