import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/voice_model.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/asmr/voice_player/voice_player_manager.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';

class VoiceListCard extends StatefulWidget {
  const VoiceListCard({super.key, required this.data});

  final VoiceModel data;

  @override
  State<VoiceListCard> createState() => _VoiceListCardState();

}

class _VoiceListCardState extends State<VoiceListCard> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        VoicePalyerContentRoute(widget.data).push(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(27, 28, 43, 0.8),
          borderRadius: BorderRadius.all(Radius.circular(5.w)),
        ),
        padding: EdgeInsets.all(10.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyImage.network(
              widget.data.smallCover ?? '',
              borderRadius: 5.w,
              width: 60.w,
              height: 60.w,
            ),
            SizedBox(width: 10.w),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(widget.data.title ?? 'loading',
                      style: MyTheme.white255_14,
                      textAlign: TextAlign.left,
                      maxLines: 1),
                      SizedBox(height: 20.w),
                      // SizedBox(
                      //   height: 20.w,
                      //   child: ValueListenableBuilder(
                      //     valueListenable: VoicePlayerManager.instance.progress,
                      //     builder: (context, Duration value, child) {
                      //       return Visibility(
                      //           visible: widget.data.id ==
                      //               VoicePlayerManager.instance.currentId && VoicePlayerManager.instance.isPlay.value,
                      //           child: ProgressBar(
                      //             progress: value,
                      //             buffered: VoicePlayerManager.instance.buffered,
                      //             total: VoicePlayerManager.instance.total,
                      //             progressBarColor: Colors.white,
                      //             baseBarColor: Colors.white.withOpacity(0.24),
                      //             bufferedBarColor:
                      //             Colors.white.withOpacity(0.24),
                      //             thumbColor: Colors.white,
                      //             barHeight: 3.0,
                      //             thumbRadius: 5.0,
                      //             timeLabelTextStyle: MyTheme.white10,
                      //             timeLabelLocation: TimeLabelLocation.above,
                      //             onSeek: (duration) {
                      //               if (VoicePlayerManager.instance.isErr) {
                      //                 MyToast.showText(text: '加载错误,请重试');
                      //                 return;
                      //               }
                      //               if (!VoicePlayerManager
                      //                   .instance.isInit.value) {
                      //                 MyToast.showText(text: '正在等待音频加载完成');
                      //                 return;
                      //               }
                      //               VoicePlayerManager.instance.audioController
                      //                   ?.seekTo(duration);
                      //             },
                      //           ));
                      //     },
                      //   ),
                      // ),
                  SizedBox(height: 5.w),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            RelativeDateFormat.format(
                                date: DateTime.parse(widget.data.createdAt ?? '')),
                            style: MyTheme.white10),
                        Row(
                          children: [
                            MyImage.asset(MyImagePaths.appCollectWhiteOff,
                                  width: 15.w, height: 15.w),
                            SizedBox(width: 3.w),
                            Text(
                                CommonUtils.renderEnFixedNumber(
                                    widget.data.favoriteFct ?? 0),
                                style: MyTheme.white10,
                                maxLines: 1),
                          ],
                        ),
                        Row(
                          children: [
                            MyImage.asset(MyImagePaths.appAsmrPlaySmall,
                                width: 13.w, height: 13.w),
                            SizedBox(width: 3.w),
                            Text(
                                CommonUtils.renderEnFixedNumber(
                                    widget.data.playFct ?? 0),
                                style: MyTheme.white10,
                                maxLines: 1),
                          ],
                        ),
                        MyImage.asset(MyImagePaths.appAsmrQue,
                            width: 15.w, height: 15.w)
                      ])
                ])),
            SizedBox(width: 10.w),
            // GestureDetector(
            //     onTap: () {
            //       //播放/暂停
            //       playerOptional(widget.data);
            //     },
            //     child: ValueListenableBuilder(
            //         valueListenable:
            //         VoicePlayerManager.instance.isPlay,
            //         builder: (context, bool value, child) {
            //           return MyImage.asset(
            //               widget.data.id ==
            //                   VoicePlayerManager
            //                       .instance.currentId
            //                   ? (VoicePlayerManager
            //                   .instance.isPlay.value
            //                   ? MyImagePaths.appAsmrPause
            //                   : MyImagePaths.appAsmrPlay)
            //                   : MyImagePaths.appAsmrPlay,
            //               width: 30.w,
            //               height: 30.w);
            //         }))
            MyImage.asset(
                MyImagePaths.appAsmrPlay,
                width: 30.w,
                height: 30.w)
          ],
        ),
      ),
    );
  }

  void playerOptional(VoiceModel data) {
    if (VoicePlayerManager.instance.audioController != null && widget.data.id ==
        VoicePlayerManager
            .instance.currentId) {//有播放器直接操作播放/暂停即可
      if (VoicePlayerManager.instance.isPlay.value) {
        VoicePlayerManager.instance.audioController?.pause();
        VoicePlayerManager.instance.isPlay.value = false;
        VoicePlayerManager.instance.removeFloatPayer();
      } else {
        VoicePlayerManager.instance.audioController?.play();
        VoicePlayerManager.instance.isPlay.value = true;
        VoicePlayerManager.instance.showFloatPayer();
        if (VoicePlayerManager.instance.minutes != null) {
          VoicePlayerManager.instance.startTimer();
        }
      }
    } else {
      VoicePlayerManager.instance.initVideoPlayer(data, context);
      VoicePlayerManager.instance.showFloatPayer();
    }

    setState(() {});
  }

}
