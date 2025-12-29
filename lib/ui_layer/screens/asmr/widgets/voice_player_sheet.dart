import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/remote_domain/domains/asmr.dart';
import 'package:jygf/ui_layer/screens/asmr/card/voice_player_sheet_card.dart';
import 'package:jygf/ui_layer/screens/asmr/voice_player/voice_player_manager.dart';
import 'package:jygf/ui_layer/screens/common_widgets/event_bus/event_bus.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

class VoicePlayerSheet extends StatefulWidget {
  const VoicePlayerSheet({super.key, this.complete});

  final Function? complete;

  @override
  State<VoicePlayerSheet> createState() => _VoicePlayerSheetState();
}

class _VoicePlayerSheetState extends State<VoicePlayerSheet> {
  double get bottomBarHeight => kIsWeb ? 17 : ScreenUtil().bottomBarHeight;

  late StreamSubscription<MyEvent> _subscription;

  @override
  void initState() {
    super.initState();

    _getData();

    // 订阅播放完毕后自动切换音频后刷新界面
    _subscription = eventBus.on<MyEvent>().listen((event) {
      debugPrint('Received event: ${event.message}');
      if (event.message == 'RefreshVoicePayerUI') {
        setState(() {});
        Navigator.pop(context);
      }
    });
  }

  Future<void> _getData() async {
    final domain = context.read<ASMRDomain>();
    final res = await domain.voiceListQueue(page: 1, limit: 1000);
    if (res.isValid) {
      VoicePlayerManager.instance.voices = res.data ?? [];//同步数据到单例中
    } else if (res.msg case final msg?) {
      MyToast.showText(text: msg);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _subscription.cancel(); // 取消订阅
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // //正在播放的数据放到第一位
    var list = VoicePlayerManager.instance.voices;
    // var playingData = VoicePlayerManager.instance.data;
    // int index = list.indexWhere((model) => model.id == playingData?.id);
    // if (index == -1) {
    //   MyToast.showText(text: '播放列表数据请求失败，请稍后再试！');
    // } else {
    //   list.removeAt(index);
    //   list.insert(0, playingData!);
    // }

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(
            top: 10.w,
            bottom: bottomBarHeight + 20.w,
            left: MyTheme.pagePadding,
            right: MyTheme.pagePadding),
        decoration: BoxDecoration(
            color: MyTheme.blackColor29_2_24,
            border:const Border(top: BorderSide(color: Color.fromRGBO(154, 48, 133, 1), width: 1)),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.w))),
        height: 500.w,
        child: Column(
          children: [
            SizedBox(
              height: 46.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 42.w,
                  ),
                  Text('bflb'.tr(context: context), style: MyTheme.white_17),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      height: double.infinity,
                      child: MyImage.asset(
                        MyImagePaths.appClose,
                        width: 16.w,
                        height: 16.w,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10.w),
            Divider(color: Colors.white.withOpacity(0.2), height: 0.5.w),
            Expanded(
                child: ListView.builder(
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, index) => VoicePlayerSheetCard(
                        data: list[index],
                      complete: () {
                          widget.complete?.call();
                      },
                      delete: () {
                          setState(() {});
                      },
                    )))
          ],
        ),
      ),
    );
  }
}
