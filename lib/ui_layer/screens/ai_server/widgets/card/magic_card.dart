import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/ai/ai_magic_model.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import '../../../../router/routes.dart';
import '../../../../utils/common_utils.dart';
import '../../../theme.dart';

class MagicCard extends StatelessWidget {
  const MagicCard({super.key, required this.data});
  final AIMagicModel data;
  static const aspectRatio = 9 / 16;

  String get imageUrl => CommonUtils.getThumb(data.toJson());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        AIMagicDetailRoute(data).push(context);
      },
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Stack(
          fit: StackFit.expand,
            children: [
            MyImage.network(
              imageUrl,
              fit: BoxFit.cover,
              backgroundColor: MyTheme.imageBgColor,
              borderRadius: 5.w,
            ),
            Container(
              decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(5.w),
              ),
            ),
            Center(
              child: Text(
              data.title ?? '',
              style: MyTheme.white244_20.copyWith(
                shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.7),
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
                ],
              ),
              maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
