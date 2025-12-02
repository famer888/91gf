import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/domain.dart';
import 'package:jygf/domain/model/voice_model.dart';
import 'package:jygf/domain/remote_domain/domains/asmr.dart';
import 'package:jygf/ui_layer/screens/asmr/voice_player/voice_player_manager.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/download_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

class VoicePlayerSheetCard extends StatefulWidget {
  const VoicePlayerSheetCard({super.key, required this.data, required this.complete, this.delete});

  final VoiceModel data;

  final Function complete;

  final Function? delete;

  @override
  State<VoicePlayerSheetCard> createState() => _VoicePlayerSheetCardState();
}

class _VoicePlayerSheetCardState extends State<VoicePlayerSheetCard> {

  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final currentData = VoicePlayerManager.instance.data;
    bool isPlaying = currentData?.id == widget.data.id;

    return InkWell(
      onTap: () {
        if (!isPlaying) {
          VoicePlayerManager.instance.initVideoPlayer(widget.data, context);
          widget.complete.call();
        }
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.all(10.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Offstage(
            offstage: !isPlaying,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.w),
              child: Text('dqbf'.tr(context: context), style: MyTheme.white09_15_M),
            ),
          ),
          Row(
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
                    Text(widget.data.title ?? '',
                        style: isPlaying ? MyTheme.orange247_15M : MyTheme.white09_15_M, maxLines: 1),
                    SizedBox(height: 5.w),
                    Text('${CommonUtils.getHMTime(widget.data.duration ?? 0)}',
                        style: MyTheme.gray173_13)
                  ])),
              SizedBox(width: 10.w),
              GestureDetector(
                  onTap: () {
                    //更多操作按钮---下载/收藏/删除
                    playerOptional(widget.data);
                  },
                  child: MyImage.asset(key: _globalKey, MyImagePaths.appAsmrMore,
                      width: 20.w, height: 16.w))
            ],
          ),
          // Offstage(
          //   offstage: !isPlaying,
          //   child: Padding(
          //     padding: EdgeInsets.only(top: 17.w),
          //     child: Text('xys'.tr(context: context),
          //         style: MyTheme.white09_15_M),
          //   ),
          // ),
        ]),
      ),
    );
  }

  void playerOptional(VoiceModel data) {
    RelativeRect? widgetPosition;
    final RenderBox? renderBox =
    _globalKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;
      widgetPosition = RelativeRect.fromLTRB(
          position.dx,
          position.dy + size.height + 10.w,
          position.dx + size.width,
          position.dy + size.height);
    }
    showMenu(
        context: context,
        color: const Color.fromRGBO(0, 0, 0, 1), // 设置背景颜色
        position: widgetPosition!,
        items: [
          if (!kIsWeb)
          PopupMenuItem(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MyImage.asset(MyImagePaths.appAsmrDown, width: 18.w, height: 18.w),
                SizedBox(width: 14.w),
                Text('xz'.tr(context: context),
                    style: MyTheme.white14),
              ],
            ),
            onTap: () {
              //下载
              downVoice();
            },
          ),
          PopupMenuItem(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MyImage.asset(widget.data.isFavorite == 1 ? MyImagePaths.appCollectOn : MyImagePaths.appAsmrCollectionN, width: 18.w, height: 18.w),
                SizedBox(width: 14.w),
                Text('sc'.tr(context: context),
                    style: MyTheme.white14),
              ],
            ),
            onTap: () {
              //收藏
              collectionVoice();
            },
          ),
          PopupMenuItem(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MyImage.asset(MyImagePaths.appAsmrDel, width: 18.w, height: 18.w),
                  SizedBox(width: 14.w),
                  Text('cdlzsx'.tr(context: context), style: MyTheme.white14),
                ],
            ),
            onTap: () {
              //从队列中删除
              deleteVoice();
            },
          ),
        ]);
  }

  Future<void> collectionVoice() async {
    final domain = context.read<ASMRDomain>();
    final res = await domain.favoriteVoice(id: widget.data.id ?? 0);
    if (res.isValid) {

      widget.data.isFavorite = res.data['is_favorite'];

      if (widget.data.id == VoicePlayerManager.instance.data?.id) {//如果收藏的当前播放着中音频则直接刷新上层界面
        VoicePlayerManager.instance.data?.isFavorite = widget.data.isFavorite;
        widget.complete.call();//收藏成功回调播放界面刷新显示
      }

      //更新VoicePlayerManager.instance.voices对应数据元收藏状态
      var list = VoicePlayerManager.instance.voices;
      int index = list.indexWhere((model) => model.id == widget.data.id);
      if (index == -1) {
        MyToast.showText(text: '音频不在列表中！');
      } else {
        VoiceModel model = list[index];
        model.isFavorite = widget.data.isFavorite;
      }

    } else if (res.msg case final msg?) {
      MyToast.showText(text: msg);
    }
  }

  //从播放列表删除
  Future<void> deleteVoice() async {
    final domain = context.read<ASMRDomain>();
    final res = await domain.delVoiceQueue(id: widget.data.id ?? 00);
    if (res.isValid) {
      VoicePlayerManager.instance.voices.remove(widget.data);
      widget.delete?.call();
    } else if (res.msg case final msg?) {
      MyToast.showText(text: msg);
    }
  }

  //语音下载
  Future<void> downVoice() async {
    final domain = context.read<ASMRDomain>();
    final res = await domain.downloadVoice(id: widget.data.id ?? 0);
    if (res.isValid) {
      final url = res.data['url']; //获取下载地址
      downVoiceTaskOptional(url);
    } else if (res.msg case final msg?) {
      MyToast.showText(text: msg);
    }
  }

  //下载任务操作
  Future<void> downVoiceTaskOptional(String url) async {
    final cache = context.read<CacheDomain>();
    final downloadUtil = context.read<DownloadUtil>();

    final taskInfo = {
      'id': '${widget.data.id}',
      'urlPath': url,
      'title': widget.data.title,
      'thumbCover': widget.data.smallCover,
      'contentType': 2,
      'downloading': false,
      'isWaiting': true,

      //传入音频数据
      'smallCover': widget.data.smallCover,
      'bigCover': widget.data.bigCover,
      'viewFct': widget.data.viewFct,
      'favoriteFct': widget.data.favoriteFct,
      'isFavorite': widget.data.isFavorite,
      'playFct': widget.data.playFct,
      'type': widget.data.type,
      'coins': widget.data.coins,
      'duration': widget.data.duration,
      'voice': widget.data.voice,
      'payTip': widget.data.payTip,
      'createdAt': widget.data.createdAt,
    };

    final tasks = await cache.readDownloadVideoTasks();
    final existTaskIndex = tasks.indexWhere((e) => e['id'] == taskInfo['id']);
    if (tasks.isNotEmpty && existTaskIndex != -1) {
      final info = tasks[existTaskIndex];
      if (info['progress'] == 1) {
        MyToast.showText(text: 'voiceyxz'.tr()); //当前音频已下载，请去我的下载缓存查看吧
      } else {
        MyToast.showText(text: 'dqrwcz'.tr()); //当前任务已经存在,请勿重复操作！
      }
      return;
    }

    downloadUtil.createDownloadTask(taskInfo: taskInfo);
  }

}
