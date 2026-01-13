import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/game/game_section/game_section_model.dart';
import '../../../../utils/common_utils.dart';
import '../../../theme.dart';
import '../../my_image.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class GameAdCard extends StatelessWidget {
  const GameAdCard({super.key, required this.ad});
  final GameSectionAdModel ad;
  String get description => ad.description ?? '4567890-';
  String get imgUrl => CommonUtils.getThumb(ad.toJson());
  @override
  Widget build(BuildContext context) {
    return ReportGestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        CommonUtils.openRoute(context, ad.toJson());
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 94.w,
            child: Stack(
              fit: StackFit.expand,
              children: [
                MyImage.network(
                  imgUrl,
                  borderRadius: 5.w,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 0,
                  top: 0,
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
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
