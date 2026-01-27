import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/common_widgets/post/card/card.dart';

import '../../../../../domain/model/topic_model.dart';
import '../../../../router/routes.dart';
import '../../../../utils/common_utils.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';
import '../../my_image.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';

class CardCountView extends StatelessWidget {
  const CardCountView({
    super.key,
    required this.viewCount,
    required this.commentCount,
    required this.likeCount,
    required this.type,
    this.topic,
    this.isDeepColor = 0,
  });

  final int viewCount;
  final int commentCount;
  final int likeCount;
  final CommunityType type;

  final int isDeepColor;
  final TopicModel? topic;

  Widget _item(String path, int count, {Color? iconColor}) => Row(
        children: [
          MyImage.asset(
            path,
            width: 20.w,
            height: 20.w,
            iconColor: iconColor,
          ),
          SizedBox(width: 4.w),
          Text(
            '${CommonUtils.renderFixedNumber(count)}',
            style: MyTheme.gray199_13,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _item(MyImagePaths.appViewIcon, viewCount),
        _item(
          type == CommunityType.community
              ? (isDeepColor > 0 ? MyImagePaths.appThumbUpOffIcon : MyImagePaths.appThumbsIcon)
              : (isDeepColor > 0 ? MyImagePaths.appCollectOn : MyImagePaths.appCollectOff),
          likeCount,
          iconColor: isDeepColor > 0 ? MyTheme.primaryColor : null,
        ),
        _item(MyImagePaths.appCommentIcon, commentCount),
        if (topic != null)
          ReportGestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => CommunityTagDetailRoute('${topic?.id}').push(context),
            child: Text('#${topic?.name ?? ''}', style: MyTheme.blue96_13_M),
          )
      ],
    );
  }
}
