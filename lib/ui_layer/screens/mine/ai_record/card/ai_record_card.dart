import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/model/ai_model.dart';
import 'package:jygf/domain/remote_domain/domains/ai.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/mine/ai_record/picture_record_preview/screen.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

enum AIRecordType {
  StripOff,
  FaceSwap;
}

class AIRecordCard extends StatefulWidget {
  const AIRecordCard(
      {super.key,
      required this.data,
      required this.delSucess,
      this.type = AIRecordType.StripOff,
      this.status});

  final int? status; // 0-待处理 1-处理中 2-已成功 3-已失败
  final AIModel data;
  final AIRecordType? type;
  final Function delSucess;

  @override
  State<AIRecordCard> createState() => _AIRecordCardState();
}

class _AIRecordCardState extends State<AIRecordCard> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    String imgStr = widget.type == AIRecordType.StripOff
        ? (widget.data.stripThumb ?? '')
        : (widget.data.faceThumb ?? '');

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.w),
        // color: MyTheme.white08Color,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (widget.data.status == 2) {
            _showSheetView(imgStr);
          }
        },
        child: Stack(
          children: [
            widget.data.status == 2
                ? Positioned.fill(
                    child: Row(
                    children: [
                      Expanded(child: MyImage.network(widget.data.thumb ?? '')),
                      Expanded(
                          child: RepaintBoundary(
                        key: _globalKey,
                        child: MyImage.network(
                            widget.type == AIRecordType.StripOff
                                ? (widget.data.stripThumb ?? '')
                                : (widget.data.faceThumb ?? '')),
                      )),
                    ],
                  ))
                : Positioned.fill(
                    child: MyImage.network(widget.data.thumb ?? '')),
            (widget.data.status ?? 0) <= 1 //毛玻璃效果
                ? Positioned(
                    top: -5,
                    bottom: -5,
                    left: -5,
                    right: -5,
                    child: CommonUtils.blurCover(borderRadius: 5.w))
                : Container(),
            widget.data.status == 2 //保存按钮
                ? Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            margin: EdgeInsets.only(bottom: 13.w),
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                _saveImage(imgStr);
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

  Future<void> _showSheetView(String imgStr) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) => PictureRecordPreviewScreen(
          url: imgStr,
          delTapCall: () {
            //删除AI记录
            if (widget.type == AIRecordType.StripOff) {
              deleteStripOff();
            } else {
              deleteFace();
            }
          }),
    );
  }

  //删除换脸记录
  Future<void> deleteFace() async {
    MyToast.showLoading(text: 'zzscz'.tr(context: context));
    final domain = context.read<AIDomain>();
    final res = await domain.delFace(ids: '${widget.data.id}');
    MyToast.closeAllLoading();
    if (res.isValid) {
      widget.delSucess.call();
    } else if (res.msg case final msg?) {
      MyToast.showText(text: msg);
    }
  }

  //删除脱衣记录
  Future<void> deleteStripOff() async {
    MyToast.showLoading(text: 'zzscz'.tr(context: context));
    final domain = context.read<AIDomain>();
    final res = await domain.delStrip(ids: '${widget.data.id}');
    MyToast.closeAllLoading();
    if (res.isValid) {
      widget.delSucess.call();
    } else if (res.msg case final msg?) {
      MyToast.showText(text: msg);
    }
  }
}
