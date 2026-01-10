import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';

import '../../../../../../domain/model/tiezt_model.dart';
import '../../../../../router/routes.dart';
import '../../../../theme.dart';
import '../../../my_image.dart';

class PostCenterCard extends StatelessWidget {
  const PostCenterCard({super.key, required this.data});

  final TieztModel data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: data.status == 1 ? () => CommunityPostDetailRoute(data.id.toString()).push(context) : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 64.w,
              height: 74.w,
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.w),
                color: MyTheme.white02Color,
              ),
              child: Center(
                child: MyImage.asset(
                  data.status == 0 ? MyImagePaths.appPostCheck : (data.status == 1 ? MyImagePaths.appPostPass : MyImagePaths.appPostRefuse),
                  width: 46.w,
                  height: 36.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              child: Text(
                data.title,
                style: MyTheme.white255_15,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );

    /* 


    return Container(
      margin: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: data.status == 1
            ? () => CommunityPostDetailRoute(data.id.toString()).push(context)
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                RelativeDateFormat.format(
                    date: DateTime.parse(data.createdAt ?? '')),
                style: MyTheme.gray102_14),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.w),
              child: Container(
                padding: EdgeInsets.only(
                  left: 10.w,
                ),
                decoration: BoxDecoration(
                  border: Border(
                      left: BorderSide(
                    color: MyTheme.cyanColor00edfd,
                    width: 2.w,
                  )),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.w),
                    Text.rich(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        TextSpan(children: [
                          data.isBest == 1
                              ? WidgetSpan(
                                  child: Container(
                                    margin: EdgeInsets.only(right: 3.w),
                                    //, bottom: 1.5.w),
                                    // padding: EdgeInsets.symmetric(horizontal: 5.w),
                                    width: kIsWeb ? 26.w : 31.w,
                                    height: kIsWeb ? 12.w : 17.w,
                                    decoration: BoxDecoration(
                                      gradient: MyTheme.gradient_90_114,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(2.w),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'jhua'.tr(context: context),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.sp,
                                            height: 1,
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ),
                                  style: TextStyle(
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                      fontSize: 15.sp,
                                      height: 1.5,
                                      overflow: TextOverflow.ellipsis,
                                      decoration: TextDecoration.none),
                                )
                              : const TextSpan(),
                          TextSpan(text: data.title, style: MyTheme.white255_15)
                        ])),
                    CardMediaView(
                      medias: data.medias,
                    ),
                    SizedBox(height: 15.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () =>
                              CommunityTagDetailRoute('${data.topic?.id}')
                                  .push(context),
                          child: Text(
                            '#${data.topic?.name ?? ''}',
                            style: MyTheme.blue96_13_M,
                          ),
                        ),
                        Text(
                          "${CommonUtils.renderFixedNumber(data.commentNum)}${tr("tpl")} ｜ ${CommonUtils.renderFixedNumber(data.viewNum)}${tr("llan")} ｜ ${CommonUtils.renderFixedNumber(data.likeNum)}${tr("dz")}",
                          style: MyTheme.gray163_11,
                        )
                      ],
                    ),
                    SizedBox(height: 18.w),
                    switch (data.status) {
                      0 => Padding(
                          padding: EdgeInsets.only(bottom: 10.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                '${'shzt'.tr(context: context)}：${'dsh'.tr(context: context)}',
                                style: MyTheme.red255_11),
                          ),
                        ),
                      2 => Padding(
                          padding: EdgeInsets.only(bottom: 10.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${'bjyy'.tr(context: context)}：',
                                  style: MyTheme.red255_11),
                              SizedBox(height: 5.w),
                              Text(
                                data.refuseReason ?? '',
                                style: MyTheme.red255_11,
                                maxLines: 20,
                              ),
                            ],
                          ),
                        ),
                      _ => const SizedBox.shrink()
                    }
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    */
  }
}
