import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/asmr/voice_player/voice_player_manager.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';

class VoiceTimeSheetCard extends StatefulWidget {
  const VoiceTimeSheetCard({super.key, required this.minute});

  final int minute;

  @override
  State<VoiceTimeSheetCard> createState() => _VoiceTimeSheetCardState();
}

class _VoiceTimeSheetCardState extends State<VoiceTimeSheetCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        VoicePlayerManager.instance.minutes = widget.minute;
        VoicePlayerManager.instance.startTimer();
        Navigator.pop(context);
      },
      child: SizedBox(
        height: 46.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Divider(color: Colors.white.withOpacity(0.2), height: 0.5.w),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Center(child: Text('${widget.minute}${'minute'.tr(context: context)}', style: MyTheme.white09_15_M))),
                  SizedBox(width: 10.w),
                  Visibility(
                    visible: (VoicePlayerManager.instance.minutes != null && VoicePlayerManager.instance.minutes == widget.minute),
                    child: MyImage.asset(
                      MyImagePaths.appAsmrGouS,
                      width: 18.w,
                      height: 18.w,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
