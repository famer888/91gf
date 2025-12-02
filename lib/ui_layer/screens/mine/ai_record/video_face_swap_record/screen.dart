import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/model/ai_model.dart';
import 'package:jygf/domain/model/video_detail_model.dart';
import 'package:jygf/domain/remote_domain/domains/ai.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/video_player/shortv_mv_player.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

class MineVideoFaceSwapRecordScreen extends StatefulWidget {
  const MineVideoFaceSwapRecordScreen({super.key, this.status});

  final int? status; //  0-待处理 1-处理中 2-已成功 3-已失败

  @override
  State<MineVideoFaceSwapRecordScreen> createState() =>
      _MineVideoFaceSwapRecordScreenState();
}

class _MineVideoFaceSwapRecordScreenState
    extends State<MineVideoFaceSwapRecordScreen> {
  @override
  Widget build(BuildContext context) {
    return TabBarWithView.line(
      labelStyle: MyTheme.white16medium,
      unselectedLabelStyle: MyTheme.white25508_16_M,
      tabBarHeight: 40.w,
      isScrollable: true,
      titles: [
        'pdz'.tr(context: context),
        'clz'.tr(context: context),
        'sccg'.tr(context: context),
        'scsb'.tr(context: context),
      ],
      views: const [
        KeepAliveWrapper(
          child: _ContentVideoFaceSwapRecordScreen(status: 0),
        ),
        KeepAliveWrapper(
          child: _ContentVideoFaceSwapRecordScreen(status: 1),
        ),
        KeepAliveWrapper(
          child: _ContentVideoFaceSwapRecordScreen(status: 2),
        ),
        KeepAliveWrapper(
          child: _ContentVideoFaceSwapRecordScreen(status: 3),
        ),
      ],
    );
  }
}

class _ContentVideoFaceSwapRecordScreen extends StatefulWidget {
  const _ContentVideoFaceSwapRecordScreen({this.status});

  final int? status; // 0-待处理 1-处理中 2-已成功 3-已失败

  @override
  State<_ContentVideoFaceSwapRecordScreen> createState() =>
      _ContentVideoFaceSwapRecordScreenState();
}

class _ContentVideoFaceSwapRecordScreenState
    extends State<_ContentVideoFaceSwapRecordScreen> {
  late final aiDomain = context.read<AIDomain>();

  Future<List<dynamic>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await aiDomain.myVideoFace(
      status: widget.status ?? 0,
      page: page,
      limit: pageSize,
    );
    return result.data;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      key: UniqueKey(),
      childAspectRatio: 170 / 250,
      itemBuilder: (_, item, __) {
        return _AIVideoFaceSwapRecordCard(
          data: item,
          delSucess: () {
            context.pop();
            setState(() {});
          },
        );
      },
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _AIVideoFaceSwapRecordCard extends StatefulWidget {
  const _AIVideoFaceSwapRecordCard({
    required this.data,
    required this.delSucess,
    this.status,
  });

  final int? status; // 0-待处理 1-处理中 2-已成功 3-已失败
  final AIModel data;
  final Function delSucess;

  @override
  State<_AIVideoFaceSwapRecordCard> createState() =>
      _AIVideoFaceSwapRecordCardState();
}

class _AIVideoFaceSwapRecordCardState
    extends State<_AIVideoFaceSwapRecordCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.w),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (widget.data.status != 2) {
            MyToast.showText(text: '处理中，无法查看视频');
            return;
          }
          _showSheetView();
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: MyImage.network(widget.data.thumb ?? ''),
            ),
            (widget.data.status ?? 0) <= 1
                ? Positioned(
                    top: -5,
                    bottom: -5,
                    left: -5,
                    right: -5,
                    child: CommonUtils.blurCover(borderRadius: 5.w))
                : Container(),
            widget.data.status == 2
                ? Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            margin: EdgeInsets.only(bottom: 13.w),
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                _saveVideo(widget.data.faceM3u8 ?? '');
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20.w),
                                height: 30.w,
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
                            )),
                      ],
                    ),
                  )
                : Container(),
            Positioned(
                child: IgnorePointer(
              child: Container(
                height: 40.w,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(0, 0, 0, 0.4),
                      Color.fromRGBO(0, 0, 0, 0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getDayTimerStr(widget.data.createdAt ?? ''),
                        style: MyTheme.white06_12,
                      ),
                      Text(
                        _getSecondTimerStr(widget.data.createdAt ?? ''),
                        style: MyTheme.white06_12,
                      )
                    ]),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Future<void> _saveVideo(String m3u8Url) async {
    MyToast.showText(text: "暂时不支持下载，请自行录屏保存");
  }

  String _getDayTimerStr(String createdAt) {
    if (createdAt.isNotEmpty && createdAt.length >= 10) {
      return createdAt.substring(0, 10);
    }
    return '';
  }

  String _getSecondTimerStr(String createdAt) {
    if (createdAt.isNotEmpty && createdAt.length >= 16) {
      return createdAt.substring(10, 16);
    }
    return '';
  }

  Future<void> _showSheetView() {
    final sheetHeight = ScreenUtil().screenHeight * 0.8;
    final videoJson = {
      'id': widget.data.id,
      'title': '视频换脸',
      'second_title': '视频换脸',
      'thumb_cover': widget.data.thumb ?? '',
      'source_240': widget.data.faceM3u8 ?? '',
    };

    final datas = VideoData.fromJson(videoJson);

    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.only(
            left: MyTheme.pagePadding,
            top: MyTheme.pagePadding,
            right: MyTheme.pagePadding,
            bottom: 44.w),
        color: MyTheme.bgColor,
        height: sheetHeight,
        child: Column(children: [
          AspectRatio(
              aspectRatio: 1, child: ShortvMvPlayer(info: datas, noBack: true)),
          SizedBox(height: 30.w),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              _saveVideo(widget.data.faceM3u8 ?? '');
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
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              _deleteRecord();
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
        ]),
      ),
    );
  }

  Future<void> _deleteRecord() async {
    MyToast.showLoading(text: 'zzscz'.tr(context: context));
    final domain = context.read<AIDomain>();
    final res = await domain.delVideoFace(ids: widget.data.id.toString());
    MyToast.closeAllLoading();
    if (res.isValid) {
      widget.delSucess.call();
    } else if (res.msg case final msg?) {
      MyToast.showText(text: msg);
    }
  }
}
