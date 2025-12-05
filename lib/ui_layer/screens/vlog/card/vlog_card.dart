import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/vlog_model.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';

class VlogCard extends StatelessWidget {
  const VlogCard({super.key, this.onTapFunc, required this.data});

  final VlogModel data;
  final Function(int)? onTapFunc;

  @override
  Widget build(BuildContext context) {
    return (data.url != null && data.url!.isNotEmpty)
        ? configADContentView()
        : configVlogContentView();
  }

  Widget configVlogContentView() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTapFunc?.call(1);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: data.mvType == 2 ? (170 / 210) : (170 / 97),
            child: Stack(
              // fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: MyImage.network(
                    data.coverVertical ?? '',
                    fit: BoxFit.cover,
                    backgroundColor: MyTheme.imageBgColor,
                    borderRadius: 5.w,
                  ),
                ),
                // data.isFree == 0 || data.mvType == 2
                data.isFree == 0
                    ? Container()
                    : Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 2.w),
                            decoration: BoxDecoration(
                                gradient: data.isFree == 2 ? MyTheme.gradient_90_114 : MyTheme.gradient_90_118,
                                borderRadius:
                                    BorderRadius.only(
                                        topLeft: Radius.circular(5.w),
                                        bottomRight: Radius.circular(5.w))),
                            child: Text(
                              data.isFree == 2 ? 'jb'.tr() : 'VIP',
                              style: MyTheme.white10,
                            ))),
                Positioned(
                    bottom: 0.w,
                    left: 0.w,
                    right: 0.w,
                    child: Container(
                      height: 30.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.w)),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(0, 0, 0, 0.6),
                              Color.fromRGBO(0, 0, 0, 0),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          )),
                    )),
                Positioned(
                  bottom: 3.w,
                  left: 3.w,
                  right: 5.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              MyImage.asset(MyImagePaths.appAsmrPlay,
                                  height: 10.w, width: 10.w,),
                              SizedBox(width: 3.w),
                              Text(
                                '${CommonUtils.renderFixedNumber(data.playCt ?? 0)}次播放',
                                style: MyTheme.white10,
                              ),
                            ],
                          ),
                          Text(
                            RelativeDateFormat.getHMTime(time: data.duration),
                            style: MyTheme.white10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5.w),
          Text(
            data.title ?? '',
            style: MyTheme.white244_12,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget configADContentView() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTapFunc?.call(2);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 170 / 210,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: MyImage.network(
                    data.imgUrl ?? '',
                    fit: BoxFit.fill,
                    backgroundColor: MyTheme.imageBgColor,
                    borderRadius: 5.w,
                  ),
                ),
                Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 38.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(252, 231, 80, 1),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(3.w),
                            bottomRight: Radius.circular(3.w)),
                      ),
                      child: Center(
                          child: Text(
                        'gg'.tr(),
                        style: MyTheme.black12_M,
                      )),
                    ))
              ],
            ),
          ),
          SizedBox(height: 5.w),
          Text(
            data.title ?? '',
            style: MyTheme.white244_13,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
