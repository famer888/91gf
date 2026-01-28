import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'user_view.dart';

import '../../../../../domain/model/post_model.dart';
import '../../../../router/routes.dart';
import '../../../theme.dart';
import 'content.dart';
import 'count_view.dart';
import 'media.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


enum CommunityType {
  bit,
  community,
}

class PostCard extends StatelessWidget {
  const PostCard.bit({
    super.key,
    required this.data,
    this.backgroundColor,
  }) : _type = CommunityType.bit;

  const PostCard.community({
    super.key,
    required this.data,
    this.backgroundColor,
  }) : _type = CommunityType.community;

  final PostModel data;
  final Color? backgroundColor;
  final CommunityType _type;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
      ),
      child: ReportGestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => switch (_type) {
          CommunityType.community => CommunityPostDetailRoute('${data.id}').push(context),
          CommunityType.bit => BitPostDetailRoute('${data.id}').push(context),
        },
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: MyTheme.pagePadding, bottom: 7.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data.user case final user? when _type == CommunityType.community)
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.w),
                      child: CardUserView(
                        user: user,
                        createdAt: data.createdAt ?? '',
                      ),
                    ),
                  CardContentView(isBest: data.isBest == 1, title: data.title),
                  if (data.medias case final medias? when medias.isNotEmpty) CardMediaView(medias: medias),
                  // Divider(color: Colors.white.withOpacity(0.04), height: 18.w),
                  SizedBox(height: 10.w),
                  CardCountView(
                    viewCount: _type == CommunityType.community ? data.viewNum : data.viewCt ?? 0,
                    commentCount: _type == CommunityType.community ? data.commentNum : data.commentCt ?? 0,
                    likeCount: _type == CommunityType.community ? data.likeNum : data.favoriteCt ?? 0,
                    topic: _type == CommunityType.community ? data.topic : null,
                    type: _type,
                  ),
                ],
              ),
            ),
            Positioned(top: 0, left: 0, child: getTopContent(data.index)),
          ],
        ),
      ),
    );
  }

  Widget getTopContent(int? index) {
    switch (index) {
      case 0:
        return MyImage.asset(MyImagePaths.appTopOne, width: 55.w, height: 20.w);
      case 1:
        return MyImage.asset(MyImagePaths.appTopTwo, width: 55.w, height: 20.w);
      case 2:
        return MyImage.asset(MyImagePaths.appTopThree, width: 55.w, height: 20.w);
    }
    return const SizedBox.shrink();
  }
}
