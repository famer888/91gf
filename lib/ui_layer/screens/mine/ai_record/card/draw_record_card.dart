import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/model/ai/ai_draw_record_model.dart';
import 'package:jygf/domain/remote_domain/domains/aidraw.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/mine/ai_record/draw_picture_record_preview/screen.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class AIDrawRecordCard extends StatefulWidget {
  const AIDrawRecordCard(
      {super.key, required this.data, required this.delSucess, this.status});

  final int? status; // 0-待处理 1-处理中 2-已成功 3-已失败
  final AIDrawRecordModel data;
  final Function delSucess;

  @override
  State<AIDrawRecordCard> createState() => _AIDrawRecordCardState();
}

class _AIDrawRecordCardState extends State<AIDrawRecordCard> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final List<Thumbs> thumbs = widget.data.thumb.length > 4
        ? widget.data.thumb.sublist(0, 4)
        : widget.data.thumb;

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.w),
        // color: MyTheme.white08Color,
      ),
      child: Stack(
        children: [
         widget.data.status == 2
                ? Positioned.fill(
              child: GridView.count(
                          crossAxisCount: 4,
                          childAspectRatio: 1 / 1.4,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          children: List.generate(thumbs.length, (index) {
              final thumb = thumbs[index];
              return ReportGestureDetector(
                onTap: () => _showSheetView(thumbs, index),
                child: Container(
                  margin: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.w))
                  ),
                  child: MyImage.network(thumb.url),
                ),
              );
                          }),
                        )) : const SizedBox.shrink(),
          (widget.data.status ?? 0) <= 1 //毛玻璃效果
              ? Positioned(
                  top: -5,
                  bottom: -5,
                  left: -5,
                  right: -5,
                  child: CommonUtils.blurCover(borderRadius: 5.w))
              : Container(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
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
                  children: [
                    Text(
                      _getDayTimerStr(widget.data.createdAt ?? ''),
                      style: MyTheme.white12,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      _getSecondTimerStr(widget.data.createdAt ?? ''),
                      style: MyTheme.white12,
                    )
                  ]),
            ),
          )),
          if ((widget.data.status ?? 0) <= 1)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 40.w,
              child: Center(
                child: Text(
                  widget.data.status == 0 ? '排队中' : '处理中',
                  style: MyTheme.white08_15,
                ),
              ),
            )
        ],
      ),
    );
  }

  Future<void> _saveImage(String imgUrl) async {
    try {
      CommonUtils.localStorageImage(imgUrl);
    } catch (e) {
      MyToast.showText(text: tr('tpbcsb'));
    }
  }

  String _getDayTimerStr(String createdAt) {
    if (createdAt.isNotEmpty && createdAt.length >= 10) {
      return (widget.data.createdAt ?? '').substring(0, 10);
    }
    return '';
  }

  String _getSecondTimerStr(String createdAt) {
    if (createdAt.isNotEmpty && createdAt.length >= 16) {
      return (widget.data.createdAt ?? '').substring(10, 16);
    }
    return '';
  }

  Future<void> _showSheetView(List<Thumbs> thumbs, int initialIndex) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) => DrawPictureRecordPreviewScreen(
          thumbs: thumbs,
          initialIndex: initialIndex,
          delTapCall: () {
            //删除AI记录
            delete();
          }),
    );
  }

  //删除记录
  Future<void> delete() async {
    MyToast.showLoading(text: 'zzscz'.tr(context: context));
    final domain = context.read<AIDrawDomain>();
    final res = await domain.delAIDrawRecord(ids: widget.data.id);
    MyToast.closeAllLoading();
    if (res.isValid) {
      widget.delSucess.call();
    } else if (res.msg case final msg?) {
      MyToast.showText(text: msg);
    }
  }
}
