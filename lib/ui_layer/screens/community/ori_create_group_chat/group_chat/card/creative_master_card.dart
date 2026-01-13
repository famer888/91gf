import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/model/soul_group_model.dart';
import 'package:jygf/ui_layer/notifiers/user_notifier.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/follow_button.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_avatar.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class CreativeMasterCard extends StatefulWidget {
  const CreativeMasterCard(
      {super.key, required this.data, required this.index});

  final CreativeMasterModel data;
  final int index;

  @override
  State<CreativeMasterCard> createState() => _CreativeMasterCardState();
}

class _CreativeMasterCardState extends State<CreativeMasterCard> {
  late final userNotifier = context.read<UserNotifier>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final aff = '${widget.data.aff}';
    final int index = widget.index + 1;
    String indexStr = '';
    if (index < 10) {
      indexStr = '0$index';
    } else {
      indexStr = '$index';
    }

    return Container(
      child: Column(children: [
        ReportGestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            UserCenterRoute(
              aff,
              //  index: 1
            ).push(context);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 0.w, right: 10.w),
                child: Text(
                  indexStr,
                  style: MyTheme.white16bold,
                ),
              ),
              MyAvatar(size: 45.w, thumb: widget.data.thumb),
              SizedBox(width: 9.5.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${widget.data.nickname}', style: MyTheme.white14),
                    Text(
                      '${widget.data.workCt}${tr('bzp')}',
                      style: MyTheme.white04_10,
                    )
                  ],
                ),
              ),
              Selector<UserNotifier, bool>(
                  selector: (_, notifier) =>
                      notifier.userFollowingStatus.contains(aff),
                  builder: (_, isFollowed, __) {
                    return FollowButton(
                        isFollowed: isFollowed,
                        onTap: () async {
                          await userNotifier.changeUserFollow(aff);
                        });
                  }),
            ],
          ),
        ),
      ]),
    );
  }
}
