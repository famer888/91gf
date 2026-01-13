import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/voice_model.dart';
import 'package:jygf/ui_layer/screens/asmr/voice_player/voice_player_manager.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:provider/provider.dart';

import '../../../../domain/model/video_detail_model.dart';
import '../../../router/routes.dart';
import '../../../utils/download_utils.dart';
import '../../common_widgets/keep_alive_wrapper.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/my_image.dart';
import '../../common_widgets/my_tab_bar.dart';
import '../../common_widgets/screen_background.dart';
import '../../common_widgets/status/empty_data.dart';
import '../../theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class MineDownloadScreen extends StatefulWidget {
  const MineDownloadScreen({super.key});

  @override
  State<MineDownloadScreen> createState() => _MineDownloadScreenState();
}

class _MineDownloadScreenState extends State<MineDownloadScreen> {
  late final downloadUtil = context.read<DownloadUtil>();
  late final videoDownloadCache = downloadUtil.cache;

  final isAllNotifier = ValueNotifier(false);
  final isEditNotifier = ValueNotifier(false);

  List<Map> _allDownTasks = [];
  List<Map> _videoTasks = [];
  List<Map> _voiceTasks = [];
  List<Map> _cartoonTasks = [];

  @override
  void initState() {
    getVideoDownloadInfo();
    super.initState();
  }

  // 获取视频下载信息
  Future getVideoDownloadInfo() async {
    _allDownTasks =
        List<Map>.from(await videoDownloadCache.readDownloadVideoTasks());
    // 筛选出视频下载任务
    _videoTasks =
        _allDownTasks.where((task) => task['contentType'] == 1).toList();
    // 筛选出音频下载任务
    _voiceTasks =
        _allDownTasks.where((task) => task['contentType'] == 2).toList();
    // 筛选出漫画下载任务
    _cartoonTasks =
        _allDownTasks.where((task) => task['contentType'] == 3).toList();

    for (var element in _videoTasks) {
      element.choosed = false;
    }
    for (var element in _voiceTasks) {
      element.choosed = false;
    }
    for (var element in _cartoonTasks) {
      element.choosed = false;
    }
    setState(() {});
  }

  void onTapAll() {
    isAllNotifier.value = !isAllNotifier.value;
    if (isAllNotifier.value) {
      for (var element in _allDownTasks) {
        element.choosed = true;
      }
    } else {
      for (var element in _allDownTasks) {
        element.choosed = false;
      }
    }
    setState(() {});
  }

  void onTapDelete() async {
    for (var element in _allDownTasks) {
      if (element.choosed) {
        downloadUtil.removeTask(element['id']);
        String path = element['url'];
        String dir = path.substring(0, path.lastIndexOf('/'));
        Directory directory = Directory(dir);
        bool isExists = await directory.exists();
        if (isExists) {
          directory.deleteSync(recursive: true);
        }
      }
    }
    _allDownTasks.removeWhere((element) => element.choosed);
    // 筛选出视频下载任务
    _videoTasks =
        _allDownTasks.where((task) => task['contentType'] == 1).toList();
    // 筛选出音频下载任务
    _voiceTasks =
        _allDownTasks.where((task) => task['contentType'] == 2).toList();
    // 筛选出漫画下载任务
    _cartoonTasks =
        _allDownTasks.where((task) => task['contentType'] == 3).toList();
    videoDownloadCache.upsertDownloadVideoTasks(tasks: _allDownTasks);
    setState(() {});
  }

  Widget _buildBottom() {
    return ValueListenableBuilder(
        valueListenable: isEditNotifier,
        builder: (_, isEdit, __) {
          if (!isEdit) {
            return const SizedBox.shrink();
          }
          return Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(25, 25, 25, 1),
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    offset: Offset(0, 0),
                    blurRadius: 10.0,
                    spreadRadius: 0)
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                      child: ReportGestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: onTapAll,
                    child: Container(
                        padding: EdgeInsets.only(left: 15.w),
                        alignment: Alignment.centerLeft,
                        child: ValueListenableBuilder(
                          valueListenable: isAllNotifier,
                          builder: (_, isAll, __) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  isAll
                                      ? Icons.check_circle_outline
                                      : Icons.circle_outlined,
                                  color: isAll
                                      ? MyTheme.jellyCyanColor103224185
                                      : MyTheme.grayColor180,
                                  size: 20.w,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 10.w,
                                  ),
                                  child: Text(
                                    tr('qxu'),
                                    // isAll ? tr('qbx') : tr('qxu'),
                                    style: isAll
                                        ? MyTheme.blue80_15
                                        : MyTheme.gray180_15,
                                  ),
                                )
                              ],
                            );
                          },
                        )),
                  )),
                  ReportGestureDetector(
                    onTap: onTapDelete,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 15.w,
                        horizontal: 40.w,
                      ),
                      decoration: const BoxDecoration(
                        gradient: MyTheme.gradient_90_114,
                      ),
                      child: Center(
                        child: Text(
                          tr('sch'),
                          style: MyTheme.white15bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: 'wdxz'.tr(context: context),
          rightWidget: ReportGestureDetector(
            onTap: () {
              isEditNotifier.value = !isEditNotifier.value;
            },
            child: Text(
              tr('bj'),
              style: MyTheme.gray150_14,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarWithView.line(
                indicatorType: IndicatorType.curve,
                tabBarPadding: EdgeInsets.symmetric(
                  vertical: 0.w,
                  horizontal: MyTheme.pagePadding,
                ),
                unselectedLabelStyle: TextStyle(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 15.sp,
                  overflow: TextOverflow.visible,
                  decoration: TextDecoration.none,
                ),
                // tabBarHeight: 40.w,
                titles: ['shp'.tr(context: context), 'dman'.tr(context: context), 'ASMR'],
                views: [
                  KeepAliveWrapper(
                    child: _VideoView(
                      videoTasks: _videoTasks,
                      isEditNotifier: isEditNotifier,
                    ),
                  ),
                  KeepAliveWrapper(
                    child: _VideoView(
                      videoTasks: _cartoonTasks,
                      isEditNotifier: isEditNotifier,
                    ),
                  ),
                  KeepAliveWrapper(
                    child: _VideoView(
                      videoTasks: _voiceTasks,
                      isEditNotifier: isEditNotifier,
                    ),
                  ),
                ],
              ),
            ),
            _buildBottom(),
          ],
        ),
      ),
    );
  }
}

class _VideoView extends StatefulWidget {
  const _VideoView({required this.videoTasks, required this.isEditNotifier});

  final List<Map> videoTasks;
  final ValueNotifier<bool> isEditNotifier;

  @override
  State<_VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<_VideoView> {
  @override
  Widget build(BuildContext context) {
    final data = widget.videoTasks;
    if (data.isEmpty) {
      return PageEmptyDataView(
        text: 'spxzk'.tr(),
      );
    }

    return GridView.builder(
        cacheExtent: 5.sh,
        padding: EdgeInsets.all(MyTheme.pagePadding),
        itemCount: data.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 7.w,
          childAspectRatio: 1.0,
        ),
        itemBuilder: (context, index) {
          return Stack(
            children: [
              _VideoCard(
                width: (1.sw - MyTheme.pagePadding * 2 - 7.w) / 2,
                data: data[index],
              ),
              Positioned.fill(
                child: ValueListenableBuilder(
                    valueListenable: widget.isEditNotifier,
                    builder: (_, isEdit, __) {
                      return isEdit
                          ? ReportGestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                data[index].choosed = !data[index].choosed;
                                setState(() {});
                              },
                              child: Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(
                                  top: 6.w,
                                  left: 6.w,
                                ),
                                child: data[index].choosed == true
                                    ? Icon(Icons.check_circle,
                                        color: MyTheme.jellyCyanColor103224185,
                                        size: 17.w)
                                    : Icon(Icons.circle_outlined,
                                        color: const Color.fromRGBO(
                                            153, 153, 153, 1),
                                        size: 17.w),
                              ),
                            )
                          : const SizedBox.shrink();
                    }),
              ),
            ],
          );
        });
  }
}

class _VideoCard extends StatefulWidget {
  const _VideoCard({required this.data, required this.width});

  final Map data;
  final double width;

  @override
  State<_VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<_VideoCard> {
  late final downloadUtil = context.read<DownloadUtil>();
  final ValueNotifier<Map> progressNotifier = ValueNotifier({});
  bool isWaiting = false;

  @override
  void initState() {
    final data = widget.data;
    if (data['progress'] != null) {
      progressNotifier.value = {
        'progress': data['progress'] + .0,
        'downloading': data['downloading'],
      };
      isWaiting = data['isWaiting'];
    }
    downloadUtil.downloadVideoProgress.addListener(_listener);
    super.initState();
  }

  void _listener() {
    isWaiting = false;
    final data =
        downloadUtil.downloadVideoProgress.value['${widget.data['id']}'];
    if (data != null) {
      progressNotifier.value = data;
    }
  }

  @override
  void dispose() {
    downloadUtil.downloadVideoProgress.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final thumbWidth = widget.width;
    final thumbHeight = thumbWidth / 7 * 4;
    final thumbUrl = data['thumbCover'];
    final marginBottom = 6.5.w;
    return ReportGestureDetector(
      onTap: () {
        final value = progressNotifier.value;
        final progress = value.progress;
        if (progress.toInt() == 1) {

          if (data['contentType'] == 2) {
            //音频点击
            if (VoicePlayerManager.instance.isPlay.value) {
              VoicePlayerManager.instance.audioController?.pause();
              VoicePlayerManager.instance.isPlay.value = false;
              VoicePlayerManager.instance.removeFloatPayer();
            }
            final voiceModel = VoiceModel(
              id: int.parse(data['id'].toString()),
              title: data['title'],
              smallCover: data['smallCover'],
              bigCover: data['bigCover'],
              viewFct: data['viewFct'],
              favoriteFct: data['favoriteFct'],
              playFct: data['playFct'],
              type: data['type'],
              coins: data['coins'],
              duration: data['duration'],
              voice: data['url'], //取本地缓存的文件夹地址
              payTip: data['payTip'],
              createdAt: data['createdAt'],
            );
            LocalVoiceRoute(voiceModel).push(context);
          } else {
            //视频点击
            final videoData = VideoData(
                source240: data['url'],
                title: data['title'],
                coverThumbHorizontal: thumbUrl,
                coverThumbVerticle: thumbUrl);
            LocalVideoRoute(videoData).push(context);
          }

        } else if (value.downloading == false && !isWaiting) {
          downloadUtil.createDownloadTask(taskInfo: widget.data);
        }
      },
      child: SizedBox(
        width: thumbWidth,
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  width: thumbWidth,
                  height: thumbHeight,
                  margin: EdgeInsets.only(bottom: marginBottom),
                  child: MyImage.network(
                    thumbUrl,
                    backgroundColor: Colors.grey,
                    fit: BoxFit.cover,
                    borderRadius: 5.w,
                  ),
                ),
                (!isWaiting && data['contentType'] == 2)
                    ? MyImage.asset(MyImagePaths.appAsmrPlay,
                        width: 40.w, height: 40.w)
                    : Container(),
                (!isWaiting && data['contentType'] == 2)
                    ? Positioned(
                        top: 6.w,
                        right: 6.w,
                        child: MyImage.asset(MyImagePaths.appAsmrQue,
                            width: 15.w, height: 15.w))
                    : Container(),
                ValueListenableBuilder(
                    valueListenable: progressNotifier,
                    builder: (_, value, __) {
                      final progress = value.progress;
                      final downloadError = value.downloadError ?? false;
                      final downloading = value.downloading ?? true;
                      String getDownloadText() {
                        String text = downloadError
                            ? tr('xsbcs')
                            : isWaiting
                                ? tr('ddxz')
                                : progress == 0
                                    ? tr('djxz')
                                    : downloading
                                        ? tr('xzjd')
                                        : tr('ztxz');
                        return text;
                      }

                      return progress.toInt() != 1
                          ? Positioned(
                              top: 0,
                              right: 0,
                              bottom: marginBottom,
                              left: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(0, 0, 0, 0.5),
                                  borderRadius: marginBottom != 0
                                      ? BorderRadius.all(Radius.circular(5.w))
                                      : BorderRadius.vertical(
                                          bottom: Radius.zero,
                                          top: Radius.circular(5.w),
                                        ),
                                ),
                                child: Center(
                                  child: Text(
                                    getDownloadText(),
                                    style: TextStyle(
                                      color: progress == -1
                                          ? MyTheme.jellyCyanColor103224185
                                          : Colors.white,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ),
                              ))
                          : const SizedBox.shrink();
                    }),
                ValueListenableBuilder(
                    valueListenable: progressNotifier,
                    builder: (_, value, __) {
                      final progress = value.progress;

                      return progress.toInt() != 1
                          ? Positioned(
                              top: 0,
                              right: 0,
                              bottom: marginBottom,
                              left: 0,
                              child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: marginBottom != 0
                                        ? BorderRadius.all(Radius.circular(5.w))
                                        : BorderRadius.vertical(
                                            bottom: Radius.zero,
                                            top: Radius.circular(5.w),
                                          ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 2.w,
                                        width: thumbWidth * progress,
                                        decoration: BoxDecoration(
                                          color:
                                              MyTheme.jellyCyanColor103224185,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(1.w),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            )
                          : Container();
                    }),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5.w),
              child: SizedBox(
                  child: Text(
                widget.data['title'],
                maxLines: 2,
                style: MyTheme.white255_15_M,
              )),
            )
          ],
        ),
      ),
    );
  }
}

extension _MapHelper on Map {
  dynamic get progress => this['progress'];

  dynamic get downloadError => this['downloadError'];

  dynamic get downloading => this['downloading'];

  bool get choosed => this['choosed'];

  set choosed(value) => this['choosed'] = value;
}
