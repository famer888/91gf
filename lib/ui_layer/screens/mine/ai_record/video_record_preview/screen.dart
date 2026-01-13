import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/ai/ai_magic_record_model.dart';
import 'package:jygf/domain/model/video_detail_model.dart';
import 'package:jygf/ui_layer/screens/common_widgets/video_player/shortv_mv_player.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class VideoRecordPreviewScreen extends StatefulWidget {
  const VideoRecordPreviewScreen(
      {super.key, required this.data, required this.delTapCall});

  final AIMagicRecordModel data;
  final Function delTapCall;

  @override
  State<VideoRecordPreviewScreen> createState() =>
      _VideoRecordPreviewScreenState();
}

class _VideoRecordPreviewScreenState extends State<VideoRecordPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    final sheetHeight = ScreenUtil().screenHeight * 0.8;
    final videoJson = {
      'id': widget.data.id,
      'title': 'AI魔法',
      'second_title': 'AI魔法',
      'thumb_cover': widget.data.cover,
      'source_240': widget.data.video,
    };

    print(videoJson);

    VideoData datas = VideoData.fromJson(videoJson);

    return Container(
        padding: EdgeInsets.only(
            left: MyTheme.pagePadding,
            top: MyTheme.pagePadding,
            right: MyTheme.pagePadding,
            bottom: 44.w),
        color: MyTheme.bgColor,
        height: sheetHeight,
        child: Column(children: [
          AspectRatio(
              aspectRatio: 1,
              child: ShortvMvPlayer(info: datas, noBack: true)),
          SizedBox(height: 30.w),
          ReportGestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              _saveVideo(widget.data.video);
            },
            child: Container(
              height: 45.w,
              decoration: BoxDecoration(
                  gradient: MyTheme.gradient_90_114,
                  borderRadius: BorderRadius.circular(5.w)),
              child: Center(
                child: Text(
                  tr('bc'),
                  style: MyTheme.white16medium,
                ),
              ),
            ),
          ),
          SizedBox(height: 15.w),
          ReportGestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              widget.delTapCall.call();
              // context.pop();
            },
            child: Container(
              height: 45.w,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(5.w)),
              child: Center(
                child: Text(
                  tr('sch'),
                  style: MyTheme.white16medium,
                ),
              ),
            ),
          )
        ]));
  }

  Future<void> _saveVideo(String m3u8Url) async {
    MyToast.showText(text: "暂时不支持下载，请自行录屏保存");
  }
}
