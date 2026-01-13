import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/ui_layer/screens/mine/ai_record/draw_art/screen.dart';
import 'package:jygf/ui_layer/screens/mine/ai_record/kiss_ai_record/screen.dart';
import 'package:jygf/ui_layer/screens/mine/ai_record/magic_ai_record/screen.dart';
import 'package:jygf/ui_layer/screens/mine/ai_record/novel_ai_record/screen.dart';
import 'package:jygf/ui_layer/screens/mine/ai_record/video_face_swap_record/screen.dart';
import 'package:jygf/ui_layer/screens/mine/ai_record/voice_ai_record/screen.dart';
import 'package:jygf/ui_layer/screens/theme.dart';

import '../../common_widgets/keep_alive_wrapper.dart';
import '../../common_widgets/my_image.dart';
import '../../common_widgets/my_tab_bar.dart';
import '../../common_widgets/screen_background.dart';
import '../../image_paths.dart';
import 'face_swap_record/screen.dart';
import 'strip_off_record/screen.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class MineAIRecordScreen extends StatefulWidget {
  const MineAIRecordScreen({super.key, this.index = 0});

  final int index;

  @override
  State<MineAIRecordScreen> createState() => _MineAIRecordScreenState();
}

class _MineAIRecordScreenState extends State<MineAIRecordScreen> {
  List<String> navList = [
    tr('aimf'),
    tr('aiqy'),
    tr('aijw'),
    tr('aihl'),
    tr('aixs'),
    tr('aiyy'),
    tr('sphl'),
    tr('aihh'),
  ];

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Positioned.fill(
                child: TabBarWithView.line(
                  titles: navList,
                  views: const [
                    KeepAliveWrapper(
                      child: MineMagicRecordScreen(),
                    ),
                    KeepAliveWrapper(
                      child: MineStrpOffRecordScreen(),
                    ),
                    KeepAliveWrapper(
                      child: MineKissRecordScreen(),
                    ),
                    KeepAliveWrapper(
                      child: MineFaceSwapRecordScreen(),
                    ),
                    KeepAliveWrapper(
                      child: MineNovelRecordScreen(),
                    ),
                    KeepAliveWrapper(
                      child: VoiceAIRecordScreen(),
                    ),
                    KeepAliveWrapper(
                      child: MineVideoFaceSwapRecordScreen(),
                    ),
                    KeepAliveWrapper(
                      child: MineDrawArtScreen(),
                    ),
                  ],
                  initialIndex: widget.index,
                  indicatorType: IndicatorType.light,
                  isScrollable: true,
                  isCenter: false,
                  tabBarPadding: EdgeInsets.only(left: 48.w),
                  labelStyle: MyTheme.white_17.copyWith(color: MyTheme.yellow255123Color),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: ReportGestureDetector(
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: MyImage.asset(
                      MyImagePaths.appBackIcon,
                      width: 20.w,
                      height: 20.w,
                    ),
                  ),
                  onTap: () {
                    context.pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

