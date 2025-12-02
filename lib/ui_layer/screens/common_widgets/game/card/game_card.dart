import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/game/game_model.dart';
import '../../../../router/routes.dart';
import '../../../../utils/common_utils.dart';
import '../../../theme.dart';
import '../../my_image.dart';

class GameCard extends StatelessWidget {
  const GameCard({super.key, required this.data});
  final GameModel data;
  static const aspectRatio = 163 / 132;

  String get imageUrl => CommonUtils.getThumb(data.toJson());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        GameDetailRoute('${data.id}').push(context);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 94.w,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    MyImage.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      backgroundColor: MyTheme.imageBgColor,
                      borderRadius: 5.w,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${CommonUtils.renderFixedNumber(data.likeFct ?? 0)}${'dz'.tr()}',
                              style: MyTheme.white08_12,
                            ),
                            Text(
                              '${CommonUtils.renderFixedNumber(data.payFct ?? 0)}${'js'.tr()}',
                              style: MyTheme.white08_12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.w),
              Text(
                data.title ?? '',
                style: MyTheme.white244_12,
                maxLines: 1,
              ),
            ],
          ),
          SizedBox(height: 1.w),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  child: Text(
                    '${data.tags}',
                    style: MyTheme.graya3a2a2_11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
