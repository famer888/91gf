import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/screens/vlog/vlog_play_screen.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class VlogSecondPage extends StatefulWidget {
  const VlogSecondPage({super.key});

  @override
  State<VlogSecondPage> createState() => _VlogSecondPageState();
}

class _VlogSecondPageState extends State<VlogSecondPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyTheme.bgColor,
      child: Stack(
        children: [
          Positioned.fill(
            child: VlogPlayScreen(
              userGlobalData: true,
              keepBottomBlank: true,
            ),
          ),
          Positioned(
              top: MyTheme.statusHeight,
              left: 2.w,
              child: ReportGestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Container(
                  width: MyTheme.navbarHegiht,
                  height: MyTheme.navbarHegiht,
                  alignment: Alignment.center,
                  child: MyImage.asset(
                    MyImagePaths.appBackIcon,
                    width: 20.w,
                    height: 20.w,
                    fit: BoxFit.fill,
                  ),
                ),
                onTap: () {
                  context.pop();
                },
              )),
        ],
      ),
    );
  }
}
