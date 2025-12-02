import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/remote_domain/domains/aikiss.dart';
import 'package:jygf/domain/model/video_detail_model.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/video_player/shortv_mv_player.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

class MineKissRecordScreen extends StatefulWidget {
  const MineKissRecordScreen({super.key, this.status});

  final int? status; //  0-待处理 1-处理中 2-切片中 3-已成功 4-已失败

  @override
  State<MineKissRecordScreen> createState() => _MineKissRecordScreenState();
}

class _MineKissRecordScreenState extends State<MineKissRecordScreen> {
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
        'qpz'.tr(context: context),
        'sccg'.tr(context: context),
        'scsb'.tr(context: context),
      ],
      views: const [
        KeepAliveWrapper(
          child: _ContentKissRecordScreen(status: 0),
        ),
        KeepAliveWrapper(
          child: _ContentKissRecordScreen(status: 1),
        ),
        KeepAliveWrapper(
          child: _ContentKissRecordScreen(status: 2),
        ),
        KeepAliveWrapper(
          child: _ContentKissRecordScreen(status: 3),
        ),
        KeepAliveWrapper(
          child: _ContentKissRecordScreen(status: 4),
        ),
      ],
    );
  }
}

class _ContentKissRecordScreen extends StatefulWidget {
  const _ContentKissRecordScreen({this.status});

  final int? status; // 0-待处理 1-处理中 2-切片中 3-已成功 4-已失败

  @override
  State<_ContentKissRecordScreen> createState() =>
      _ContentKissRecordScreenState();
}

class _ContentKissRecordScreenState extends State<_ContentKissRecordScreen> {
  late final aiDomain = context.read<AIKissDomain>();

  Future<List<dynamic>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await aiDomain.aiKissRecord(
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
      itemBuilder: (_, item, __) => _AIKissRecordCard(
        data: item is Map ? item : (item as dynamic) as Map,
        delSucess: () {
          context.pop();
          setState(() {});
        },
      ),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _AIKissRecordCard extends StatefulWidget {
  const _AIKissRecordCard(
      {required this.data, required this.delSucess, this.status});

  final int? status; // 0-待处理 1-处理中 2-切片中 3-已成功 4-已失败
  final Map data;
  final Function delSucess;

  @override
  State<_AIKissRecordCard> createState() => _AIKissRecordCardState();
}

class _AIKissRecordCardState extends State<_AIKissRecordCard> {
  int get _status => (widget.data['status'] ?? 0);

  String get _cover => (widget.data['cover'] ?? '');

  String get _createdAt => (widget.data['created_at'] ?? '');

  String get _video => (widget.data['video'] ?? '');

  int get _id => (widget.data['id'] ?? 0);

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
          if (_status != 3) {
            MyToast.showText(text: '处理中，无法查看视频');
            return;
          }
          _showSheetView();
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: MyImage.network(_cover),
            ),
            (_status <= 1)
                ? Positioned(
                    top: -5,
                    bottom: -5,
                    left: -5,
                    right: -5,
                    child: CommonUtils.blurCover(borderRadius: 5.w))
                : Container(),
            _status == 3
                ? Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            margin: EdgeInsets.only(bottom: 13.w),
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                _saveVideo(_video);
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
                        _getDayTimerStr(_createdAt),
                        style: MyTheme.white06_12,
                      ),
                      Text(
                        _getSecondTimerStr(_createdAt),
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
      'id': _id,
      'title': 'AI接吻',
      'second_title': 'AI接吻',
      'thumb_cover': _cover,
      'source_240': _video,
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
              _saveVideo(_video);
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
    final domain = context.read<AIKissDomain>();
    final res = await domain.delAIKissRecord(ids: _id.toString());
    MyToast.closeAllLoading();
    if (res.isValid) {
      widget.delSucess.call();
    } else if (res.msg case final msg?) {
      MyToast.showText(text: msg);
    }
  }
}
