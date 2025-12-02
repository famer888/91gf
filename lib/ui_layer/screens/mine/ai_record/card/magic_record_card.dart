import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/model/ai/ai_magic_record_model.dart';
import 'package:jygf/domain/remote_domain/domains/aimagic.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/mine/ai_record/video_record_preview/screen.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

class AIMagicRecordCard extends StatefulWidget {
  const AIMagicRecordCard(
      {super.key, required this.data, required this.delSucess, this.status});

  final int? status; // 0-待处理 1-处理中 2-已成功 3-已失败
  final AIMagicRecordModel data;
  final Function delSucess;

  @override
  State<AIMagicRecordCard> createState() => _AIMagicRecordCardState();
}

class _AIMagicRecordCardState extends State<AIMagicRecordCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.w),
        // color: MyTheme.white08Color,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (widget.data.status != 3) {
            MyToast.showText(text: '处理中，无法查看视频');
            return;
          }
          _showSheetView(widget.data);
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: MyImage.network(widget.data.thumb ?? widget.data.cover),
            ),
            (widget.data.status ?? 0) <= 1 //毛玻璃效果
                ? Positioned(
                    top: -5,
                    bottom: -5,
                    left: -5,
                    right: -5,
                    child: CommonUtils.blurCover(borderRadius: 5.w))
                : Container(),
            widget.data.status == 3 //保存按钮
                ? Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            margin: EdgeInsets.only(bottom: 13.w),
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                _saveVideo(widget.data.video);
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

  Future<void> _showSheetView(AIMagicRecordModel data) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) => VideoRecordPreviewScreen(
          data: data,
          delTapCall: () {
            //删除AI记录
            delete();
          }),
    );
  }

  //删除记录
  Future<void> delete() async {
    MyToast.showLoading(text: 'zzscz'.tr(context: context));
    final domain = context.read<AIMagicDomain>();
    final res = await domain.delAIMagicRecord(ids: widget.data.id);
    MyToast.closeAllLoading();
    if (res.isValid) {
      widget.delSucess.call();
    } else if (res.msg case final msg?) {
      MyToast.showText(text: msg);
    }
  }
}
