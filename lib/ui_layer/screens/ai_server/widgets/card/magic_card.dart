import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/ai/ai_magic_model.dart';
import 'package:jygf/ui_layer/screens/common_widgets/gradient_text.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import '../../../../router/routes.dart';
import '../../../../utils/common_utils.dart';
import '../../../theme.dart';

class MagicCard extends StatelessWidget {
  const MagicCard({super.key, required this.data, required this.index});
  final AIMagicModel data;
  final int index;
  static const aspectRatio = 9 / 16;
  
  static final List<List<Color>> _gradientColors = [
    [
      const Color.fromRGBO(115, 194, 255, 1),
      const Color.fromRGBO(236, 255, 246, 1),
      const Color.fromRGBO(131, 249, 255, 1),
    ],
    [
      const Color.fromRGBO(183, 115, 255, 1),
      const Color.fromRGBO(236, 255, 246, 1),
      const Color.fromRGBO(183, 115, 255, 1),
    ],
    [
     const Color.fromRGBO(255, 211, 115, 1),
     const Color.fromRGBO(236, 255, 246, 1),
     const Color.fromRGBO(255, 211, 115, 1),
    ],
  ];
  
  List<Color> get _currentGradientColors => _gradientColors[index % 3];

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
              gradient: const LinearGradient(colors: [
                              Color.fromRGBO(176, 66, 255, 0.3),
                              Color.fromRGBO(255, 133, 164, 0.3),
                            ]),
              borderRadius: BorderRadius.circular(5.w),
              ),
            ),
            Center(
              child: GradientText(
                data.title,
                gradient: LinearGradient(
                  colors: _currentGradientColors,
                ),
                style: MyTheme.white244_20.copyWith(
                  color: Colors.white,
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
