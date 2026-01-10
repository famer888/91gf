import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/post_model.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/post/card/card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/post/card/content.dart';
import 'package:jygf/ui_layer/screens/common_widgets/post/card/count_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/post/card/hash_tag.dart';
import 'package:jygf/ui_layer/screens/common_widgets/post/card/media.dart';
import 'package:jygf/ui_layer/screens/common_widgets/post/card/user_view.dart';
import 'package:jygf/ui_layer/screens/theme.dart';

enum _Type {
  seed,
  post,
  postPublish,
}

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.data,
    this.rank,
  }) : _type = _Type.post;

  const PostCard.postPublish({
    super.key,
    required this.data,
  })  : _type = _Type.postPublish,
        rank = null; 

  const PostCard.seed({
    super.key,
    required this.data,
  })  : _type = _Type.seed,
        rank = null;

  final PostModel data;
  final _Type _type;
  final int? rank;

  @override
  Widget build(BuildContext context) {
    final child = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => switch (_type) {
        _Type.postPublish => () {
          if (data.status == 1) {
            CommunityPostDetailRoute('${data.id}').push(context);
          }
        },
        _Type.post => CommunityPostDetailRoute('${data.id}').push(context),
        _Type.seed => BitPostDetailRoute('${data.id}').push(context),
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (data.user case final user? when _type == _Type.post)
            Padding(
              padding: EdgeInsets.only(bottom: 10.w),
              child: CardUserView(
                user: user,
                createdAt: data.createdAt ?? '',
              ),
            ),
          if (_type == _Type.postPublish)
            Padding(
              padding: EdgeInsets.only(bottom: 10.w),
              child: Row(children: [
                Text(
                  '发布于${data.createdAt}',
                  style: MyTheme.gray102_13,
                ),
                const Spacer(),
                if (data.status == 0) 
                  Text(
                    data.status == 2 ? '未通过' : '待审核',
                    style: TextStyle(
                      color: data.status == 2 
                          ? const Color.fromRGBO(255, 0, 0, 1)
                          : MyTheme.white08Color, 
                      fontSize: 12.sp,
                    ),
                  )
              ]),
            ),
          if (_type == _Type.postPublish && 
              (data.refuseReason?.isNotEmpty ?? false))
            Padding(
              padding: EdgeInsets.only(bottom: 10.w),
              child: Text(
                data.refuseReason ?? '',
                style: TextStyle(
                  color: const Color.fromRGBO(255, 0, 0, 1),
                  fontSize: 12.sp,
                ),
              ),
            ),
          CardContentView(
            isBest: data.isBest == 1,
            title: data.title,
          ),
          if (data.medias case final medias? when medias.isNotEmpty)
            CardMediaView(medias: medias),
          if (data.topic case final topics)
            CardHashTag(
            id: '${topics?.id}',
            name: topics?.name ?? '',
            tapAct: () {
              if (_type == _Type.seed) {

              }
              else {
                CommunityTagDetailRoute('${topics?.id}').push(context);
              }
            },
          ),
          CardCountView(  
            viewCount: data.viewNum,
            commentCount: data.commentNum,
            likeCount: data.likeNum,
            type: CommunityType.bit,
          ),
        ]),
      ),
    );

    if (rank case final rank? when rank < 3) {
      final rankColors = [
        [
          const Color(0xff04f7ff).withOpacity(0.3),
          Colors.transparent,
        ],
        [
          const Color(0xffff0404).withOpacity(0.3),
          Colors.transparent,
        ],
        [
          const Color(0xffffee04).withOpacity(0.3),
          Colors.transparent,
        ],
      ];
      return DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xff232337),
          borderRadius: BorderRadius.circular(5.w),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.w),
            gradient: LinearGradient(
              colors: rankColors[rank],
              stops: const [0.0, 0.3],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(children: [
            Align(
              alignment: Alignment.topRight,
              child: Text(
                'TOP${rank + 1}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.1),
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  height: 1.0,
                ),
              ),
            ),
            child,
          ]),
        ),
      );
    }

    return child;
  }
}
