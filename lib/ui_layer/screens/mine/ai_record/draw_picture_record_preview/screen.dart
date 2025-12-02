import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/ai/ai_draw_record_model.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';

class DrawPictureRecordPreviewScreen extends StatefulWidget {
  const DrawPictureRecordPreviewScreen({
    super.key,
    required this.thumbs,
    required this.initialIndex,
    required this.delTapCall,
  });

  final List<Thumbs> thumbs;
  final int initialIndex;
  final VoidCallback delTapCall;

  @override
  State<DrawPictureRecordPreviewScreen> createState() =>
      _DrawPictureRecordPreviewScreenState();
}

class _DrawPictureRecordPreviewScreenState
    extends State<DrawPictureRecordPreviewScreen> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final sheetHeight = ScreenUtil().screenHeight * 0.8;

    return Container(
        padding: EdgeInsets.only(
            left: MyTheme.pagePadding,
            top: MyTheme.pagePadding,
            right: MyTheme.pagePadding,
            bottom: 44.w),
        color: MyTheme.bgColor,
        height: sheetHeight,
        child: Column(children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.thumbs.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) {
                final thumb = widget.thumbs[index];
                return Center(
                  child: MyImage.network(thumb.url),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '${_currentIndex + 1}/${widget.thumbs.length}',
                  style: MyTheme.white16medium,
                ),
              ],
            ),
          ),
          SizedBox(height: 30.w),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              _saveImage(context);
            },
            child: Container(
              height: 45.w,
              decoration: BoxDecoration(
                  gradient: MyTheme.gradient_90_114,
                  borderRadius: BorderRadius.circular(5.w)),
              child: Center(
                child: Text(
                  '保存当前图片',
                  style: MyTheme.white16medium,
                ),
              ),
            ),
          ),
          SizedBox(height: 15.w),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              widget.delTapCall.call();
            },
            child: Container(
              height: 45.w,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(5.w)),
              child: Center(
                child: Text(
                  tr('schqb'),
                  style: MyTheme.white16medium,
                ),
              ),
            ),
          )
        ]));
  }

  Future<void> _saveImage(BuildContext context) async {
    try {
      CommonUtils.localStorageImage(widget.thumbs[_currentIndex].url);
    } catch (e) {
      MyToast.showText(text: tr('tpbcsb'));
    }
  }
}
