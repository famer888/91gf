import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/app_global.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';

class NovelReadeSetSheet extends StatefulWidget {
  const NovelReadeSetSheet({super.key, required this.fontSize, required this.bgColorIndex, required this.callback});

  final double fontSize;

  final int bgColorIndex;

  final Function(double, int) callback;

  @override
  State<NovelReadeSetSheet> createState() => _NovelReadeSetSheetState();
}

class _NovelReadeSetSheetState extends State<NovelReadeSetSheet> {
  List titls = ['黄', '黑', '粉', '蓝', '紫'];
  int _bgColorIndex = 1;
  double _fontSize = 15;

  @override
  void initState() {
    // TODO: implement initState
    _bgColorIndex = widget.bgColorIndex;
    _fontSize = widget.fontSize;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 100),
        child: Container(
            padding: EdgeInsets.all(MyTheme.pagePadding),
            width: 1.sw,
            height: 170.w,
            decoration: BoxDecoration(
              color: MyTheme.white008Color,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.w),
                topRight: Radius.circular(10.w),
              ),
            ),
            child: cofigContentView()));
  }

  Widget cofigContentView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('字号', style: MyTheme.white14),
        SizedBox(height: 5.w),
        SizedBox(
          width: 1.sw,
          height: 30.w,
          child: Row(children: [
            MyImage.asset(MyImagePaths.appNovelFontsize0, width: 22.w),
            Expanded(
              child: ReaderProgressBar(
                curValue: _fontSize,
                divisions: 10,
                minValue: 12,
                maxValue: 22,
                onChange: (value) => updateFontSize(value),
                selected: (value) => updateFontSize(value),
              ),
            ),
            MyImage.asset(MyImagePaths.appNovelFontsize1, width: 22.w),
          ]),
        ),
        SizedBox(height: 5.w),
        Text('背景', style: MyTheme.white14),
        GridView.builder(
          padding: EdgeInsets.symmetric(
            vertical: MyTheme.pagePadding,
          ),
          shrinkWrap: true,
          itemCount: AppGlobal.bgColores.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 70 / 30,
            mainAxisSpacing: 10.w,
            crossAxisSpacing: 10.w,
          ),
          primary: false,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              _bgColorIndex = index;
              setState(() {});
              widget.callback(_fontSize, index);
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppGlobal.bgColores[index],
                borderRadius: BorderRadius.all(
                  Radius.circular(2.w),
                ),
                border: Border.all(
                  color: _bgColorIndex == index ? Colors.white : Colors.transparent, // 设置边框颜色
                  width: 1.5, // 设置边框宽度
                ),
              ),
              child: Text(titls[index], style: MyTheme.white11),
            ),
          ),
        )
      ],
    );
  }

  void updateFontSize(double size) {
    setState(() => _fontSize = size);
    widget.callback(_fontSize, _bgColorIndex);
  }
}

/// 进度条
class ReaderProgressBar extends StatelessWidget {
  final void Function(double)? selected;
  final void Function(double)? onChange;
  final double curValue;
  final double minValue;
  final double maxValue;
  final int? divisions;

  const ReaderProgressBar({
    super.key,
    required this.curValue,
    required this.minValue,
    required this.maxValue,
    this.selected,
    this.onChange,
    this.divisions,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 1.w,
        trackShape: const RectangularSliderTrackShape(),
        activeTrackColor: const Color.fromRGBO(247, 50, 208, 1),
        inactiveTrackColor: const Color(0xFFF2F2F2),
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.w),
        thumbColor: const Color.fromRGBO(247, 50, 208, 1),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 10.w),
        // 滑块外圈颜色
        overlayColor: const Color.fromRGBO(247, 50, 208, 0.3),
        // 标签形状，可以自定义
        valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
        activeTickMarkColor: Colors.red,
      ),
      child: Slider(
        divisions: divisions ?? 10,
        value: curValue,
        min: minValue,
        max: maxValue,
        onChanged: onChange,
        onChangeEnd: selected,
      ),
    );
  }
}
