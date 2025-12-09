import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/voice_model.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/acg/novel/novel_voice_player/novel_voice_player_manager.dart';
import 'package:jygf/ui_layer/screens/common_widgets/event_bus/event_bus.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_avatar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';

class NovelVoicePlayerDraggableView extends StatefulWidget {
  const NovelVoicePlayerDraggableView({super.key});

  @override
  State<NovelVoicePlayerDraggableView> createState() =>
      _NovelVoicePlayerDraggableViewState();
}

class _NovelVoicePlayerDraggableViewState
    extends State<NovelVoicePlayerDraggableView> {
  double _x = ScreenUtil().screenWidth - 13.w - 90.w; // Initial X position
  double _y = ScreenUtil().screenHeight - 64.w - 30.w; // Initial Y position

  late StreamSubscription<MyEvent> _subscription;

  @override
  void initState() {
    super.initState();

    // 订阅播放完毕后自动切换音频后刷新界面
    _subscription = eventBus.on<MyEvent>().listen((event) {
      debugPrint('Received event: ${event.message}');
      if (event.message == 'RefreshNovelVoicePayerUI') {
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
                  _x = details.offset.dx
                      .clamp(0.0, MediaQuery.of(context).size.width - 90.w);
                  _y = details.offset.dy
                      .clamp(0.0, MediaQuery.of(context).size.height - 30.w);
                });
              }, // 拖动时显示的按钮的样式
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return GestureDetector(
      onTap: () {
        // VoicePalyerContentRoute(
        //         VoicePlayerManager.instance.data ?? VoiceModel())
        //     .push(context);
        const NovelVoicePalyerContentRoute().push(context);
      },
      child: SizedBox(
          width: 90.w,
          height: 30.w,
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              decoration: BoxDecoration(
                color: MyTheme.jellyCyanColor,
                borderRadius: BorderRadius.all(Radius.circular(15.w)),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MyAvatar(
                        size: 25.w,
                        thumb:
                        NovelVoicePlayerManager.instance.data?.smallCover ?? ''),
                    GestureDetector(
                        onTap: () {
                          //播放/暂停
                        },
                        child: MyImage.asset(MyImagePaths.appNovelVoicePause,
                            width: 25.w, height: 25.w)),
                    GestureDetector(
                        onTap: () {
                          //关闭播放器
                          CommonUtils.removeFloatPayer();
                          setState(() {

                          });
                        },
                        child: MyImage.asset(
                            MyImagePaths.appNovelVoiceCloseWhite,
                            width: 25.w,
                            height: 25.w)),
                  ]))),
    );
  }
}
