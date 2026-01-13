import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/feed/feed_model.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class RankCard extends StatelessWidget {
  final int index;
  final FeedVideoModel data;

  const RankCard({
    super.key,
    required this.index,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return ReportGestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        VideoDetailRoute('${data.id}').push(context);
      },
      child: Container(
        width: double.infinity,
        height: 110.w,
        margin: EdgeInsets.only(bottom: 12.w),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(MyImagePaths.appRankCardBg),
            fit: BoxFit.fill,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 30.w,
              margin: EdgeInsets.only(left: 5.w),
              child: Stack(
                children: [
                   Align(
                  alignment: Alignment.centerLeft,
                  child: Transform(transform: Matrix4.translationValues(-8, 0, 0),child: MyImage.asset(MyImagePaths.appRankCardMask,width: 70.w,height: 150.w,fit: BoxFit.contain,)),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 2.w),
                    MyImage.asset(
                      MyImagePaths.appRankCardTop,
                      width: 26.w,
                      height: 12.w,
                      fit: BoxFit.contain,
                    ),
                    // SizedBox(height: 2.w),
                    Text(
                      _formatRank(index),
                      style: TextStyle(
                        color: const Color(0xFFFDEDA3),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Bebas',
                      ),
                    ),
                  ],
                ),
               
              ]),
            ),
            Container(
              width: 150.w,
              height: 90.w,
              margin: EdgeInsets.symmetric(vertical: 10.w),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6.r),
                    child: MyImage.network(
                      CommonUtils.getThumb(data.toJson()),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    right: 4.w,
                    bottom: 4.w,
                    child: Text(
                      RelativeDateFormat.getHMTime(time: data.duration),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 12.w, top: 12.w, bottom: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    _buildTags(data.tags),
                    Row(
                      children: [
                        _buildStatItem(
                          MyImagePaths.app2024ComBofangliangBig1,
                          '${CommonUtils.renderFixedNumber(data.playCt)}',
                        ),
                        SizedBox(width: 16.w),
                        _buildStatItem(
                          MyImagePaths.appReplyIcon,
                          '${CommonUtils.renderFixedNumber(data.countComment)}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTags(String tags) {
    if (tags.isEmpty) return const SizedBox();
    List<String> tagList = tags.split(',');
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tagList.map((text) {
          if (text.isEmpty) return const SizedBox();
          return Container(
            margin: EdgeInsets.only(right: 6.w),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.w),
            decoration: BoxDecoration(
              gradient: MyTheme.gradient_90_114_15,
              borderRadius: BorderRadius.circular(3.r),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatItem(String iconPath, String text) {
    return Row(
      children: [
        MyImage.asset(
          iconPath,
          width: 14.w,
          height: 14.w,
        ),
        SizedBox(width: 4.w),
        Text(
          text,
          style: TextStyle(
            color: const Color(0xFF999999),
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  String _formatRank(int index) {
    return index < 10 ? '0$index' : '$index';
  }
}

