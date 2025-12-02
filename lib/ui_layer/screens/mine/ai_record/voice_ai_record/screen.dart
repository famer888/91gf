import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/remote_domain/domains/aiaudio.dart';
import 'package:jygf/ui_layer/screens/common_widgets/dialog/widgets/regular_dialog.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VoiceAIRecordScreen extends StatefulWidget {
  const VoiceAIRecordScreen({super.key});

  @override
  State<VoiceAIRecordScreen> createState() => _VoiceAIRecordScreenState();
}

class _VoiceAIRecordScreenState extends State<VoiceAIRecordScreen> {
  @override
  Widget build(BuildContext context) {
    return TabBarWithView.line(
      labelStyle: MyTheme.white16medium,
      unselectedLabelStyle: MyTheme.white25508_16_M,
      tabBarHeight: 40.w,
      // isScrollable: false,
      titles: [
        'pdz'.tr(context: context),
        'clz'.tr(context: context),
        'qpz'.tr(context: context),
        'sccg'.tr(context: context),
        'scsb'.tr(context: context),
      ],
      views: const [
        KeepAliveWrapper(
          child: _ContentVoiceAIRecordScreen(status: 0),
        ),
        KeepAliveWrapper(
          child: _ContentVoiceAIRecordScreen(status: 1),
        ),
        KeepAliveWrapper(
          child: _ContentVoiceAIRecordScreen(status: 2),
        ),
        KeepAliveWrapper(
          child: _ContentVoiceAIRecordScreen(status: 3),
        ),
        KeepAliveWrapper(
          child: _ContentVoiceAIRecordScreen(status: 4),
        ),
      ],
    );
  }
}

class _ContentVoiceAIRecordScreen extends StatefulWidget {
  const _ContentVoiceAIRecordScreen({this.status});

  final int? status; // 0-排队中 3-生成成功 4-生成失败

  @override
  State<_ContentVoiceAIRecordScreen> createState() =>
      _ContentVoiceAIRecordScreenState();
}

class _ContentVoiceAIRecordScreenState
    extends State<_ContentVoiceAIRecordScreen> {
  late final aiDomain = context.read<AIAudioDomain>();
  final GlobalKey<MyListViewState<dynamic>> _listKey =
      GlobalKey<MyListViewState<dynamic>>();

  Future<List<dynamic>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await aiDomain.aiAudioRecord(
        status: widget.status ?? 0, page: page, limit: pageSize);
    if (result.isValid) {
      return result.data;
    } else {
      MyToast.showText(text: result.msg ?? '加载失败');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.status == 3) {
      return MyListView.list(
          key: _listKey,
          contentPadding: 12.w,
          padding: EdgeInsets.symmetric(
              horizontal: MyTheme.pagePadding, vertical: 12.w),
          itemBuilder: (context, item, index) => VoiceAIRecordCard(
              data: item,
              refresh: () {
                _listKey.currentState?.reloadPage();
              }),
          onFetchingMore: (currentPage, pageSize) =>
              _getData(page: currentPage, pageSize: pageSize));
    } else {
      return MyListView.grid(
          key: _listKey,
          childAspectRatio: 170 / 250,
          itemBuilder: (context, item, index) => VoiceAIRecordSimpleCard(
              data: item is Map ? item : (item as dynamic) as Map,
              status: widget.status ?? 0,
              refresh: () {
                _listKey.currentState?.reloadPage();
              }),
          onFetchingMore: (currentPage, pageSize) =>
              _getData(page: currentPage, pageSize: pageSize));
    }
  }
}

class VoiceAIRecordCard extends StatefulWidget {
  const VoiceAIRecordCard(
      {super.key, required this.data, required this.refresh});

  final dynamic data; // Map or model
  final VoidCallback refresh;
  @override
  State<VoiceAIRecordCard> createState() => _VoiceAIRecordCardState();
}

class _VoiceAIRecordCardState extends State<VoiceAIRecordCard> {
  VideoPlayerController? _controller;
  Duration _progress = const Duration(seconds: 0);
  Duration _total = const Duration(seconds: 0);
  bool _isInit = false;
  bool _isPlaying = false;

  String get _idStr {
    final map = (widget.data is Map) ? widget.data as Map : <String, dynamic>{};
    return '${map['id'] ?? ''}';
  }

  String get _createdAt {
    final map = (widget.data is Map) ? widget.data as Map : <String, dynamic>{};
    return (map['updated_at'] ?? '');
  }

  String get _audioUrl {
    final map = (widget.data is Map) ? widget.data as Map : <String, dynamic>{};
    return (map['audio_m3u8'] ?? '');
  }

  int get _duration {
    final map = (widget.data is Map) ? widget.data as Map : <String, dynamic>{};
    return (map['audio_duration'] ?? 0);
  }

  String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final minutes = two(d.inMinutes.remainder(60));
    final seconds = two(d.inSeconds.remainder(60));
    final hours = d.inHours;
    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '${int.parse(minutes)}:$seconds';
  }

  Future<void> _initAndToggle() async {
    if (_audioUrl.isEmpty) {
      MyToast.showText(text: '音频地址为空');
      return;
    }
    if (_controller == null) {
      try {
        _controller = VideoPlayerController.networkUrl(Uri.parse(_audioUrl));
        await _controller!.initialize();
        _total = _controller!.value.duration;
        _controller!.addListener(() {
          if (!mounted) return;
          final value = _controller!.value;
          bool shouldReset = false;
          if (value.isCompleted ||
              (value.position >= value.duration &&
                  value.duration.inMilliseconds > 0)) {
            shouldReset = true;
          }
          setState(() {
            _progress =
                shouldReset ? const Duration(seconds: 0) : value.position;
            _total = value.duration;
            if (shouldReset) {
              _isPlaying = false;
            }
          });
        });
        _isInit = true;
      } catch (e) {
        MyToast.showText(text: '音频加载失败');
        return;
      }
    }
    if (_isPlaying) {
      await _controller?.pause();
    } else {
      await _controller?.play();
    }
    setState(() {
      _isPlaying = !(_isPlaying);
    });
  }

  @override
  void dispose() {
    _controller?.removeListener(() {});
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(children: [
        Expanded(
            child: Text('提交时间： $_createdAt',
                style: MyTheme.white06_12,
                maxLines: 1,
                overflow: TextOverflow.ellipsis)),
        // GestureDetector(
        //     behavior: HitTestBehavior.translucent,
        //     onTap: () {
        //       MyToast.showText(text: '暂不支持下载');
        //     },
        //     child: Container(
        //       height: 20.w,
        //       decoration: BoxDecoration(
        //           gradient: MyTheme.gradient_90_114,
        //           borderRadius: BorderRadius.circular(3.w)),
        //       child: Padding(
        //         padding: EdgeInsets.symmetric(horizontal: 15.w),
        //         child: Center(child: Text('下载', style: MyTheme.white12)),
        //       ),
        //     ))
      ]),
      SizedBox(height: 8.w),
      Container(
        height: 44.w,
        decoration: BoxDecoration(
            color: const Color(0xff1b1c2b),
            borderRadius: BorderRadius.circular(22.w)),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _initAndToggle,
            child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white, size: 24.w),
          ),
          SizedBox(width: 4.w),
          Text('${_format(_progress)}/${_format(Duration(seconds: _duration))}',
              style: MyTheme.white12),
          SizedBox(width: 8.w),
          Expanded(
              child: ProgressBar(
            timeLabelLocation: TimeLabelLocation.none,
            progress: _progress,
            total: _total,
            baseBarColor: Colors.white,
            bufferedBarColor: Colors.white,
            progressBarColor: _progress > Duration.zero
                ? MyTheme.blueColor64
                : Colors.transparent,
            barHeight: 2.0,
            thumbRadius: 0.0,
            onSeek: (d) {
              if (!_isInit || _controller == null) return;
              _controller!.seekTo(d);
            },
          )),
          SizedBox(width: 8.w),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _deleteRecord,
            child: Text('删除', style: MyTheme.white12),
          ),
        ]),
      )
    ]);
  }

  void _deleteRecord() {
    CommonUtils.showDialog(
        context: context,
        builder: (context) => RegularDialog(
              title: 'wxts'.tr(context: context),
              content: Text('是否确定删除语音记录',
                  style: MyTheme.white255_15, textAlign: TextAlign.center),
              buttonText: '确认',
              cancelText: '取消',
              confirmOnTap: () async {
                Navigator.pop(context);
                MyToast.showLoading(text: '正在删除');
                final domain = context.read<AIAudioDomain>();
                final res = await domain.delAIAudioRecord(ids: _idStr);
                MyToast.closeAllLoading();
                if (res.isValid) {
                  MyToast.showText(text: '删除成功');
                  widget.refresh.call();
                } else if (res.msg case final msg?) {
                  MyToast.showText(text: msg);
                }
              },
              cancelOnTap: () {
                Navigator.pop(context);
              },
            ));
  }
}

class VoiceAIRecordSimpleCard extends StatefulWidget {
  const VoiceAIRecordSimpleCard({
    super.key,
    required this.data,
    required this.status,
    required this.refresh,
  });

  final Map data;
  final int status; // 0-排队中 4-生成失败
  final VoidCallback refresh;

  @override
  State<VoiceAIRecordSimpleCard> createState() =>
      _VoiceAIRecordSimpleCardState();
}

class _VoiceAIRecordSimpleCardState extends State<VoiceAIRecordSimpleCard> {
  String get _createdAt => (widget.data['updated_at'] ?? '');

  String get _desc => (widget.data['description'] ?? '');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.w),
              color: const Color(0xff1b1c2b),
            ),
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Text(
                      _desc.isEmpty
                          ? (widget.status == 0
                              ? 'pdz'.tr(context: context)
                              : 'scsb'.tr(context: context))
                          : _desc,
                      style: MyTheme.white16medium,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: CommonUtils.blurCover(borderRadius: 5.w),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 6.w),
        Text(
          '提交时间： $_createdAt',
          style: MyTheme.white06_10,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
