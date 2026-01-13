import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/common_widgets/gradient_border_box.dart';

import '../../../../../domain/model/topic_model.dart';
import '../../../../router/routes.dart';
import '../../../common_widgets/my_image.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class TopicField extends StatelessWidget {
  const TopicField({
    super.key,
    required this.type,
    required this.topicNotifier,
  });

  final int type;
  final ValueNotifier<TopicModel?> topicNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: topicNotifier,
      builder: (_, topic, __) => ReportGestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          if (await CommunityModuleRoute(id: topic?.id ?? 0, topicType: type).push(context) case final TopicModel topic) {
            topicNotifier.value = topic;
          }
        },
        child: GradientBorder(
          radius: 8.w,
          borderWidth: 0.8.w,
          gradient: MyTheme.dhButtonGradient,
          child: SizedBox(
            height: 50.w,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${topic == null ? 'xzht'.tr(context: context) : topic.name}',
                    style: MyTheme.gray143_15,
                  ),
                  MyImage.asset(MyImagePaths.appIssueArrow, width: 8.w, height: 10.w, iconColor: MyTheme.whiteColor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
