import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/common_widgets/gradient_border_container.dart';

import '../../../../../domain/model/topic_model.dart';
import '../../../../router/routes.dart';
import '../../../common_widgets/my_image.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';

class TopicField extends StatelessWidget {
  const TopicField({
    super.key,
    required this.type,
    required this.topicNotifier,
  });

  final String type;
  final ValueNotifier<TopicModel?> topicNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: topicNotifier,
      builder: (_, topic, __) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          if (await CommunityModuleRoute(id: topic?.id ?? 0, type: type).push(context) case final TopicModel topic) {
            topicNotifier.value = topic;
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          height: 50.w,
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4.w))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('#${topic == null ? 'xzht'.tr(context: context) : topic.name}', style: MyTheme.gray143_15),
              MyImage.asset(MyImagePaths.appIssueArrow, width: 6.w, height: 10.w)
            ],
          ),
        ),
      ),
    );
  }
}
