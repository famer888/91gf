import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/follow_user_model.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class VlogFocusUserView extends StatefulWidget {
  const VlogFocusUserView({super.key, required this.focusArr});

  final List<FollowingUserData>? focusArr;

  @override
  State<VlogFocusUserView> createState() => _VlogFocusUserViewState();
}

class _VlogFocusUserViewState extends State<VlogFocusUserView> {
  @override
  Widget build(BuildContext context) {
    return widget.focusArr?.isEmpty ?? false
        ? Container()
        : SizedBox(
            height: 90.w,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: widget.focusArr!
                  .map((e) => ReportGestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        //跳转用户中心
                        final aff = '${e.aff}';
                        UserCenterRoute(aff).push(context);
                      },
                      child: Container(
                        height: 80.w,
                        width: 52.w,
                        margin: EdgeInsets.only(right: 10.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 40.w,
                              width: 40.w,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: MyTheme.blueColor81_151_241,
                                    width: 1.5.w),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.w)),
                              ),
                              child: MyImage.network(e.thumb ?? '',
                                  borderRadius: 20.w),
                            ),
                            SizedBox(height: 3.w),
                            Text('${e.nickname}', style: MyTheme.white14),
                          ],
                        ),
                      )))
                  .toList(),
            ),
          );
  }
}
