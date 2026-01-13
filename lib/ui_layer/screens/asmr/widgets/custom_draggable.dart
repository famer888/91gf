import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/voice_model.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/asmr/voice_player/voice_player_manager.dart';
import 'package:jygf/ui_layer/screens/common_widgets/event_bus/event_bus.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class DraggableFloatingButton extends StatefulWidget {
  const DraggableFloatingButton({super.key});

  @override
  State<DraggableFloatingButton> createState() => _DraggableFloatingButtonState();
}

class _DraggableFloatingButtonState extends State<DraggableFloatingButton> {
  double _x = ScreenUtil().screenWidth - 13.w - 60.w; // Initial X position
  double _y = ScreenUtil().screenHeight -  64.w - 60.w; // Initial Y position

  late StreamSubscription<MyEvent> _subscription;

  @override
  void initState() {
    super.initState();

    // 订阅播放完毕后自动切换音频后刷新界面
    _subscription = eventBus.on<MyEvent>().listen((event) {
      debugPrint('Received event: ${event.message}');
      if (event.message == 'RefreshVoicePayerUI') {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel(); // 取消订阅
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: _x,
            top: _y,
            child: Draggable(
              feedback: _buildButton(), // 拖动开始前显示的部件
              childWhenDragging: const SizedBox(), // 原位置的部件显示的内容
              child: _buildButton(),
              onDragEnd: (details) {
                setState(() {
                  _x = details.offset.dx.clamp(0.0, MediaQuery.of(context).size.width - 60.w);
                  _y = details.offset.dy.clamp(0.0, MediaQuery.of(context).size.height - 60.w);
                });
              }, // 拖动时显示的按钮的样式
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return ReportGestureDetector(
      onTap: () {
        VoicePalyerContentRoute(VoicePlayerManager.instance.data ?? VoiceModel()).push(context);
      },
      child: SizedBox(
        width: 60.w,
        height: 60.w,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const MyImage.asset(MyImagePaths.appAsmrRecord,
                width: double.infinity),
            Positioned.fill(
                child: Center(
                  child: SizedBox(
                    width: 46.w,
                    height: 46.w,
                    child: ClipRRect(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        borderRadius:
                        BorderRadius.circular(23.w),
                        child: MyImage.network(
                            VoicePlayerManager.instance.data?.smallCover ?? '', width: 46.w,
                            height: 46.w)),
                  ),
                )),
            Positioned.fill(
                child: Center(
                  child: SizedBox(
                    width: 36.w,
                    child: Text('播放中', style: MyTheme.white11semibold,),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}